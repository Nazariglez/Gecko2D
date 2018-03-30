import * as C from "./const";
import * as path from 'path';
import * as toml from 'toml';
import * as colors from 'colors';
import * as fs from 'fs-extra';
import {trimLineSpaces} from './utils';

export const platform = {
    HTML5: "html5",
    OSX: "osx",
    Linux: "linux",
    Win: "windows",
    Android: "android",
    IOS: "ios"
};

export const graphics = {
    osx : ["opengl", "metal"],
    windows: ["direct3d11", "direct3d9", "direct3d12", "opengl"]
}

export const defaultConfig = `# development ${C.ENGINE_NAME} config.
name = "Gecko2D-Game"
sources = ["Sources"]
shaders = []                        #shaders directory
libraries = []                      #libs at Libraries folder or haxelib
output = "build"                    #build output
debug = true                        #compile in debug mode

[html5]
webgl = true
canvas = "kanvas"           #canvas id
script = "game"             #script name
serve_port = 8080           #port to serve the build with ${C.ENGINE_NAME} serve
html_file = ""              #inject the script in a custom html

[osx]
graphics = "${graphics.osx[0]}"         #mac graphics [${graphics.osx.join(" | ")}]

[windows]
graphics = "${graphics.windows[0]}"         #windows graphics [${graphics.windows.join(" | ")}]

[flags]                         #custom compiler flags
#debug_collisions = true

[core]
clean_temp = false              #clean temporal files after compile
compile = true                  #if false, the game will not be compiled, and the "resources" to compile will stay at ${C.TEMP_RELATIVE_PATH}
compiler_parameters = []        #haxe compiler parameters (ex: "-dce full")
ffmpeg = ""                     #ffmpeg drivers path (could be absolute)
haxe = ""
kha = ""
`;

export interface Config {
    name:string
    sources:string[]
    shaders:string[]
    libraries:string[]
    output:string
    debug:boolean

    html5?:ConfigHTML5
    osx?:ConfigOSX
    windows?:ConfigWin
    linus?:ConfigLinux
    android?:ConfigAndroid
    ios?:ConfigIOS

    flags:{}

    core:ConfigCore
}

export interface ConfigHTML5 {
    webgl:boolean
    canvas:string
    script:string
    serve_port?:number
    html_file?:string //todo create custom html file
    uglify?:boolean
}

interface ConfigOSX {
    graphics?:string
}

interface ConfigWin {
    graphics?:string
}

interface ConfigLinux {}

interface ConfigAndroid {}

interface ConfigIOS {}

interface ConfigCore {
    clean_temp:boolean
    compiler_parameters:string[]
    ffmpeg?:string
    haxe:string
    kha:string
    compile:boolean
    engine?:string
    khafile?:string //add extra opts to include in khafile as plain text -> "$project.addAssets("assets");";
}

export function parseConfig(input:string) : Config {
    let config:Config;

    try {
        config = toml.parse(input) as Config;
    } catch(e){
        console.error(colors.red(`Error: (${e.line},${e.column}) ${e.message}`));
    }

    if(config){
        config.core.haxe = config.core.haxe ? path.resolve(config.core.haxe) : C.HAXE_PATH;
        config.core.kha = config.core.kha ? path.resolve(config.core.kha) : C.KHA_PATH;
        config.core.engine = config.core.engine ? path.resolve(config.core.engine) : C.ENGINE_SOURCE_PATH;
        
        if(!config.core.compile){
            //disable clean temp when the user wants compile himself
            config.core.clean_temp = false;
        }

        config.libraries.unshift(config.core.engine);

        if(graphics.osx.length && config[platform.OSX] && config[platform.OSX].graphics){
            if(graphics.osx.indexOf(config[platform.OSX].graphics) === -1){
                console.error(colors.red(`Invalid graphics '${config[platform.OSX].graphics}' for osx, using '${graphics.osx[0]}'`));
                config[platform.OSX].graphics = graphics.osx[0];
            }
        }

        if(graphics.windows.length && config[platform.Win] && config[platform.Win].graphics){
            if(graphics.windows.indexOf(config[platform.Win].graphics) === -1){
                console.error(colors.red(`Invalid graphics '${config[platform.Win].graphics}' for windows, using '${graphics.windows[0]}'`));
                config[platform.Win].graphics = graphics.windows[0];
            }
        }

        if(config.html5){
            if(config.debug){
                config.html5.script += ".debug";
            }

            if(!config.html5.serve_port) {
                config.html5.serve_port = C.HTML5_SERVE_PORT;
            }

            if(typeof config.html5.uglify === "undefined"){
                config.html5.uglify = !config.debug; //uglify in !debug by default
            }
        }

        config.flags = config.flags || {};
        for(let key in config.flags) {
            const validTypes = ["string", "boolean", "number"];
            const flagType = typeof(config.flags[key]);
            if(validTypes.indexOf(flagType) === -1){
                console.error(colors.red(`Error: Invalid flag type ('${key}' type '${flagType}'). Flags must be ${validTypes.join(", ")}.`));
                return null;
            }
        }
    }

    return config;
}

export function getConfigFile(prefix:string, silence:boolean = false) : string {
    let _prefix = prefix || "dev";

    let fileName = `${_prefix}.${C.ENGINE_NAME}.toml`;
    const _pathFile = path.join(C.CURRENT_PATH, fileName);

    let file:string;
    if(fs.existsSync(_pathFile)){
        file = fs.readFileSync(_pathFile, {encoding: "UTF-8"});
    }else if(!prefix){
        const files = fs.readdirSync(C.CURRENT_PATH);
        for(let i = 0; i < files.length; i++) {
            if(files[i].indexOf(`${C.ENGINE_NAME}.toml`) !== -1){
                file = fs.readFileSync(path.join(C.CURRENT_PATH, files[i]), {encoding: "UTF-8"});
                fileName = files[i];
                break;
            }
        }
    }else{
        console.error(colors.red(`Error: config file '${fileName}' not found.`));
        return file;
    }

    if(!silence){
        console.log(colors.blue(`Using '${colors.magenta(fileName)}' config file.`));
    }
    
    return file;
}

export function generateKhafileContent(config:Config) : string {
    let kfile = `let p = new Project("${config.name}");\n`;
    config.sources.forEach((s)=>{
        kfile += `p.addSources("${s}");\n`;
    });

    if(config.libraries&&config.libraries.length){
        config.libraries.forEach((s)=>{
            kfile += `p.addLibrary("${s}");\n`;
        });
    }

    if(config.shaders.length >= 0){
        config.shaders.forEach((s)=>{
            kfile += `p.addShaders("${s}");\n`;
        });
    }

    kfile += `p.addAssets('Assets/**', {nameBaseDir: 'Assets', destination: 'assets/{dir}/{name}', name: '{dir}/{name}'});\n`;

    if(config.html5){
        kfile += `
        p.targetOptions.html5.canvasId = "${config.html5.canvas}";
        p.targetOptions.html5.scriptName = "${config.html5.script}";
        p.targetOptions.html5.webgl = ${config.html5.webgl};
        `;
    }

    if(config.core.compiler_parameters.length){
        config.core.compiler_parameters.forEach((s)=>{
            kfile += `p.addParameter("${s}");\n`;
        });
    }

    kfile += `p.addDefine("game_name=${config.name}");\n`;

    if(Object.keys(config.flags).length){
        for(let flag in config.flags){
            kfile += `p.addDefine("${C.FLAG_PREFIX}${flag}=${config.flags[flag]}");\n`;
        }
    }

    if(config.core.khafile){
        kfile += config.core.khafile.replace("$project", "p") + "\n";
    }

    kfile += "resolve(p);";

    return trimLineSpaces(kfile);
}
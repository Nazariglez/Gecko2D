import * as C from "./const";
import * as path from 'path';
import * as toml from 'toml';
import * as colors from 'colors';
import {trimLineSpaces} from './utils';

export const platform = {
    HTML5: "html5",
    OSX: "osx",
    Linux: "linux",
    Win: "windows",
    Android: "android",
    IOS: "ios"
};

export const defaultConfig = `# development ${C.ENGINE_NAME} config.
name = "My ${C.ENGINE_NAME} Game"
sources = ["Sources"]
libraries = []                  #libs at Libraries folder or haxelib
output = "build"                #build output

[html5]
webgl = true
canvas = "kanvas"           #canvas id
script = "game"             #script name

[osx]
disable = true
graphics = "opengl"         #mac graphics [opengl || metal]

[core]
clean_temp = true               #clean temporal files after compile
haxe = ""
kha = ""
`;

export interface Config {
    name:string
    sources:string[]
    libraries:string[]
    output:string

    html5?:ConfigHTML5
    osx?:ConfigOSX
    windows?:ConfigWin
    linus?:ConfigLinux
    android?:ConfigAndroid
    ios?:ConfigIOS

    core:ConfigCore
}

interface DisableInterface {
    disable?:boolean
}

interface ConfigHTML5 extends DisableInterface {
    webgl:boolean
    canvas:string
    script:string
}

interface ConfigOSX  extends DisableInterface{
    graphics?:string
}

interface ConfigWin  extends DisableInterface{
    graphics?:string
}

interface ConfigLinux extends DisableInterface{}

interface ConfigAndroid extends DisableInterface{}

interface ConfigIOS extends DisableInterface{}

interface ConfigCore {
    clean_temp:boolean
    haxe:string
    kha:string
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

        config.libraries.unshift(C.ENGINE_NAME);
    }

    return config;
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

    kfile += `p.addAssets('Assets/**', {nameBaseDir: 'Assets', destination: '{dir}/{name}', name: '{dir}/{name}'});\n`;

    if(config.html5 && !config.html5.disable){
        kfile += `
        p.targetOptions.html5.canvasId = "${config.html5.canvas}";
        p.targetOptions.html5.scriptName = "${config.html5.script}";
        p.targetOptions.html5.webgl = ${config.html5.webgl};
        `;
    }

    if(config.core.khafile){
        kfile += config.core.khafile.replace("$project", "p") + "\n";
    }

    kfile += "resolve(p);";

    return trimLineSpaces(kfile);
}
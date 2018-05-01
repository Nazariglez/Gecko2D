///<reference path="../../Kha/Tools/khamake/src/Options.ts" />
import * as fs from 'fs-extra';
import * as path from 'path';
import {Command, ActionCallback} from "../cli";
import * as C from "../const";
import {existsConfigFile, createFolder} from "../utils";
import {parseConfig, Config, generateKhafileContent, platform, getConfigFile, ConfigHTML5, createKhaFile} from "../config";
import {exec, execSync} from 'child_process';
import {series, eachSeries} from 'async';
import * as colors from 'colors';
import { create } from 'domain';
import { Options } from '../../Kha/Tools/khamake/src/Options';

declare const __non_webpack_require__:any;

const usage = `compile the current project
          ${C.ENGINE_NAME} build [ target ] [ -c config ]
          
          where [ target ] can be some platform as 'html5' or 'osx',
          and where [ -c config ] can be the prefix of a config file.
          For example: 'dev' to use 'dev.${C.ENGINE_NAME}.toml' 
          or 'prod' to use 'prod.${C.ENGINE_NAME}.toml'.
          
          By default will compile all the targets in 'dev.${C.ENGINE_NAME}.toml'`;

export const cmd:Command = {
    name: "build",
    alias: ["b"],
    usage: usage,
    action: _action
}

interface buildParseArgs {
    err?:string
    args:string[]
    target:string
    config:string
}

function _parseArgs(args:string[]) : buildParseArgs {
    let parsed:buildParseArgs = {
        err:"",
        args: args,
        target: "",
        config: ""
    };

    if(!args.length){
        return parsed;
    }

    let platformList = Object.keys(platform);
    if(args[0][0] !== "-"){
        let target = args.shift();
        let valid = false;
        for(let i = 0; i < platformList.length; i++) {
            let t = platform[platformList[i]];
            if(t === target){
                valid = true;
                parsed.target = t;
                break;
            }
        }

        if(!valid){
            parsed.err = `Invalid target '${target}'.`;
            return parsed;
        }
    }

    if(args.length >= 2 && args[0][0] === "-" && args[0] === "-c"){
        args.shift(); //discard -c
        let file = args.shift();
        if(file[0] === "-"){
            parsed.err = `Invalid config '-c ${file}'.`;
            return parsed;
        }

        parsed.config = file;
    }

    parsed.args = args;
    return parsed;
}

function _action(args:string[], cb:ActionCallback) {
    if(!existsConfigFile()){
        cb(new Error(`Invalid ${C.ENGINE_NAME} project. Config file not found.`));
        return;
    }

    const parsed = _parseArgs(args);
    if(parsed.err){
        cb(new Error(parsed.err));
        return;
    }

    args = parsed.args;

    const file = getConfigFile(parsed.config, true);
    if(!file){
        cb(new Error("Not found any config file."));
        return;
    }

    const config = parseConfig(file);
    if(!config){
        cb(new Error("Invalid config file"));
        return;
    }

    if(!parsed.target){
        parsed.target = "html5";
    }

    if(!config[parsed.target]){
        cb(new Error(`Target ${parsed.target} not defined in the config file.`));
        return;
    }

    let platformList = Object.keys(platform);
    let err = createKhaFile(parsed.config);
    if(err){
        cb(err);
        return;
    }

    let kmakeBasic:KhaMakeConfig = {
        target: "",
        projectfile: C.KHAFILE_RELATIVE_PATH,
        to: config.output,
        kha: config.core.kha,
        haxe: config.core.haxe,
        build: path.resolve(C.CURRENT_PATH, config.output),
        debug: !!config.debug,
        engineConfig: config,
        ffmpeg: config.core.ffmpeg ? path.resolve(config.core.ffmpeg) : ""
    };

    let list = parsed.target ? [_getPlatformByValue(parsed.target)] : platformList;

    eachSeries(list, (key, next)=>{
        
        let target = platform[key];
        if(!config[target]){
            next();
            return;
        }

        let kmake = JSON.parse(JSON.stringify(kmakeBasic));
        kmake.target = target;
        if(target === platform.OSX || target === platform.Win) {
            if(config[target].graphics){
                kmake.graphics = config[target].graphics;
            }
        }

        _runKhaMake(kmake, next);

    }, (err)=>{
        if(err){
            cb(err);
            return;
        }

        if(config.core.clean_temp){
            let err = _cleanTempFolder();
            if(err){
                cb(err);
                return;
            }
        }

        console.log(colors.bold(colors.green("Done.")));
        cb(null, args);
    });
}

function _getPlatformByValue(v:string) : string {
    let key = "";
    for(var k in platform){
        if(platform[k] === v){
            key = k;
            break;
        }
    }
    return key;
}

interface KhaMakeConfig {
    target:string
    projectfile:string
    kha:string
    haxe:string
    to:string
    build:string
    debug:boolean
    engineConfig:Config
    graphics?:string
    ffmpeg?:string
}

async function _runKhaMake(config:KhaMakeConfig, cb) {
    if(!Object.keys(config.engineConfig.flags).length){
        console.log(colors.cyan(`Compiling ${config.engineConfig.name} to ${config.target}...`));
    }else{
        let txt = `Compiling ${config.engineConfig.name} to ${config.target} using:`;
        for(let flag in config.engineConfig.flags){
            txt += colors.gray(`\n- ${flag}: ${config.engineConfig.flags[flag]}`);
        }
        console.log(colors.cyan(txt));
    }
    
    console.log(colors.yellow(" - - - - "));

    let options:any = {
        from: C.CURRENT_PATH,
        to: config.to,
        projectfile: config.projectfile,
        target: config.target,
        vr: 'none',
        pch: false,
        intermediate: '',
        graphics: config.graphics,
        visualstudio: 'vs2017',
        kha: config.kha,
        haxe: config.haxe,
        ogg: '',
        aac: '',
        mp3: '',
        h264: '',
        webm: '',
        wmv: '',
        theora: '',
        kfx: '',
        krafix: '',
        ffmpeg: config.ffmpeg,
        nokrafix: false,
        embedflashassets: false,
        compile: config.engineConfig.core.compile,
        run: false,
        init: false,
        name: config.engineConfig.name,
        server: false,
        port: 8080,
        debug: config.debug,
        silent: false,
        watch: false
    };

    const khamakeApi = __non_webpack_require__(path.join(C.KHA_PATH, 'Tools/khamake/out/main.js'));

    let errString = "";
    await khamakeApi.run(options, {
        info: msg => {
            console.log(msg);
        },
        error: msgErr => {
            errString += msgErr + '\n';
        }
    });

    console.log(colors.yellow(" - - - - \n"));

    if(errString){
        cb(new Error(`Error: ${errString}`));
        return;
    }

    let err = createFolder(C.TEMP_PATH);
    if(err){
        cb(err);
        return;
    }

    if(config.target === "html5"){
        err = _moveHTML5Build(
            path.join(config.engineConfig.output, "html5"),
            path.join(config.engineConfig.output, "html5-build"),
            config.debug,
            config.engineConfig
        );
        if(err){
            cb(err);
            return;
        }
    }

    cb();
}

const releaseDestination = {
    html5: "html5",
    osx: "osx-build/build/$mode"
};

function _moveBuild(target:string, to:string, debug:boolean, config?:Config) : Error {
    let err:Error;
    let buildPath = releaseDestination[target].replace("$mode", debug ? "Debug" : "Release");
    let _from = path.join(C.TEMP_BUILD_PATH, buildPath);
    let _to = path.join(to, target);

    switch(target) {
        case platform.HTML5:
            err = _moveHTML5Build(_from, _to, debug, config);
            break;
        default:
            _to = path.join(_to, debug ? "debug" : "release");
            err = _copy(_from, _to);
            break;
    }

    return err
}

function _moveHTML5Build(from:string, to:string, debug:boolean, config:Config) : Error {
    //todo if exists a custom html file copy and replace vars
    let err:Error;

    let scriptName = config.html5.script;
    if(debug){
        err = _copy(path.join(from, `${scriptName}.js`), path.join(to, `${scriptName}.js`));
        if(err){
            return err;
        }

        err = _copy(path.join(from, `${scriptName}.js.map`), path.join(to, `${scriptName}.js.map`));
        if(err){
            return err;
        }
    }else{
        if(config.html5.uglify){
            let file:string;
            try {
                file = fs.readFileSync(path.join(from, `${scriptName}.js`), {encoding: "UTF-8"});
            }catch(e){
                return e;
            }

            let min:string;
            try {
                console.log(colors.cyan("Minifying javascript..."));
                min = execSync(`node ${C.ENGINE_PATH}/node_modules/uglify-js/bin/uglifyjs ${path.join(from, `${scriptName}.js`)} --compress --mangle`, {encoding: "UTF-8"}) as any;
            }catch(e){
                return e;
            }

            try {
                fs.ensureDirSync(to);
                fs.writeFileSync(path.join(to, `${scriptName}.js`), min, {encoding: "UTF-8", flag: "w"});
            }catch(e){
                return e;
            }

        }else{
            err = _copy(path.join(from, `${scriptName}.js`), path.join(to, `${scriptName}.js`));
            if(err){
                return err;
            }
        }
    }

    let html5File = config.html5.html_file ? path.resolve(C.CURRENT_PATH, config.html5.html_file) : path.join(C.HTML5_TEMPLATE_PATH, "index.html");
    let file:string;
    try {
        file = fs.readFileSync(html5File, {encoding: "UTF-8"});
    }catch(e){
        return e;
    }

    file = file.replace(/\{name\}/g, config.name);
    file = file.replace(/\{scriptName\}/g, scriptName);
    file = file.replace(/\{canvasID\}/g, config.html5.canvas);

    try {
        fs.writeFileSync(path.join(to, `index.html`), file, {encoding: "UTF-8"});
    }catch(e){
        return e;
    }

    if(fs.existsSync(path.join(from, "assets"))){
        return _copy(path.join(from, "assets"), path.join(to, "assets"));
    }

    return null;
}

function _copy(from:string, to:string) : Error {
    //console.log(colors.cyan(`Moving build '${from} to ${to}`));
    let err:Error;
    try {
        fs.copySync(from, to);
    }catch(e){
        err = e
    }
    return err;
}

function _cleanTempFolder() : Error {
    console.log(colors.cyan("Cleaning temporal files..."));
    let err:Error;
    try {
        fs.removeSync(C.TEMP_PATH);
    }catch(e){
        err = e
    }
    return err;
}
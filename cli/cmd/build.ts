import * as fs from 'fs-extra';
import * as path from 'path';
import {Command, ActionCallback} from "../cli";
import * as C from "../const";
import {existsConfigFile, createFolder} from "../utils";
import {parseConfig, Config, generateKhafileContent, platform} from "../config";
import {exec} from 'child_process';
import {series, eachSeries} from 'async';
import * as colors from 'colors';

const usage = `compile the current project
          ${C.ENGINE_NAME} build [ target ] [ -c config ]
          
          where [ target ] can be some platform as 'html5' or 'osx',
          and where [ -c config ] can be the prefix of a config file.
          For example: 'dev' to use 'dev.${C.ENGINE_NAME}.toml' 
          or 'prod' to use 'prod.${C.ENGINE_NAME}.toml'.
          
          By default will compile all the targets in 'dev.${C.ENGINE_NAME}.toml'`;

export const cmd:Command = {
    name: "build",
    alias: ["-b", "--build"],
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
    let parsed = {
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

    const file = _getConfigFile(parsed.config);
    if(!file){
        cb(new Error("Not found any config file."));
        return;
    }

    const config = parseConfig(file);
    if(!config){
        cb(new Error("Invalid config file"));
        return;
    }

    if(parsed.target){
        if(!config[parsed.target]){
            cb(new Error(`Target ${parsed.target} not defined in the config file.`));
            return;
        }

        if(config[parsed.target].disable){
            cb(new Error(`Target ${parsed.target} is disabled in the config file.`));
            return;
        }
    }

    let platformList = Object.keys(platform);
    let err = _generateKhafile(config);
    if(err){
        cb(err);
        return;
    }

    let kmakeBasic:KhaMakeConfig = {
        target: "",
        projectfile: path.join(C.TEMP_RELATIVE_PATH, "khafile.js"),
        to: C.TEMP_BUILD_PATH,
        kha: config.core.kha,
        haxe: config.core.haxe,
        build: path.resolve(C.CURRENT_PATH, config.output)
    };

    let existsTarget = false;
    for(let i = 0; i < platformList.length; i++){
        let target = platform[platformList[i]];
        if(config[target] && !config[target].disable) {
            existsTarget = true;
            break;
        }
    }

    if(!existsTarget){
        cb(new Error("No one platform it's defined as target in the config file."));
        return;
    }

    let list = parsed.target ? [_getPlatformByValue(parsed.target)] : platformList;

    eachSeries(list, (key, next)=>{
        
        let target = platform[key];
        if(!config[target] || config[target].disabled){
            next();
            return;
        }

        let kmake = JSON.parse(JSON.stringify(kmakeBasic));
        kmake.target = target;
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

function _getConfigFile(prefix:string) : string {
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

    console.log(colors.blue(`Using '${colors.magenta(fileName)}' config file.`));
    return file;
}

function _generateKhafile(config:Config) : Error {
    let err = createFolder(C.TEMP_PATH);
    if(err){
        return err;
    }

    try {
        fs.writeFileSync(path.join(C.TEMP_PATH, "khafile.js"), generateKhafileContent(config), {encoding: "UTF-8"});        
    } catch(e){
        err = e
    }

    return err
}

interface KhaMakeConfig {
    target:string
    projectfile:string
    kha:string
    haxe:string
    to:string
    build:string
}

async function _runKhaMake(config:KhaMakeConfig, cb) {
    console.log(colors.cyan(`Compiling ${config.target}...`));

    let cmd = `${C.KHA_MAKE_PATH} ${config.target} --compile`;
    //cmd += ` -t ${config.target}`;
    cmd += ` --projectfile ${config.projectfile}`;
    cmd += ` -k ${config.kha}`;
    cmd += ` --haxe ${config.haxe}`;
    cmd += ` --to ${config.to}`;
    
    console.log(colors.yellow(" - - - - "));
    exec(cmd, (err:Error, stdout:string, stderr:string)=>{
        console.log(stdout);
        console.log(colors.yellow(" - - - - \n"));

        if(err){
            cb(err);
            return;
        }

        err = createFolder(C.TEMP_PATH);
        if(err){
            cb(err);
            return;
        }

        err = _moveBuild(config.target, config.build);
        if(err){
            cb(err);
            return;
        }

        cb();
    });
}


function _moveBuild(target:string, to:string) : Error {
    let err:Error;

    try {
        switch(target){
            case "html5":
                fs.copySync(path.join(C.TEMP_BUILD_PATH, "html5"), path.join(to, "html5"));
                //todo move other platforms
                break;
        }
    }catch(e){
        err = e
    }

    return err
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
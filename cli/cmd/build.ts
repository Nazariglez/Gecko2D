import * as fs from 'fs-extra';
import * as path from 'path';
import {Command, ActionCallback} from "../cli";
import * as C from "../const";
import {existsConfigFile, createFolder, trimLineSpaces} from "./utils";
import {parseConfig, Config} from "../config";
import {exec} from 'child_process';
import {series} from 'async';
import * as colors from 'colors';

export const cmdBuild:Command = {
    name: "build",
    usage: "-",
    action: _action
}

function _action(args:string[], cb:ActionCallback) {
    if(!existsConfigFile()){
        cb(new Error(`Invalid ${C.ENGINE_NAME} project. Config file not found.`));
        return;
    }

    const file = _getConfigFile();
    if(!file){
        cb(new Error("Not found any config file."));
        return;
    }

    const config = parseConfig(file);
    if(!config){
        cb(new Error("Invalid config file"));
        return;
    }

    let err = _generateKhafile(config);
    if(err){
        cb(err);
        return;
    }

    let kmake:KhaMakeConfig = {
        target: "html5",
        projectfile: path.join(C.TEMP_RELATIVE_PATH, "khafile.js"),
        to: C.TEMP_BUILD_PATH,
        kha: config.core.kha,
        haxe: config.core.haxe,
        build: path.resolve(C.CURRENT_PATH, config.output)
    };


    series([
        function(next){
            _runKhaMake(kmake, next);
        }
    ], function(err){
        if(err){
            cb(err);
            return;
        }

        if(config.core.clean_temp){
            err = _cleanTempFolder();
            if(err){
                cb(err);
                return;
            }
        }

        console.log(colors.bold(colors.green("Done.")));
        cb(null, args);
    });
}

function _getConfigFile() : string {
    let fileName = `dev.${C.ENGINE_NAME}.toml`;
    const _pathFile = path.join(C.CURRENT_PATH, fileName);

    let file:string;
    if(fs.existsSync(_pathFile)){
        file = fs.readFileSync(_pathFile, {encoding: "UTF-8"});
    }else{
        const files = fs.readdirSync(C.CURRENT_PATH);
        for(let i = 0; i < files.length; i++) {
            if(files[i].indexOf(`${C.ENGINE_NAME}.toml`) !== -1){
                file = fs.readFileSync(path.join(C.CURRENT_PATH, files[i]), {encoding: "UTF-8"});
                fileName = files[i];
                break;
            }
        }
    }

    console.log(colors.blue(`Using '${colors.magenta(fileName)}' config file.`));
    return file;
}

function _generateKhafile(config:Config) : Error {
    let err = createFolder(C.TEMP_PATH);
    if(err){
        return err;
    }

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

    kfile += `
    p.targetOptions.html5.canvasId = "${config.html5.canvas}";
    p.targetOptions.html5.scriptName = "${config.html5.script}";
    p.targetOptions.html5.webgl = ${config.html5.webgl};
    `;

    kfile += "resolve(p);";

    kfile = trimLineSpaces(kfile);

    try {
        fs.writeFileSync(path.join(C.TEMP_PATH, "khafile.js"), kfile, {encoding: "UTF-8"});        
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

    let cmd = `${C.KHA_MAKE_PATH}`;
    cmd += ` -t ${config.target}`;
    cmd += ` --projectfile ${config.projectfile}`;
    cmd += ` -k ${config.kha}`;
    cmd += ` --haxe ${config.haxe}`;
    cmd += ` --to ${config.to}`;
    
    exec(cmd, (err:Error, stdout:string, stderr:string)=>{
        if(err){
            console.log(stdout);
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

async function syncExec(cmd, cb) : Promise<any> {
    return new Promise<any>((resolve, reject) => {
        const child = exec(cmd, (err, stdout, stderr) =>{
            let _err = cb(err, stdout, stderr);
            if(_err){
                reject(_err);
                return;
            }

            resolve(true);
        });
    });
}
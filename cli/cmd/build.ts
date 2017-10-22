import * as fs from 'fs';
import * as path from 'path';
import {Command} from "../cli";
import * as C from "../const";
import {existsConfigFile, createTempFolder, trimLineSpaces} from "./utils";
import {parseConfig, Config} from "../config";
import {exec} from 'child_process';

export const cmdBuild:Command = {
    name: "build",
    usage: "-",
    action: _action
}

function _action(args:string[]) : string[] {
    if(!existsConfigFile()){
        console.log(`Invalid ${C.ENGINE_NAME} project. Config file not found.`);
        return [];
    }

    const file = _getConfigFile();
    if(!file){
        console.log("Not found any config file.");
        return [];
    }

    const config = parseConfig(file);
    if(!config){
        console.log("Invalid config file");
        return;
    }

    let err = _generateKhafile(config);
    if(err){
        console.error(err);
        return [];
    }

    let kmake:KhaMakeConfig = {
        target: "html5",
        projectfile: path.join(C.TEMP_RELATIVE_PATH, "khafile.js"),
        from: ".",
        to: C.TEMP_BUILD_PATH,
        kha: config.core.kha,
        haxe: config.core.haxe,
    };

    _runKhaMake(kmake)
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

    console.log(`Using '${fileName}' config file.`);
    return file;
}

function _generateKhafile(config:Config) : Error {
    let err = createTempFolder();
    if(err){
        return err;
    }

    let kfile = trimLineSpaces(`
    let p = new Project("${config.name}");
    ${config.sources.map((s)=>{
        return `p.addSources("${s}");`
    }).join("\n")}

    p.targetOptions.html5.canvasId = "${config.html5.canvas}";
    p.targetOptions.html5.scriptName = "${config.html5.script}";
    p.targetOptions.html5.webgl = ${config.html5.webgl};

    resolve(p);
    `);

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
    from:string
    to:string
}

function _runKhaMake(config:KhaMakeConfig) {
    console.log(`Compiling ${config.target}...`);

    let cmd = `${C.KHA_MAKE_PATH}`;
    cmd += ` -t ${config.target}`;
    cmd += ` --projectfile ${config.projectfile}`;
    cmd += ` -k ${config.kha}`;
    cmd += ` --haxe ${config.haxe}`;
    //cmd += ` --from ${config.from}`;
    cmd += ` --to ${config.to}`;
    console.log(cmd);
    exec(cmd, (err:Error, stdout:string, stderr:string)=>{
        if(err){
            console.log(stdout);
            console.error(err);
            return;
        }

        //todo move the build to config.output
    });
}
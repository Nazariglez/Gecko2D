import * as fs from 'fs';
import * as path from 'path';
import {Command} from "../cli";
import {HAXE_PATH, KHA_PATH, KHA_MAKE_PATH, CURRENT_PATH, ENGINE_NAME, TEMP_PATH} from "../const";
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
        console.log(`Invalid ${ENGINE_NAME} project. Config file not found.`);
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

    console.log(config);
    let err = _generateKhafile(config);
    if(err){
        console.error(err);
        return [];
    }

    let kmake:KhaMakeConfig = {
        target: "html5",
        projectfile: "khafile.js",
        from: TEMP_PATH,
        to: path.join(TEMP_PATH, "./build"),
        kha: config.core.kha,
        haxe: config.core.haxe,
    };

    _runKhaMake(kmake)
}

function _getConfigFile() : string {
    let fileName = `dev.${ENGINE_NAME}.toml`;
    const _pathFile = path.join(CURRENT_PATH, fileName);

    let file:string;
    if(fs.existsSync(_pathFile)){
        file = fs.readFileSync(_pathFile, {encoding: "UTF-8"});
    }else{
        const files = fs.readdirSync(CURRENT_PATH);
        for(let i = 0; i < files.length; i++) {
            if(files[i].indexOf(`${ENGINE_NAME}.toml`) !== -1){
                file = fs.readFileSync(path.join(CURRENT_PATH, files[i]), {encoding: "UTF-8"});
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
    resolve(p);
    `);

    try {
        fs.writeFileSync(path.join(TEMP_PATH, "khafile.js"), kfile, {encoding: "UTF-8"});        
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
    let cmd = `${KHA_MAKE_PATH}`;
    cmd += ` -t ${config.target}`;
    cmd += ` --projectfile ${config.projectfile}`;
    cmd += ` -k ${config.kha}`;
    cmd += ` --haxe ${config.haxe}`;
    cmd += ` --from ${config.from}`;
    cmd += ` --to ${config.to}`;
    console.log(cmd);
    exec(cmd, (err:Error, stdout:string, stderr:string)=>{
        console.log(err, stdout, stderr);
    });
}
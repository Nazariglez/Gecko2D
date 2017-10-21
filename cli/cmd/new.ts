import * as fs from 'fs';
import * as path from 'path';
import {Command} from "../cli";
import {CURRENT_PATH, ENGINE_NAME} from "../const";
import {existsConfigFile} from "./utils";
import {defaultConfig} from "../config";

export const cmdNew:Command = {
    name: "new",
    usage: "-",
    action: _action
}

function _action(args:string[]) : string[] {
    if(existsConfigFile()){
        console.log(`Already exists a ${ENGINE_NAME} project in this path: ${CURRENT_PATH}`);
        return [];
    }

    let err = _createProject();
    if(err){
        console.error(err);
        return [];
    }

    console.log(`Created a new ${ENGINE_NAME} project.`);
    return args;
}

function _createProject() : Error {
    let err:Error;

    try {
        fs.writeFileSync(path.join(CURRENT_PATH,`dev.${ENGINE_NAME}.toml`), defaultConfig, {encoding: "UTF-8"});
    }catch(e){
        err = e;
    }

    return err;
}
import * as fs from 'fs';
import * as path from 'path';
import {Command, ActionCallback} from "../cli";
import {CURRENT_PATH, ENGINE_NAME} from "../const";
import {existsConfigFile} from "./utils";
import {defaultConfig} from "../config";
import * as colors from 'colors';

export const cmdNew:Command = {
    name: "new",
    usage: "-",
    action: _action
}

function _action(args:string[], cb:ActionCallback) {
    if(existsConfigFile()){
        cb(new Error(`Already exists a ${ENGINE_NAME} project in this path: ${CURRENT_PATH}`));
        return;
    }

    let err = _createProject();
    if(err){
        cb(err);
        return;
    }

    console.log(colors.green(`Created a new ${ENGINE_NAME} project.`));
    cb(null, args);
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
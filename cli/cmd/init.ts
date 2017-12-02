import * as fs from 'fs-extra';
import * as path from 'path';
import {Command, ActionCallback} from "../cli";
import * as C from "../const";
import {existsConfigFile, copyEngineToProject} from "../utils";
import {defaultConfig} from "../config";
import * as colors from 'colors';

export const cmd:Command = {
    name: "init",
    alias: ["i"],
    usage: "initialize a new project",
    action: _action
}

function _action(args:string[], cb:ActionCallback) {
    if(existsConfigFile()){
        cb(new Error(`Already exists a ${C.ENGINE_NAME} project in this path: ${C.CURRENT_PATH}`));
        return;
    }

    let err = _createProject();
    if(err){
        cb(err);
        return;
    }

    console.log(colors.green(`Created a new ${C.ENGINE_NAME} project.`));
    cb(null, args);
}

function _createProject() : Error {
    let err:Error;

    try {
        fs.writeFileSync(path.join(C.CURRENT_PATH,`dev.${C.ENGINE_NAME}.toml`), defaultConfig, {encoding: "UTF-8"});
    }catch(e){
        err = e;
    }

    if(err){
        return err;
    }

    return _copyGameTemplate();
}

function _copyGameTemplate() : Error {
    let err:Error;
    const files = fs.readdirSync(C.GAME_TEMPLATE_PATH);
    for(let i = 0; i < files.length; i++){
        let f = files[i];
        try {
            fs.copySync(path.join(C.GAME_TEMPLATE_PATH, f), path.join(C.CURRENT_PATH, f));            
        }catch(e){
            err = e;
            break;
        }
    }

    if(err){
        return err;
    }

    return copyEngineToProject();
}
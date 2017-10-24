import * as fs from 'fs-extra';
import * as path from 'path';
import {Command, ActionCallback} from "../cli";
import {CURRENT_PATH, ENGINE_NAME, ENGINE_PATH} from "../const";
import {existsConfigFile, copyEngineToProject} from "../utils";
import {defaultConfig} from "../config";
import * as colors from 'colors';

export const cmd:Command = {
    name: "init",
    alias: ["-i", "--init"],
    usage: "initialize a new project",
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

    if(err){
        return err;
    }

    return _copyTemplate();
}

function _copyTemplate() : Error {
    let err:Error;
    const templatePath = path.join(ENGINE_PATH, "template");
    const files = fs.readdirSync(templatePath);
    for(let i = 0; i < files.length; i++){
        let f = files[i];
        try {
            fs.copySync(path.join(templatePath, f), path.join(CURRENT_PATH, f));            
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
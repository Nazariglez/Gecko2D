import * as fs from 'fs-extra';
import * as path from 'path';
import {Command, ActionCallback} from "../cli";
import * as C from "../const";
import {existsConfigFile, copyEngineToProject} from "../utils";
import {defaultConfig} from "../config";
import * as colors from 'colors';
import * as isUrl from 'is-url';

export const cmd:Command = {
    name: "init",
    alias: ["i"],
    usage: "initialize a new project",
    action: _action
}

interface buildParseArgs {
    err?:string
    args:string[]
    template:string
    isUrl:boolean
}

function _parseArgs(args:string[]) : buildParseArgs {
    const parsed:buildParseArgs = {
        err: "",
        args: args,
        template: "",
        isUrl: false
    };

    console.log(args);

    if(!args.length){
        return parsed;
    }

    if(args[0][0] !== "-"){
        return parsed;
    }

    if(args.length >= 2 && args[0][0] === "-" && args[0] === "-t"){
        args.shift(); //discard -t
        let template = args.shift();
        if(template[0] === "-"){
            parsed.err = `Invalid template '-t ${template}'.`;
            return parsed;
        }

        parsed.template = template;
        parsed.isUrl = isUrl(template);
    }

    parsed.args = args;
    return parsed;
}

function _action(args:string[], cb:ActionCallback) {
    if(existsConfigFile()){
        cb(new Error(`Already exists a ${C.ENGINE_NAME} project in this path: ${C.CURRENT_PATH}`));
        return;
    }

    const parsed = _parseArgs(args);
    if(parsed.err){
        cb(new Error(parsed.err));
        return;
    }

    let err = _createProject(parsed.template || "basic", parsed.isUrl);
    if(err){
        cb(err);
        return;
    }

    console.log(colors.green(`Created a new ${C.ENGINE_NAME} project.`));
    cb(null, parsed.args);
}

function _createProject(template:string, isUrl:boolean = false) : Error {
    //todo if template isUrl downaload from github.com
    const templatePath = path.join(C.TEMPLATES_PATH, template);
    if(!fs.pathExistsSync(templatePath)){
        return new Error(`Game template '${template}' not found.`);
    }

    return _copyGameTemplate(templatePath);
}

function _createConfigFile() : Error {
    let err:Error;
    
    try {
        fs.writeFileSync(path.join(C.CURRENT_PATH,`dev.${C.ENGINE_NAME}.toml`), defaultConfig, {encoding: "UTF-8"});
    }catch(e){
        err = e;
    }

    return err;
}

function _copyGameTemplate(templatePath:string) : Error {
    let err:Error;
    const files = fs.readdirSync(templatePath);
    for(let i = 0; i < files.length; i++){
        let f = files[i];
        try {
            fs.copySync(path.join(templatePath, f), path.join(C.CURRENT_PATH, f));            
        }catch(e){
            err = e;
            break;
        }
    }

    if(err){
        return err;
    }

    if(!fs.existsSync(path.join(templatePath, `dev.${C.ENGINE_NAME}.toml`))){
        return _createConfigFile();
    }

    return null;
}
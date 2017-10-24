import * as fs from 'fs-extra';
import * as path from 'path';
import {ENGINE_NAME, CURRENT_PATH, TEMP_PATH, ENGINE_PATH} from "./const";

export function existsConfigFile() : boolean {
    const findName = `${ENGINE_NAME}.toml`;
    const files = fs.readdirSync(CURRENT_PATH);

    let exists = false;

    for(let i = 0; i < files.length; i++){
        if(files[i].indexOf(findName) !== -1){
            exists = true;
            break;
        }
    }

    return exists;
}

export function createFolder(folder:string) : Error {
    let err:Error;

    if(fs.existsSync(folder)){
        return err;
    }
    try {
        fs.mkdirSync(folder)
    } catch(e){
        err = e
    }

    return err
}

export function trimLineSpaces(input:string) : string {
    return input.split("\n").map((line)=>line.trim()).join("\n");
}

export function copyEngineToProject() : Error {
    let err:Error;

    try {
        fs.copySync(path.join(ENGINE_PATH, "Sources"), path.join(CURRENT_PATH, "Libraries", ENGINE_NAME, "Sources"));
    }catch(e){
        err = e;
    }
    
    return err;
}

export function nodeVersion() : [number, number, number] {
    let v = process.version;
    v = v.replace("v", "");
    
    let arr = v.split(/[\.||-]/);
    return [parseInt(arr[0]), parseInt(arr[1]), parseInt(arr[3])];
}
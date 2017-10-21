import * as fs from 'fs';
import {ENGINE_NAME, CURRENT_PATH, TEMP_PATH} from "../const";

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

export function createTempFolder() : Error {
    let err:Error;

    if(fs.existsSync(TEMP_PATH)){
        return err;
    }
    try {
        fs.mkdirSync(TEMP_PATH)
    } catch(e){
        err = e
    }

    return err
}

export function trimLineSpaces(input:string) : string {
    return input.split("\n").map((line)=>line.trim()).join("\n");
}
import {Command, ActionCallback} from '../cli';
import {existsConfigFile, copyEngineToProject, removeEngineFromLibraries} from '../utils';
import * as fs from 'fs-extra';
import * as colors from 'colors';
import * as C from '../const';

export const cmd:Command = {
    name: "update",
    alias: ["u"],
    usage: `update ${C.ENGINE_NAME} in the current project`,
    action: _action
};

function _action(args:string[], cb:ActionCallback) {
    if(!existsConfigFile){
        cb(new Error(`Invalid ${C.ENGINE_NAME} project.`));
        return;
    }

    console.log(colors.blue(`Updating ${C.ENGINE_NAME} at '${colors.magenta(`/Libraries/${C.ENGINE_NAME}`)}'...`));    
    let err = removeEngineFromLibraries();
    if(err){
        cb(err);
        return;
    }

    err = copyEngineToProject();
    if(err){
        cb(err);
        return;
    }

    console.log(colors.green(colors.bold("Done.")));
    cb(null, args);
}
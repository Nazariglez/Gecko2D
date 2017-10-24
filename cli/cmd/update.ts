import {Command, ActionCallback} from '../cli';
import {commands} from "./cmd";
import {existsConfigFile, copyEngineToProject} from './utils';
import * as colors from 'colors';
import * as C from '../const';

export const cmdUpdate:Command = {
    name: "update",
    alias: ["-u", "--update"],
    usage: `update ${C.ENGINE_NAME} in the current project`,
    action: _action
};

function _action(args:string[], cb:ActionCallback) {
    if(!existsConfigFile){
        cb(new Error(`Invalid ${C.ENGINE_NAME} project.`));
        return;
    }

    console.log(colors.blue(`Updating ${C.ENGINE_NAME} at '${colors.magenta(`/Libraries/${C.ENGINE_NAME}`)}'...`));
    let err = copyEngineToProject();
    if(err){
        cb(err);
        return;
    }

    console.log(colors.green(colors.bold("Done.")));
    cb(null, args);
}
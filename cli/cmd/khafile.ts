import {parseConfig, Config, getConfigFile, generateKhafileContent, createKhaFile} from '../config';
import { Command, ActionCallback } from '../cli';
import { existsConfigFile, createFolder } from '../utils';
import * as C from '../const';
import * as path from 'path';
import * as fs from 'fs-extra';

const usage = `generate the khafile.js using the config file
          ${C.ENGINE_NAME} khafile [ -c config ]

          where [ -c config ] can be the prefix of a config file.`;

export const cmd:Command = {
    name: "khafile",
    alias: ["k"],
    usage: usage,
    action: _action
};

interface buildParseArgs {
    err?:string
    args:string[]
    config:string
}

function _parseArgs(args:string[]) : buildParseArgs {
    let parsed:buildParseArgs = {
        err: "",
        args: args,
        config: ""
    };

    if(!args.length){
        return parsed;
    }

    if(args.length >= 2 && args[0] === "-c"){
        args.shift();
        let file = args.shift();
        if(file[0] === "-"){
            parsed.err = `Invalid config '-c ${file}'.`;
            return parsed;
        }

        parsed.config = file;
    }

    parsed.args = args;
    return parsed;
}

function _action(args:string[], cb:ActionCallback) {
    if(!existsConfigFile()){
        cb(new Error(`Invalid ${C.ENGINE_NAME} project. Config file not found.`));
        return;
    }

    const parsed = _parseArgs(args);
    if(parsed.err){
        cb(new Error(parsed.err));
        return;
    }

    args = parsed.args;

    console.log("Generating khafile.js...");
    let err = createKhaFile(parsed.config);
    if(err){
        cb(err);
        return;
    }

    cb(null, args);
}
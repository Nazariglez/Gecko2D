import {Command, ActionCallback} from '../cli';
import {existsConfigFile} from '../utils';
import {getConfigFile, parseConfig} from '../config';
import {cmd as serve} from './serve';
import {cmd as build} from './build';
import {series} from 'async';
import * as path from 'path';
import * as nodeWatch from 'node-watch';
import * as colors from 'colors';
import * as C from '../const';

const usage = `watch the project and serve the changes
        ${C.ENGINE_NAME} watch [ -c config ]

        where [ -c config ] can be the prefix of a config file.
        For example: 'dev' to use 'dev.${C.ENGINE_NAME}.toml'`;

export const cmd:Command = {
    name: "watch",
    alias: ["-w", "--watch"],
    usage: usage,
    action: _action
};

interface watchParseArgs {
    err:string
    args:string[]
    config:string
}

function _parseArgs(args:string[]) : watchParseArgs {
    let parsed:watchParseArgs = {
        err:"",
        args: args,
        config: ""
    };

    if(!args.length){
        return parsed;
    }

    if(args.length >= 2 && args[0][0] === "-" && args[0] === "-c"){
        args.shift(); //discard -c
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

    const file = getConfigFile(parsed.config, true);
    if(!file){
        cb(new Error("Not found any config file."));
        return;
    }

    const config = parseConfig(file);
    if(!config){
        cb(new Error("Invalid config file"));
        return;
    }

    let _args = [];
    if(parsed.config){
        _args = ["-c", parsed.config];
    }
    
    console.log(colors.yellow("Watching project..."));

    let _buildArgs = ["html5"].concat(_args);
    series([
        function(next:(err:Error, ...args)=>void){
            build.action([].concat(_buildArgs), next);
        },
        function(next:(err:Error, ...args)=>void){
            serve.action([].concat(_args), next);
        },
    ], (err:Error)=>{
        if(err){
            cb(err);
            return;
        }

        let watchList = [];
        let configFile = parsed.config ? parsed.config : "dev";
        watchList.push(configFile + "." + C.ENGINE_NAME + ".toml");

        if(config.libraries.length){
            watchList = watchList.concat(config.libraries.map(l => path.join("Libraries", l)));
        }

        if(config.sources.length){
            watchList = watchList.concat(config.sources.map(s => s));
        }

        watchList.push("Assets");

        let dirty = false;
        setInterval(()=>{
            if(!dirty){ return; }

            dirty = false;
            build.action([].concat(_buildArgs), (err:Error, args:string[])=>{
                if(err){
                    console.error(colors.red(err.message));
                    return;
                }
            });
        }, 500);


        const regex = /^[^.].*$/;
        nodeWatch(watchList, {recursive:true, filter: (name)=>{
            const s = name.split("/"); //todo split with windows separator
            return regex.test(s[s.length-1]);    
        }}, (evt:string, file:string)=>{
            console.log(colors.cyan(`Watch: ${colors.yellow(`[${evt}] -> ${file}`)}`));
            dirty = true;
            
            //todo watch assets apart and compile only assets when it's needed
        });
    });


    cb(null, args);
}
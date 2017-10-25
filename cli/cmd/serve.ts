import {Command, ActionCallback} from '../cli';
import {existsConfigFile} from '../utils';
import {getConfigFile, parseConfig} from '../config';
import * as colors from 'colors';
import * as http from 'http';
import * as nodeStatic from 'node-static';
import * as path from 'path';
import * as C from '../const';

const usage = `serve the html5 build
          ${C.ENGINE_NAME} serve [ -c config ]

          where [ -c config ] can be the prefix of a config file.
          For example: 'dev' to use 'dev.${C.ENGINE_NAME}.toml'`;

export const cmd:Command = {
    name: "serve",
    alias: ["-s", "--serve"],
    usage: usage,
    action: _action
};

interface serveParseArgs {
    err:string
    args:string[]
    config:string
}

function _parseArgs(args:string[]) : serveParseArgs {
    let parsed:serveParseArgs = {
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

    const buildPath = path.join(config.output, "html5");
    console.log(colors.blue(`Serving '${colors.magenta(buildPath)}' on '${colors.magenta(config.html5.serve_port.toString())}'`))

    const serv = new nodeStatic.Server(path.resolve(C.CURRENT_PATH, buildPath), {cache: 0});
    const htmlServer = http.createServer((req, res)=>{
        req.addListener("end", ()=>serv.serve(req, res)).resume();
    });

    htmlServer.on("error", (e:any)=>{
        if(e.code === "EADDRINUSE") {
            cb(new Error(`Error: Port ${config.html5.serve_port} is already in use.`));
            return;
        } else {
            cb(e);
            return;
        }
    });

    htmlServer.listen(config.html5.serve_port);
    cb(null, args);
}
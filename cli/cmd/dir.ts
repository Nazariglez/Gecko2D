import {Command, ActionCallback} from '../cli';
import {ENGINE_NAME} from '../const';
import * as path from 'path';

const usage = `print the directory where ${ENGINE_NAME} is installed
          ${ENGINE_NAME} dir [ -kha ]

          where [ -kha ] print the Kha directory`;

export const cmd:Command = {
    name: "dir",
    alias: [],
    usage: usage,
    action: _action
};

function _action(args:string[], cb:ActionCallback) {
    var kha:boolean = false;

    if(args.length && args[0] === "-kha"){
        args.shift();
        kha = true;
    }

    if(kha){
        console.log(path.join(process.cwd(), "Kha"));
    }else{
        console.log(process.cwd());
    }

    cb(null, args);
}
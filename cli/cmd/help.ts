import {Command, ActionCallback} from '../cli';
import {commands} from '../commands';
import * as C from '../const';

export const cmd:Command = {
    name: "help",
    alias: ["-h", "--help"],
    usage: "print command list help",
    action: _action
};

function _action(args:string[], cb:ActionCallback) {
    let txt = `Usage: ${C.ENGINE_NAME} <command> [ options ]
    
Commands:\n`;

    commands.forEach(cmd => {
        txt += `    ${cmd.name}`;
        if(cmd.alias&&cmd.alias.length){
            txt += `, ${cmd.alias.join(", ")}`; 
        }
        txt += "\n";
        txt += `        - ${cmd.usage}\n\n`;
    });

    console.log(txt);
    cb(null, args);
}
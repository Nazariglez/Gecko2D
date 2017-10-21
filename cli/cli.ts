import {commands} from "./cmd/cmd";

const inputArgs = process.argv.slice(2);
let commandList:{[key:string]:Command} = {};

export interface Command {
    name:string
    usage:string
    action:(args:string[])=>string[]
    sub?:Command[]
}

export function run(){
    if(!inputArgs.length){
        _showHelp();
        return;
    }


    commands.forEach(registerCommand);
    _processArgs();
}

export function registerCommand(command:Command) {
    commandList[command.name] = command;
}

function _processArgs(){
    let args = inputArgs;
    let cmd = args.shift();
    args = _runCommand(cmd, args);
}

function _showHelp() {
    console.log("help info");
}

function _runCommand(cmd:string, args:string[]) : string[] {
    let command = commandList[cmd];
    if(!command){
        console.log("Invalid command.");
        _showHelp();
        return;
    }

    args = command.action(args);

    return args;
}
import {Command, ActionCallback} from '../cli';
import {ENGINE_NAME} from '../const';

export const cmd:Command = {
    name: "version",
    alias: ["-v", "--version"],
    usage: `print ${ENGINE_NAME} version`,
    action: _action
};

function _action(args:string[], cb:ActionCallback) {
    console.log(`${ENGINE_NAME} version: ${require("../../package.json").version}`);
    cb(null, args);
}
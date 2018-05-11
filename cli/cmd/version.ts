import {Command, ActionCallback} from '../cli';
import {ENGINE_NAME} from '../const';

declare const __non_webpack_require__:any;

export const cmd:Command = {
    name: "version",
    alias: ["-v", "--version"],
    usage: `print ${ENGINE_NAME} version`,
    action: _action
};

function _action(args:string[], cb:ActionCallback) {
    console.log(`${ENGINE_NAME} version: ${__non_webpack_require__("../../package.json").version}`);
    cb(null, args);
}
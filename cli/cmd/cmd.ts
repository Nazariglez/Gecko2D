import {Command} from "../cli";
import {cmdNew} from "./new";
import {cmdBuild} from "./build";

export const commands:Command[] = [
    cmdNew,
    cmdBuild
];
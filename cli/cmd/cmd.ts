import {Command} from "../cli";
import {cmdInit} from "./init";
import {cmdBuild} from "./build";
import {cmdVersion} from "./version";
import {cmdHelp} from "./help";
import {cmdUpdate} from './update';

export const commands:Command[] = [
    cmdInit,
    cmdBuild,
    cmdVersion,
    cmdHelp,
    cmdUpdate
];
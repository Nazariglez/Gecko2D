import {Command} from "../cli";
import {cmdInit} from "./init";
import {cmdBuild} from "./build";
import {cmdVersion} from "./version";
import {cmdHelp} from "./help";

export const commands:Command[] = [
    cmdInit,
    cmdBuild,
    cmdVersion,
    cmdHelp,
];
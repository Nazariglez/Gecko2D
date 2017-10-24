import {Command} from "./cli";
import * as build from './cmd/build';
import * as help from './cmd/help';
import * as init from './cmd/init';
import * as update from './cmd/update';
import * as version from './cmd/version';

export const commands:Command[] = [
    build,
    help,
    init,
    update,
    version
].map(c => c.cmd);
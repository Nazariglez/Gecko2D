import {Command} from "./cli";
import * as build from './cmd/build';
import * as help from './cmd/help';
import * as init from './cmd/init';
import * as version from './cmd/version';
import * as serve from './cmd/serve';
import * as watch from './cmd/watch';
import * as docs from './cmd/docs';
import * as dir from './cmd/dir';
import * as khafile from "./cmd/khafile";

export const commands:Command[] = [
    build,
    help,
    init,
    version,
    serve,
    watch,
    //docs,
    dir,
    khafile
].map(c => c.cmd).sort((a, b)=>{
    if(a.name < b.name) return -1;
    if(a.name > b.name) return 1;
    return 0;
});
///<reference path="../node_modules/@types/node/index.d.ts" />
import {run} from './cli';
import {nodeVersion} from './cmd/utils';
import * as colors from 'colors';

if(nodeVersion()[0] < 6){
    console.error(colors.red("Invalid node version. Must be >= 6.x.x"));
}else{
    run();
}


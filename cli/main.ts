///<reference path="../node_modules/@types/node/index.d.ts" />
import {run} from './cli';
import {nodeVersion, getRequiredNodeVersion} from './utils';
import * as colors from 'colors';

if(nodeVersion()[0] < getRequiredNodeVersion()[0]){
    console.error(colors.red("Invalid node version. Must be >= " + getRequiredNodeVersion().join(".")));
}else{
    run();
}


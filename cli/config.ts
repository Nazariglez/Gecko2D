import * as C from "./const";
import * as path from 'path';
import * as toml from 'toml';
import * as colors from 'colors';

export const defaultConfig = `# development ${C.ENGINE_NAME} config.
name = "My ${C.ENGINE_NAME} Game"
sources = ["Sources"]
libraries = []                  #libs at Libraries folder or haxelib
output = "build"                #build output

[html5]
enable = true
webgl = true
canvas = "khanvas"          #canvas id
script = "game"             #script name

[core]
clean_temp = true               #clean temporal files after compile
haxe = ""
kha = ""
`;

export interface Config {
    name:string
    sources:string[]
    libraries:string[]
    output:string

    html5:ConfigHTML5

    core:ConfigCore
}

interface ConfigHTML5 {
    enable:boolean
    webgl:boolean
    canvas:string
    script:string
}

interface ConfigCore {
    clean_temp:boolean
    haxe:string
    kha:string
}

export function parseConfig(input:string) : Config {
    let config:Config;

    try {
        config = toml.parse(input) as Config;
    } catch(e){
        console.error(colors.red(`Error: (${e.line},${e.column}) ${e.message}`));
    }

    if(config){
        config.core.haxe = config.core.haxe ? path.resolve(config.core.haxe) : C.HAXE_PATH;
        config.core.kha = config.core.kha ? path.resolve(config.core.kha) : C.KHA_PATH;

        config.libraries.unshift(C.ENGINE_NAME);
    }

    return config;
}
import * as C from "./const";
import * as path from 'path';
import * as toml from 'toml';

export const defaultConfig = `# development ${C.ENGINE_NAME} config.
name = "My ${C.ENGINE_NAME} Game"
sources = ["src"]

[html5]
enable = true

[core]
haxe = ""
kha = ""
`;

export interface Config {
    name:string
    sources:string[]

    html5:ConfigHTML5

    core:ConfigCore
}

interface ConfigHTML5 {
    enable:boolean
}

interface ConfigCore {
    haxe:string
    kha:string
}

export function parseConfig(input:string) : Config {
    let config:Config;

    try {
        config = toml.parse(input) as Config;
    } catch(e){
        console.error(`Error: (${e.line},${e.column}) ${e.message}`);
    }

    if(config){
        config.core.haxe = config.core.haxe ? path.resolve(config.core.haxe) : C.HAXE_PATH;
        config.core.kha = config.core.kha ? path.resolve(config.core.kha) : C.KHA_PATH;
    }

    return config;
}
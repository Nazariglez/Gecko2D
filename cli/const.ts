import * as path from "path";

export const ENGINE_NAME = "gecko";
export const FLAG_PREFIX = "flag_";
export const CURRENT_PATH = process.cwd();
export const TEMP_RELATIVE_PATH = "./kha_build";
export const KHAFILE_RELATIVE_PATH = "./khafile.js";
export const KHAFILE_PATH = path.resolve(CURRENT_PATH, KHAFILE_RELATIVE_PATH);
export const TEMP_PATH = path.join(CURRENT_PATH, TEMP_RELATIVE_PATH);
export const TEMP_BUILD_PATH = path.join(TEMP_PATH, "build");
export const ENGINE_PATH = path.resolve(__dirname, "../../");
export const ENGINE_SOURCE_PATH = path.join(ENGINE_PATH, "Sources");
export const COMMANDS_PATH = path.resolve(ENGINE_PATH, "cli/cmd");
export const KHA_PATH = path.join(ENGINE_PATH, "Kha");
export const KHA_MAKE_PATH = path.join(KHA_PATH, (process.platform === 'win32') ? "make.bat" : "make.sh");
export const HAXE_PATH = path.join(KHA_PATH, "Tools", "haxe");
export const TEMPLATES_PATH = path.join(ENGINE_PATH, "templates");
export const GAME_TEMPLATE_PATH = path.join(TEMPLATES_PATH, "game");
export const BUILD_TEMPLATES_PATH = path.join(ENGINE_PATH, "build_templates");
export const HTML5_TEMPLATE_PATH = path.join(BUILD_TEMPLATES_PATH, "html5");

export const HTML5_SERVE_PORT = 8080;
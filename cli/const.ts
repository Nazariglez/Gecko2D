import * as path from "path";

export const CURRENT_PATH = process.cwd();
export const ENGINE_PATH = path.resolve(__dirname, "../../");
export const KHA_PATH = path.join(ENGINE_PATH, "Kha");
export const KHA_MAKE_PATH = path.join(KHA_PATH, "make.js");
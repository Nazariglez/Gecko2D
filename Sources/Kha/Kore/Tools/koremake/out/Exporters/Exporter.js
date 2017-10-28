"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const fs = require("fs-extra");
const path = require("path");
class Exporter {
    constructor() {
    }
    writeFile(file) {
        this.out = fs.openSync(file, 'w');
    }
    closeFile() {
        fs.closeSync(this.out);
    }
    p(line = '', indent = 0) {
        let tabs = '';
        for (let i = 0; i < indent; ++i)
            tabs += '\t';
        let data = new Buffer(tabs + line + '\n');
        fs.writeSync(this.out, data, 0, data.length, null);
    }
    nicePath(from, to, filepath) {
        let absolute = filepath;
        if (!path.isAbsolute(absolute)) {
            absolute = path.resolve(from, filepath);
        }
        return path.relative(to, absolute);
    }
}
exports.Exporter = Exporter;
//# sourceMappingURL=Exporter.js.map
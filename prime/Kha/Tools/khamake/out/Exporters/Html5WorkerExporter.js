"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const Html5Exporter_1 = require("./Html5Exporter");
class Html5WorkerExporter extends Html5Exporter_1.Html5Exporter {
    constructor(options) {
        super(options);
        this.sources.pop();
        this.addSourceDirectory(path.join(options.kha, 'Backends', 'HTML5-Worker'));
    }
}
exports.Html5WorkerExporter = Html5WorkerExporter;
//# sourceMappingURL=Html5WorkerExporter.js.map
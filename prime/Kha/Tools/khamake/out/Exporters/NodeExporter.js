"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const Html5Exporter_1 = require("./Html5Exporter");
class NodeExporter extends Html5Exporter_1.Html5Exporter {
    constructor(options) {
        super(options);
        this.removeSourceDirectory(path.join(options.kha, 'Backends', 'HTML5'));
        this.addSourceDirectory(path.join(options.kha, 'Backends', 'Node'));
    }
}
exports.NodeExporter = NodeExporter;
//# sourceMappingURL=NodeExporter.js.map
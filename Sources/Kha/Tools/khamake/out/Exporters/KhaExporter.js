"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const Exporter_1 = require("./Exporter");
class KhaExporter extends Exporter_1.Exporter {
    constructor(options) {
        super();
        this.options = options;
        this.width = 640;
        this.height = 480;
        this.sources = [];
        this.libraries = [];
        this.addSourceDirectory(path.join(options.kha, 'Sources'));
        this.projectFiles = !options.noproject;
        this.parameters = [];
        // this.parameters = ['--macro kha.internal.GraphicsBuilder.build("' + this.backend().toLowerCase() + '")'];
        this.addSourceDirectory(path.join(options.kha, 'Backends', this.backend()));
    }
    sysdir() {
        return this.systemDirectory;
    }
    setWidthAndHeight(width, height) {
        this.width = width;
        this.height = height;
    }
    setName(name) {
        this.name = name;
        this.safename = name.replace(/ /g, '-');
    }
    setSystemDirectory(systemDirectory) {
        this.systemDirectory = systemDirectory;
    }
    addShader(shader) {
    }
    addSourceDirectory(path) {
        this.sources.push(path);
    }
    addLibrary(library) {
        this.libraries.push(library);
    }
    removeSourceDirectory(path) {
        for (let i = 0; i < this.sources.length; ++i) {
            if (this.sources[i] === path) {
                this.sources.splice(i, 1);
                return;
            }
        }
    }
    copyImage(platform, from, to, options, cache) {
        return __awaiter(this, void 0, void 0, function* () {
            return [];
        });
    }
    copySound(platform, from, to, options) {
        return __awaiter(this, void 0, void 0, function* () {
            return [];
        });
    }
    copyVideo(platform, from, to, options) {
        return __awaiter(this, void 0, void 0, function* () {
            return [];
        });
    }
    copyBlob(platform, from, to, options) {
        return __awaiter(this, void 0, void 0, function* () {
            return [];
        });
    }
    copyFont(platform, from, to, options) {
        return __awaiter(this, void 0, void 0, function* () {
            return yield this.copyBlob(platform, from, to + '.ttf', options);
        });
    }
}
exports.KhaExporter = KhaExporter;
//# sourceMappingURL=KhaExporter.js.map
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
const fs = require("fs-extra");
const path = require("path");
const KhaExporter_1 = require("./KhaExporter");
const Converter_1 = require("../Converter");
const ImageTool_1 = require("../ImageTool");
class KromExporter extends KhaExporter_1.KhaExporter {
    constructor(options) {
        super(options);
    }
    backend() {
        return 'Krom';
    }
    haxeOptions(name, targetOptions, defines) {
        defines.push('js-classic');
        defines.push('sys_' + this.options.target);
        defines.push('sys_g1');
        defines.push('sys_g2');
        defines.push('sys_g3');
        defines.push('sys_g4');
        defines.push('sys_a1');
        defines.push('sys_a2');
        defines.push('kha_js');
        defines.push('kha_' + this.options.target);
        defines.push('kha_' + this.options.target + '_js');
        defines.push('kha_' + this.options.graphics);
        defines.push('kha_g1');
        defines.push('kha_g2');
        defines.push('kha_g3');
        defines.push('kha_g4');
        defines.push('kha_a1');
        defines.push('kha_a2');
        this.parameters.push('-debug');
        return {
            from: this.options.from.toString(),
            to: path.join(this.sysdir(), 'krom.js.temp'),
            realto: path.join(this.sysdir(), 'krom.js'),
            sources: this.sources,
            libraries: this.libraries,
            defines: defines,
            parameters: this.parameters,
            haxeDirectory: this.options.haxe,
            system: this.sysdir(),
            language: 'js',
            width: this.width,
            height: this.height,
            name: name,
            main: this.options.main,
        };
    }
    export(name, targetOptions, haxeOptions) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.ensureDirSync(path.join(this.options.to, this.sysdir()));
        });
    }
    copySound(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to + '.wav'), { overwrite: true });
            return [to + '.wav'];
        });
    }
    copyImage(platform, from, to, options, cache) {
        return __awaiter(this, void 0, void 0, function* () {
            let format = yield ImageTool_1.exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), options, undefined, false, false, cache);
            return [to + '.' + format];
        });
    }
    copyBlob(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to), { overwrite: true });
            return [to];
        });
    }
    copyVideo(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.ensureDirSync(path.join(this.options.to, this.sysdir(), path.dirname(to)));
            let webm = yield Converter_1.convert(from, path.join(this.options.to, this.sysdir(), to + '.webm'), this.options.webm);
            let files = [];
            if (webm)
                files.push(to + '.webm');
            return files;
        });
    }
}
exports.KromExporter = KromExporter;
//# sourceMappingURL=KromExporter.js.map
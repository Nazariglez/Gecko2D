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
const uuid = require('uuid');
class UnityExporter extends KhaExporter_1.KhaExporter {
    constructor(options) {
        super(options);
        fs.removeSync(path.join(this.options.to, this.sysdir(), 'Assets', 'Sources'));
    }
    backend() {
        return 'Unity';
    }
    haxeOptions(name, targetOptions, defines) {
        defines.push('no-root');
        defines.push('no-compilation');
        defines.push('sys_' + this.options.target);
        defines.push('sys_g1');
        defines.push('sys_g2');
        defines.push('sys_g3');
        defines.push('sys_g4');
        defines.push('sys_a1');
        defines.push('kha_cs');
        defines.push('kha_' + this.options.target);
        defines.push('kha_' + this.options.target + '_cs');
        defines.push('kha_g1');
        defines.push('kha_g2');
        defines.push('kha_g3');
        defines.push('kha_g4');
        defines.push('kha_a1');
        return {
            from: this.options.from,
            to: path.join(this.sysdir(), 'Assets', 'Sources'),
            sources: this.sources,
            libraries: this.libraries,
            defines: defines,
            parameters: this.parameters,
            haxeDirectory: this.options.haxe,
            system: this.sysdir(),
            language: 'cs',
            width: this.width,
            height: this.height,
            name: name,
            main: this.options.main,
        };
    }
    export(name, targetOptions, haxeOptions) {
        return __awaiter(this, void 0, void 0, function* () {
            let copyDirectory = (from, to) => {
                let files = fs.readdirSync(path.join(__dirname, '..', '..', 'Data', 'unity', from));
                fs.ensureDirSync(path.join(this.options.to, this.sysdir(), to));
                for (let file of files) {
                    let text = fs.readFileSync(path.join(__dirname, '..', '..', 'Data', 'unity', from, file), 'utf8');
                    fs.writeFileSync(path.join(this.options.to, this.sysdir(), to, file), text);
                }
            };
            copyDirectory('Assets', 'Assets');
            copyDirectory('Editor', 'Assets/Editor');
            copyDirectory('ProjectSettings', 'ProjectSettings');
        });
    }
    /*copyMusic(platform, from, to, encoders, callback) {
        callback([to]);
    }*/
    copySound(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            let ogg = yield Converter_1.convert(from, path.join(this.options.to, this.sysdir(), 'Assets', 'Resources', 'Sounds', to + '.ogg'), this.options.ogg);
            return [to + '.ogg'];
        });
    }
    copyImage(platform, from, to, asset, cache) {
        return __awaiter(this, void 0, void 0, function* () {
            let format = yield ImageTool_1.exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), 'Assets', 'Resources', 'Images', to), asset, undefined, false, true, cache);
            return [to + '.' + format];
        });
    }
    copyBlob(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), 'Assets', 'Resources', 'Blobs', to + '.bytes'), { overwrite: true });
            return [to];
        });
    }
    copyVideo(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            return [to];
        });
    }
}
exports.UnityExporter = UnityExporter;
//# sourceMappingURL=UnityExporter.js.map
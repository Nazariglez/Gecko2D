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
const child_process = require("child_process");
const fs = require("fs-extra");
const path = require("path");
const KhaExporter_1 = require("./KhaExporter");
const Haxe_1 = require("../Haxe");
const log = require("../log");
class EmptyExporter extends KhaExporter_1.KhaExporter {
    constructor(options) {
        super(options);
    }
    backend() {
        return 'Empty';
    }
    haxeOptions(name, targetOptions, defines) {
        defines.push('sys_g1');
        defines.push('sys_g2');
        defines.push('sys_g3');
        defines.push('sys_g4');
        defines.push('sys_a1');
        defines.push('sys_a2');
        defines.push('kha_g1');
        defines.push('kha_g2');
        defines.push('kha_g3');
        defines.push('kha_g4');
        defines.push('kha_a1');
        defines.push('kha_a2');
        return {
            from: this.options.from,
            to: path.join(this.sysdir(), 'docs.xml'),
            sources: this.sources,
            libraries: this.libraries,
            defines: defines,
            parameters: this.parameters,
            haxeDirectory: this.options.haxe,
            system: this.sysdir(),
            language: 'xml',
            width: this.width,
            height: this.height,
            name: name,
            main: this.options.main,
        };
    }
    export(name, _targetOptions, haxeOptions) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.ensureDirSync(path.join(this.options.to, this.sysdir()));
            let result = yield Haxe_1.executeHaxe(this.options.to, this.options.haxe, ['project-' + this.sysdir() + '.hxml']);
            if (result === 0) {
                let doxresult = child_process.spawnSync('haxelib', ['run', 'dox', '-in', 'kha.*', '-i', path.join('build', this.sysdir(), 'docs.xml')], { env: process.env, cwd: path.normalize(this.options.from) });
                if (doxresult.stdout.toString() !== '') {
                    log.info(doxresult.stdout.toString());
                }
                if (doxresult.stderr.toString() !== '') {
                    log.error(doxresult.stderr.toString());
                }
            }
        });
    }
    copySound(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            return [''];
        });
    }
    copyImage(platform, from, to, asset) {
        return __awaiter(this, void 0, void 0, function* () {
            return [''];
        });
    }
    copyBlob(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            return [''];
        });
    }
    copyVideo(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            return [''];
        });
    }
}
exports.EmptyExporter = EmptyExporter;
//# sourceMappingURL=EmptyExporter.js.map
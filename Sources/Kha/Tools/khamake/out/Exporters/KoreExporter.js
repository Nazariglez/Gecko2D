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
const GraphicsApi_1 = require("../GraphicsApi");
const Platform_1 = require("../Platform");
const ImageTool_1 = require("../ImageTool");
class KoreExporter extends KhaExporter_1.KhaExporter {
    constructor(options) {
        super(options);
        // Files.removeDirectory(this.directory.resolve(Paths.get(this.sysdir() + "-build", "Sources")));
    }
    backend() {
        return 'Kore';
    }
    haxeOptions(name, targetOptions, defines) {
        defines.push('no-compilation');
        defines.push('sys_' + this.options.target);
        defines.push('sys_kore');
        defines.push('sys_g1');
        defines.push('sys_g2');
        defines.push('sys_g3');
        defines.push('sys_g4');
        defines.push('sys_a1');
        defines.push('sys_a2');
        defines.push('kha_cpp');
        defines.push('kha_' + this.options.target);
        defines.push('kha_' + this.options.target + '_cpp');
        defines.push('kha_' + this.options.graphics);
        defines.push('kha_kore');
        defines.push('kha_g1');
        defines.push('kha_g2');
        defines.push('kha_g3');
        defines.push('kha_g4');
        defines.push('kha_a1');
        defines.push('kha_a2');
        if (this.options.vr === 'gearvr') {
            defines.push('vr_gearvr');
        }
        else if (this.options.vr === 'cardboard') {
            defines.push('vr_cardboard');
        }
        else if (this.options.vr === 'rift') {
            defines.push('vr_rift');
        }
        return {
            from: this.options.from,
            to: path.join(this.sysdir() + '-build', 'Sources'),
            sources: this.sources,
            libraries: this.libraries,
            defines: defines,
            parameters: this.parameters,
            haxeDirectory: this.options.haxe,
            system: this.sysdir(),
            language: 'cpp',
            width: this.width,
            height: this.height,
            name: name,
            main: this.options.main,
        };
    }
    export(name, targetOptions, haxeOptions) {
        return __awaiter(this, void 0, void 0, function* () {
        });
    }
    copySound(platform, from, to, options) {
        return __awaiter(this, void 0, void 0, function* () {
            if (options.quality < 1) {
                fs.ensureDirSync(path.join(this.options.to, this.sysdir(), path.dirname(to)));
                let ogg = yield Converter_1.convert(from, path.join(this.options.to, this.sysdir(), to + '.ogg'), this.options.ogg);
                return [to + '.ogg'];
            }
            else {
                fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to + '.wav'), { overwrite: true });
                return [to + '.wav'];
            }
        });
    }
    copyImage(platform, from, to, options, cache) {
        return __awaiter(this, void 0, void 0, function* () {
            if (platform === Platform_1.Platform.iOS && options.quality < 1) {
                let format = yield ImageTool_1.exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), options, 'pvr', true, false, cache);
                return [to + '.' + format];
            }
            else if (platform === Platform_1.Platform.Windows && options.quality < 1 && (this.options.graphics === GraphicsApi_1.GraphicsApi.OpenGL || this.options.graphics === GraphicsApi_1.GraphicsApi.Vulkan)) {
                // let format = await exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), options, 'ASTC', true, false, cache);
                let format = yield ImageTool_1.exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), options, 'DXT5', true, false, cache);
                return [to + '.' + format];
            }
            else {
                let format = yield ImageTool_1.exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), options, 'lz4', true, false, cache);
                return [to + '.' + format];
            }
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
            if (platform === Platform_1.Platform.Windows) {
                yield Converter_1.convert(from, path.join(this.options.to, this.sysdir(), to + '.avi'), this.options.h264);
                return [to + '.avi'];
            }
            else if (platform === Platform_1.Platform.iOS || platform === Platform_1.Platform.OSX) {
                yield Converter_1.convert(from, path.join(this.options.to, this.sysdir(), to + '.mp4'), this.options.h264);
                return [to + '.mp4'];
            }
            else if (platform === Platform_1.Platform.Android) {
                yield Converter_1.convert(from, path.join(this.options.to, this.sysdir(), to + '.ts'), this.options.h264);
                return [to + '.ts'];
            }
            else {
                yield Converter_1.convert(from, path.join(this.options.to, this.sysdir(), to + '.ogv'), this.options.theora);
                return [to + '.ogv'];
            }
        });
    }
}
exports.KoreExporter = KoreExporter;
//# sourceMappingURL=KoreExporter.js.map
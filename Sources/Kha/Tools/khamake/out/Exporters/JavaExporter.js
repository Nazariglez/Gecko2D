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
const ImageTool_1 = require("../ImageTool");
class JavaExporter extends KhaExporter_1.KhaExporter {
    constructor(options) {
        super(options);
        fs.removeSync(path.join(this.options.to, this.sysdir(), 'Sources'));
    }
    haxeOptions(name, targetOptions, defines) {
        defines.push('no-compilation');
        defines.push('sys_' + this.options.target);
        defines.push('sys_g1');
        defines.push('sys_g2');
        defines.push('sys_a1');
        defines.push('kha_' + this.options.target);
        if (this.options.target !== 'java') {
            defines.push('kha_java');
            defines.push('kha_' + this.options.target + '_java');
        }
        defines.push('kha_g1');
        defines.push('kha_g2');
        defines.push('kha_a1');
        return {
            from: this.options.from,
            to: path.join(this.sysdir(), 'Sources'),
            sources: this.sources,
            libraries: this.libraries,
            defines: defines,
            parameters: this.parameters,
            haxeDirectory: this.options.haxe,
            system: this.sysdir(),
            language: 'java',
            width: this.width,
            height: this.height,
            name: name,
            main: this.options.main,
        };
    }
    export(name, targetOptions, haxeOptions) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.ensureDirSync(path.join(this.options.to, this.sysdir()));
            this.exportEclipseProject();
        });
    }
    backend() {
        return 'Java';
    }
    exportEclipseProject() {
        this.writeFile(path.join(this.options.to, this.sysdir(), '.classpath'));
        this.p('<?xml version="1.0" encoding="UTF-8"?>');
        this.p('<classpath>');
        this.p('\t<classpathentry kind="src" path="Sources/src"/>');
        this.p('\t<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>');
        this.p('\t<classpathentry kind="output" path="bin"/>');
        this.p('</classpath>');
        this.closeFile();
        this.writeFile(path.join(this.options.to, this.sysdir(), '.project'));
        this.p('<?xml version="1.0" encoding="UTF-8"?>');
        this.p('<projectDescription>');
        this.p('\t<name>' + path.parse(this.options.to).name + '</name>');
        this.p('\t<comment></comment>');
        this.p('\t<projects>');
        this.p('\t</projects>');
        this.p('\t<buildSpec>');
        this.p('\t\t<buildCommand>');
        this.p('\t\t\t<name>org.eclipse.jdt.core.javabuilder</name>');
        this.p('\t\t\t<arguments>');
        this.p('\t\t\t</arguments>');
        this.p('\t\t</buildCommand>');
        this.p('\t</buildSpec>');
        this.p('\t<natures>');
        this.p('\t\t<nature>org.eclipse.jdt.core.javanature</nature>');
        this.p('\t</natures>');
        this.p('</projectDescription>');
        this.closeFile();
    }
    /*copyMusic(platform, from, to, encoders) {
        this.copyFile(from, this.directory.resolve(this.sysdir()).resolve(to + '.wav'));
        callback([to + '.wav']);
    }*/
    copySound(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            fs.copySync(from.toString(), path.join(this.options.to, this.sysdir(), to + '.wav'), { overwrite: true });
            return [to + '.wav'];
        });
    }
    copyImage(platform, from, to, asset, cache) {
        return __awaiter(this, void 0, void 0, function* () {
            let format = yield ImageTool_1.exportImage(this.options.kha, from, path.join(this.options.to, this.sysdir(), to), asset, undefined, false, false, cache);
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
            return [to];
        });
    }
}
exports.JavaExporter = JavaExporter;
//# sourceMappingURL=JavaExporter.js.map
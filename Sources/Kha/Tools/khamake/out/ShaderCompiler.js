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
const os = require("os");
const path = require("path");
const chokidar = require("chokidar");
const GraphicsApi_1 = require("./GraphicsApi");
const Platform_1 = require("./Platform");
const AssetConverter_1 = require("./AssetConverter");
const log = require("./log");
class CompiledShader {
    constructor() {
        this.files = [];
        this.inputs = [];
        this.outputs = [];
        this.uniforms = [];
        this.types = [];
    }
}
exports.CompiledShader = CompiledShader;
class ShaderCompiler {
    constructor(exporter, platform, compiler, to, temp, builddir, options, shaderMatchers) {
        this.exporter = exporter;
        if (platform.endsWith('-native'))
            platform = platform.substr(0, platform.length - '-native'.length);
        if (platform.endsWith('-hl'))
            platform = platform.substr(0, platform.length - '-hl'.length);
        this.platform = platform;
        this.compiler = compiler;
        this.type = ShaderCompiler.findType(platform, options);
        this.options = options;
        this.to = to;
        this.temp = temp;
        this.builddir = builddir;
        this.shaderMatchers = shaderMatchers;
    }
    close() {
        if (this.watcher)
            this.watcher.close();
    }
    static findType(platform, options) {
        switch (platform) {
            case Platform_1.Platform.Empty:
            case Platform_1.Platform.Node:
                return 'glsl';
            case Platform_1.Platform.Flash:
                return 'agal';
            case Platform_1.Platform.Android:
                if (options.graphics === GraphicsApi_1.GraphicsApi.Vulkan) {
                    return 'spirv';
                }
                else {
                    return 'essl';
                }
            case Platform_1.Platform.HTML5:
            case Platform_1.Platform.DebugHTML5:
            case Platform_1.Platform.HTML5Worker:
            case Platform_1.Platform.Tizen:
            case Platform_1.Platform.Pi:
                return 'essl';
            case Platform_1.Platform.tvOS:
            case Platform_1.Platform.iOS:
                if (options.graphics === GraphicsApi_1.GraphicsApi.Metal) {
                    return 'metal';
                }
                else {
                    return 'essl';
                }
            case Platform_1.Platform.Windows:
                if (options.graphics === GraphicsApi_1.GraphicsApi.Vulkan) {
                    return 'spirv';
                }
                else if (options.graphics === GraphicsApi_1.GraphicsApi.OpenGL) {
                    return 'glsl';
                }
                else if (options.graphics === GraphicsApi_1.GraphicsApi.Direct3D11 || options.graphics === GraphicsApi_1.GraphicsApi.Direct3D12) {
                    return 'd3d11';
                }
                else {
                    return 'd3d9';
                }
            case Platform_1.Platform.WindowsApp:
                return 'd3d11';
            case Platform_1.Platform.Xbox360:
            case Platform_1.Platform.PlayStation3:
                return 'd3d9';
            case Platform_1.Platform.Linux:
                if (options.graphics === GraphicsApi_1.GraphicsApi.Vulkan) {
                    return 'spirv';
                }
                else {
                    return 'glsl';
                }
            case Platform_1.Platform.OSX:
                if (options.graphics === GraphicsApi_1.GraphicsApi.Metal) {
                    return 'metal';
                }
                else {
                    return 'glsl';
                }
            case Platform_1.Platform.Unity:
                return 'hlsl';
            case Platform_1.Platform.Krom:
                if (process.platform === 'win32') {
                    return 'd3d11';
                }
                else {
                    return 'glsl';
                }
            default:
                for (let p in Platform_1.Platform) {
                    if (platform === p) {
                        return 'none';
                    }
                }
                return 'glsl';
        }
    }
    watch(watch, match, options, recompileAll) {
        return new Promise((resolve, reject) => {
            let shaders = [];
            let ready = false;
            this.watcher = chokidar.watch(match, { ignored: /[\/\\]\./, persistent: watch });
            this.watcher.on('add', (filepath) => {
                let file = path.parse(filepath);
                if (ready) {
                    switch (file.ext) {
                        case '.glsl':
                            if (!file.name.endsWith('.inc')) {
                                log.info('Compiling ' + file.name);
                                this.compileShader(filepath, options, recompileAll);
                            }
                            break;
                    }
                }
                else {
                    switch (file.ext) {
                        case '.glsl':
                            if (!file.name.endsWith('.inc')) {
                                shaders.push(filepath);
                            }
                            break;
                    }
                }
            });
            this.watcher.on('change', (filepath) => {
                let file = path.parse(filepath);
                switch (file.ext) {
                    case '.glsl':
                        if (!file.name.endsWith('.inc')) {
                            log.info('Recompiling ' + file.name);
                            this.compileShader(filepath, options, recompileAll);
                        }
                        break;
                }
            });
            this.watcher.on('unlink', (file) => {
            });
            this.watcher.on('ready', () => __awaiter(this, void 0, void 0, function* () {
                ready = true;
                let compiledShaders = [];
                let index = 0;
                for (let shader of shaders) {
                    let parsed = path.parse(shader);
                    log.info('Compiling shader ' + (index + 1) + ' of ' + shaders.length + ' (' + parsed.base + ').');
                    let compiledShader = null;
                    try {
                        compiledShader = yield this.compileShader(shader, options, recompileAll);
                    }
                    catch (error) {
                        reject(error);
                        return;
                    }
                    if (compiledShader === null) {
                        compiledShader = new CompiledShader();
                        // mark variables as invalid, so they are loaded from previous compilation
                        compiledShader.files = null;
                        compiledShader.inputs = null;
                        compiledShader.outputs = null;
                        compiledShader.uniforms = null;
                        compiledShader.types = null;
                    }
                    if (compiledShader.files != null && compiledShader.files.length === 0) {
                        // TODO: Remove when krafix has been recompiled everywhere
                        compiledShader.files.push(parsed.name + '.' + this.type);
                    }
                    compiledShader.name = AssetConverter_1.AssetConverter.createExportInfo(parsed, false, options, this.exporter.options.from).name;
                    compiledShaders.push(compiledShader);
                    ++index;
                }
                resolve(compiledShaders);
                return;
            }));
        });
    }
    run(watch, recompileAll) {
        return __awaiter(this, void 0, void 0, function* () {
            let shaders = [];
            for (let matcher of this.shaderMatchers) {
                try {
                    shaders = shaders.concat(yield this.watch(watch, matcher.match, matcher.options, recompileAll));
                }
                catch (error) {
                }
            }
            return shaders;
        });
    }
    compileShader(file, options, recompile) {
        return new Promise((resolve, reject) => {
            if (!this.compiler)
                reject('No shader compiler found.');
            if (this.type === 'none') {
                resolve(new CompiledShader());
                return;
            }
            let fileinfo = path.parse(file);
            let from = file;
            let to = path.join(this.to, fileinfo.name + '.' + this.type);
            let temp = to + '.temp';
            fs.stat(from, (fromErr, fromStats) => {
                fs.stat(to, (toErr, toStats) => {
                    fs.stat(this.compiler, (compErr, compStats) => {
                        if (!recompile && (fromErr || (!toErr && toStats.mtime.getTime() > fromStats.mtime.getTime() && toStats.mtime.getTime() > compStats.mtime.getTime()))) {
                            if (fromErr)
                                log.error('Shader compiler error: ' + fromErr);
                            resolve(null);
                        }
                        else {
                            if (this.type === 'metal') {
                                fs.ensureDirSync(path.join(this.builddir, 'Sources'));
                                let funcname = fileinfo.name;
                                funcname = funcname.replace(/-/g, '_');
                                funcname = funcname.replace(/\./g, '_');
                                funcname += '_main';
                                fs.writeFileSync(to, funcname, 'utf8');
                                to = path.join(this.builddir, 'Sources', fileinfo.name + '.' + this.type);
                                temp = to;
                            }
                            let parameters = [this.type === 'hlsl' ? 'd3d9' : this.type, from, temp, this.temp, this.platform];
                            if (this.options.shaderversion) {
                                parameters.push('--version');
                                parameters.push(this.options.shaderversion);
                            }
                            else if (this.platform === Platform_1.Platform.Krom && os.platform() === 'linux') {
                                parameters.push('--version');
                                parameters.push('110');
                            }
                            if (this.options.glsl2) {
                                parameters.push('--glsl2');
                            }
                            if (options.defines) {
                                for (let define of options.defines) {
                                    parameters.push('-D' + define);
                                }
                            }
                            if (this.platform === Platform_1.Platform.HTML5 || this.platform === Platform_1.Platform.HTML5Worker || this.platform === Platform_1.Platform.Android) {
                                parameters.push('--relax');
                            }
                            parameters[1] = path.resolve(parameters[1]);
                            parameters[2] = path.resolve(parameters[2]);
                            parameters[3] = path.resolve(parameters[3]);
                            let child = child_process.spawn(this.compiler, parameters);
                            child.stdout.on('data', (data) => {
                                log.info(data.toString());
                            });
                            let errorLine = '';
                            let newErrorLine = true;
                            let errorData = false;
                            let compiledShader = new CompiledShader();
                            function parseData(data) {
                                data = data.replace(':\\', '#\\'); // Filter out absolute paths on Windows
                                let parts = data.split(':');
                                if (parts.length >= 3) {
                                    if (parts[0] === 'uniform') {
                                        compiledShader.uniforms.push({ name: parts[1], type: parts[2] });
                                    }
                                    else if (parts[0] === 'input') {
                                        compiledShader.inputs.push({ name: parts[1], type: parts[2] });
                                    }
                                    else if (parts[0] === 'output') {
                                        compiledShader.outputs.push({ name: parts[1], type: parts[2] });
                                    }
                                    else if (parts[0] === 'type') {
                                        let type = data.substring(data.indexOf(':') + 1);
                                        let name = type.substring(0, type.indexOf(':'));
                                        let typedata = type.substring(type.indexOf(':') + 2);
                                        typedata = typedata.substr(0, typedata.length - 1);
                                        let members = typedata.split(',');
                                        let memberdecls = [];
                                        for (let member of members) {
                                            let memberparts = member.split(':');
                                            memberdecls.push({ type: memberparts[1], name: memberparts[0] });
                                        }
                                        compiledShader.types.push({ name: name, members: memberdecls });
                                    }
                                }
                                else if (parts.length >= 2) {
                                    if (parts[0] === 'file') {
                                        const parsed = path.parse(parts[1].replace('#\\', ':\\'));
                                        let name = parsed.name;
                                        if (parsed.ext !== '.temp')
                                            name += parsed.ext;
                                        compiledShader.files.push(name);
                                    }
                                }
                            }
                            child.stderr.on('data', (data) => {
                                let str = data.toString();
                                for (let char of str) {
                                    if (char === '\n') {
                                        if (errorData) {
                                            parseData(errorLine.trim());
                                        }
                                        else {
                                            log.error(errorLine.trim());
                                        }
                                        errorLine = '';
                                        newErrorLine = true;
                                        errorData = false;
                                    }
                                    else if (newErrorLine && char === '#') {
                                        errorData = true;
                                        newErrorLine = false;
                                    }
                                    else {
                                        errorLine += char;
                                        newErrorLine = false;
                                    }
                                }
                            });
                            child.on('close', (code) => {
                                if (errorLine.trim().length > 0) {
                                    if (errorData) {
                                        parseData(errorLine.trim());
                                    }
                                    else {
                                        log.error(errorLine.trim());
                                    }
                                }
                                if (code === 0) {
                                    if (this.type !== 'metal') {
                                        if (compiledShader.files === null || compiledShader.files.length === 0) {
                                            fs.renameSync(temp, to);
                                        }
                                        for (let file of compiledShader.files) {
                                            fs.renameSync(path.join(this.to, file + '.temp'), path.join(this.to, file));
                                        }
                                    }
                                    resolve(compiledShader);
                                }
                                else {
                                    process.exitCode = 1;
                                    reject('Shader compiler error.');
                                }
                            });
                        }
                    });
                });
            });
        });
    }
}
exports.ShaderCompiler = ShaderCompiler;
//# sourceMappingURL=ShaderCompiler.js.map
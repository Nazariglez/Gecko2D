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
const exec_1 = require("./exec");
const korepath = require("./korepath");
const log = require("./log");
const Platform_1 = require("./Platform");
const ProjectFile_1 = require("./ProjectFile");
const AssetConverter_1 = require("./AssetConverter");
const HaxeCompiler_1 = require("./HaxeCompiler");
const ShaderCompiler_1 = require("./ShaderCompiler");
const AndroidExporter_1 = require("./Exporters/AndroidExporter");
const DebugHtml5Exporter_1 = require("./Exporters/DebugHtml5Exporter");
const EmptyExporter_1 = require("./Exporters/EmptyExporter");
const FlashExporter_1 = require("./Exporters/FlashExporter");
const Html5Exporter_1 = require("./Exporters/Html5Exporter");
const Html5WorkerExporter_1 = require("./Exporters/Html5WorkerExporter");
const JavaExporter_1 = require("./Exporters/JavaExporter");
const KoreExporter_1 = require("./Exporters/KoreExporter");
const KoreHLExporter_1 = require("./Exporters/KoreHLExporter");
const KromExporter_1 = require("./Exporters/KromExporter");
const NodeExporter_1 = require("./Exporters/NodeExporter");
const PlayStationMobileExporter_1 = require("./Exporters/PlayStationMobileExporter");
const WpfExporter_1 = require("./Exporters/WpfExporter");
const XnaExporter_1 = require("./Exporters/XnaExporter");
const UnityExporter_1 = require("./Exporters/UnityExporter");
const HaxeProject_1 = require("./HaxeProject");
let lastAssetConverter;
let lastShaderCompiler;
let lastHaxeCompiler;
function fixName(name) {
    name = name.replace(/[-\ \.\/\\]/g, '_');
    if (name[0] === '0' || name[0] === '1' || name[0] === '2' || name[0] === '3' || name[0] === '4'
        || name[0] === '5' || name[0] === '6' || name[0] === '7' || name[0] === '8' || name[0] === '9') {
        name = '_' + name;
    }
    return name;
}
function safeName(name) {
    return name.replace(/[\\\/]/g, '_');
}
function createKorefile(name, exporter, options, targetOptions, libraries, cdefines) {
    let out = '';
    out += 'let fs = require(\'fs\');\n';
    out += 'let path = require(\'path\');\n';
    out += 'let project = new Project(\'' + name + '\', __dirname);\n';
    for (let cdefine of cdefines) {
        out += 'project.addDefine(\'' + cdefine + '\');\n';
    }
    if (targetOptions) {
        let koreTargetOptions = {};
        for (let option in targetOptions) {
            if (option.endsWith('_native'))
                continue;
            koreTargetOptions[option] = targetOptions[option];
        }
        for (let option in targetOptions) {
            if (option.endsWith('_native')) {
                koreTargetOptions[option.substr(0, option.length - '_native'.length)] = targetOptions[option];
            }
        }
        out += 'project.targetOptions = ' + JSON.stringify(koreTargetOptions) + ';\n';
    }
    out += 'project.setDebugDir(\'' + path.relative(options.from, path.join(options.to, exporter.sysdir())).replace(/\\/g, '/') + '\');\n';
    let buildpath = path.relative(options.from, path.join(options.to, exporter.sysdir() + '-build')).replace(/\\/g, '/');
    if (buildpath.startsWith('..'))
        buildpath = path.resolve(path.join(options.from.toString(), buildpath));
    out += 'Promise.all([Project.createProject(\'' + buildpath.replace(/\\/g, '/') + '\', __dirname), '
        + 'Project.createProject(\'' + path.normalize(options.kha).replace(/\\/g, '/') + '\', __dirname), '
        + 'Project.createProject(\'' + path.join(options.kha, 'Kore').replace(/\\/g, '/') + '\', __dirname)]).then((projects) => {\n';
    out += '\tfor (let p of projects) project.addSubProject(p);\n';
    out += '\tlet libs = [];\n';
    for (let lib of libraries) {
        let libPath = lib.libroot;
        out += '\tif (fs.existsSync(path.join(\'' + libPath.replace(/\\/g, '/') + '\', \'korefile.js\'))) {\n';
        out += '\t\tlibs.push(Project.createProject(\'' + libPath.replace(/\\/g, '/') + '\', __dirname));\n';
        out += '\t}\n';
    }
    out += '\tPromise.all(libs).then((libprojects) => {\n';
    out += '\t\tfor (let p of libprojects) project.addSubProject(p);\n';
    out += '\t\tresolve(project);\n';
    out += '\t});\n';
    out += '});\n';
    return out;
}
function exportProjectFiles(name, resourceDir, projectData, options, exporter, kore, korehl, libraries, targetOptions, defines, cdefines) {
    return __awaiter(this, void 0, void 0, function* () {
        if (options.haxe !== '') {
            let haxeOptions = exporter.haxeOptions(name, targetOptions, defines);
            haxeOptions.defines.push('kha');
            haxeOptions.defines.push('kha_version=1611');
            haxeOptions.safeName = safeName(haxeOptions.name);
            if (options.debug && haxeOptions.parameters.indexOf('-debug') < 0) {
                haxeOptions.parameters.push('-debug');
            }
            HaxeProject_1.writeHaxeProject(options.to, haxeOptions);
            if (!options.nohaxe) {
                let compiler = new HaxeCompiler_1.HaxeCompiler(options.to, haxeOptions.to, haxeOptions.realto, resourceDir, options.haxe, 'project-' + exporter.sysdir() + '.hxml', haxeOptions.sources);
                lastHaxeCompiler = compiler;
                yield compiler.run(options.watch);
            }
            projectData.postHaxeCompilation();
            yield exporter.export(name, targetOptions, haxeOptions);
        }
        if (options.haxe !== '' && kore && !options.noproject) {
            // If target is a Kore project, generate additional project folders here.
            // generate the korefile.js
            fs.copySync(path.join(__dirname, '..', 'Data', 'build-korefile.js'), path.join(options.to, exporter.sysdir() + '-build', 'korefile.js'), { overwrite: true });
            fs.writeFileSync(path.join(options.from, 'korefile.js'), createKorefile(name, exporter, options, targetOptions, libraries, cdefines));
            // Similar to khamake.js -> main.js -> run(...)
            // We now do koremake.js -> main.js -> run(...)
            // This will create additional project folders for the target,
            // e.g. 'build/android-native-build'
            try {
                let name = yield require(path.join(korepath.get(), 'out', 'main.js')).run({
                    from: options.from,
                    to: path.join(options.to, exporter.sysdir() + '-build'),
                    target: koreplatform(options.target),
                    graphics: options.graphics,
                    vrApi: options.vr,
                    visualstudio: options.visualstudio,
                    compile: options.compile,
                    run: options.run,
                    debug: options.debug,
                    noshaders: true
                }, {
                    info: log.info,
                    error: log.error
                });
                projectData.postCppCompilation();
                log.info('Done.');
                return name;
            }
            catch (error) {
                log.error(error);
                return '';
            }
        }
        else if (options.haxe !== '' && korehl && !options.noproject) {
            fs.copySync(path.join(__dirname, 'Data', 'hl', 'kore_sources.c'), path.join(options.to, exporter.sysdir() + '-build', 'kore_sources.c'), { overwrite: true });
            fs.copySync(path.join(__dirname, 'Data', 'hl', 'korefile.js'), path.join(options.to, exporter.sysdir() + '-build', 'korefile.js'), { overwrite: true });
            fs.writeFileSync(path.join(options.from, 'korefile.js'), createKorefile(name, exporter, options, targetOptions, libraries, cdefines));
            try {
                let name = yield require(path.join(korepath.get(), 'out', 'main.js')).run({
                    from: options.from,
                    to: path.join(options.to, exporter.sysdir() + '-build'),
                    target: koreplatform(options.target),
                    graphics: options.graphics,
                    vrApi: options.vr,
                    visualstudio: options.visualstudio,
                    compile: options.compile,
                    run: options.run,
                    debug: options.debug,
                    noshaders: true
                }, {
                    info: log.info,
                    error: log.error
                });
                log.info('Done.');
                return name;
            }
            catch (error) {
                log.error(error);
                return '';
            }
        }
        else {
            // If target is not a Kore project, e.g. HTML5, finish building here.
            log.info('Done.');
            return name;
        }
    });
}
function koreplatform(platform) {
    if (platform.endsWith('-native'))
        return platform.substr(0, platform.length - '-native'.length);
    else if (platform.endsWith('-hl'))
        return platform.substr(0, platform.length - '-hl'.length);
    else
        return platform;
}
function exportKhaProject(options) {
    return __awaiter(this, void 0, void 0, function* () {
        log.info('Creating Kha project.');
        let project = null;
        let projectData;
        let foundProjectFile = false;
        // get the khafile.js and load the config code,
        // then create the project config object, which contains stuff
        // like project name, assets paths, sources path, library path...
        if (fs.existsSync(path.join(options.from, options.projectfile))) {
            projectData = yield ProjectFile_1.loadProject(options.from, options.projectfile, options.target);
            project = projectData.project;
            foundProjectFile = true;
        }
        if (!foundProjectFile) {
            throw 'No khafile found.';
        }
        let temp = path.join(options.to, 'temp');
        fs.ensureDirSync(temp);
        let exporter = null;
        let kore = false;
        let korehl = false;
        let target = options.target.toLowerCase();
        let baseTarget = target;
        let customTarget = null;
        if (project.customTargets.get(options.target)) {
            customTarget = project.customTargets.get(options.target);
            baseTarget = customTarget.baseTarget;
        }
        switch (baseTarget) {
            case Platform_1.Platform.Krom:
                exporter = new KromExporter_1.KromExporter(options);
                break;
            case Platform_1.Platform.Flash:
                exporter = new FlashExporter_1.FlashExporter(options);
                break;
            case Platform_1.Platform.HTML5:
                exporter = new Html5Exporter_1.Html5Exporter(options);
                break;
            case Platform_1.Platform.HTML5Worker:
                exporter = new Html5WorkerExporter_1.Html5WorkerExporter(options);
                break;
            case Platform_1.Platform.DebugHTML5:
                exporter = new DebugHtml5Exporter_1.DebugHtml5Exporter(options);
                break;
            case Platform_1.Platform.WPF:
                exporter = new WpfExporter_1.WpfExporter(options);
                break;
            case Platform_1.Platform.XNA:
                exporter = new XnaExporter_1.XnaExporter(options);
                break;
            case Platform_1.Platform.Java:
                exporter = new JavaExporter_1.JavaExporter(options);
                break;
            case Platform_1.Platform.PlayStationMobile:
                exporter = new PlayStationMobileExporter_1.PlayStationMobileExporter(options);
                break;
            case Platform_1.Platform.Android:
                exporter = new AndroidExporter_1.AndroidExporter(options);
                break;
            case Platform_1.Platform.Node:
                exporter = new NodeExporter_1.NodeExporter(options);
                break;
            case Platform_1.Platform.Unity:
                exporter = new UnityExporter_1.UnityExporter(options);
                break;
            case Platform_1.Platform.Empty:
                exporter = new EmptyExporter_1.EmptyExporter(options);
                break;
            default:
                if (target.endsWith('-hl')) {
                    korehl = true;
                    options.target = koreplatform(target);
                    exporter = new KoreHLExporter_1.KoreHLExporter(options);
                }
                else {
                    kore = true;
                    options.target = koreplatform(target);
                    exporter = new KoreExporter_1.KoreExporter(options);
                }
                break;
        }
        exporter.setSystemDirectory(target);
        // Create the target build folder
        // e.g. 'build/android-native'
        fs.ensureDirSync(path.join(options.to, exporter.sysdir()));
        let defaultWindowOptions = {
            width: 800,
            height: 600
        };
        let windowOptions = project.windowOptions ? project.windowOptions : defaultWindowOptions;
        exporter.setName(project.name);
        exporter.setWidthAndHeight('width' in windowOptions ? windowOptions.width : defaultWindowOptions.width, 'height' in windowOptions ? windowOptions.height : defaultWindowOptions.height);
        for (let source of project.sources) {
            exporter.addSourceDirectory(source);
        }
        for (let library of project.libraries) {
            exporter.addLibrary(library);
        }
        exporter.parameters = exporter.parameters.concat(project.parameters);
        project.scriptdir = options.kha;
        project.addShaders('Sources/Shaders/**', {});
        projectData.preAssetConversion();
        let assetConverter = new AssetConverter_1.AssetConverter(exporter, options.target, project.assetMatchers);
        lastAssetConverter = assetConverter;
        let assets = yield assetConverter.run(options.watch, temp);
        let shaderDir = path.join(options.to, exporter.sysdir() + '-resources');
        if (target === Platform_1.Platform.Unity) {
            shaderDir = path.join(options.to, exporter.sysdir(), 'Assets', 'Shaders');
        }
        projectData.preShaderCompilation();
        fs.ensureDirSync(shaderDir);
        let oldResources = null;
        let recompileAllShaders = false;
        try {
            oldResources = JSON.parse(fs.readFileSync(path.join(options.to, exporter.sysdir() + '-resources', 'files.json'), 'utf8'));
            for (let file of oldResources.files) {
                if (file.type === 'shader') {
                    if (!file.files || file.files.length === 0) {
                        recompileAllShaders = true;
                        break;
                    }
                }
            }
        }
        catch (error) {
        }
        let exportedShaders = [];
        if (!options.noshaders) {
            let shaderCompiler = new ShaderCompiler_1.ShaderCompiler(exporter, options.target, options.krafix, shaderDir, temp, path.join(options.to, exporter.sysdir() + '-build'), options, project.shaderMatchers);
            lastShaderCompiler = shaderCompiler;
            exportedShaders = yield shaderCompiler.run(options.watch, recompileAllShaders);
        }
        if (target === Platform_1.Platform.Unity) {
            fs.ensureDirSync(path.join(options.to, exporter.sysdir() + '-resources'));
            for (let shader of exportedShaders) {
                fs.writeFileSync(path.join(options.to, exporter.sysdir() + '-resources', shader.name + '.hlsl'), shader.name);
            }
            let proto = fs.readFileSync(path.join(options.from, options.kha, 'Tools', 'khamake', 'Data', 'unity', 'Shaders', 'proto.shader'), 'utf8');
            for (let i1 = 0; i1 < exportedShaders.length; ++i1) {
                if (exportedShaders[i1].name.endsWith('.vert')) {
                    for (let i2 = 0; i2 < exportedShaders.length; ++i2) {
                        if (exportedShaders[i2].name.endsWith('.frag')) {
                            let shadername = exportedShaders[i1].name + '.' + exportedShaders[i2].name;
                            let proto2 = proto.replace(/{name}/g, shadername);
                            proto2 = proto2.replace(/{vert}/g, exportedShaders[i1].name);
                            proto2 = proto2.replace(/{frag}/g, exportedShaders[i2].name);
                            fs.writeFileSync(path.join(shaderDir, shadername + '.shader'), proto2, 'utf8');
                        }
                    }
                }
            }
            let blobDir = path.join(options.to, exporter.sysdir(), 'Assets', 'Resources', 'Blobs');
            fs.ensureDirSync(blobDir);
            for (let i = 0; i < exportedShaders.length; ++i) {
                fs.writeFileSync(path.join(blobDir, exportedShaders[i].files[0] + '.bytes'), exportedShaders[i].name, 'utf8');
            }
        }
        function findShader(name) {
            let fallback = {};
            fallback.files = [];
            fallback.inputs = [];
            fallback.outputs = [];
            fallback.uniforms = [];
            fallback.types = [];
            try {
                for (let file of oldResources.files) {
                    if (file.type === 'shader' && file.name === fixName(name)) {
                        return file;
                    }
                }
            }
            catch (error) {
                return fallback;
            }
            return fallback;
        }
        let files = [];
        for (let asset of assets) {
            let file = {
                name: fixName(asset.name),
                files: asset.files,
                type: asset.type
            };
            if (file.type === 'image') {
                file.original_width = asset.original_width;
                file.original_height = asset.original_height;
                if (asset.readable)
                    file.readable = asset.readable;
            }
            files.push(file);
        }
        for (let shader of exportedShaders) {
            let oldShader = findShader(shader.name);
            files.push({
                name: fixName(shader.name),
                files: shader.files === null ? oldShader.files : shader.files,
                type: 'shader',
                inputs: shader.inputs === null ? oldShader.inputs : shader.inputs,
                outputs: shader.outputs === null ? oldShader.outputs : shader.outputs,
                uniforms: shader.uniforms === null ? oldShader.uniforms : shader.uniforms,
                types: shader.types === null ? oldShader.types : shader.types
            });
        }
        function secondPass() {
            // First pass is for main project files. Second pass is for shaders.
            // Will try to look for the folder, e.g. 'build/Shaders'.
            // if it exists, export files similar to other a
            let hxslDir = path.join('build', 'Shaders');
            /** if (fs.existsSync(hxslDir) && fs.readdirSync(hxslDir).length > 0) {
                addShaders(exporter, platform, project, from, to.resolve(exporter.sysdir() + '-resources'), temp, from.resolve(Paths.get(hxslDir)), krafix);
                if (foundProjectFile) {
                    fs.outputFileSync(to.resolve(Paths.get(exporter.sysdir() + '-resources', 'files.json')).toString(), JSON.stringify({ files: files }, null, '\t'), { encoding: 'utf8' });
                    log.info('Assets done.');
                    exportProjectFiles(name, from, to, options, exporter, platform, khaDirectory, haxeDirectory, kore, project.libraries, project.targetOptions, callback);
                }
                else {
                    exportProjectFiles(name, from, to, options, exporter, platform, khaDirectory, haxeDirectory, kore, project.libraries, project.targetOptions, callback);
                }
            }*/
        }
        if (foundProjectFile) {
            fs.outputFileSync(path.join(options.to, exporter.sysdir() + '-resources', 'files.json'), JSON.stringify({ files: files }, null, '\t'));
        }
        projectData.preHaxeCompilation();
        return yield exportProjectFiles(project.name, path.join(options.to, exporter.sysdir() + '-resources'), projectData, options, exporter, kore, korehl, project.libraries, project.targetOptions, project.defines, project.cdefines);
    });
}
function isKhaProject(directory, projectfile) {
    return fs.existsSync(path.join(directory, 'Kha')) || fs.existsSync(path.join(directory, projectfile));
}
function exportProject(options) {
    return __awaiter(this, void 0, void 0, function* () {
        if (isKhaProject(options.from, options.projectfile)) {
            return yield exportKhaProject(options);
        }
        else {
            log.error('Neither Kha directory nor project file (' + options.projectfile + ') found.');
            return 'Unknown';
        }
    });
}
function runProject(options) {
    return new Promise((resolve, reject) => {
        log.info('Running...');
        let run = child_process.spawn(path.join(process.cwd(), options.to, 'linux-build', name), [], { cwd: path.join(process.cwd(), options.to, 'linux') });
        run.stdout.on('data', function (data) {
            log.info(data.toString());
        });
        run.stderr.on('data', function (data) {
            log.error(data.toString());
        });
        run.on('close', function (code) {
            resolve();
        });
    });
}
exports.api = 2;
function run(options, loglog) {
    return __awaiter(this, void 0, void 0, function* () {
        if (options.silent) {
            log.silent();
        }
        else {
            log.set(loglog);
        }
        if (!options.kha) {
            let p = path.join(__dirname, '..', '..', '..');
            if (fs.existsSync(p) && fs.statSync(p).isDirectory()) {
                options.kha = p;
            }
        }
        else {
            options.kha = path.resolve(options.kha);
        }
        log.info('Using Kha from ' + options.kha);
        if (!options.haxe) {
            let haxepath = path.join(options.kha, 'Tools', 'haxe');
            if (fs.existsSync(haxepath) && fs.statSync(haxepath).isDirectory())
                options.haxe = haxepath;
        }
        if (!options.krafix) {
            let krafixpath = path.join(options.kha, 'Kore', 'Tools', 'krafix', 'krafix' + exec_1.sys());
            if (fs.existsSync(krafixpath))
                options.krafix = krafixpath;
        }
        if (!options.ogg) {
            let oggpath = path.join(options.kha, 'Tools', 'oggenc', 'oggenc' + exec_1.sys());
            if (fs.existsSync(oggpath))
                options.ogg = oggpath + ' {in} -o {out} --quiet';
        }
        // if (!options.kravur) {
        //     let kravurpath = path.join(options.kha, 'Tools', 'kravur', 'kravur' + sys());
        //     if (fs.existsSync(kravurpath)) options.kravur = kravurpath + ' {in} {size} {out}';
        // }
        if (!options.aac && options.ffmpeg) {
            options.aac = options.ffmpeg + ' -i {in} {out}';
        }
        if (!options.mp3 && options.ffmpeg) {
            options.mp3 = options.ffmpeg + ' -i {in} {out}';
        }
        if (!options.h264 && options.ffmpeg) {
            options.h264 = options.ffmpeg + ' -i {in} {out}';
        }
        if (!options.webm && options.ffmpeg) {
            options.webm = options.ffmpeg + ' -i {in} {out}';
        }
        if (!options.wmv && options.ffmpeg) {
            options.wmv = options.ffmpeg + ' -i {in} {out}';
        }
        if (!options.theora && options.ffmpeg) {
            options.theora = options.ffmpeg + ' -i {in} {out}';
        }
        let name = yield exportProject(options);
        if (options.target === Platform_1.Platform.Linux && options.run) {
            yield runProject(options);
        }
        if (options.compile && options.target === Platform_1.Platform.Android) {
            let gradlew = (process.platform === 'win32') ? 'gradlew.bat' : 'bash';
            let args = (process.platform === 'win32') ? [] : ['gradlew'];
            args.push('assemble');
            let make = child_process.spawn(gradlew, args, { cwd: path.join(options.to, 'android', name) });
            make.stdout.on('data', function (data) {
                log.info(data.toString());
            });
            make.stderr.on('data', function (data) {
                log.error(data.toString());
            });
            make.on('close', function (code) {
                if (code === 0) {
                }
                else {
                    log.error('Compilation failed.');
                    process.exit(code);
                }
            });
        }
        return name;
    });
}
exports.run = run;
function close() {
    if (lastAssetConverter)
        lastAssetConverter.close();
    if (lastShaderCompiler)
        lastShaderCompiler.close();
    if (lastHaxeCompiler)
        lastHaxeCompiler.close();
}
exports.close = close;
//# sourceMappingURL=main.js.map
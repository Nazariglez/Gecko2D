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
const log = require("./log");
const GraphicsApi_1 = require("./GraphicsApi");
const Options_1 = require("./Options");
const Project_1 = require("./Project");
const Platform_1 = require("./Platform");
const exec = require("./exec");
const VisualStudioVersion_1 = require("./VisualStudioVersion");
const AndroidExporter_1 = require("./Exporters/AndroidExporter");
const LinuxExporter_1 = require("./Exporters/LinuxExporter");
const EmscriptenExporter_1 = require("./Exporters/EmscriptenExporter");
const TizenExporter_1 = require("./Exporters/TizenExporter");
const VisualStudioExporter_1 = require("./Exporters/VisualStudioExporter");
const XCodeExporter_1 = require("./Exporters/XCodeExporter");
let _global = global;
_global.__base = __dirname + '/';
let debug = false;
function fromPlatform(platform) {
    switch (platform.toLowerCase()) {
        case Platform_1.Platform.Windows:
            return 'Windows';
        case Platform_1.Platform.WindowsApp:
            return 'Windows App';
        case Platform_1.Platform.iOS:
            return 'iOS';
        case Platform_1.Platform.OSX:
            return 'OS X';
        case Platform_1.Platform.Android:
            return 'Android';
        case Platform_1.Platform.Linux:
            return 'Linux';
        case Platform_1.Platform.HTML5:
            return 'HTML5';
        case Platform_1.Platform.Tizen:
            return 'Tizen';
        case Platform_1.Platform.Pi:
            return 'Pi';
        case Platform_1.Platform.tvOS:
            return 'tvOS';
        case Platform_1.Platform.PS4:
            return 'PlayStation4';
        case Platform_1.Platform.XboxOne:
            return 'Xbox One';
        case Platform_1.Platform.Switch:
            return 'Switch';
        default:
            throw 'Unknown platform ' + platform + '.';
    }
}
function shaderLang(platform) {
    switch (platform) {
        case Platform_1.Platform.Windows:
            switch (Options_1.Options.graphicsApi) {
                case GraphicsApi_1.GraphicsApi.OpenGL:
                    return 'glsl';
                case GraphicsApi_1.GraphicsApi.Direct3D9:
                    return 'd3d9';
                case GraphicsApi_1.GraphicsApi.Direct3D11:
                    return 'd3d11';
                case GraphicsApi_1.GraphicsApi.Direct3D12:
                    return 'd3d11';
                case GraphicsApi_1.GraphicsApi.Vulkan:
                    return 'spirv';
                default:
                    return 'd3d9';
            }
        case Platform_1.Platform.WindowsApp:
            return 'd3d11';
        case Platform_1.Platform.iOS:
        case Platform_1.Platform.tvOS:
            switch (Options_1.Options.graphicsApi) {
                case GraphicsApi_1.GraphicsApi.Metal:
                    return 'metal';
                default:
                    return 'essl';
            }
        case Platform_1.Platform.OSX:
            switch (Options_1.Options.graphicsApi) {
                case GraphicsApi_1.GraphicsApi.Metal:
                    return 'metal';
                default:
                    return 'glsl';
            }
        case Platform_1.Platform.Android:
            switch (Options_1.Options.graphicsApi) {
                case GraphicsApi_1.GraphicsApi.Vulkan:
                    return 'spirv';
                default:
                    return 'essl';
            }
        case Platform_1.Platform.Linux:
            switch (Options_1.Options.graphicsApi) {
                case GraphicsApi_1.GraphicsApi.Vulkan:
                    return 'spirv';
                default:
                    return 'glsl';
            }
        case Platform_1.Platform.HTML5:
            return 'essl';
        case Platform_1.Platform.Tizen:
            return 'essl';
        case Platform_1.Platform.Pi:
            return 'essl';
        default:
            return platform;
    }
}
function compileShader(projectDir, type, from, to, temp, platform, builddir) {
    return __awaiter(this, void 0, void 0, function* () {
        return new Promise((resolve, reject) => {
            let compilerPath = '';
            if (Project_1.Project.koreDir !== '') {
                compilerPath = path.resolve(Project_1.Project.koreDir, 'Tools', 'krafix', 'krafix' + exec.sys());
            }
            if (fs.existsSync(path.join(projectDir, 'Backends'))) {
                let libdirs = fs.readdirSync(path.join(projectDir, 'Backends'));
                for (let ld in libdirs) {
                    let libdir = path.join(projectDir, 'Backends', libdirs[ld]);
                    if (fs.statSync(libdir).isDirectory()) {
                        let exe = path.join(libdir, 'krafix', 'krafix-' + platform + '.exe');
                        if (fs.existsSync(exe)) {
                            compilerPath = exe;
                        }
                    }
                }
            }
            if (compilerPath !== '') {
                if (type === 'metal') {
                    fs.ensureDirSync(path.join(builddir, 'Sources'));
                    let fileinfo = path.parse(from);
                    let funcname = fileinfo.name;
                    funcname = funcname.replace(/-/g, '_');
                    funcname = funcname.replace(/\./g, '_');
                    funcname += '_main';
                    fs.writeFileSync(to, funcname, 'utf8');
                    to = path.join(builddir, 'Sources', fileinfo.name + '.' + type);
                    temp = to + '.temp';
                }
                let params = [type, from, to, temp, platform];
                if (debug)
                    params.push('--debug');
                let compiler = child_process.spawn(compilerPath, params);
                compiler.stdout.on('data', (data) => {
                    log.info(data.toString());
                });
                let errorLine = '';
                let newErrorLine = true;
                let errorData = false;
                function parseData(data) {
                }
                compiler.stderr.on('data', (data) => {
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
                compiler.on('close', (code) => {
                    if (code === 0) {
                        resolve();
                    }
                    else {
                        // process.exitCode = 1;
                        reject('Shader compiler error.');
                    }
                });
            }
            else {
                throw 'Could not find shader compiler.';
            }
        });
    });
}
function exportKoremakeProject(from, to, platform, options) {
    return __awaiter(this, void 0, void 0, function* () {
        log.info('korefile found.');
        log.info('Creating ' + fromPlatform(platform) + ' project files.');
        let project;
        try {
            project = yield Project_1.Project.create(from, platform);
            if (shaderLang(platform) === 'metal') {
                project.addFile('build/Sources/*', {});
            }
            project.searchFiles(undefined);
            project.flatten();
        }
        catch (error) {
            log.error(error);
            throw error;
        }
        fs.ensureDirSync(to);
        let files = project.getFiles();
        if (!options.noshaders) {
            let shaderCount = 0;
            for (let file of files) {
                if (file.file.endsWith('.glsl')) {
                    ++shaderCount;
                }
            }
            let shaderIndex = 0;
            for (let file of files) {
                if (file.file.endsWith('.glsl')) {
                    let outfile = file.file;
                    const index = outfile.lastIndexOf('/');
                    if (index > 0)
                        outfile = outfile.substr(index);
                    outfile = outfile.substr(0, outfile.length - 5);
                    let parsedFile = path.parse(file.file);
                    log.info('Compiling shader ' + (shaderIndex + 1) + ' of ' + shaderCount + ' (' + parsedFile.name + ').');
                    ++shaderIndex;
                    yield compileShader(from, shaderLang(platform), file.file, path.join(project.getDebugDir(), outfile), 'build', platform, 'build');
                }
            }
        }
        // Run again to find new shader files for Metal
        project.searchFiles(undefined);
        project.flatten();
        let exporter = null;
        if (platform === Platform_1.Platform.iOS || platform === Platform_1.Platform.OSX || platform === Platform_1.Platform.tvOS)
            exporter = new XCodeExporter_1.XCodeExporter();
        else if (platform === Platform_1.Platform.Android)
            exporter = new AndroidExporter_1.AndroidExporter();
        else if (platform === Platform_1.Platform.HTML5)
            exporter = new EmscriptenExporter_1.EmscriptenExporter();
        else if (platform === Platform_1.Platform.Linux || platform === Platform_1.Platform.Pi)
            exporter = new LinuxExporter_1.LinuxExporter();
        else if (platform === Platform_1.Platform.Tizen)
            exporter = new TizenExporter_1.TizenExporter();
        else if (platform === Platform_1.Platform.PS4 || platform === Platform_1.Platform.XboxOne || platform === Platform_1.Platform.Switch) {
            let libsdir = path.join(from.toString(), 'Backends');
            if (fs.existsSync(libsdir) && fs.statSync(libsdir).isDirectory()) {
                let libdirs = fs.readdirSync(libsdir);
                for (let libdir of libdirs) {
                    if (fs.statSync(path.join(from.toString(), 'Backends', libdir)).isDirectory()
                        && (libdir.toLowerCase() === platform.toLowerCase() || libdir.toLowerCase() === fromPlatform(platform).toLowerCase())) {
                        let libfiles = fs.readdirSync(path.join(from.toString(), 'Backends', libdir));
                        for (let libfile of libfiles) {
                            if (libfile.endsWith('Exporter.js')) {
                                let Exporter = require(path.relative(__dirname, path.join(from.toString(), 'Backends', libdir, libfile)));
                                exporter = new Exporter();
                                break;
                            }
                        }
                    }
                }
            }
        }
        else
            exporter = new VisualStudioExporter_1.VisualStudioExporter();
        if (exporter === null) {
            throw 'No exporter found for platform ' + platform + '.';
        }
        exporter.exportSolution(project, from, to, platform, options.vrApi, options);
        return project;
    });
}
function isKoremakeProject(directory) {
    return fs.existsSync(path.resolve(directory, 'korefile.js'));
}
function exportProject(from, to, platform, options) {
    return __awaiter(this, void 0, void 0, function* () {
        if (isKoremakeProject(from)) {
            return exportKoremakeProject(from, to, platform, options);
        }
        else {
            throw 'korefile.js not found.';
        }
    });
}
function compileProject(make, project, solutionName, options) {
    return new Promise((resolve, reject) => {
        make.stdout.on('data', function (data) {
            log.info(data.toString(), false);
        });
        make.stderr.on('data', function (data) {
            log.error(data.toString(), false);
        });
        make.on('close', function (code) {
            if (code === 0) {
                if ((options.customTarget && options.customTarget.baseTarget === Platform_1.Platform.Linux) || options.target === Platform_1.Platform.Linux) {
                    fs.copySync(path.join(path.join(options.to.toString(), options.buildPath), solutionName), path.join(options.from.toString(), project.getDebugDir(), solutionName), { overwrite: true });
                }
                else if ((options.customTarget && options.customTarget.baseTarget === Platform_1.Platform.Windows) || options.target === Platform_1.Platform.Windows) {
                    fs.copySync(path.join(options.to.toString(), 'Release', solutionName + '.exe'), path.join(options.from.toString(), project.getDebugDir(), solutionName + '.exe'), { overwrite: true });
                }
                if (options.run) {
                    if ((options.customTarget && options.customTarget.baseTarget === Platform_1.Platform.OSX) || options.target === Platform_1.Platform.OSX) {
                        child_process.spawn('open', ['build/Release/' + solutionName + '.app/Contents/MacOS/' + solutionName], { stdio: 'inherit', cwd: options.to });
                    }
                    else if ((options.customTarget && (options.customTarget.baseTarget === Platform_1.Platform.Linux || options.customTarget.baseTarget === Platform_1.Platform.Windows)) || options.target === Platform_1.Platform.Linux || options.target === Platform_1.Platform.Windows) {
                        child_process.spawn(path.resolve(path.join(options.from.toString(), project.getDebugDir(), solutionName)), [], { stdio: 'inherit', cwd: path.join(options.from.toString(), project.getDebugDir()) });
                    }
                    else {
                        log.info('--run not yet implemented for this platform');
                    }
                }
            }
            else {
                log.error('Compilation failed.');
                process.exit(code);
            }
        });
    });
}
exports.api = 2;
function run(options, loglog) {
    return __awaiter(this, void 0, void 0, function* () {
        log.set(loglog);
        if (options.graphics !== undefined) {
            Options_1.Options.graphicsApi = options.graphics;
        }
        if (options.visualstudio !== undefined) {
            Options_1.Options.visualStudioVersion = options.visualstudio;
        }
        if (!options.kore) {
            let p = path.join(__dirname, '..', '..', '..');
            if (fs.existsSync(p) && fs.statSync(p).isDirectory()) {
                options.kore = p;
            }
        }
        else {
            options.kore = path.resolve(options.kore);
        }
        debug = options.debug;
        if (options.vr !== undefined) {
            Options_1.Options.vrApi = options.vr;
        }
        options.buildPath = options.debug ? 'Debug' : 'Release';
        let project = null;
        try {
            project = yield exportProject(options.from, options.to, options.target, options);
        }
        catch (error) {
            log.error(error);
            return '';
        }
        let solutionName = project.getName();
        if (options.compile && solutionName !== '') {
            log.info('Compiling...');
            let make = null;
            if ((options.customTarget && options.customTarget.baseTarget === Platform_1.Platform.Linux) || options.target === Platform_1.Platform.Linux) {
                make = child_process.spawn('make', [], { cwd: path.join(options.to, options.buildPath) });
            }
            else if ((options.customTarget && (options.customTarget.baseTarget === Platform_1.Platform.OSX || options.customTarget.baseTarget === Platform_1.Platform.iOS)) || options.target === Platform_1.Platform.OSX || options.target === Platform_1.Platform.iOS) {
                make = child_process.spawn('xcodebuild', ['-configuration', options.debug ? 'Debug' : 'Release', '-project', solutionName + '.xcodeproj'], { cwd: options.to });
            }
            else if ((options.customTarget && options.customTarget.baseTarget === Platform_1.Platform.Windows) || options.target === Platform_1.Platform.Windows
                || (options.customTarget && options.customTarget.baseTarget === Platform_1.Platform.WindowsApp) || options.target === Platform_1.Platform.WindowsApp) {
                let vsvars = null;
                switch (options.visualstudio) {
                    case VisualStudioVersion_1.VisualStudioVersion.VS2017:
                        const vspath = child_process.execFileSync(path.join(__dirname, '..', 'Data', 'windows', 'vswhere.exe'), ['-latest', '-property', 'installationPath'], { encoding: 'utf8' });
                        const varspath = path.join(vspath.trim(), 'VC', 'Auxiliary', 'Build', 'vcvars32.bat');
                        if (fs.existsSync(varspath)) {
                            vsvars = varspath;
                        }
                        break;
                    case VisualStudioVersion_1.VisualStudioVersion.VS2015:
                        if (process.env.VS140COMNTOOLS) {
                            vsvars = process.env.VS140COMNTOOLS + '\\vsvars32.bat';
                        }
                        break;
                    case VisualStudioVersion_1.VisualStudioVersion.VS2013:
                        if (process.env.VS120COMNTOOLS) {
                            vsvars = process.env.VS120COMNTOOLS + '\\vsvars32.bat';
                        }
                        break;
                    case VisualStudioVersion_1.VisualStudioVersion.VS2012:
                        if (process.env.VS110COMNTOOLS) {
                            vsvars = process.env.VS110COMNTOOLS + '\\vsvars32.bat';
                        }
                        break;
                    case VisualStudioVersion_1.VisualStudioVersion.VS2010:
                        if (process.env.VS100COMNTOOLS) {
                            vsvars = process.env.VS100COMNTOOLS + '\\vsvars32.bat';
                        }
                        break;
                }
                if (vsvars !== null) {
                    fs.writeFileSync(path.join(options.to, 'build.bat'), '@call "' + vsvars + '"\n' + '@MSBuild.exe "' + solutionName + '.vcxproj" /m /p:Configuration=' + (options.debug ? 'Debug' : 'Release') + ',Platform=Win32');
                    make = child_process.spawn('build.bat', [], { cwd: options.to });
                }
                else {
                    log.error('Visual Studio not found.');
                }
            }
            else if ((options.customTarget && options.customTarget.baseTarget === Platform_1.Platform.Android) || options.target === Platform_1.Platform.Android) {
                let gradlew = (process.platform === 'win32') ? 'gradlew.bat' : 'bash';
                let args = (process.platform === 'win32') ? [] : ['gradlew'];
                args.push('assemble' + (options.debug ? 'Debug' : 'Release') + 'Arm7');
                make = child_process.spawn(gradlew, args, { cwd: path.join(options.to, solutionName) });
            }
            if (make !== null) {
                yield compileProject(make, project, solutionName, options);
                return solutionName;
            }
            else {
                log.info('--compile not yet implemented for this platform');
                return solutionName;
            }
        }
        return solutionName;
    });
}
exports.run = run;
//# sourceMappingURL=main.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const child_process = require("child_process");
const fs = require("fs");
const path = require("path");
const log = require("./log");
class Library {
}
exports.Library = Library;
class Target {
    constructor(baseTarget, backends) {
        this.baseTarget = baseTarget;
        this.backends = backends;
    }
}
exports.Target = Target;
function contains(main, sub) {
    main = path.resolve(main);
    sub = path.resolve(sub);
    if (process.platform === 'win32') {
        main = main.toLowerCase();
        sub = sub.toLowerCase();
    }
    return sub.indexOf(main) === 0 && sub.slice(main.length)[0] === path.sep;
}
class Project {
    constructor(name) {
        this.name = name;
        this.sources = [];
        this.defines = [];
        this.cdefines = [];
        this.parameters = [];
        this.scriptdir = Project.scriptdir;
        this.libraries = [];
        this.localLibraryPath = 'Libraries';
        this.assetMatchers = [];
        this.shaderMatchers = [];
        this.customTargets = new Map();
        this.windowOptions = {};
        this.targetOptions = {
            html5: {},
            flash: {},
            android: {},
            android_native: {},
            ios: {}
        };
    }
    /**
     * Add all assets matching the match regex relative to the directory containing the current khafile.
     * Asset types are infered from the file suffix.
     * The regex syntax is very simple: * for anything, ** for anything across directories.
     */
    addAssets(match, options) {
        if (!options)
            options = {};
        // try to avoid weird paths - remove when https://github.com/paulmillr/chokidar/issues/300 is fixed
        match = path.resolve(this.scriptdir, match);
        if (contains(process.cwd(), match)) {
            match = path.relative(process.cwd(), match);
        }
        this.assetMatchers.push({ match: match, options: options });
    }
    addSources(source) {
        this.sources.push(path.resolve(path.join(this.scriptdir, source)));
    }
    /**
     * Add all shaders matching the match regex relative to the directory containing the current khafile.
     * The regex syntax is very simple: * for anything, ** for anything across directories.
     */
    addShaders(match, options) {
        if (!options)
            options = {};
        // try to avoid weird paths - remove when https://github.com/paulmillr/chokidar/issues/300 is fixed
        match = path.resolve(this.scriptdir, match);
        if (contains(process.cwd(), match)) {
            match = path.relative(process.cwd(), match);
        }
        this.shaderMatchers.push({ match: match, options: options });
    }
    addDefine(define) {
        this.defines.push(define);
    }
    addCDefine(define) {
        this.cdefines.push(define);
    }
    addParameter(parameter) {
        this.parameters.push(parameter);
    }
    addTarget(name, baseTarget, backends) {
        this.customTargets.set(name, new Target(baseTarget, backends));
    }
    addLibrary(library) {
        this.addDefine(library);
        let self = this;
        function findLibraryDirectory(name) {
            if (path.isAbsolute(name)) {
                return { libpath: name, libroot: name };
            }
            // Tries to load the default library from inside the kha project.
            // e.g. 'Libraries/wyngine'
            let libpath = path.join(self.scriptdir, self.localLibraryPath, name);
            if (fs.existsSync(libpath) && fs.statSync(libpath).isDirectory()) {
                return { libpath: libpath, libroot: self.localLibraryPath + '/' + name };
            }
            // If the library couldn't be found in Libraries folder, try
            // looking in the haxelib folders.
            // e.g. addLibrary('hxcpp') => '/usr/lib/haxelib/hxcpp/3,2,193'
            try {
                libpath = path.join(child_process.execSync('haxelib config', { encoding: 'utf8' }).trim(), name.replace(/\./g, ',').toLowerCase());
            }
            catch (error) {
                if (process.env.HAXEPATH) {
                    libpath = path.join(process.env.HAXEPATH, 'lib', name.toLowerCase());
                }
            }
            if (fs.existsSync(libpath) && fs.statSync(libpath).isDirectory()) {
                if (fs.existsSync(path.join(libpath, '.dev'))) {
                    return { libpath: fs.readFileSync(path.join(libpath, '.dev'), 'utf8'), libroot: libpath };
                }
                else if (fs.existsSync(path.join(libpath, '.current'))) {
                    // Get the latest version of the haxelib path,
                    // e.g. for 'hxcpp', latest version '3,2,193'
                    let current = fs.readFileSync(path.join(libpath, '.current'), 'utf8');
                    return { libpath: path.join(libpath, current.replace(/\./g, ',')), libroot: libpath };
                }
            }
            // Show error if library isn't found in Libraries or haxelib folder
            log.error('Error: Library ' + name + ' not found.');
            log.error('Add it to the \'Libraries\' subdirectory of your project. You may also install it via haxelib but that\'s less cool.');
            throw 'Library ' + name + ' not found.';
        }
        let libInfo = findLibraryDirectory(library);
        let dir = libInfo.libpath;
        if (dir !== '') {
            this.libraries.push({
                libpath: dir,
                libroot: libInfo.libroot
            });
            // If this is a haxelib library, there must be a haxelib.json
            if (fs.existsSync(path.join(dir, 'haxelib.json'))) {
                let options = JSON.parse(fs.readFileSync(path.join(dir, 'haxelib.json'), 'utf8'));
                // If there is a classPath value, add that directory to be loaded.
                // Otherwise, just load the current path.
                if (options.classPath) {
                    // TODO find an example haxelib that has a classPath value
                    this.sources.push(path.join(dir, options.classPath));
                }
                else {
                    // e.g. '/usr/lib/haxelib/hxcpp/3,2,193'
                    this.sources.push(dir);
                }
                // If this haxelib has other library dependencies, add them too
                if (options.dependencies) {
                    for (let dependency in options.dependencies) {
                        if (dependency.toLowerCase() !== 'kha') {
                            this.addLibrary(dependency);
                        }
                    }
                }
            }
            else {
                // If there is no haxelib.json file, then just load the library
                // by the Sources folder.
                // e.g. Libraries/wyngine/Sources
                this.sources.push(path.join(dir, 'Sources'));
            }
            if (fs.existsSync(path.join(dir, 'extraParams.hxml'))) {
                let params = fs.readFileSync(path.join(dir, 'extraParams.hxml'), 'utf8');
                for (let parameter of params.split('\n')) {
                    let param = parameter.trim();
                    if (param !== '') {
                        if (param.startsWith('-lib')) {
                            // (DK)
                            //  - '-lib xxx' is for linking a library via haxe, it forces the use of the haxelib version
                            //  - this should be handled by khamake though, as it tracks the dependencies better (local folder or haxelib)
                            console.log('ignoring', dir + '/extraParams.hxml "' + param + '"');
                        }
                        else {
                            this.addParameter(param);
                        }
                    }
                }
            }
            this.addShaders(dir + '/Sources/Shaders/**', {});
        }
    }
}
exports.Project = Project;
//# sourceMappingURL=Project.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Exporter_1 = require("./Exporter");
const child_process = require("child_process");
const fs = require("fs-extra");
const path = require("path");
let emmccPath = 'emcc';
let defines = '';
let includes = '';
let definesArray = [];
let includesArray = [];
function link(files, output) {
    let params = []; // -O2 ";
    for (let file of files) {
        // console.log(files[file]);
        params.push(file);
    }
    params.push('-o');
    params.push(output);
    console.log('Linking ' + output);
    let res = child_process.spawnSync(emmccPath, params);
    if (res != null) {
        if (res.stdout !== null && res.stdout.toString() !== '')
            console.log('stdout: ' + res.stdout);
        if (res.stderr !== null && res.stderr.toString() !== '')
            console.log('stderr: ' + res.stderr);
        if (res.error !== null)
            console.log(res.error);
    }
}
class EmscriptenExporter extends Exporter_1.Exporter {
    constructor() {
        super();
    }
    compile(inFilename, outFilename) {
        if (fs.existsSync(outFilename))
            return;
        // console.log("Compiling " + inFilename + " to " + outFilename);
        // console.log(emmccPath + " " + inFilename+ " " +includes+ " " +defines+ " " +"-c -o"+ " " +outFilename);
        // console.log(emmccPath + " " + inFilename+ " " +  includes+ " " +  defines+ " " + "-c -o"+ " " + outFilename);
        let params = [];
        params.push(inFilename);
        for (let i = 0; i < includesArray.length; i++) {
            params.push(includesArray[i]);
        }
        for (let i = 0; i < definesArray.length; i++) {
            params.push(definesArray[i]);
        }
        params.push('-c');
        params.push('-o');
        params.push(outFilename);
        // console.log(params);
        let res = child_process.spawnSync(emmccPath, params, { stdio: 'inherit' });
        if (res != null) {
            if (res.stdout !== null && res.stdout.toString() !== '')
                console.log('stdout: ' + res.stdout);
            if (res.stderr !== null && res.stderr.toString() !== '')
                console.log('stderr: ' + res.stderr);
            if (res.error !== null)
                console.log(res.error);
        }
    }
    exportSolution(project, from, to, platform) {
        let debugDirName = project.getDebugDir();
        debugDirName = debugDirName.replace(/\\/g, '/');
        if (debugDirName.endsWith('/'))
            debugDirName = debugDirName.substr(0, debugDirName.length - 1);
        if (debugDirName.lastIndexOf('/') >= 0)
            debugDirName = debugDirName.substr(debugDirName.lastIndexOf('/') + 1);
        fs.copySync(path.resolve(from, debugDirName), path.resolve(to, debugDirName), { overwrite: true });
        defines = '';
        definesArray = [];
        for (let def in project.getDefines()) {
            defines += '-D' + project.getDefines()[def] + ' ';
            definesArray.push('-D' + project.getDefines()[def]);
        }
        defines += '-D KORE_DEBUGDIR="\\"' + debugDirName + '\\""' + ' ';
        definesArray.push('-D KORE_DEBUGDIR="\\"' + debugDirName + '\\""');
        includes = '';
        includesArray = [];
        for (let inc in project.getIncludeDirs()) {
            includes += '-I' + this.nicePath(from, to, path.join(from, project.getIncludeDirs()[inc])) + ' ';
            includesArray.push('-I' + this.nicePath(from, to, path.join(from, project.getIncludeDirs()[inc])));
        }
        this.writeFile(path.resolve(to, 'makefile'));
        this.p();
        let oline = '';
        for (let fileobject of project.getFiles()) {
            let filename = fileobject.file;
            if (!filename.endsWith('.cpp') && !filename.endsWith('.c'))
                continue;
            let lastpoint = filename.lastIndexOf('.');
            let oname = this.nicePath(from, to, filename.substr(0, lastpoint) + '.o');
            oname = oname.replace(/..\//, '');
            oline += ' ' + oname;
        }
        this.p('kore.html:' + oline);
        this.p('emcc -O2 -s TOTAL_MEMORY=134217728 ' + oline + ' -o kore.html --preload-file ' + debugDirName, 1);
        this.p();
        for (let fileobject of project.getFiles()) {
            let filename = fileobject.file;
            if (!filename.endsWith('.cpp') && !filename.endsWith('.c'))
                continue;
            let builddir = to;
            let dirs = filename.split('/');
            let name = '';
            for (let i = 0; i < dirs.length - 1; ++i) {
                let s = dirs[i];
                if (s === '' || s === '..')
                    continue;
                name += s + '/';
                builddir = path.resolve(builddir, s);
                if (!fs.existsSync(builddir))
                    fs.ensureDirSync(builddir);
            }
            let lastpoint = filename.lastIndexOf('.');
            let oname = this.nicePath(from, to, filename.substr(0, lastpoint) + '.o');
            oname = oname.replace(/..\//, '');
            this.p(oname + ': ' + this.nicePath(from, to, filename));
            this.p('emcc -O2 -c ' + this.nicePath(from, to, filename) + ' ' + includes + ' ' + defines + ' -o ' + oname, 1);
        }
        this.closeFile();
        /*
         std::vector<std::string> objectFiles;
         for (std::string filename : project->getFiles()) if (endsWith(filename, ".c") || endsWith(filename, ".cpp")) {
         //files += "../../" + filename + " ";
         compile(directory.resolve(filename).toString(), directory.resolve(Paths::get("build", filename + ".o")).toString());
         objectFiles.push_back(directory.resolve(Paths::get("build", filename + ".o")).toString());
         }
         link(objectFiles, directory.resolve(Paths::get("build", "Kt.js")));
         */
        /*console.log("Compiling files...");
        var objectFiles = [];
        var files = project.getFiles();
        for (let file of files) {
            if (file.endsWith(".c") || file.endsWith(".cpp")) {
                //files += "../../" + filename + " ";
                compile(from.resolve(file).toString(), to.resolve(file + ".o").toString());
                objectFiles.push(to.resolve(file + ".o").toString());
            }
        }
        link(objectFiles, to.resolve(Paths.get("build", "Kt.js").toString()));*/
    }
}
exports.EmscriptenExporter = EmscriptenExporter;
//# sourceMappingURL=EmscriptenExporter.js.map
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
const uuid = require('uuid');
class CSharpExporter extends KhaExporter_1.KhaExporter {
    constructor(options) {
        super(options);
        fs.removeSync(path.join(this.options.to, this.sysdir() + '-build', 'Sources'));
    }
    includeFiles(dir, baseDir) {
        if (!dir || !fs.existsSync(dir))
            return;
        let files = fs.readdirSync(dir);
        for (let f in files) {
            let file = path.join(dir, files[f]);
            if (fs.existsSync(file) && fs.statSync(file).isDirectory())
                this.includeFiles(file, baseDir);
            else if (file.endsWith('.cs')) {
                this.p('<Compile Include="' + path.relative(baseDir, file).replace(/\//g, '\\') + '" />', 2);
            }
        }
    }
    haxeOptions(name, targetOptions, defines) {
        defines.push('no-root');
        defines.push('no-compilation');
        defines.push('sys_' + this.options.target);
        defines.push('sys_g1');
        defines.push('sys_g2');
        defines.push('sys_a1');
        defines.push('kha_cs');
        defines.push('kha_' + this.options.target);
        defines.push('kha_' + this.options.target + '_cs');
        defines.push('kha_g1');
        defines.push('kha_g2');
        defines.push('kha_a1');
        return {
            from: this.options.from,
            to: path.join(this.sysdir() + '-build', 'Sources'),
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
            if (this.projectFiles) {
                const projectUuid = uuid.v4();
                this.exportSLN(projectUuid);
                this.exportCsProj(projectUuid);
                this.exportResources();
            }
        });
    }
    exportSLN(projectUuid) {
        fs.ensureDirSync(path.join(this.options.to, this.sysdir() + '-build'));
        this.writeFile(path.join(this.options.to, this.sysdir() + '-build', 'Project.sln'));
        const solutionUuid = uuid.v4();
        this.p('Microsoft Visual Studio Solution File, Format Version 11.00');
        this.p('# Visual Studio 2010');
        this.p('Project("{' + solutionUuid.toString().toUpperCase() + '}") = "HaxeProject", "Project.csproj", "{' + projectUuid.toString().toUpperCase() + '}"');
        this.p('EndProject');
        this.p('Global');
        this.p('GlobalSection(SolutionConfigurationPlatforms) = preSolution', 1);
        this.p('Debug|x86 = Debug|x86', 2);
        this.p('Release|x86 = Release|x86', 2);
        this.p('EndGlobalSection', 1);
        this.p('GlobalSection(ProjectConfigurationPlatforms) = postSolution', 1);
        this.p('{' + projectUuid.toString().toUpperCase() + '}.Debug|x86.ActiveCfg = Debug|x86', 2);
        this.p('{' + projectUuid.toString().toUpperCase() + '}.Debug|x86.Build.0 = Debug|x86', 2);
        this.p('{' + projectUuid.toString().toUpperCase() + '}.Release|x86.ActiveCfg = Release|x86', 2);
        this.p('{' + projectUuid.toString().toUpperCase() + '}.Release|x86.Build.0 = Release|x86', 2);
        this.p('EndGlobalSection', 1);
        this.p('GlobalSection(SolutionProperties) = preSolution', 1);
        this.p('HideSolutionNode = FALSE', 2);
        this.p('EndGlobalSection', 1);
        this.p('EndGlobal');
        this.closeFile();
    }
    copySound(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            return [to];
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
            fs.copySync(from, path.join(this.options.to, this.sysdir(), to), { overwrite: true });
            return [to];
        });
    }
    copyVideo(platform, from, to) {
        return __awaiter(this, void 0, void 0, function* () {
            return [to];
        });
    }
}
exports.CSharpExporter = CSharpExporter;
//# sourceMappingURL=CSharpExporter.js.map
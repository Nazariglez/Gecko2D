"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const Block_1 = require("./Block");
const Platform_1 = require("./Platform");
function toLine(options) {
    let line = '';
    for (let option of options) {
        line += option + ';';
    }
    return line;
}
class ClCompile extends Block_1.Block {
    constructor(out, indentation, platform, configuration, includes, defines) {
        super(out, indentation);
        this.platform = platform;
        this.includes = includes;
        this.defines = defines;
        this.minimalRebuild = false;
        // PS3
        this.userPreprocessorDefinitions = '';
        // Xbox360
        this.functionLevelLinking = false;
        this.stringPooling = false;
        this.prefast = false;
        this.favorSize = false;
        this.fastCap = false;
        this.warningLevel = 3;
        this.optimization = false;
        this.runtimeLibrary = 'MultiThreadedDebug';
        this.multiProcessorCompilation = true;
        this.objectFileName = '$(IntDir)\\build\\%(RelativeDir)';
        this.generateDebugInformation = false;
        // this.configuration = configuration;
        switch (platform) {
            case Platform_1.Platform.WindowsApp:
                this.includes.push('$(ProjectDir)');
                this.includes.push('$(IntermediateOutputPath)');
                this.includes.push('%(AdditionalIncludeDirectories)');
                this.defines.push('_UNICODE');
                this.defines.push('UNICODE');
                this.defines.push('%(PreprocessorDefinitions)');
                break;
            default:
                break;
        }
    }
    print() {
        let defineLine = toLine(this.defines);
        let includeLine = toLine(this.includes);
        this.tagStart('ClCompile');
        this.tag('AdditionalIncludeDirectories', includeLine);
        if (this.platform === Platform_1.Platform.Windows) {
            this.tag('WarningLevel', 'Level' + this.warningLevel);
            this.tag('Optimization', this.optimization ? 'Enabled' : 'Disabled');
            this.tag('PreprocessorDefinitions', defineLine);
            this.tag('RuntimeLibrary', this.runtimeLibrary);
            this.tag('MultiProcessorCompilation', this.multiProcessorCompilation ? 'true' : 'false');
            this.tag('MinimalRebuild', this.minimalRebuild ? 'true' : 'false');
            this.tag('ObjectFileName', this.objectFileName);
            this.tag('SDLCheck', 'true');
        }
        else if (this.platform === Platform_1.Platform.WindowsApp) {
            // tag("PreprocessorDefinitions", defineLine);
            this.tag('PrecompiledHeader', 'NotUsing');
            this.tag('ObjectFileName', this.objectFileName);
            this.tag('DisableSpecificWarnings', '4453');
            this.tag('SDLCheck', 'true');
        }
        this.tagEnd('ClCompile');
    }
}
exports.ClCompile = ClCompile;
//# sourceMappingURL=ClCompile.js.map
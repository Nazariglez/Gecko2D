"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const GraphicsApi_1 = require("./GraphicsApi");
const VisualStudioVersion_1 = require("./VisualStudioVersion");
const VrApi_1 = require("./VrApi");
exports.Options = {
    precompiledHeaders: false,
    intermediateDrive: '',
    graphicsApi: GraphicsApi_1.GraphicsApi.Direct3D11,
    vrApi: VrApi_1.VrApi.None,
    visualStudioVersion: VisualStudioVersion_1.VisualStudioVersion.VS2017,
    compile: false,
    run: false
};
//# sourceMappingURL=Options.js.map
import {GraphicsApi} from './GraphicsApi';
import {VisualStudioVersion} from './VisualStudioVersion';
import {VrApi} from './VrApi';

export let Options = {
	precompiledHeaders: false,
	intermediateDrive: '',
	graphicsApi: GraphicsApi.Direct3D11,
	vrApi: VrApi.None,
	visualStudioVersion: VisualStudioVersion.VS2017,
	compile: false,
	run: false
};

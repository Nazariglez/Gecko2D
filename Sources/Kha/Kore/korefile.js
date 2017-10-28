const path = require('path');

const project = new Project('Kore', __dirname);

const g1 = true;
project.addDefine('KORE_G1');

const g2 = true;
project.addDefine('KORE_G2');

const g3 = true;
project.addDefine('KORE_G3');

let g4 = false;

let g5 = false;

const a1 = true;
project.addDefine('KORE_A1');

const a2 = true;
project.addDefine('KORE_A2');

let a3 = false;

project.addFile('Sources/**');
project.addExclude('Sources/Kore/IO/snappy/**');
project.addIncludeDir('Sources');

function addBackend(name) {
	project.addFile('Backends/' + name + '/Sources/**');
	project.addIncludeDir('Backends/' + name + '/Sources');
}

let plugin = false;

if (platform === Platform.Windows) {
	project.addDefine('KORE_WINDOWS');
	addBackend('System/Windows');
	project.addLib('dxguid');
	project.addLib('dsound');
	project.addLib('dinput8');

	project.addDefine('_CRT_SECURE_NO_WARNINGS');
	project.addDefine('_WINSOCK_DEPRECATED_NO_WARNINGS');
	project.addLib('ws2_32');

	project.addFile('Backends/System/Windows/Libraries/DirectShow/**');
	project.addIncludeDir('Backends/System/Windows/Libraries/DirectShow/BaseClasses');
	project.addLib('strmiids');
	project.addLib('winmm');

	if (graphics === GraphicsApi.OpenGL1) {
		addBackend('Graphics3/OpenGL1');
		project.addDefine('KORE_OPENGL1');
		project.addDefine('GLEW_STATIC');
	}
	else if (graphics === GraphicsApi.OpenGL) {
		g4 = true;
		addBackend('Graphics4/OpenGL');
		project.addDefine('KORE_OPENGL');
		project.addDefine('GLEW_STATIC');
	}
	else if (graphics === GraphicsApi.Direct3D11) {
		g4 = true;
		addBackend('Graphics4/Direct3D11');
		project.addDefine('KORE_DIRECT3D');
		project.addDefine('KORE_DIRECT3D11');
		project.addLib('d3d11');
	}
	else if (graphics === GraphicsApi.Direct3D12) {
		g4 = true;
		g5 = true;
		addBackend('Graphics5/Direct3D12');
		project.addDefine('KORE_DIRECT3D');
		project.addDefine('KORE_DIRECT3D12');
		project.addLib('dxgi');
		project.addLib('d3d12');
	}
	else if (graphics === GraphicsApi.Vulkan) {
		g4 = true;
		g5 = true;
		addBackend('Graphics5/Vulkan');
		project.addDefine('KORE_VULKAN');
		project.addDefine('VK_USE_PLATFORM_WIN32_KHR');
		project.addLibFor('Win32', 'Backends/Graphics5/Vulkan/Libraries/win32/vulkan-1');
		project.addLibFor('x64', 'Backends/Graphics5/Vulkan/Libraries/win64/vulkan-1');
	}
	else {
		g4 = true;
		addBackend('Graphics4/Direct3D9');
		project.addDefine('KORE_DIRECT3D');
		project.addDefine('KORE_DIRECT3D9');
		project.addLib('d3d9');
	}

	if (vr === VrApi.Oculus) {
		project.addDefine('KORE_VR');
		project.addDefine('KORE_OCULUS');
		project.addLibFor('x64', 'Backends/System/Windows/Libraries/OculusSDK/Lib/x64/LibOVR');
		project.addLibFor('Win32', 'Backends/System/Windows/Libraries/OculusSDK/Lib/Win32/LibOVR');
		project.addFile('Backends/System/Windows/Libraries/OculusSDK/**');
		project.addIncludeDir('Backends/System/Windows/Libraries/OculusSDK/LibOVR/Include');
		project.addIncludeDir('Backends/System/Windows/Libraries/OculusSDK/LibOVR/Src');
		project.addIncludeDir('Backends/System/Windows/Libraries/OculusSDK/LibOVRKernel/Src');
		project.addIncludeDir('Backends/System/Windows/Libraries/OculusSDK/Logging/include');
	}
	else if (vr === VrApi.SteamVR) {
		project.addDefine('KORE_VR');
		project.addDefine('KORE_STEAMVR');
		project.addDefine('VR_API_PUBLIC');
		project.addFile('Backends/System/Windows/Libraries/SteamVR/src/**');
		project.addIncludeDir('Backends/System/Windows/Libraries/SteamVR/src');
		project.addIncludeDir('Backends/System/Windows/Libraries/SteamVR/src/vrcommon');
		project.addIncludeDir('Backends/System/Windows/Libraries/SteamVR/headers');
	}
}
else if (platform === Platform.WindowsApp) {
	g4 = true;
	project.addDefine('KORE_WINDOWSAPP');
	addBackend('System/WindowsApp');
	addBackend('Graphics4/Direct3D11');
	project.addDefine('_CRT_SECURE_NO_WARNINGS');
	
	if (vr === VrApi.Hololens) {
		project.addDefine('KORE_VR');
		project.addDefine('KORE_HOLOLENS');
	}
	
}
else if (platform === Platform.OSX) {
	project.addDefine('KORE_MACOS');
	addBackend('System/Apple');
	addBackend('System/macOS');
	if (graphics === GraphicsApi.Metal) {
		g4 = true;
		g5 = true;
		addBackend('Graphics5/Metal');
		project.addDefine('KORE_METAL');
		project.addLib('Metal');
		project.addLib('MetalKit');
	}
	else if (graphics === GraphicsApi.OpenGL1) {
		addBackend('Graphics3/OpenGL1');
		project.addDefine('KORE_OPENGL1');
		project.addLib('OpenGL');
	}
	else {
		g4 = true;
		addBackend('Graphics4/OpenGL');
		project.addDefine('KORE_OPENGL');
		project.addLib('OpenGL');
	}
	project.addLib('IOKit');
	project.addLib('Cocoa');
	project.addLib('AppKit');
	project.addLib('CoreAudio');
	project.addLib('CoreData');
	project.addLib('CoreMedia');
	project.addLib('CoreVideo');
	project.addLib('AVFoundation');
	project.addLib('Foundation');
	project.addDefine('KORE_POSIX');
}
else if (platform === Platform.iOS || platform === Platform.tvOS) {
	if (platform === Platform.tvOS) {
		project.addDefine('KORE_TVOS');
	}
	else {
		project.addDefine('KORE_IOS');
	}
	addBackend('System/Apple');
	addBackend('System/iOS');
	if (graphics === GraphicsApi.Metal) {
		g4 = true;
		g5 = true;
		addBackend('Graphics5/Metal');
		project.addDefine('KORE_METAL');
		project.addLib('Metal');
	}
	else {
		g4 = true;
		addBackend('Graphics4/OpenGL');
		project.addDefine('KORE_OPENGL');
		project.addDefine('KORE_OPENGL_ES');
		project.addLib('OpenGLES');
	}
	project.addLib('UIKit');
	project.addLib('Foundation');
	project.addLib('CoreGraphics');
	project.addLib('QuartzCore');
	project.addLib('CoreAudio');
	project.addLib('AudioToolbox');
	project.addLib('CoreMotion');
	project.addLib('AVFoundation');
	project.addLib('CoreFoundation');
	project.addLib('CoreVideo');
	project.addLib('CoreMedia');
	project.addDefine('KORE_POSIX');
}
else if (platform === Platform.Android) {
	project.addDefine('KORE_ANDROID');
	addBackend('System/Android');
	if (graphics === GraphicsApi.Vulkan) {
		g4 = true;
		g5 = true;
		addBackend('Graphics5/Vulkan');
		project.addDefine('KORE_VULKAN');
	}
	else {
		g4 = true;
		addBackend('Graphics4/OpenGL');
		project.addDefine('KORE_OPENGL');
		project.addDefine('KORE_OPENGL_ES');
	}
	project.addDefine('KORE_ANDROID_API=15');
	project.addDefine('KORE_POSIX');
	project.addLib('log');
	project.addLib('android');
	project.addLib('EGL');
	project.addLib('GLESv2');
	project.addLib('OpenSLES');
	project.addLib('OpenMAXAL');
}
else if (platform === Platform.HTML5) {
	g4 = true;
	project.addDefine('KORE_HTML5');
	addBackend('System/HTML5');
	addBackend('Graphics4/OpenGL');
	project.addExclude('Backends/Graphics4/OpenGL/Sources/GL/**');
	project.addDefine('KORE_OPENGL');
	project.addDefine('KORE_OPENGL_ES');
}
else if (platform === Platform.Linux) {
	project.addDefine('KORE_LINUX');
	addBackend('System/Linux');
	project.addLib('asound');
	project.addLib('dl');
	if (graphics === GraphicsApi.Vulkan) {
		g4 = true;
		g5 = true;
		addBackend('Graphics5/Vulkan');
		project.addLib('vulkan');
		project.addLib('xcb');
		project.addDefine('KORE_VULKAN');
		project.addDefine('VK_USE_PLATFORM_XCB_KHR');
	}
	else {
		g4 = true;
		addBackend('Graphics4/OpenGL');
		project.addLib('GL');
		project.addLib('X11');
		project.addLib('Xinerama');
		project.addDefine('KORE_OPENGL');
	}
	project.addDefine('KORE_POSIX');
}
else if (platform === Platform.Pi) {
	g4 = true;
	project.addDefine('KORE_PI');
	addBackend('System/Pi');
	addBackend('Graphics4/OpenGL');
	project.addExclude('Backends/Graphics4/OpenGL/Sources/GL/**');
	project.addDefine('KORE_OPENGL');
	project.addDefine('KORE_OPENGL_ES');
	project.addDefine('KORE_POSIX');
	project.addIncludeDir('/opt/vc/include');
	project.addIncludeDir('/opt/vc/include/interface/vcos/pthreads');
	project.addIncludeDir('/opt/vc/include/interface/vmcs_host/linux');
	project.addLib('dl');
	project.addLib('GLESv2');
	project.addLib('EGL');
	project.addLib('bcm_host');
	project.addLib('asound');
	project.addLib('X11');		
}
else if (platform === Platform.Tizen) {
	g4 = true;
	project.addDefine('KORE_TIZEN');
	addBackend('System/Tizen');
	addBackend('Graphics4/OpenGL');
	project.addExclude('Backends/Graphics4/OpenGL/Sources/GL/**');
	project.addDefine('KORE_OPENGL');
	project.addDefine('KORE_OPENGL_ES');
	project.addDefine('KORE_POSIX');
}
else {
	plugin = true;
	g4 = true;
	g5 = true;
	if (platform === Platform.XboxOne) {
		addBackend('Graphics5/Direct3D12');
		project.addDefine('KORE_DIRECT3D');
		project.addDefine('KORE_DIRECT3D12');
	}
}

if (g4) {
	project.addDefine('KORE_G4');
}
else {
	project.addExclude('Sources/Kore/Graphics4/**');
}

if (g5) {
	project.addDefine('KORE_G5');
	addBackend('Graphics4/G4onG5');
}
else {
	project.addDefine('KORE_G5');
	addBackend('Graphics5/G5onG4');
}

if (!a3) {
	a3 = true;
	project.addDefine('KORE_A3');
	addBackend('Audio3/A3onA2');
}

if (plugin) {
	let backend = 'Unknown';
	if (platform === Platform.PS4) {
		backend = 'PlayStation4';
	}
	else if (platform === Platform.XboxOne) {
		backend = 'XboxOne';
	}
	else if (platform === Platform.Switch) {
		backend = 'Switch';
	}
	Project.createProject(path.join(Project.root, 'Backends', backend), __dirname).then((backend) => {
		project.addSubProject(backend);
		resolve(project);
	});
}
else {
	resolve(project);
}

var project = new Project('Kha', __dirname);

project.addFiles('Backends/Kore/khacpp/src/**.h', 'Backends/Kore/khacpp/src/**.cpp', 'Backends/Kore/khacpp/include/**.h');
//'Backends/Kore/khacpp/project/libs/nekoapi/**.cpp'
project.addFiles('Backends/Kore/khacpp/project/libs/common/**.h', 'Backends/Kore/khacpp/project/libs/common/**.cpp');
if (platform === Platform.Windows || platform === Platform.WindowsApp) project.addFiles('Backends/Kore/khacpp/project/libs/msvccompat/**.cpp');
if (platform === Platform.Linux) project.addFiles('Backends/Kore/khacpp/project/libs/linuxcompat/**.cpp');
project.addFiles('Backends/Kore/khacpp/project/libs/regexp/**.h', 'Backends/Kore/khacpp/project/libs/regexp/**.cpp', 'Backends/Kore/khacpp/project/libs/std/**.h', 'Backends/Kore/khacpp/project/libs/std/**.cpp');
//project.addFiles('Backends/Kore/khacpp/project/thirdparty/mbedtls-2.2.1/library/*.c');
//'Backends/Kore/khacpp/project/libs/zlib/**.cpp'
project.addFiles('Backends/Kore/khacpp/project/thirdparty/pcre-7.8/**.h', 'Backends/Kore/khacpp/project/thirdparty/pcre-7.8/**.c');
//'Backends/Kore/khacpp/project/thirdparty/pcre-7.8/**.cc'
project.addFiles('Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/**.h',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/adler32.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/compress.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/crc32.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/gzio.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/uncompr.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/deflate.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/trees.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/zutil.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/inflate.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/infback.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/inftrees.c',
'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3/inffast.c'
);
project.addFiles('Backends/Kore/khacpp/project/thirdparty/mbedtls-2.2.1/**');

project.addFiles('Backends/Kore/*.cpp', 'Backends/Kore/*.h');

project.addExcludes('Backends/Kore/khacpp/project/thirdparty/pcre-7.8/dftables.c', 'Backends/Kore/khacpp/project/thirdparty/pcre-7.8/pcredemo.c', 'Backends/Kore/khacpp/project/thirdparty/pcre-7.8/pcregrep.c', 'Backends/Kore/khacpp/project/thirdparty/pcre-7.8/pcretest.c');
project.addExcludes('Backends/Kore/khacpp/src/ExampleMain.cpp', 'Backends/Kore/khacpp/src/hx/Scriptable.cpp', 'Backends/Kore/khacpp/src/hx/NoFiles.cpp', 'Backends/Kore/khacpp/src/hx/cppia/**');
project.addExcludes('Backends/Kore/khacpp/src/hx/Debugger.cpp', 'Backends/Kore/khacpp/src/hx/Profiler.cpp', 'Backends/Kore/khacpp/src/hx/Telemetry.cpp');
project.addExcludes('Backends/Kore/khacpp/src/hx/NekoAPI.cpp');
project.addExcludes('Backends/Kore/khacpp/src/hx/libs/sqlite/**');
project.addExcludes('Backends/Kore/khacpp/src/hx/libs/mysql/**');

project.addIncludeDirs('Backends/Kore/khacpp/include', 'Backends/Kore/khacpp/project/thirdparty/pcre-7.8', 'Backends/Kore/khacpp/project/thirdparty/zlib-1.2.3', 'Backends/Kore/khacpp/project/libs/nekoapi', 'Backends/Kore/khacpp/project/thirdparty/mbedtls-2.2.1/include');

//if (options.vrApi == "rift") {
//	out += "project.addIncludeDirs('C:/khaviar/LibOVRKernel/Src/');\n";
//	out += "project.addIncludeDirs('C:/khaviar/LibOVR/Include/');\n";
//}

if (platform !== Platform.Android) {
	project.addExcludes('Backends/Kore/khacpp/src/hx/AndroidCompat.cpp');
}

if (platform === Platform.Windows) project.addDefine('HX_WINDOWS');
if (platform === Platform.WindowsApp) {
	project.addDefine('HX_WINDOWS');
	project.addDefine('HX_WINRT');
}
if (platform !== Platform.Windows) {
	project.addDefine('KORE_MULTITHREADED_AUDIO');
}
if (platform === Platform.OSX) {
	project.addDefine('HXCPP_M64');
	project.addDefine('HX_MACOS');
}
if (platform === Platform.Linux) project.addDefine('HX_LINUX');
if (platform === Platform.iOS) {
	project.addDefine('IPHONE');
	project.addDefine('HX_IPHONE');
}
if (platform === Platform.tvOS) {
	project.addDefine('APPLETV');
}
if (platform === Platform.Android) {
	project.addDefine('ANDROID');
	project.addDefine('_ANDROID');
	project.addDefine('HX_ANDROID');
	project.addDefine('HXCPP_ANDROID_PLATFORM=24');
}
if (platform === Platform.OSX) {
	project.addDefine('KORE_DEBUGDIR="osx"');
	project.addLib('Security');
}
if (platform === Platform.iOS) project.addDefine('KORE_DEBUGDIR="ios"');

// project:addDefine('HXCPP_SCRIPTABLE');
project.addDefine('HXCPP_API_LEVEL=330');
project.addDefine('STATIC_LINK');
project.addDefine('PCRE_STATIC');
project.addDefine('HXCPP_SET_PROP');
project.addDefine('HXCPP_VISIT_ALLOCS');
project.addDefine('KORE');
project.addDefine('ROTATE90');

//if (Options.vrApi === "gearvr") {
//	out += "project.addDefine('VR_GEAR_VR');\n";
//}
//else if (Options.vrApi === "cardboard") {
//	out += "project.addDefine('VR_CARDBOARD');\n";
//}
//else if (Options.vrApi === "rift") {
//	out += "project.addDefine('VR_RIFT');\n";
//}
//
//if (options.vrApi == "rift") {
//	out += "project.addLib('C:/khaviar/LibOVRKernel/Lib/Windows/Win32/Release/VS2013/LibOVRKernel');\n";
//	out += "project.addLib('C:/khaviar/LibOVR/Lib/Windows/Win32/Release/VS2013/LibOVR');\n";
//}

if (platform === Platform.Windows || platform === Platform.WindowsApp) {
	project.addDefine('_WINSOCK_DEPRECATED_NO_WARNINGS');
}
if (platform === Platform.Windows) {
	project.addLib('ws2_32');
}

resolve(project);

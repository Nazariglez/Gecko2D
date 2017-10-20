let project = new Project('HaxeCrossCode', __dirname);
if (platform === Platform.WindowsApp) {
	project.addFiles('Sources/**.h', 'Sources/**.cpp');
}
else {
	project.addFiles('Sources/**.h', 'Sources/**.cpp', { pch: 'hxcpp.h' });
}
project.addFiles('Sources/src/resources/**.cpp');
project.addFiles('Sources/src/__lib__.cpp', 'Sources/src/__boot__.cpp');
project.addFiles('Sources/**.metal');
project.addExcludes('Sources/src/__main__.cpp');
project.addIncludeDirs('Sources/include');
resolve(project);

let fs = require('fs');
let path = require('path');
let project = new Project('ProjectName', __dirname);
project.targetOptions = {"html5":{},"flash":{},"android":{},"ios":{}};
project.setDebugDir('build/ios');
Promise.all([Project.createProject('build/ios-build', __dirname), Project.createProject('/Users/nazarigonzalez/haxe/primegame/Kha', __dirname), Project.createProject('/Users/nazarigonzalez/haxe/primegame/Kha/Kore', __dirname)]).then((projects) => {
	for (let p of projects) project.addSubProject(p);
	let libs = [];
	Promise.all(libs).then((libprojects) => {
		for (let p of libprojects) project.addSubProject(p);
		resolve(project);
	});
});

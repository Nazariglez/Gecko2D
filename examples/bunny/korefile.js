let fs = require('fs');
let path = require('path');
let project = new Project('bunnymark', __dirname);
project.targetOptions = {"html5":{"canvasId":"kanvas","scriptName":"game.debug","webgl":true},"flash":{},"android":{},"ios":{}};
project.setDebugDir('kha_temp/build/osx');
Promise.all([Project.createProject('kha_temp/build/osx-build', __dirname), Project.createProject('/Users/nazarigonzalez/haxe/primegame/examples/bunny/Libraries/k2d/Sources/Kha', __dirname), Project.createProject('/Users/nazarigonzalez/haxe/primegame/examples/bunny/Libraries/k2d/Sources/Kha/Kore', __dirname)]).then((projects) => {
	for (let p of projects) project.addSubProject(p);
	let libs = [];
	if (fs.existsSync(path.join('Libraries/k2d', 'korefile.js'))) {
		libs.push(Project.createProject('Libraries/k2d', __dirname));
	}
	Promise.all(libs).then((libprojects) => {
		for (let p of libprojects) project.addSubProject(p);
		resolve(project);
	});
});

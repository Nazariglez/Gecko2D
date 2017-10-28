let p = new Project("My k2d Game");
p.addSources("Sources");
p.addLibrary("k2d");
p.addShaders("Sources/Shaders/**");
p.addAssets('Assets/**', {nameBaseDir: 'Assets', destination: '{dir}/{name}', name: '{dir}/{name}'});

p.targetOptions.html5.canvasId = "kanvas";
p.targetOptions.html5.scriptName = "game";
p.targetOptions.html5.webgl = true;
resolve(p);
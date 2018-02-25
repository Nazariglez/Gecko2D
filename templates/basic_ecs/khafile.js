let p = new Project("Gecko2D-Game");
p.addSources("Sources");
p.addLibrary("/Users/nazarigonzalez/Gecko2D/Sources");
p.addShaders("Sources/Shaders/**");
p.addAssets('Assets/**', {nameBaseDir: 'Assets', destination: 'assets/{dir}/{name}', name: '{dir}/{name}'});

p.targetOptions.html5.canvasId = "kanvas";
p.targetOptions.html5.scriptName = "game.debug";
p.targetOptions.html5.webgl = true;
p.addDefine("game_name=Gecko2D-Game");
resolve(p);
let project = new Project('New Project');
project.addAssets('Assets/**');
project.addSources('Sources');
project.addLibrary("/Users/nazarigonzalez/Gecko2D/Sources");
project.addDefine('--macro include("/Users/nazarigonzalez/Gecko2D/Sources")');
project.addParameter('-xml docs/gecko.xml');
resolve(project);

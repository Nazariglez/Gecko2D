package;

import scenes.LoaderScene;
import scenes.MainScene;

class Game extends gecko.Game {
    public var loaderScene:LoaderScene = new LoaderScene();
    public var mainScene:MainScene = new MainScene();

    private var _assetsToLoad:Array<String> = [
        //your assets here
    ];

    public override function init() {
        sceneManager.addScene(mainScene);
        sceneManager.addScene(loaderScene);

        sceneManager.setSceneByID("loader-scene");

        loaderScene.loadAssets(_assetsToLoad, _onLoaded);
    }

    private function _onLoaded() {
        sceneManager.setSceneByID("main-scene");
    }
}
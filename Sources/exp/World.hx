package exp;

import exp.render.Graphics;
import exp.utils.Event;

class World {
    public var currentScene:Scene = Scene.create();
    private var _nextScene:Scene;

    public var onSceneChanged:Event<Scene->Scene->Void>;

    public function new(){
        onSceneChanged = Event.create();
    }

    public function changeScene(scene:Scene) {
        _nextScene = scene;
    }

    public function update(delta:Float32) {
        if(_nextScene != null){
            var scene = currentScene;

            currentScene = _nextScene;
            _nextScene = null;

            onSceneChanged.emit(scene, currentScene);
        }

        currentScene.process(delta);
    }

    public function draw(g:Graphics) {
        currentScene.draw(g);
    }
}
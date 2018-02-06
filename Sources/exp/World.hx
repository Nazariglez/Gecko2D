package exp;

import exp.utils.Event;

class World {
    public var currentScene:Scene = Scene.create("initial");
    private var _nextScene:Scene;

    public var onSceneChanged:Event<Scene->Scene->Void> = Event.create();

    public function new(){}

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

        currentScene.update(delta);
    }

    public function draw() {
        currentScene.draw();
    }
}
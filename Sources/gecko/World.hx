package gecko;

import gecko.utils.Event;

class World {
    public var currentScene(default, null):Scene = Scene.create();
    private var _nextScene:Scene;
    private var _destroyCurrentScene:Bool = false;

    public var onSceneChanged:Event<Scene->Scene->Void>;

    public function new(){
        onSceneChanged = Event.create();
    }

    public function changeScene(sceneIn:Scene, destroyCurrentScene:Bool = false) {
        _destroyCurrentScene = destroyCurrentScene;
        _nextScene = sceneIn;
        trace("scene in", sceneIn.id, "scene out", currentScene.id);
    }

    public function update(delta:Float32) {
        if(_nextScene != null){
            trace("init change scene");
            var scene = currentScene;

            currentScene = _nextScene;
            _nextScene = null;

            onSceneChanged.emit(scene, currentScene);

            if(_destroyCurrentScene){
                scene.destroy();
            }
            trace("end change scene",_destroyCurrentScene);
        }

        currentScene.process(delta);
    }

    public function draw(g:Graphics) {
        currentScene.draw(g);
    }
}
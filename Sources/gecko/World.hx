package gecko;

import gecko.render.Graphics;
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
    }

    public function update(delta:Float32) {
        if(_nextScene != null){
            var scene = currentScene;

            currentScene = _nextScene;
            _nextScene = null;

            onSceneChanged.emit(scene, currentScene);

            if(_destroyCurrentScene){
                scene.destroy();
            }
        }

        currentScene.process(delta);
    }

    public function draw(g:Graphics) {
        currentScene.draw(g);
    }
}
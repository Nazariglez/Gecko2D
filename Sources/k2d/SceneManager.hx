package k2d;

import k2d.math.FastFloat;
import k2d.render.Renderer;

class SceneManager {
    static private var _sceneID:Int = 1;

    public var scenes:Array<Scene> = new Array<Scene>();
    public var game:Game;

    public var scene(get, set):Scene;
    private var _scene:Scene;

    public function new(game:Game){
        this.game = game;
        scene = createScene();
        addScene(scene);
    }

    public function createScene(?id:String) {
        if(id == null){
            id = 'scene${SceneManager._sceneID}';
            SceneManager._sceneID++;
        }
        return new Scene(id);
    }

    public function addScene(scene:Scene) {
        scenes.push(scene);
    }

    public function removeScene(scene:Scene) {
        scenes.remove(scene);
    }

    public function update(dt:FastFloat) {
        scene.update(dt);
    }

    public function render(r:Renderer) {
        scene.render(r);
    }

    function get_scene() : Scene {
        return _scene;
    }

    function set_scene(scene:Scene) : Scene {
        scene.size.set(game.width, game.height);
        return _scene = scene;
    }
}
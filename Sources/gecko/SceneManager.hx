package gecko;

import gecko.math.FastFloat;
import gecko.render.Renderer;

class SceneManager {
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
        return new Scene(id);
    }

    public function addScene(scene:Scene) {
        scenes.push(scene);
    }

    public function removeScene(scene:Scene) {
        scenes.remove(scene);
    }

    public function getSceneByID(id:String) : Scene {
        for(sc in scenes){
            if(sc.id == id){
                return sc;
            }
        }

        return null;
    }

    public function setSceneByID(id:String) {
        var sc = getSceneByID(id);
        if(sc == null){
            throw new Error('Invalid scene id: `$id`');
            return;
        }

        this.scene = sc;
    }

    public function update(dt:FastFloat) {
        scene.update(dt);
    }

    public function render(r:Renderer) {
        scene.processRender(r);
    }

    function get_scene() : Scene {
        return _scene;
    }

    function set_scene(scene:Scene) : Scene {
        scene.size.set(game.width, game.height);
        return _scene = scene;
    }
}
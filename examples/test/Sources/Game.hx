package;

import gecko.Scene;
import gecko.Color;
import gecko.Graphics;
import gecko.Assets;
import gecko.components.draw.SpriteComponent;
import gecko.Screen;
import gecko.Entity;
import gecko.Gecko;

class Game {
    public function new(){
        Assets.load([
            "rabbit.png"
        ], _onLoaded).start();

        Gecko.onDraw += function(g:Graphics) {
            g.color = Color.Red;
            g.fillRect(Screen.centerX, Screen.centerY, 3 , 3);
        };

        gecko.input.Mouse.enable();
        /*untyped js.Browser.window.goto = function(){
            _onLoaded();
        };*/

        gecko.input.Mouse.onRightReleased += function(x, y){
            _onLoaded();
        };
    }

    private function _onLoaded() {
        /*var e = Entity.create();
        e.addComponent(SpriteComponent.create("rabbit.png"));
        e.transform.position.set(Screen.centerX, Screen.centerY);

        Gecko.currentScene.addEntity(e);*/
        var scene = gecko.math.Random.getFloat() < 0.5 ? TestScene.create() : TestScene2.create();

        Gecko.world.changeScene(scene, true);
    }
}
package;

import gecko.Color;
import gecko.render.Graphics;
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
    }

    private function _onLoaded() {
        var scene = Gecko.currentScene;

        var e = Entity.create();
        e.addComponent(SpriteComponent.create("rabbit.png"));
        e.transform.position.set(Screen.centerX, Screen.centerY);

        scene.addEntity(e);
    }
}
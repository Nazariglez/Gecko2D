package scenes;

import gecko.systems.draw.DrawSystem;
import gecko.Gecko;
import gecko.Float32;
import gecko.components.input.MouseComponent;
import gecko.components.draw.SpriteComponent;
import gecko.Screen;
import gecko.Entity;
import gecko.systems.input.InteractivitySystem;
import gecko.Scene;
import gecko.Color;

class CustomScene extends Scene {
    public function init(closeButton:Bool = false) {
        addSystem(DrawSystem.create());
        addSystem(InteractivitySystem.create());

        if(closeButton){
            _addCloseButton();
        }
    }

    private function _addCloseButton() : Entity {
        var btn = createEntity();
        btn.transform.position.set(Screen.width-20, 20);
        btn.transform.anchor.set(1, 0);
        btn.transform.fixedToCamera = true;

        var sprite = btn.addComponent(SpriteComponent.create("images/kenney/red_cross.png"));

        var mouse = btn.addComponent(MouseComponent.create());
        mouse.onClick += _gotoMainScene;

        mouse.onOver += function(x:Float32, y:Float32) {
            sprite.color = Color.Red;
        };

        mouse.onOut += function(x:Float32, y:Float32) {
            sprite.color = Color.White;
        };

        return btn;
    }

    private function _gotoMainScene(x:Float32, y:Float32) {
        Gecko.world.changeScene(MainScene.create(), true);
    }
}
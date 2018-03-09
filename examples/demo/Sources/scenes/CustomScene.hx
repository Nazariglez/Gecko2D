package scenes;

import exp.Gecko;
import exp.Float32;
import exp.components.input.MouseComponent;
import exp.components.draw.SpriteComponent;
import exp.Screen;
import exp.components.core.TransformComponent;
import exp.Entity;
import exp.systems.input.InteractivitySystem;
import exp.Scene;
import exp.Color;

class CustomScene extends Scene {
    public function new(){
        super();

        addSystem(InteractivitySystem.create());
    }

    public function init(closeButton:Bool = false) {
        if(closeButton){
            _addCloseButton();
        }
    }

    private function _addCloseButton() {
        var btn = Entity.create();
        var transform = btn.addComponent(TransformComponent.create(Screen.width-20, 20));
        transform.anchor.set(1, 0);

        btn.addComponent(SpriteComponent.create("images/kenney/red_cross.png"));

        var mouse = btn.addComponent(MouseComponent.create());
        mouse.onClick += _gotoMainScene;

        mouse.onOver += function(x:Float32, y:Float32) {
            btn.renderer.color = Color.Red;
        };

        mouse.onOut += function(x:Float32, y:Float32) {
            btn.renderer.color = Color.White;
        };

        addEntity(btn);
    }

    private function _gotoMainScene(x:Float32, y:Float32) {
        Gecko.world.changeScene(MainScene.create());
    }
}
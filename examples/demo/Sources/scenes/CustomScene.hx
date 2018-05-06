package scenes;

import gecko.components.draw.DrawComponent;
import gecko.systems.misc.BehaviorSystem;
import gecko.systems.draw.DrawSystem;
import gecko.Gecko;

import gecko.components.input.MouseComponent;
import gecko.components.draw.SpriteComponent;
import gecko.Screen;
import gecko.Entity;
import gecko.systems.input.InteractivitySystem;
import gecko.Scene;
import gecko.Color;

class CustomScene extends Scene {
    public var hud:Entity;

    public function init(closeButton:Bool = false) {
        addSystem(DrawSystem.create());
        addSystem(BehaviorSystem.create());
        addSystem(InteractivitySystem.create());

        hud = createEntity();
        hud.addComponent(DrawComponent.create());
        hud.transform.fixedToCamera = true;
        hud.transform.size.set(Screen.width, Screen.height);
        hud.transform.position.set(Screen.centerX, Screen.centerY);

        if(closeButton){
            _addCloseButton();
        }
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        hud = null;
    }

    private function _addCloseButton() : Entity {
        var btn = createEntity();
        btn.transform.parent = hud.transform;
        btn.transform.position.set(Screen.width-20, 20);
        btn.transform.anchor.set(1, 0);

        var sprite = btn.addComponent(SpriteComponent.create("images/kenney/red_cross.png"));

        var mouse = btn.addComponent(MouseComponent.create());
        mouse.onClick += _gotoMainScene;

        mouse.onOver += function(x:Float, y:Float) {
            sprite.color = Color.Red;
        };

        mouse.onOut += function(x:Float, y:Float) {
            sprite.color = Color.White;
        };

        return btn;
    }

    private function _gotoMainScene(x:Float, y:Float) {
        Gecko.world.changeScene(MainScene.create(), true);
    }
}
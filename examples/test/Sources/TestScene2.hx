package;

import gecko.components.input.MouseComponent;
import gecko.systems.input.InteractivitySystem;
import gecko.Color;
import gecko.Entity;
import gecko.components.draw.SpriteComponent;
import gecko.Screen;

class TestScene2 extends gecko.Scene {
    public function init() {
        addSystem(InteractivitySystem.create());

        var e = Entity.create();
        var r = e.addComponent(SpriteComponent.create("rabbit.png"));
        r.color = Color.Red;
        e.transform.position.set(Screen.centerX, Screen.centerY);

        var mouse:MouseComponent = e.addComponent(MouseComponent.create());
        mouse.onClick += function(x, y){
          trace(x,y);
        };

        addEntity(e);
    }
}
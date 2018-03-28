package;

import gecko.systems.input.InteractivitySystem;
import gecko.Entity;
import gecko.components.draw.SpriteComponent;
import gecko.Screen;

class TestScene extends gecko.Scene {
    public function init() {
        addSystem(InteractivitySystem.create());

        var e = Entity.create();
        e.addComponent(SpriteComponent.create("rabbit.png"));
        e.transform.position.set(Screen.centerX, Screen.centerY);

        addEntity(e);
    }
}
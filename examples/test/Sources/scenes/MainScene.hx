package scenes;

import gecko.components.draw.CircleComponent;
import gecko.Color;
import gecko.components.draw.RectangleComponent;
import gecko.systems.draw.DrawSystem;
import gecko.Screen;
import gecko.Entity;
import gecko.Scene;
import gecko.components.draw.TextComponent;

class MainScene extends Scene {
    public function init() {
        addSystem(DrawSystem.create());
        addEntity(_getWelcomeText());


    }

    private function _getWelcomeText() {
        var entity = Entity.create();
        entity.addComponent(TextComponent.create("Welcome to your Gecko2D game!", "Ubuntu-B.ttf", 40));
        entity.transform.position.set(Screen.centerX, Screen.centerY);
        return entity;
    }
}
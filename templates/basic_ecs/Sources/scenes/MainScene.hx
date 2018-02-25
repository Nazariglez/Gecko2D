package scenes;

import exp.Screen;
import exp.Entity;
import exp.Scene;
import exp.components.core.TransformComponent;
import exp.components.draw.TextComponent;

class MainScene extends Scene {
    public function init() {
        addEntity(_getWelcomeText());
    }

    private function _getWelcomeText() {
        var entity = Entity.create();
        entity.addComponent(TransformComponent.create(Screen.centerX, Screen.centerY));
        entity.addComponent(TextComponent.create("Welcome to your Gecko2D game!", "Ubuntu-B.ttf", 40));
        return entity;
    }
}
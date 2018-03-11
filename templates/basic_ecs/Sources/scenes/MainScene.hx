package scenes;

import gecko.Screen;
import gecko.Entity;
import gecko.Scene;
import gecko.components.core.TransformComponent;
import gecko.components.draw.TextComponent;

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
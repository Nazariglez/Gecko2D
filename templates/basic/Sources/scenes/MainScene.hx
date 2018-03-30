package scenes;

import gecko.Screen;
import gecko.Entity;
import gecko.Scene;
import gecko.components.draw.TextComponent;

class MainScene extends Scene {
    public function init() {
        addEntity(_getWelcomeText());
    }

    private function _getWelcomeText() {
        var entity = Entity.create();
        entity.addComponent(TextComponent.create("Welcome to your Gecko2D game!", "Ubuntu-B.ttf", 40));
        entity.transform.position.set(Screen.centerX, Screen.centerY);
        return entity;
    }
}
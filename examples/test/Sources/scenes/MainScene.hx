package scenes;

import gecko.systems.draw.DrawSystem;
import gecko.Screen;
import gecko.Scene;
import gecko.components.draw.TextComponent;

class MainScene extends Scene {
    public function init() {
        addSystem(DrawSystem.create());
        _addWelcomeText();
    }

    private function _addWelcomeText() {
        var entity = createEntity();
        entity.addComponent(TextComponent.create("Welcome to your Gecko2D game!", "Ubuntu-B.ttf", 40));
        entity.transform.position.set(Screen.centerX, Screen.centerY);
    }
}
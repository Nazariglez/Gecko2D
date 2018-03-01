package scenes;

import exp.Gecko;
import exp.Color;
import exp.components.input.MouseComponent;
import exp.components.draw.NineSliceComponent;
import exp.components.draw.SpriteComponent;
import exp.Float32;
import exp.Screen;
import exp.Entity;
import exp.components.core.TransformComponent;
import exp.components.draw.TextComponent;

class MainScene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init();
        //addEntity(_getWelcomeText());

        _createButton("Draw Sprites", Screen.centerX, Screen.centerY, _gotoDrawSprite);
    }

    private function _gotoDrawSprite(x:Float32, y:Float32) {
        Gecko.world.changeScene(DrawSpriteScene.create(true));
    }

    private function _createButton(text:String, x:Float32, y:Float32, callback:Float32->Float32->Void) {
        var txt = Entity.create();
        txt.addComponent(TransformComponent.create(x, y));
        txt.addComponent(TextComponent.create(text, "Ubuntu-B.ttf", 20));

        var btn = Entity.create();
        btn.addComponent(TransformComponent.create(x, y));
        btn.addComponent(NineSliceComponent.create("images/green_panel.png", txt.transform.width + 20, 50));

        var mouse = btn.addComponent(MouseComponent.create());
        mouse.onOver += function(x:Float32, y:Float32) {
            btn.renderer.color = Color.LightGreen;
        };

        mouse.onOut += function(x:Float32, y:Float32){
            btn.renderer.color = Color.White;
        };

        mouse.onClick += callback;

        addEntity(btn);
        addEntity(txt);
    }

    private function _getWelcomeText() {
        var entity = Entity.create();
        entity.addComponent(TransformComponent.create(Screen.centerX, Screen.centerY));
        entity.addComponent(TextComponent.create("Welcome to your Gecko2D game!", "Ubuntu-B.ttf", 40));
        return entity;
    }
}
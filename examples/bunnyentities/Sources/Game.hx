package;

import exp.Float32;
import exp.components.core.TransformComponent;
import exp.components.draw.TextComponent;
import exp.components.draw.SpriteComponent;
import exp.Screen;
import exp.resources.Font;
import exp.Color;
import exp.render.Graphics;
import exp.Gecko;
import exp.Assets;
import exp.Entity;
import exp.input.Mouse;

class Game {
    private var _count:Int = 0;
    private var _font:Font;

    public function new(){
        Assets.load([
            "rabbit.png",
            "Ubuntu-B.ttf"
        ], _onAssetsLoaded).start();
    }

    private function _onAssetsLoaded() {
        _font = Assets.fonts.get("Ubuntu-B.ttf");

        Gecko.currentScene.addSystem(BounceSystem.create(0.75));
        Gecko.onDraw += _onDraw;

        Mouse.enable();
        Mouse.onLeftPressed += function(x:Float32, y:Float32){
          _addBunny(100);
        };

        Mouse.onRightPressed += function(x:Float32, y:Float32){
            _addBunny(500);
        }

        _addBackgroundText();
        _addBunny();
    }

    private function _onDraw(g:Graphics) {
        g.color = Color.White;
        g.fillRect(0, 0, 150, 50);
        g.color = Color.Black;
        g.font = _font;
        g.fontSize = 18;
        g.drawText('${Gecko.renderTicker.fps}fps - ${Gecko.renderTicker.ms}ms', 10, 5);
        g.color = Color.Orange;
        g.drawText('Bunnies: ${_count}', 10, 25);
    }

    private function _createBunny() : Entity {
        var bunny = Entity.create();
        bunny.addComponent(TransformComponent.create(0, 0));
        bunny.addComponent(SpriteComponent.create("rabbit.png"));
        bunny.addComponent(BounceComponent.create(Math.random() * 10, Math.random() * 10 - 5));
        return bunny;
    }

    private function _addBunny(amount:Int = 1) {
        for(i in 0...amount) {
            _count++;
            Gecko.currentScene.addEntity(_createBunny());
        }
    }

    private function _addBackgroundText() {
        var textEntity = Entity.create();
        textEntity.addComponent(TransformComponent.create(Screen.centerX, Screen.centerY));
        textEntity.addComponent(TextComponent.create("Left click to add 100 bunnies.\nRight click to add 500 bunnies.", "Ubuntu-B.ttf", 30, "center"));
        Gecko.currentScene.addEntity(textEntity);
    }
}
package;

import exp.input.Mouse;
import exp.components.draw.TextComponent;
import exp.Screen;
import exp.components.core.TransformComponent;
import exp.Entity;
import exp.resources.Texture;
import exp.render.Graphics;
import exp.Color;
import exp.Gecko;
import exp.Assets;
import exp.Float32;
import exp.math.Point;
import exp.resources.Font;

typedef Bunny = {
    position:Point,
    speed:Point
}

class Game {
    private var _count:Int = 0;
    private var _font:Font;
    private var _texture:Texture;

    private var _gravity:Float32 = 0.75;
    private var _bunnies:Array<Bunny> = [];

    public function new(){
        Assets.load([
            "rabbit.png",
            "Ubuntu-B.ttf"
        ], _onAssetsLoaded).start();
    }

    private function _onAssetsLoaded() {
        _font = Assets.fonts.get("Ubuntu-B.ttf");
        _texture = Assets.textures.get("rabbit.png");

        Gecko.onUpdate += _onUpdate;
        Gecko.onDraw += _onDraw;

        Mouse.enable();
        Mouse.onLeftPressed += function(x:Float32, y:Float32){
            _addBunny(500);
        };

        Mouse.onRightPressed += function(x:Float32, y:Float32){
            _addBunny(1000);
        }

        _addBackgroundText();
        _addBunny();
    }

    private function _addBunny(amount:Int = 1) {
        for(i in 0...amount){
            _count++;
            _bunnies.push({
                position: Point.create(0, 0),
                speed: Point.create(Math.random() * 10, Math.random() * 10 - 5)
            });
        }
    }

    inline private function _drawBunnies(g:Graphics) {
        for(bunny in _bunnies){
            g.drawTexture(_texture, bunny.position.x, bunny.position.y);
        }
    }

    private function _onUpdate(dt:Float32) {
        for(bunny in _bunnies){
            bunny.position.x += bunny.speed.x;
            bunny.position.y += bunny.speed.y;
            bunny.speed.y += _gravity;

            if(bunny.position.x > Screen.width){
                bunny.speed.x *= -1;
                bunny.position.x = Screen.width;
            }else if(bunny.position.x < 0){
                bunny.speed.x *= -1;
                bunny.position.x = 0;
            }

            if(bunny.position.y > Screen.height){
                bunny.speed.y *= -0.85;
                bunny.position.y = Screen.height;

                if(Math.random() > 0.5){
                    bunny.speed.y -= Math.random() * 6;
                }

            }else if(bunny.position.y < 0){
                bunny.speed.y = 0;
                bunny.position.y = 0;
            }
        }
    }

    private function _onDraw(g:Graphics) {
        _drawBunnies(g);

        g.color = Color.White;
        g.fillRect(0, 0, 150, 50);
        g.color = Color.Black;
        g.font = _font;
        g.fontSize = 18;
        g.drawText('${Gecko.renderTicker.fps}fps - ${Gecko.renderTicker.ms}ms', 10, 5);
        g.color = Color.Orange;
        g.drawText('Bunnies: ${_count}', 10, 25);
    }

    private function _addBackgroundText() {
        var textEntity = Entity.create();
        textEntity.addComponent(TransformComponent.create(Screen.centerX, Screen.centerY));
        textEntity.addComponent(TextComponent.create("Left click to add 500 bunnies.\nRight click to add 1000 bunnies.", "Ubuntu-B.ttf", 30, "center"));
        Gecko.currentScene.addEntity(textEntity);
    }
}
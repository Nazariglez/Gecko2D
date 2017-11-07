package;

import k2d.render.Renderer2D;
import k2d.math.FastFloat;
import k2d.Container;
import k2d.Sprite;
import kha.input.Mouse;
import k2d.Assets;

class Game extends k2d.Game {
    public static var MIN_X:FastFloat = 0;
    public static var MAX_X:FastFloat = 0;
    public static var MIN_Y:FastFloat = 0;
    public static var MAX_Y:FastFloat = 0;
    public static var GRAVITY:FastFloat = 0.5;

    private var _bunnies:Array<Bunny> = new Array<Bunny>();
    private var _gravity:FastFloat = 0.5;

    private var _count:Int = 0;

    private var _font:k2d.resources.Font;
    private var _container:Container;

    private var _fpsCounter = new k2d.utils.FPSCounter();
    private var _bunnyPool:Array<Bunny> = new Array<Bunny>();

    public override function onInit() {
        Assets.load([
            "mainfont.ttf",
            "rabbit.png"
        ], function(?err:String){
            if(err != null){
                trace(err);
                return;
            }

            _font = Assets.fonts["mainfont.ttf"];
            _container = new Container(this.width, this.height);
            _container.sizeByChildren = false;

            Game.MIN_X = 0;
            Game.MAX_X = this.width;
            Game.MIN_Y = 0;
            Game.MAX_Y = this.height;

            Mouse.get().notify(_onMouseDown, null, null, null);

            for(i in 0...100000){
                _bunnies.push(new Bunny());
            }
        }).start();
    }

    private function _onMouseDown(btn:Int, x:Int, y:Int) {
        for(i in 0...500){
            _addBunny();
        }
    }

    private function _addBunny(){
        var b = _bunnyPool.length > 0 ? _bunnyPool.pop() : new Bunny();
        b.anchor.set(0,0);
        b.pivot.set(0,0);
        b.speed.set(Math.random() * 5, Math.random() * 5 - 2.5);
        _container.addChild(b);

        _bunnies.push(b);
        _count++;
    }
    
    public override function onUpdate(delta:Float) {
        if(_container == null){
            return;
        }

        _container.update(delta);
    }

    public override function onRender(r:Renderer2D) {
        _fpsCounter.tick();
        if(_container == null){
            return;
        }

        _container.render(r);
        r.reset();

        r.color = 0xffffff;
        r.fillRect(0, 0, 190, 50);
        r.color = 0x000000;
        r.font = _font;
        r.fontSize = 16;
        r.drawString('${_fpsCounter.fps}fps - ${_fpsCounter.ms}ms', 10, 5);
        r.color = 0xffaa55;
        r.drawString('Bunnies: ${_count}', 10, 22);
    }
}
package;

import gecko.render.Renderer;
import gecko.math.FastFloat;
import gecko.Container;
import gecko.Sprite;
import kha.input.Mouse;
import gecko.Assets;

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
    private var _fpsCounter = new k2d.utils.FPSCounter();

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

            Game.MIN_X = 0;
            Game.MAX_X = this.width;
            Game.MIN_Y = 0;
            Game.MAX_Y = this.height;

            Mouse.get().notify(_onMouseDown, null, null, null);

        }).start();
    }

    private function _onMouseDown(btn:Int, x:Int, y:Int) {
        for(i in 0...500){
            _addBunny();
        }
    }

    private function _addBunny(){
        var b = new Bunny();
        b.anchor.set(0,0);
        b.pivot.set(0,0);
        b.speed.set(Math.random() * 5, Math.random() * 5 - 2.5);
        scene.addChild(b);

        _bunnies.push(b);
        _count++;
    }

    public override function render(r:Renderer) {
        super.render(r);

        _fpsCounter.tick();

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
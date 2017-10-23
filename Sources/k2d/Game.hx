package k2d;

import kha.System;
import kha.Framebuffer;

class Game {
    private var _loop:Loop = new Loop();

	public static function init(title:String, width:Int, height:Int) : Void {
        System.init({
            title: title,
            width: width,
            height: height
        }, function(){
            var game = new Game();
        });
    }

    public function new() {
        System.notifyOnRender(render);
        _loop.onTick(update);
        _loop.start();
    }

    function update(delta:Float) : Void {
		trace("u:", _loop.delta);
	}

    function render(framebuffer:Framebuffer) : Void {

    }
}
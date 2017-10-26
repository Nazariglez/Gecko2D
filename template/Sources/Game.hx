package;

import k2d.Renderer;

class Game extends k2d.Game {

    public override function onInit() {
        trace("on init");
    }
    
    public override function onUpdate(delta:Float) {
        trace("u:", delta);
    }

    public override function onRender(renderer:Renderer) {
        trace("rendeeeer");
    }
}
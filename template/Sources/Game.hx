package;

import k2d.Framebuffer;

class Game extends k2d.Game {
    public override function onUpdate(delta:Float) {
        trace("u:", delta);
    }

    public override function onRender(framebuffer:Framebuffer) {
        trace("rendeeeer");
    }
}
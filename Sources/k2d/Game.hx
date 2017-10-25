package k2d;

import k2d.exception.NotImplementedException;
import k2d.i.IUpdatable;
import k2d.i.IRenderable;
import k2d.math.Rect;

import kha.System;
import kha.Framebuffer;

class Game implements IUpdatable implements IRenderable {
    private var title: String;
    private var rect: Rect;

    private var _loop:Loop = new Loop();

	public function onPreUpdate(delta: Float)   { throw new NotImplementedException(); }
	public function onUpdate(delta: Float)      { throw new NotImplementedException(); }
	public function onPostUpdate(delta: Float)  { throw new NotImplementedException(); }

    public function onRender(framebuffer: Framebuffer) { throw new NotImplementedException(); }

    public function new(title:String, rect: Rect) {
        this.title = title;
        this.rect = rect;
    }
    
    public function run() {
        System.init({
            title: title,
            width: Std.int(this.rect.width),
            height: Std.int(this.rect.height)
        }, function onRun() {
            System.notifyOnRender(this.onRender);
            this._loop.onTick(this.onUpdate);
            this._loop.start();
        });
    }
}
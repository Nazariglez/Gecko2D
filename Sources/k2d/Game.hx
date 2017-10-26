package k2d;

import k2d.exception.NotImplementedException;
import k2d.i.IUpdatable;
import k2d.i.IRenderable;
import k2d.math.Rect;

import kha.System;

class Game implements IUpdatable implements IRenderable {
    public var title:String;
    public var width:Int;
    public var height:Int;
    public var renderer:Renderer = new Renderer();

    public var isRunning(get, null):Bool;

    private var _loop:Loop = new Loop();

	public function onPreUpdate(delta: Float)   { /*throw new NotImplementedException();*/ }
	public function onUpdate(delta: Float)      { trace("my update"); }
	public function onPostUpdate(delta: Float)  { /*throw new NotImplementedException();*/ }

    public function onRender(framebuffer: Framebuffer) { trace("my renderer"); }

    static public function init(title:String, width:Int, height:Int) : Game {
        var game = new Game(title, width, height);
        game.run();
        return game;
    }

    public function new(title:String, width:Int, height:Int) {
        this.title = title;
        this.width = width;
        this.height = height;
    }
    
    public function run() {
        System.init({
            title: this.title,
            width: this.width,
            height: this.height
        }, function onRun() {
            System.notifyOnRender(this._render);
            this._loop.onTick(this._update);
            this._loop.start();
        });
    }

    public function start() {
        this._loop.start();
    }

    public function stop() {
        this._loop.stop();
    }

    private function _update(delta:Float) {
        this.onPreUpdate(delta);
        this.onUpdate(delta);
        this.onPostUpdate(delta);
    }

    private function _render(framebuffer:Framebuffer) {
        renderer.setFramebuffer(framebuffer);
        this.onRender(framebuffer);
    }

    function get_isRunning() : Bool {
		return _loop.isRunning;
	}
}
package k2d;

import k2d.i.IUpdatable;
import k2d.i.IRenderable;

class Game {
    public var title:String;
    public var width:Int;
    public var height:Int;
    public var renderer:Renderer = new Renderer();

    public var isRunning(get, null):Bool;

    private var _loop:Loop = new Loop();
    private var _initiated:Bool = false;

	public function onPreUpdate(delta: Float)   { /*throw new NotImplementedException();*/ }
	public function onUpdate(delta: Float)      { trace("on game update"); }
	public function onPostUpdate(delta: Float)  { /*throw new NotImplementedException();*/ }

    public function onRender(renderer:Renderer) { trace("on game render"); }
    public function onInit() { trace("on game init."); }

    public function new(title:String, width:Int, height:Int) {
        this.title = title;
        this.width = width;
        this.height = height;
    }
    
    public function run() {
        kha.System.init({
            title: title,
            width: width,
            height: height
        }, function onRun() {
            kha.System.notifyOnRender(_render);
            _loop.onTick(_update);
        });
    }

    public function start() {
        if(!_initiated){ return; }
        _loop.start();
    }

    public function stop() {
        if(!_initiated){ return; }
        _loop.stop();
    }

    private function _update(delta:Float) {
        onPreUpdate(delta);
        onUpdate(delta);
        onPostUpdate(delta);
    }

    private function _render(framebuffer:Framebuffer) {
        _init(framebuffer);
        renderer.begin();
        _renderSceneGraph();
        renderer.end();
        renderer.clear();
    }

    private inline function _renderSceneGraph() {
        //todo render sceneGraph
        onRender(renderer);
    }

    private inline function _init(frb:Framebuffer) {
        if(_initiated){ return; }
        _initiated = true;
        renderer.setFramebuffer(frb);
        onInit();
        start();
    }

    function get_isRunning() : Bool {
		return _loop.isRunning;
	}
}
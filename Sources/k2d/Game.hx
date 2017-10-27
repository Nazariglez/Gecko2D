package k2d;

import k2d.i.IRenderer;
import k2d.render.Renderer2D;
import k2d.render.Renderer;
import k2d.render.Framebuffer;

typedef RenderAction<T:IRenderer> = {
    public var renderer:IRenderer;
    public var action:T->Void;
}

class Game {
    public var title:String;
    public var width:Int;
    public var height:Int;
    public var renderers:Array<RenderAction<Dynamic>> = [];

    public var isRunning(get, null):Bool;

    private var _loop:Loop = new Loop();
    private var _initiated:Bool = false;

	public function onPreUpdate(delta: Float)   { /*throw new NotImplementedException();*/ }
	public function onUpdate(delta: Float)      { trace("on game update"); }
	public function onPostUpdate(delta: Float)  { /*throw new NotImplementedException();*/ }

    public function onRender(renderer:Renderer2D) { trace("on game render"); }
    public function onInit() { trace("on game init."); }

    public function new(title:String, width:Int, height:Int) {
        this.title = title;
        this.width = width;
        this.height = height;
        
        addRenderer(new Renderer2D(), _render2D);
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

    @:generic public function addRenderer<T:IRenderer>(renderer:T, action:T->Void){
        renderers.push({
            renderer: renderer,
            action: action
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
        for(rAction in renderers){
            rAction.action(rAction.renderer);
        }
    }

    private function _render2D(r:Renderer2D) {
        r.begin();
        _renderSceneGraph(r);
        r.end();
        r.clear();
    }

    private inline function _renderSceneGraph(r:Renderer2D) {
        //todo render sceneGraph
        onRender(r);
    }

    private inline function _init(frb:Framebuffer) {
        if(_initiated || renderers.length == 0){ return; }

        _initiated = true;

        for(rAction in renderers){
            rAction.renderer.setFramebuffer(frb);
        }

        onInit();
        start();
    }

    function get_isRunning() : Bool {
		return _loop.isRunning;
	}
}
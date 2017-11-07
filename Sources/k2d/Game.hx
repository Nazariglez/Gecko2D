package k2d;

import k2d.utils.GameStats;
import k2d.render.IRenderer;
import k2d.render.Renderer2D;
import k2d.render.Renderer;
import k2d.render.Framebuffer;

typedef RenderAction<T:IRenderer> = {
    public var id:String;
    public var renderer:IRenderer;
    public var action:T->Void;
}

class Game {
    #if debug
    public var debugStats = new GameStats();
    #end

    public var title:String;
    
    public var width(get, set):Int;
    private var _width:Int = 0;

    public var height(get, set):Int;
    private var _height:Int = 0;


    public var renderers:Array<RenderAction<Dynamic>> = [];

    public var isRunning(get, null):Bool;

    private var _loop:Loop = new Loop();
    private var _initiated:Bool = false;

	public function onPreUpdate(delta: Float)   { /*throw new NotImplementedException();*/ }
	public function onUpdate(delta: Float)      { trace("on game update"); }
	public function onPostUpdate(delta: Float)  { /*throw new NotImplementedException();*/ }

    public function onRender(renderer:Renderer2D) { trace("on game render"); }
    public function onInit() { trace("on game init."); }

    private var _backbuffer:kha.Image;

    public function new(title:String, width:Int = 0, height:Int = 0) {
        this.title = title;
        this.width = width;
        this.height = height;
        
        addRenderer("2d", new Renderer2D(), _render2D);
    }
    
    public function run() {
        kha.System.init({
            title: title,
            width: width,
            height: height
        }, function onRun() {
            _backbuffer = kha.Image.createRenderTarget(width, height);
            kha.System.notifyOnRender(_render);
            System.subscribeOnSystemUpdate(_systemUpdate);
            _loop.onTick(_update);
        });
    }

    @:generic public function addRenderer<T:IRenderer>(id:String, renderer:T, action:T->Void){
        if(_initiated){
            throw new Error("Renderers must be added before onInit.");
            return;
        }

        //TODO addRenderers could be added at compilation time by macros
        var rAction:RenderAction<T> = {
            id: id,
            renderer: renderer,
            action: action
        };

        var index = _getRendererIndex(id);
        if(index == -1) {
            renderers.push(rAction);
            return;
        }

        renderers[index] = rAction;
    }

    private inline function _getRendererIndex(id:String) : Int {
        var index = -1;
        for(i in 0...renderers.length){
            if(renderers[i].id == id){
                index = i;
                break;
            }
        }

        return index;
    }

    @:generic public function getRenderer<T:IRenderer>(id:String, type:Class<T>) : T {
        var r:T = null;
        for(rAction in renderers){
            if(rAction.id == id){
                r = cast rAction.renderer;
                break;
            }
        }

        return r;
    }

    public function start() {
        if(!_initiated){ return; }
        if(isRunning){ return; }

        Movie.unpauseAll();
        _loop.start();
        System.start();
    }

    public function stop() {
        if(!_initiated){ return; }
        if(!isRunning){ return; }

        Movie.pauseAll();
        _loop.stop();
        System.stop();
    }

    #if kha_js 
    public function getCanvas() : js.html.CanvasElement {
        return cast js.Browser.document.getElementById(kha.CompilerDefines.canvas_id);
    }
    #else
    public function getCanvas() : Dynamic {
        return null;
    }
    #end

    private function _systemUpdate() {
        #if debug
        debugStats.system.tick();
        #end
    }

    private function _update(delta:Float) {
        #if debug
        debugStats.update.tick();
        #end

        onPreUpdate(delta);
        onUpdate(delta);
        onPostUpdate(delta);
    }

    private function _render(framebuffer:Framebuffer) {
        #if debug
        debugStats.renderer.tick();
        #end

        //todo draw in backbuffer and put in the framebuffer later?

        _init();

        if(!isRunning){
            return;
        }

        //draw the last frame backbuffer to framebuffer
        framebuffer.g2.begin();
        kha.Scaler.scale(_backbuffer, framebuffer, kha.System.screenRotation);
        framebuffer.g2.end();

        //draw the actual frame to the backbuffer
        for(rAction in renderers){
            rAction.renderer.g2 = _backbuffer.g2;
            rAction.renderer.g4 = _backbuffer.g4;
            rAction.action(rAction.renderer);
        }
    }

    private function _render2D(r:Renderer2D) {
        r.begin();
        _renderSceneGraph(r);
        r.end();
        r.reset();
    }

    private inline function _renderSceneGraph(r:Renderer2D) {
        //todo render sceneGraph
        onRender(r);
    }

    private inline function _init() {
        if(_initiated || renderers.length == 0){ return; }

        _initiated = true;

        onInit();
        start();
    }

    function get_isRunning() : Bool {
		return _loop.isRunning;
	}

    function get_width() : Int {
        return _width;
    }

    function set_width(v:Int) : Int {
        //todo manage resize events in html and native
        #if kha_js
        if(v <= 0) {
            //todo set screen size in desktop?
            v = js.Browser.window.innerWidth;
        }
        #end

        if(!_initiated){
            #if kha_js
            var canvas = getCanvas();
            if(canvas != null){
                canvas.width = v;
                canvas.style.width = v + "px";
            }
            #end
        }
        return _width = v;
    }

    function get_height() : Int {
        return _height;
    }

    function set_height(v:Int) : Int {
        //todo manage resize events in html and native
        #if kha_js
        if(v <= 0) {
            //todo set screen size in desktop?
            v = js.Browser.window.innerHeight;
        }
        #end

        if(!_initiated){
            #if kha_js
            var canvas = getCanvas();
            if(canvas != null){
                canvas.height = v;
                canvas.style.height = v + "px";
            }
            #end
        }
        return _height = v;
    }
}
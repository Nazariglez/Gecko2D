package gecko;

import gecko.render.RenderAction;
import gecko.input.Keyboard;
import gecko.input.Mouse;
import gecko.utils.GameStats;
import gecko.math.FastFloat;
import gecko.render.IRenderer;
import gecko.render.Renderer;
import gecko.render.Framebuffer;
import gecko.tween.TweenManager;
import gecko.timer.TimerManager;
import gecko.resources.Image;

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

    public var sceneManager:SceneManager;
    public var scene(get, set):Scene;

    private var _initiated:Bool = false;

    private var _backbuffer:kha.Image;
    private var _opts:GeckoOptions;

    public function new(opts:GeckoOptions) {
        _opts = opts;
        title = opts.title;
        width = opts.width;
        height = opts.height;

        addRenderer("2d", new Renderer(), _render2D);

        sceneManager = new SceneManager(this);
        _backbuffer = Image.createRenderTarget(opts.width, opts.height);

        Gecko.subscribeOnRender(_render);
        Gecko.subscribeOnSystemUpdate(_systemUpdate);
        Gecko.subscribeOnGameUpdate(_update);

        _init();

        #if ((kha_html5 ||kha_debug_html5) && debug)
            untyped js.Browser.window.game = this;
        #end
    }

    public function init(){}

    @:generic public function addRenderer<T:IRenderer>(id:String, renderer:T, action:T->Void){
        if(_initiated){
            throw new Error("Renderers must be added before init.");
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

        //Movie.unpauseAll();
        Gecko.start();
    }

    public function stop() {
        if(!_initiated){ return; }

        //Movie.pauseAll();
        Gecko.stop();
    }

    private function _systemUpdate() {
        #if debug
        debugStats.system.tick();
        #end
    }

    private function _update(delta:FastFloat) {
        #if debug
        debugStats.update.tick();
        #end
        
        update(delta);

        if(Keyboard.isEnabled){
            Keyboard.update(delta);
        }

        if(Mouse.isEnabled){
            Mouse.update(delta);
        }
    }

    public function update(delta:FastFloat) {
        TimerManager.Global.update(delta);
        TweenManager.Global.update(delta);
        
        sceneManager.update(delta);
    }

    private function _render(framebuffer:Framebuffer) {
        #if debug
        debugStats.renderer.tick();
        #end

        for(rAction in renderers){
            rAction.renderer.g2 = _backbuffer.g2;
            rAction.renderer.g4 = _backbuffer.g4;
            rAction.action(rAction.renderer);
        }

        framebuffer.g2.begin();
        #if kha_js
        if(_opts.html5CanvasMode == Html5CanvasMode.Fill){
            var canvas = Gecko.getHtml5Canvas();
            framebuffer.g2.drawScaledImage(_backbuffer, 0, 0, canvas.width, canvas.height);
        }else{
            kha.Scaler.scale(_backbuffer, framebuffer, kha.ScreenRotation.RotationNone);
        }
        #else
        kha.Scaler.scale(_backbuffer, framebuffer, kha.ScreenRotation.RotationNone);
        #end
        framebuffer.g2.end();
    }

    private function _render2D(r:Renderer) {
        r.begin();
        render(r);
        r.end();
    }

    public function render(renderer:Renderer){
        sceneManager.render(renderer);
        renderer.reset();
    }

    private inline function _init() {
        if(_initiated || renderers.length == 0){ return; }

        _initiated = true;

        init();
        start();
    }

    function get_scene() : Scene {
        return sceneManager.scene;
    }

    function set_scene(scene:Scene) : Scene {
        sceneManager.scene = scene;
        return scene;
    }

    function get_width() : Int {
        return _width;
    }

    function set_width(v:Int) : Int {
        //todo manage resize events in html and native
        return _width = v;
    }

    function get_height() : Int {
        return _height;
    }

    function set_height(v:Int) : Int {
        //todo manage resize events in html and native
        return _height = v;
    }
}
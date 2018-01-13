package gecko;

import gecko.input.Touch;
import gecko.input.Keyboard;
import gecko.input.Mouse;
import gecko.utils.GameStats;
import gecko.math.FastFloat;
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

    public var renderer:Renderer;

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

        renderer = new Renderer();

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

        if(Touch.isEnabled){
            Touch.update(delta);
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

        renderer.g2 = _backbuffer.g2;
        renderer.g4 = _backbuffer.g4;
        _render2D();

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

    private function _render2D() {
        renderer.begin();
        render(renderer);
        renderer.end();
    }

    public function render(renderer:Renderer){
        sceneManager.render(renderer);
        renderer.reset();
    }

    private inline function _init() {
        if(_initiated){ return; }

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
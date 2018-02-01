package exp;

import exp.systems.RenderSystem;
import exp.math.Random;
import kha.WindowMode;
import kha.Scheduler;
import kha.Framebuffer;
import kha.System;
import exp.render.Renderer;
import exp.resources.Image;

//TODO gecko renderer must be Gecko.graphics and must be accesible
    //TODO gecko render(r:Renderer) must be gecko draw() and use Gecko.graphics as global?

#if ((kha_html5 ||kha_debug_html5) && debug)
@:expose
#end
#if !macro @:build(exp.macros.GeckoBuilder.build()) #end
class Gecko {
    static public var isIniaited:Bool = false;

    static public var manager:EntityManager;

    static private var _updateHandlers:Array<Float32->Void> = [];
    static private var _renderHandlers:Array<Renderer->Void> = [];
    static private var _khaInitHandlers:Array<Void->Void> = [];

    static private var _renderer:Renderer;
    static private var _backbuffer:Image;
    static private var _opts:GeckoOptions;

    static public function init(onReady:Void->Void, opts:GeckoOptions) {
        var options = _parseOptions(opts != null ? opts : {});

        System.init(options.khaOptions, function(){
            _init(options, onReady);
        });
    }

    static private function _init(opts:GeckoOptions, onReady:Void->Void) {
        _opts = opts;
        _renderer = new Renderer();
        _backbuffer = Image.createRenderTarget(opts.width, opts.height); //todo antialias

        System.notifyOnRender(_render);
        Scheduler.addTimeTask(_update, 0, 1 / 60);
        resize(opts.width, opts.height, opts.html5CanvasMode);

        Random.init(opts.randomSeed);

        _initEntityManager();

        isIniaited = true;

        for(handler in _khaInitHandlers){
            handler();
        }

        onReady();
    }

    static public function addSystems(systems:Array<System>) {
        //todo
    }

    static private function _initEntityManager() {
        manager = new EntityManager();
        manager.addSystem(new RenderSystem());
        onUpdate(manager.update);
        onRender(manager.render);
    }

    static public function resize(width:Int, height:Int, ?html5CanvasMode:Html5CanvasMode){
        html5CanvasMode = html5CanvasMode != null ? html5CanvasMode : Html5CanvasMode.None;
        #if kha_html5
        width = width <= 0 ? js.Browser.window.innerWidth : width;
        height = height <= 0 ? js.Browser.window.innerHeight : height;

        switch(html5CanvasMode){
            case Html5CanvasMode.Fill: _resizeHtml5CanvasFill(width, height);
            case Html5CanvasMode.AspectFit: _resizeHtml5CanvasAspectFit(width, height);
            case Html5CanvasMode.AspectFill: _resizeHtml5CanvasAspectFill(width, height);
            default: _resizeHtml5Canvas(width, height);
        }
        #else
        width = width <= 0 ? 800 : width; //todo screenSize
        height = height <= 0 ? 600 : height;
        System.changeResolution(width, height);
        #end
    }

    #if kha_js
    static private function _resizeHtml5Canvas(width:Int, height:Int) {
        var canvas = getHtml5Canvas();
        canvas.width = width;
        canvas.style.width = width + "px";
        canvas.height = height;
        canvas.style.height = height + "px";
    }

    static private function _resizeHtml5CanvasFill(width:Int, height:Int) {
        var innerWidth:Int = cast js.Browser.window.innerWidth;
        var innerHeight:Int = cast js.Browser.window.innerHeight;
        _resizeHtml5Canvas(innerWidth, innerHeight);
    }

    static private function _resizeHtml5CanvasAspectFit(width:Int, height:Int) {
        var canvas = getHtml5Canvas();
        canvas.width = width;
        canvas.height = height;

        var ww:Int = untyped __js__('parseInt({0}) || {1}', canvas.style.width, canvas.width);
        var hh:Int = untyped __js__('parseInt({0}) || {1}', canvas.style.height, canvas.height);

        var innerWidth:Int = cast js.Browser.window.innerWidth;
        var innerHeight:Int = cast js.Browser.window.innerHeight;

        if (innerWidth < ww || innerHeight < hh || innerWidth > ww || innerHeight > hh) {
            var scale = Math.min(innerWidth/width, innerHeight/height);
            canvas.style.width = width*scale + "px";
            canvas.style.height = height*scale + "px";
        }
    }

    static private function _resizeHtml5CanvasAspectFill(width:Int, height:Int) {
        var canvas = getHtml5Canvas();
        canvas.width = width;
        canvas.height = height;

        var ww:Int = untyped __js__('parseInt({0}) || {1}', canvas.style.width, canvas.width);
        var hh:Int = untyped __js__('parseInt({0}) || {1}', canvas.style.height, canvas.height);

        var innerWidth:Int = cast js.Browser.window.innerWidth;
        var innerHeight:Int = cast js.Browser.window.innerHeight;

        if (innerWidth < ww || innerHeight < hh || innerWidth > ww || innerHeight > hh) {
            var scale = Math.max(innerWidth/width, innerHeight/height);
            canvas.style.width = width*scale + "px";
            canvas.style.height = height*scale + "px";
        }
    }
    #end

    static private function _parseOptions(opts:GeckoOptions) : GeckoOptions {
        var options:GeckoOptions = {};
        var khaOptions:SystemOptions = opts.khaOptions != null ? opts.khaOptions : {};

        options.title = opts.title != null ? opts.title : Gecko.gameTitle;
        options.width = opts.width != null ? opts.width : 800;
        options.height = opts.height != null ? opts.height : 600;
        options.backgroundColor = opts.backgroundColor != null ? opts.backgroundColor : Color.Black;
        options.fullScreen = opts.fullScreen;
        options.transparent = opts.transparent;
        options.maximizable = opts.maximizable;
        options.html5CanvasMode = opts.html5CanvasMode != null ? opts.html5CanvasMode : Html5CanvasMode.None;

        if(opts.randomSeed == null){
            #if debug
            options.randomSeed = 1;
            #else
            options.randomSeed = Std.int(Date.now().getTime());
            #end
        }else{
            options.randomSeed = opts.randomSeed;
        }

        khaOptions.title = options.title;
        khaOptions.width = options.width;
        khaOptions.height = options.height;
        khaOptions.windowMode = khaOptions.windowMode != null ? khaOptions.windowMode : (options.fullScreen ? WindowMode.Fullscreen : WindowMode.Window);
        khaOptions.samplesPerPixel = khaOptions.samplesPerPixel != null ? khaOptions.samplesPerPixel : (options.antialiasing != 0 ? options.antialiasing : 0);
        khaOptions.maximizable = khaOptions.maximizable != null ? khaOptions.maximizable : options.maximizable;

        options.khaOptions = khaOptions;

        return options;
    }

    static public function onUpdate(handler:Float32->Void) {
        _updateHandlers.push(handler);
    }

    static public function offUpdate(handler:Float32->Void) {
        _updateHandlers.remove(handler);
    }

    static public function onRender(handler:Renderer->Void) {
        _renderHandlers.push(handler);
    }

    static public function offRender(handler:Renderer->Void) {
        _renderHandlers.remove(handler);
    }

    static public function onKhaInit(handler:Void->Void) {
        _khaInitHandlers.push(handler);
    }

    static public function offKhaInit(handler:Void->Void) {
        _khaInitHandlers.remove(handler);
    }

    static private function _update() {
        for(handler in _updateHandlers){
            handler(0.0);
        }
    }

    static private function _render(f:Framebuffer) {

        _renderer.g2 = _backbuffer.g2;
        _renderer.g4 = _backbuffer.g4;

        _renderer.begin();
        for(handler in _renderHandlers){
            handler(_renderer);
        }
        _renderer.end();

        //todo background color
        f.g2.begin(); //todo html5 scale it's better with matrix transforms
        #if kha_js
        if(_opts.html5CanvasMode == Html5CanvasMode.Fill){
            var canvas = Gecko.getHtml5Canvas();
            f.g2.drawScaledImage(_backbuffer, 0, 0, canvas.width, canvas.height);
        }else{
            kha.Scaler.scale(_backbuffer, f, kha.ScreenRotation.RotationNone);
        }
        #else
        kha.Scaler.scale(_backbuffer, f, kha.ScreenRotation.RotationNone);
        #end
        f.g2.end();
    }

    static public function getHtml5Canvas() : #if kha_js js.html.CanvasElement #else Dynamic #end {
        #if kha_js
        return cast js.Browser.document.getElementById(kha.CompilerDefines.canvas_id);
        #else
        return null;
        #end
    }
}
package exp;

import exp.utils.FPSCounter;
import exp.utils.Event;
import exp.systems.RenderSystem;
import exp.math.Random;
import kha.WindowMode;
import kha.Scheduler;
import kha.Framebuffer;
import kha.System;
import exp.render.Graphics;
import exp.resources.Image;

#if ((kha_html5 ||kha_debug_html5) && debug)
@:expose
#end
#if !macro @:build(exp.macros.GeckoBuilder.build()) #end
class Gecko {
    static public var isIniaited(get, never):Bool;
    static private var _isIniaited:Bool = false;

    static public var world:World;

    static public var graphics:Graphics;
    static private var _opts:GeckoOptions;

    static public var onUpdate:Event<Float32->Void> = Event.create();
    static public var onDraw:Event<Void->Void> = Event.create();
    static public var onKhaInit:Event<Void->Void> = Event.create();
    static public var onStart:Event<Void->Void> = Event.create();
    static public var onStop:Event<Void->Void> = Event.create();

    static public var isRunning(get, null):Bool;
    static private var _isRunning:Bool = false;

    static private var _updateTaskId:Int = -1;
    static public var updateTicker:FPSCounter;


    static public function init(onReady:Void->Void, opts:GeckoOptions) {
        var options = _parseOptions(opts != null ? opts : {});

        System.init(options.khaOptions, function(){
            _init(options, onReady);
        });
    }

    static private function _init(opts:GeckoOptions, onReady:Void->Void) {
        _opts = opts;

        if(graphics == null){
            graphics = new Graphics();
        }

        Screen.init(opts.screen, opts.antialiasing);

        resize(opts.width, opts.height, opts.html5CanvasMode);

        Random.init(opts.randomSeed);

        _initWorld();

        //clear the ticker
        updateTicker = new FPSCounter();
        onStop += updateTicker.clear;

        _isIniaited = true;

        start();

        onKhaInit.emit();
        onKhaInit.clear();

        onReady();
    }

    static public function start() {
        if(_isRunning || !_isIniaited)return;
        System.notifyOnRender(_render);
        _updateTaskId = Scheduler.addTimeTask(_update, 0, 1 / 60);
        onStart.emit();
    }

    static public function stop() {
        if(!_isRunning || !_isIniaited)return;
        System.removeRenderListener(_render);
        Scheduler.removeTimeTask(_updateTaskId);
        onStop.emit();
    }


    static private function _initWorld() {
        if(world == null){
            world = new World();
        }
        onUpdate += world.update;
        onDraw += world.draw;
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
        options.bgColor = opts.bgColor != null ? opts.bgColor : Color.Black;
        options.fullScreen = opts.fullScreen;
        options.maximizable = opts.maximizable;
        options.html5CanvasMode = opts.html5CanvasMode != null ? opts.html5CanvasMode : Html5CanvasMode.None;

        options.screen = opts.screen != null ? opts.screen : {width:opts.width, height:opts.height, mode:ScreenMode.None};
        if(options.screen.mode == null){
            options.screen.mode = ScreenMode.None;
        }

        if(opts.randomSeed == null){
            #if debug
            options.randomSeed = 1;
            #else
            options.randomSeed = math.Random();
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

    static private function _update() {
        updateTicker.tick();
        onUpdate.emit(updateTicker.delta);
    }

    static private function _render(f:Framebuffer) {

        graphics.setBuffer(Screen.buffer);

        graphics.begin();
        onDraw.emit();
        graphics.end();

        f.g2.begin(true, _opts.bgColor); //todo html5 scale it's better with matrix transforms
        #if kha_js
        if(_opts.html5CanvasMode == Html5CanvasMode.Fill){
            var canvas = Gecko.getHtml5Canvas();
            f.g2.drawScaledImage(Screen.buffer, 0, 0, canvas.width, canvas.height);
        }else{
            kha.Scaler.scale(Screen.buffer, f, kha.ScreenRotation.RotationNone);
        }
        #else
        kha.Scaler.scale(Screen.buffer, f, kha.ScreenRotation.RotationNone);
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

    static inline function get_isIniaited():Bool {
        return _isIniaited;
    }

    static inline function get_isRunning():Bool {
        return _isRunning;
    }
}
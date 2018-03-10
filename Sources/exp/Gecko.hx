package exp;

import exp.timer.TimerManager;
import exp.utils.FPSCounter;
import exp.utils.Event;
import exp.systems.draw.DrawSystem;
import exp.math.Random;
import kha.WindowMode;
import kha.Scheduler;
import kha.Framebuffer;
import kha.System;
import exp.render.Graphics;

#if ((kha_html5 ||kha_debug_html5) && debug)
@:expose
#end
#if !macro @:build(exp.macros.GeckoBuilder.build()) #end
class Gecko {
    static public var isIniaited(default, null):Bool = false;

    static public var world:World;

    static public var graphics:Graphics;
    static private var _opts:GeckoOptions;

    static public var onSystemUpdate:Event<Float32->Void> = Event.create();
    static public var onUpdate:Event<Float32->Void> = Event.create();
    static public var onDraw:Event<Graphics->Void> = Event.create();
    static public var onStart:Event<Void->Void> = Event.create();
    static public var onStop:Event<Void->Void> = Event.create();
    static public var onWindowResize:Event<Int->Int->Void> = Event.create();

    static public var isRunning(default, null):Bool = false;
    static public var isProcessing(default, null):Bool = false;

    static private var _updateTaskId:Int = -1;
    static public var fixedTicker:FPSCounter;
    static public var ticker:FPSCounter;
    static public var renderTicker:FPSCounter;

    static private var _countUniqueID:Int = 0;
    static public function getUniqueID() : Int {
        return _countUniqueID++;
    }

    static private var _dirtyWindowResize:Bool = false;

    static public var currentScene(get, never):Scene;
    static public var timerManager:TimerManager;

    static private var _onKhaInitCallbacks:Array<Void->Void> = [];

    static public var time(get, null):Float32;

    static private var _destroyCallbacks:Array<Void->Void> = [];

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

        var _width:Int = opts.width;
        var _height:Int = opts.height;

        #if kha_html5
        if(opts.maximizable){
            _width = cast js.Browser.window.innerWidth;
            _height = cast js.Browser.window.innerHeight;

            if(opts.resizable){
                untyped js.Browser.window.addEventListener("resize", _onHtml5WindowResize);
            }
        }
        #end

        resize(_width, _height);

        Screen.init(opts.screen, opts.antialiasing, _width, _height);

        Random.init(opts.randomSeed);

        timerManager = TimerManager.create();

        _initWorld();

        //clear the ticker
        fixedTicker = new FPSCounter(true);
        onStop += fixedTicker.clear;

        ticker = new FPSCounter();
        onStop += ticker.clear;

        renderTicker = new FPSCounter();
        onStop += renderTicker.clear;

        isIniaited = true;

        start();

        _dispatchOnKhaInit();

        onReady();
    }

    static public function addOnKhaInitCallback(fn:Void->Void) {
        if(isIniaited){
            throw "Kha init callback must be added before Gecko init.";
        }

        _onKhaInitCallbacks.push(fn);
    }

    static private function _dispatchOnKhaInit() {
        var fn = _onKhaInitCallbacks.pop();
        while(fn != null){
            fn();
            fn = _onKhaInitCallbacks.pop();
        }
    }

    static public function start() {
        if(isRunning || !isIniaited)return;
        System.notifyOnRender(_render);
        _updateTaskId = Scheduler.addTimeTask(_update, 0, 1 / _opts.fps);
        isRunning = true;
        onStart.emit();
    }

    static public function stop() {
        if(!isRunning || !isIniaited)return;
        System.removeRenderListener(_render);
        Scheduler.removeTimeTask(_updateTaskId);
        isRunning = false;
        onStop.emit();
    }


    static private function _initWorld() {
        if(world == null){
            world = new World();
        }
        onUpdate += world.update;
        onDraw += world.draw;
    }

    static public function resize(width:Int, height:Int){

        width = width <= 0 ? 800 : width;
        height = height <= 0 ? 600 : height;
        System.changeResolution(width, height);

        #if kha_html5
        _resizeHtml5Canvas(width, height);
        #end

        onWindowResize.emit(width, height);
    }

    #if kha_html5
    static private function _resizeHtml5Canvas(width:Int, height:Int) {
        var canvas = getHtml5Canvas();
        canvas.width = width;
        canvas.style.width = width + "px";
        canvas.height = height;
        canvas.style.height = height + "px";
    }

    static private function _onHtml5WindowResize(){
        _dirtyWindowResize = true;
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
        options.maximizable = opts.maximizable != null ? opts.maximizable : false;
        options.resizable = opts.resizable != null ? opts.resizable : false;
        options.fps = opts.fps != null ? opts.fps : 60;
        options.useFixedDelta = opts.useFixedDelta != null ? opts.useFixedDelta : true;

        options.screen = opts.screen != null ? opts.screen : {width:opts.width, height:opts.height, mode:ScreenMode.None};
        if(options.screen.mode == null){
            options.screen.mode = ScreenMode.None;
        }

        if(opts.randomSeed == null){
            #if debug
            options.randomSeed = 1;
            #else
            options.randomSeed = Std.int(kha.System.time * 1000);
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
        khaOptions.resizable = khaOptions.resizable != null ? khaOptions.resizable : options.resizable;

        options.khaOptions = khaOptions;

        return options;
    }

    static inline private function _safeDestroyObjects() {
        var cb:Void->Void;
        while((cb = _destroyCallbacks.pop()) != null){
            cb();
        }
    }

    static private function _update() {
        _safeDestroyObjects();

        isProcessing = true;

        #if kha_html5
        if(_dirtyWindowResize){
            resize(cast js.Browser.window.innerWidth, cast js.Browser.window.innerHeight);
            _dirtyWindowResize = false;
        }
        #end

        fixedTicker.tick();
        ticker.tick();

        timerManager.tick();

        onUpdate.emit(_opts.useFixedDelta ? fixedTicker.delta : ticker.delta);
        onSystemUpdate.emit(ticker.delta);

        isProcessing = false;

        _safeDestroyObjects();
    }

    static private function _render(f:Framebuffer) {
        isProcessing = true;

        renderTicker.tick();

        graphics.setRenderTarget(Screen.buffer);

        graphics.begin();
        onDraw.emit(graphics);
        graphics.end();

        f.g2.begin(true, _opts.bgColor);
        f.g2.transformation.setFrom(Screen.matrix);
        f.g2.drawImage(Screen.buffer, 0, 0);
        f.g2.end();

        isProcessing = false;
    }

    static public function getHtml5Canvas() : #if kha_js js.html.CanvasElement #else Dynamic #end {
        #if kha_js
        return cast js.Browser.document.getElementById(kha.CompilerDefines.canvas_id);
        #else
        return null;
        #end
    }

    inline static function get_currentScene():Scene {
        return world.currentScene;
    }

    inline static function get_time():Float32 {
        return kha.Scheduler.realTime();
    }

}
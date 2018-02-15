package exp;

import exp.utils.FPSCounter;
import exp.utils.Event;
import exp.systems.DrawSystem;
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
    static public var isIniaited(get, never):Bool;
    static private var _isIniaited:Bool = false;

    static public var world:World;

    static public var graphics:Graphics;
    static private var _opts:GeckoOptions;

    static public var onUpdate:Event<Float32->Void> = Event.create();
    static public var onDraw:Event<Graphics->Void> = Event.create();
    static public var onKhaInit:Event<Void->Void> = Event.create();
    static public var onStart:Event<Void->Void> = Event.create();
    static public var onStop:Event<Void->Void> = Event.create();
    static public var onWindowResize:Event<Int->Int->Void> = Event.create();

    static public var isRunning(get, null):Bool;
    static private var _isRunning:Bool = false;

    static private var _updateTaskId:Int = -1;
    static public var updateTicker:FPSCounter;
    static public var renderTicker:FPSCounter;

    static private var _countUniqueID:Int = 0;
    static public function getUniqueID() : Int {
        return _countUniqueID++;
    }

    static private var _dirtyWindowResize:Bool = false;

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
        if(opts.fullScreen){
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

        _initWorld();

        //clear the ticker
        updateTicker = new FPSCounter();
        onStop += updateTicker.clear;

        renderTicker = new FPSCounter();
        onStop += renderTicker.clear;

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
        _isRunning = true;
        onStart.emit();
    }

    static public function stop() {
        if(!_isRunning || !_isIniaited)return;
        System.removeRenderListener(_render);
        Scheduler.removeTimeTask(_updateTaskId);
        _isRunning = false;
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
        options.maximizable = opts.maximizable;
        options.resizable = opts.resizable != null ? opts.resizable : false;

        options.screen = opts.screen != null ? opts.screen : {width:opts.width, height:opts.height, mode:ScreenMode.None};
        if(options.screen.mode == null){
            options.screen.mode = ScreenMode.None;
        }

        if(opts.randomSeed == null){
            #if debug
            options.randomSeed = 1;
            #else
            options.randomSeed = Std.random(100000);
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

    static private function _update() {
        #if kha_html5
        if(_dirtyWindowResize){
            resize(cast js.Browser.window.innerWidth, cast js.Browser.window.innerHeight);
            _dirtyWindowResize = false;
        }
        #end

        updateTicker.tick();
        onUpdate.emit(updateTicker.delta);
    }

    static private function _render(f:Framebuffer) {
        renderTicker.tick();

        graphics.setRenderTarget(Screen.buffer);

        graphics.begin();
        onDraw.emit(graphics);
        graphics.end();

        f.g2.begin(true, _opts.bgColor);
        f.g2.transformation.setFrom(Screen.matrix);
        f.g2.drawImage(Screen.buffer, 0, 0);
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
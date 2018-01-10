package gecko;

import gecko.render.BlendMode;
import gecko.render.Framebuffer;
import gecko.math.FastFloat;
import kha.WindowMode;
import kha.Scheduler;
import kha.System;

#if !macro @:build(gecko.GeckoBuilder.build()) #end
class Gecko {
    static public var game:Game;
    static public var delta:FastFloat;
    static public var initiated:Bool = false;

    static private var _initEvents:Array<Void->Void> = new Array<Void -> Void>();
    static private var _updateEvents:Array<Void -> Void> = new Array<Void -> Void>();
    static private var _renderEvents:Array<Framebuffer -> Void> = new Array<Framebuffer -> Void>();
    static private var _gameUpdateEvents:Array<FastFloat -> Void> = new Array<FastFloat -> Void>();

    static private var _timeTaskID:Int = -1;

    static private var _gameLoop:Loop = new Loop();

    @:generic static public function init<T:Game>(gameClass:Class<T>, ?opts:GeckoOptions) {
        var options:GeckoOptions = Gecko._parseOptions(opts != null ? opts : {});
        System.init(options.khaOptions, function _onKhaInit(){
            initiated = true;

            resize(opts.width, opts.height, opts.html5CanvasMode);

            for(fn in _initEvents){
                fn();
            }

            Gecko.game = Type.createInstance(gameClass, [options]);

            _gameLoop.onTick(Gecko._onGameUpdate);

            //trace(kha.Display.width(0), kha.Display.height(0));

            //todo read size in update and trigger resize events
        });
    }

    static public function getHtml5Canvas() : #if kha_js js.html.CanvasElement #else Dynamic #end {
        #if kha_js
        return cast js.Browser.document.getElementById(kha.CompilerDefines.canvas_id);
        #else
        return null;
        #end
    }

    static public function exit(){
        #if !js
        Gecko.stop();
        System.requestShutdown();
        #end
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

    static public function isRunning() : Bool {
        return _gameLoop.isRunning;
    }

    static public function start() {
        if(_gameLoop.isRunning)return;

        _timeTaskID = Scheduler.addTimeTask(_onSystemUpdate, 0, 1/30);
        System.notifyOnRender(_onRender);
        _gameLoop.start();
    }

    static public function stop() {
        if(!_gameLoop.isRunning)return;

        Scheduler.removeTimeTask(_timeTaskID);
        System.removeRenderListener(_onRender);
        _gameLoop.stop();
    }

    static public function subscribeOnKhaInit(cb:Void->Void) {
        Gecko._initEvents.push(cb);
    }

    static public function unsubscribeOnKhaInit(cb:Void->Void) {
        Gecko._initEvents.remove(cb);
    }

    static public function subscribeOnSystemUpdate(cb:Void->Void) {
        Gecko._updateEvents.push(cb);
    }

    static public function unsubscribeOnSystemUpdate(cb:Void->Void) {
        Gecko._updateEvents.remove(cb);
    }

    static public function subscribeOnGameUpdate(cb:FastFloat->Void) {
        Gecko._gameUpdateEvents.push(cb);
    }

    static public function unsubscribeOnGameUpdate(cb:FastFloat->Void) {
        Gecko._gameUpdateEvents.remove(cb);
    }

    static public function subscribeOnRender(cb:Framebuffer->Void) {
        Gecko._renderEvents.push(cb);
    }

    static public function unsubscribeOnRender(cb:Framebuffer->Void) {
        Gecko._renderEvents.remove(cb);
    }

    static private function _onSystemUpdate() {
        for(evt in _updateEvents){
            evt();
        }
    }

    static private function _onRender(framebuffer:Framebuffer){
        for(fn in _renderEvents){
            fn(framebuffer);
        }
    }

    static private function _onGameUpdate(delta:FastFloat) {
        Gecko.delta = delta;

        for(fn in _gameUpdateEvents){
            fn(delta);
        }
    }

    private function new(){}
}
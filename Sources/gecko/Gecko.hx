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

            for(fn in _initEvents){
                fn();
            }

            Gecko.game = Type.createInstance(gameClass, [options]);

            _gameLoop.onTick(Gecko._onGameUpdate);
        });
    }

    static public function exit(){
        #if !js
        Gecko.stop();
        System.requestShutdown();
        #end
    }

    static private function _parseOptions(opts:GeckoOptions) : GeckoOptions {
        var options:GeckoOptions = {};
        var khaOptions:SystemOptions = opts.khaOptions != null ? opts.khaOptions : {};

        options.title = opts.title != null ? opts.title : Gecko.gameTitle;
        options.width = opts.width != null ? opts.width : 800;
        options.height = opts.height != null ? opts.height : 600;
        options.backgroundColor = opts.backgroundColor != null ? opts.backgroundColor : Color.Black;
        options.fullScreen = opts.fullScreen;
        options.transparent = opts.transparent;

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
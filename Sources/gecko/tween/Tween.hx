package gecko.tween;

import gecko.utils.Event;
import gecko.macros.IAutoPool;
import gecko.Float32;

class Tween implements IAutoPool {
    inline static public function interpolate(from:Float32, to:Float32, totalTime:Float32, elapsedTime:Float32, easing:Ease) : Float32 {
        return from + ((to - from) * easing(elapsedTime/totalTime));
    }

    public var onStart:Event<Void->Void>;
    public var onStop:Event<Void->Void>;
    public var onInit:Event<Void->Void>;
    public var onEnd:Event<Void->Void>;
    public var onUpdate:Event<Float32->Void>;
    public var onYoyo:Event<Void->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onPause:Event<Void->Void>;
    public var onResume:Event<Void->Void>;

    public var isActive(default, null):Bool = false;
    public var isEnded(default, null):Bool = false;
    public var isStarted(default, null):Bool = false;
    public var isPaused(default, null):Bool = false;

    public var destroyOnEnd:Bool = false;
    public var easing:Ease = Easing.linear;
    public var loop:Bool = false;
    public var delay:Float32 = 0;
    public var time:Float32 = 0;

    public var repeat:Int = 0;
    private var _repeat:Int = 0;

    public var yoyo:Bool = false;
    private var _yoyo:Bool = false;

    private var _delayTime:Float32 = 0;
    private var _elapsedTime:Float32 = 0;

    public var target:Dynamic;
    public var manager(default, null):TweenManager;

    private var _to:Dynamic = {};
    private var _from:Dynamic = {};

    private var _subtargetTo:Array<Map<String, Float32>> = [];
    private var _subtargetFrom:Array<Map<String, Float32>> = [];
    private var _subtarget:Array<Dynamic> = [];

    public function new() {
        onStart = Event.create();
        onStop = Event.create();
        onInit = Event.create();
        onEnd = Event.create();
        onUpdate = Event.create();
        onYoyo = Event.create();
        onRepeat = Event.create();
        onPause = Event.create();
        onResume = Event.create();
    }

    public function init(target:Dynamic, valuesTo:Dynamic, time:Float32, ?easing:Ease, ?manager:TweenManager) {
        this.target = target;
        this.easing = easing != null ? easing : Easing.linear;
        this.manager = manager != null ? manager : Gecko.tweenManager;
        this.manager.tweens.push(this);
        this.time = time;
        _to = valuesTo;
    }

    public function start() {
        if(isActive){
            return;
        }

        isActive = true;

        reset();
        onStart.emit();
    }

    public function stop() {
        if(!isActive){
            return;
        }

        isActive = false;

        reset();
        onStop.emit();
    }

    public function pause() {
        if(!isActive || isPaused){
            return;
        }

        isPaused = true;
        onPause.emit();
    }

    public function resume() {
        if(!isActive || !isPaused){
            return;
        }

        isPaused = false;
        onResume.emit();
    }

    inline private inline function _swapFromTo() {
        var _toCache = _subtargetTo;
        var _fromCache = _subtargetFrom;
        _subtargetFrom = _toCache;
        _subtargetTo = _fromCache;
    }

    inline public function setTo(valuesTo:Dynamic) {
        _to = valuesTo;
    }

    inline public function setFrom(valuesFrom:Dynamic) {
        _from = valuesFrom;
    }

    public function remove() {
        if(manager == null){
            return;
        }

        manager.removeTween(this);
    }

    public function reset() {
        _elapsedTime = 0;
        _repeat = 0;
        _delayTime = 0;
        isStarted = false;
        isPaused = false;
        isEnded = false;

        if(yoyo && _yoyo){
            _swapFromTo();

            _yoyo = false;
        }
    }

    private inline function _canUpdate() : Bool {
        return time > 0 && isActive && !isPaused && target != null;
    }

    public function update(dt:Float32) {
        if(!_canUpdate()) {
            return;
        }

        if(delay > _delayTime){
            _delayTime += dt;
            return;
        }

        if(!isStarted){
            _parseTweenData();
            isStarted = true;
            onInit.emit();
        }

        if(_subtarget.length <= 0){
            stop();
            reset();
            return;
        }

        var time = yoyo ? this.time/2 : this.time;
        if(time > _elapsedTime){
            var t = _elapsedTime+dt;
            var ended = (t >= time);

            _elapsedTime = ended ? time : t;

            for(i in 0..._subtarget.length){
                _apply(_subtargetTo[i], _subtargetFrom[i], time, _subtarget[i]);
            }

            var realElapsed = _yoyo ? time + _elapsedTime : _elapsedTime;
            onUpdate.emit(realElapsed);

            if(ended){
                if(yoyo && !_yoyo){
                    _yoyo = true;
                    _swapFromTo();

                    //todo path

                    onYoyo.emit();
                    _elapsedTime = 0;
                    return;
                }

                if(loop || repeat > _repeat){
                    _repeat++;
                    onRepeat.emit(_repeat);
                    _elapsedTime = 0;

                    if(yoyo && _yoyo){
                        _swapFromTo();

                        //todo path

                        _yoyo = false;
                    }
                    return;
                }

                isEnded = true;
                isActive = false;
                onEnd.emit();
            }
            return;
        }
    }

    private function _parseTweenData() {
        if(isStarted) return;
        _parse(_to, _from, target);

        //todo path
    }

    private function _parse(to:Dynamic, from:Dynamic, targ:Dynamic) {
        var _target1:Dynamic = null;
        var _to1:Map<String, Float32> = null;
        var _from1:Map<String, Float32> = null;

        for(k in Reflect.fields(to)){
            var toVal:Null<Float32> = Reflect.getProperty(to, k);
            var fromVal:Null<Float32> = Reflect.getProperty(from, k);
            var targetVal = Reflect.getProperty(targ, k);

            if(Reflect.isObject(toVal)){
                _parse(toVal, fromVal, targetVal);
            }else{
                if(_target1 == null){
                    _target1 = targ;
                    //todo clean the maps, dont create new
                    _to1 = new Map();
                    _from1 = new Map();
                }

                _to1[k] = toVal;
                _from1[k] = fromVal == null ? targetVal : fromVal;
            }
        }

        if(_target1 != null){
            _subtarget.push(_target1);
            _subtargetTo.push(_to1);
            _subtargetFrom.push(_from1);
        }
    }

    public function _apply(to:Map<String, Float32>, from:Map<String, Float32>, time:Float32, targ:Dynamic) {
        for(k in to.keys()){ //todo avoid to use map.keys() because create an array each time
            var b = from[k];
            var c = to[k] - b;
            var d = time;
            var t = _elapsedTime/d;
            Reflect.setProperty(targ, k, b+(c*easing(t)));
        }

        //todo path
    }

    public function clear(){
        time = 0;
        isActive = false;
        easing = Easing.linear;
        destroyOnEnd = false;
        repeat = 0;
        loop = false;
        delay = 0;
        yoyo = false;
        isStarted = false;
        isPaused = false;
        isEnded = false;

        _to = null;
        _from = null;
        _delayTime = 0;
        _elapsedTime = 0;
        _repeat = 0;
        _yoyo = false;
    }

    public function beforeDestroy(){
        if(manager != null){
            remove();
        }

        clear();

        onInit.clear();
        onStart.clear();
        onStop.clear();
        onResume.clear();
        onPause.clear();
        onEnd.clear();
        onRepeat.clear();
        onUpdate.clear();
        onYoyo.clear();
    }
}
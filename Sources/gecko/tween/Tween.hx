package gecko.tween;

import gecko.utils.Event;
import gecko.math.FastFloat;
import gecko.utils.EventEmitter;

class Tween {
    static private inline var EVENT_START = "start";
    static private inline var EVENT_STOP = "stop";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";
    static private inline var EVENT_UPDATE = "update";
    static private inline var EVENT_YOYO = "yoyo";
    static private inline var EVENT_INIT = "init";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_REPEAT = "repeat";

    public var onStart:Event<Void->Void>;
    public var onStartOnce:Event<Void->Void>;
    public var onStop:Event<Void->Void>;
    public var onStopOnce:Event<Void->Void>;
    public var onInit:Event<Void->Void>;
    public var onInitOnce:Event<Void->Void>;
    public var onEnd:Event<Void->Void>;
    public var onEndOnce:Event<Void->Void>;
    public var onUpdate:Event<FastFloat->Void>;
    public var onUpdateOnce:Event<FastFloat->Void>;
    public var onYoyo:Event<Void->Void>;
    public var onYoyoOnce:Event<Void->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onRepeatOnce:Event<Int->Void>;
    public var onPause:Event<Void->Void>;
    public var onPauseOnce:Event<Void->Void>;
    public var onResume:Event<Void->Void>;
    public var onResumeOnce:Event<Void->Void>;

    private function _bindEvents() {
        onStart = _eventEmitter.bind(new Event(EVENT_START));
        onStartOnce = _eventEmitter.bind(new Event(EVENT_START, true));
        onStop = _eventEmitter.bind(new Event(EVENT_STOP));
        onStopOnce = _eventEmitter.bind(new Event(EVENT_STOP, true));
        onInit = _eventEmitter.bind(new Event(EVENT_INIT));
        onInitOnce = _eventEmitter.bind(new Event(EVENT_INIT, true));
        onEnd = _eventEmitter.bind(new Event(EVENT_END));
        onEndOnce = _eventEmitter.bind(new Event(EVENT_END, true));
        onUpdate = _eventEmitter.bind(new Event(EVENT_UPDATE));
        onUpdateOnce = _eventEmitter.bind(new Event(EVENT_UPDATE, true));
        onYoyo = _eventEmitter.bind(new Event(EVENT_YOYO));
        onYoyoOnce = _eventEmitter.bind(new Event(EVENT_YOYO, true));
        onRepeat = _eventEmitter.bind(new Event(EVENT_REPEAT));
        onRepeatOnce = _eventEmitter.bind(new Event(EVENT_REPEAT, true));
        onPause = _eventEmitter.bind(new Event(EVENT_PAUSE));
        onPauseOnce = _eventEmitter.bind(new Event(EVENT_PAUSE, true));
        onResume = _eventEmitter.bind(new Event(EVENT_RESUME));
        onResumeOnce = _eventEmitter.bind(new Event(EVENT_RESUME, true));
    }

    static public function interpolate(from:FastFloat, to:FastFloat, totalTime:FastFloat, elapsedTime:FastFloat, easing:FastFloat -> FastFloat) : FastFloat {
        return from + ((to - from) * easing(elapsedTime/totalTime));
    }

    public var target:Dynamic;
    public var manager:TweenManager;

    public var time:FastFloat = 0;
    public var isActive:Bool = false;
    public var easing:FastFloat -> FastFloat = Easing.linear();
    public var expire:Bool = false;
    public var repeat:Int = 0;
    public var loop:Bool = false;
    public var delay:FastFloat = 0;
    public var yoyo:Bool = false;
    public var isStarted:Bool = false;
    public var isEnded:Bool = false;
    public var isPaused:Bool = false;

    private var _to:Dynamic = {};
    private var _from:Dynamic = {};

    private var _subtargetTo:Array<Map<String, FastFloat>> = [];
    private var _subtargetFrom:Array<Map<String, FastFloat>> = [];
    private var _subtarget:Array<Dynamic> = [];

    private var _delayTime:FastFloat = 0;
    private var _elapsedTime:FastFloat = 0;
    private var _repeat:Int = 0;
    private var _yoyo:Bool = false;

    private var _eventEmitter:EventEmitter = new EventEmitter();
    private var _group:TweenGroup;

    public function new(target:Dynamic, ?manager:TweenManager) {
        if(manager == null){
            manager = TweenManager.Global;
        }
        _bindEvents();

        this.target = target;
        addTo(manager);
        clear();
    }

    public function setGroup(group:TweenGroup) {
        _group = group;
    }

    public function start() {
        if(isActive){
            return;
        }

        isActive = true;
        _eventEmitter.emit(EVENT_START);
    }

    public function stop() {
        if(!isActive){
            return;
        }

        isActive = false;
        
        reset();
        _eventEmitter.emit(EVENT_STOP);
    }

    public function pause() {
        if(!isActive || isPaused){
            return;
        }

        isPaused = true;
        _eventEmitter.emit(EVENT_PAUSE);
    }

    public function resume() {
        if(!isActive || !isPaused){
            return;
        }

        isPaused = false;
        _eventEmitter.emit(EVENT_RESUME);
    }

    public function setTo(data:Dynamic){
        //todo add arrays with some values to go in order, like {x: [100, 250, 500]}
        _to = data;
    }

    public function setFrom(data:Dynamic){
        _from = data;
    }

    public function remove(){
        if(manager == null){
            return;
        }

        manager.removeTween(this);
    }

    public function addTo(manager:TweenManager) {
        manager.addTween(this);
    }

    public function clear() {
        time = 0;
        isActive = false;
        easing = Easing.linear();
        expire = false;
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

        //todo path
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

    public function update(dt:FastFloat){
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
            _eventEmitter.emit(EVENT_INIT);
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
            _eventEmitter.emit(EVENT_UPDATE, [realElapsed]);

            if(ended){
                if(yoyo && !_yoyo){
                    _yoyo = true;
                    _swapFromTo();

                    //todo path

                    _eventEmitter.emit(EVENT_YOYO);
                    _elapsedTime = 0;
                    return;
                }

                if(loop || repeat > _repeat){
                    _repeat++;
                    _eventEmitter.emit(EVENT_REPEAT, [_repeat]);
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
                _eventEmitter.emit(EVENT_END);
            }
            return;
        }
    }

    private inline function _swapFromTo() {
        var _toCache = _subtargetTo;
        var _fromCache = _subtargetFrom;
        _subtargetFrom = _toCache;
        _subtargetTo = _fromCache;
    }

    public function _apply(to:Map<String, FastFloat>, from:Map<String, FastFloat>, time:FastFloat, targ:Dynamic) {
        for(k in to.keys()){
            var b = from[k];
            var c = to[k] - b;
            var d = time;
            var t = _elapsedTime/d;
            Reflect.setProperty(targ, k, b+(c*easing(t)));
        }

        //todo path
    }

    private function _parseTweenData() {
        if(isStarted) return;
        _parse(_to, _from, target);

        //todo path
    }

    private function _parse(to:Dynamic, from:Dynamic, targ:Dynamic) {
        var _target1:Dynamic = null;
        var _to1:Map<String, FastFloat> = null;
        var _from1:Map<String, FastFloat> = null;

        for(k in Reflect.fields(to)){
            var toVal:Null<FastFloat> = Reflect.getProperty(to, k);
            var fromVal:Null<FastFloat> = Reflect.getProperty(from, k);
            var targetVal = Reflect.getProperty(targ, k);

            if(Reflect.isObject(toVal)){
                _parse(toVal, fromVal, targetVal);
            }else{
               if(_target1 == null){
                   _target1 = targ;
                   _to1 = new Map<String, FastFloat>();
                   _from1 = new Map<String, FastFloat>();
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
}
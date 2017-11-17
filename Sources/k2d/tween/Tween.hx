package k2d.tween;

import k2d.math.FastFloat;
import k2d.utils.EventEmitter;

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

    public function parseDynamicStruct(d:Dynamic) : Map<String, FastFloat> {
        var map = new Map<String, FastFloat>();
        
        if(!Reflect.isObject(d)){
            trace("invalid tween object.", d);
            return map;
        }

        for(key in Reflect.fields(d)){
            map[key] = Reflect.field(d, key);
        }

        return map;
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
        isEnded = false;

        if(yoyo && _yoyo){
            _swapFromTo();

            _yoyo = false;
        }
    }

    private inline function _canUpdate() : Bool {
        return time > 0 && isActive && !isPaused && target != null;
    }

    public function update(dt:FastFloat, ms:FastFloat){
        if(!_canUpdate()) return;

        if(delay > _delayTime){
            _delayTime += ms;
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
            var t = _elapsedTime+ms;
            var ended = (t >= time);

            _elapsedTime = ended ? time : t;

            for(i in 0..._subtarget.length){
                _apply(_subtargetTo[i], _subtargetFrom[i], time, _subtarget[i]);
            }

            var realElapsed = _yoyo ? time + _elapsedTime : _elapsedTime;
            _eventEmitter.emit(EVENT_UPDATE, realElapsed);

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
                    _eventEmitter.emit(EVENT_REPEAT, _repeat);
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

    public function subscribeOnStart(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_START, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_START, cb);
    }

    public function unsubscribeOnStart(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_START, cb);
    }

    public function subscribeOnStop(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_STOP, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_STOP, cb);
    }

    public function unsubscribeOnStop(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_STOP, cb);
    }

    public function subscribeOnInit(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_INIT, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_INIT, cb);
    }

    public function unsubscribeOnInit(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_INIT, cb);
    }

    public function subscribeOnEnd(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_END, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_END, cb);
    }

    public function unsubscribeOnEnd(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_END, cb);
    }

    public function subscribeOnUpdate(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_UPDATE, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_UPDATE, cb);
    }

    public function unsubscribeOnUpdate(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_UPDATE, cb);
    }

    public function subscribeOnYoyo(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_YOYO, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_YOYO, cb);
    }

    public function unsubscribeOnYoyo(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_YOYO, cb);
    }

    public function subscribeOnRepeat(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_REPEAT, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_REPEAT, cb);
    }

    public function unsubscribeOnRepeat(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_REPEAT, cb);
    }

    public function subscribeOnPause(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_PAUSE, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_PAUSE, cb);
    }

    public function unsubscribeOnPause(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_PAUSE, cb);
    }

    public function subscribeOnResume(cb:Void->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_RESUME, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_RESUME, cb);
    }

    public function unsubscribeOnResume(cb:Void->Void){
        _eventEmitter.removeListener(EVENT_RESUME, cb);
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
package k2d.tween;

import k2d.math.FastFloat;
import k2d.utils.EventEmitter;

class Tween {
    static private inline var EVENT_START = "start";
    static private inline var EVENT_STOP = "stop";
    static private inline var EVENT_UPDATE = "update";
    static private inline var EVENT_YOYO = "yoyo";
    static private inline var EVENT_INIT = "init";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_REPEAT = "repeat";

    public var target:Dynamic;
    public var manager:TweenManager;

    public var time:FastFloat = 0;
    public var active:Bool = false;
    public var easing:FastFloat -> FastFloat = Easing.linear();
    public var expire:Bool = false;
    public var repeat:Int = 0;
    public var loop:Bool = false;
    public var delay:FastFloat = 0;
    public var yoyo:Bool = false;
    public var isStarted:Bool = false;
    public var isEnded:Bool = false;

    private var _to:Map<String, FastFloat> = null;
    private var _from:Map<String, FastFloat> = null;
    private var _delayTime:FastFloat = 0;
    private var _elapsedTime:FastFloat = 0;
    private var _repeat:Int = 0;
    private var _yoyo:Bool = false;

    private var _eventEmitter:EventEmitter = new EventEmitter();

    public function new(target:Dynamic, ?manager:TweenManager) {
        if(manager == null){
            manager = TweenManager.Global;
        }
        this.target = target;
        addTo(manager);
        clear();
    }

    public function start() {
        active = true;
        _eventEmitter.emit(EVENT_START);
    }

    public function stop() {
        active = false;
        _eventEmitter.emit(EVENT_STOP);
    }

    public function setTo(data:Dynamic){
        _to = parseDynamicStruct(data);
    }

    public function setFrom(data:Dynamic){
        _from = parseDynamicStruct(data);
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
        active = false;
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
            var _to = this._to;
            var _from = this._from;
            this._to = _from;
            this._from = _to;

            _yoyo = false;
        }
    }

    private inline function _canUpdate() : Bool {
        return time > 0 && active && target != null;
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

        var time = yoyo ? this.time/2 : this.time;
        if(time > _elapsedTime){
            var t = _elapsedTime+ms;
            var ended = (t >= time);

            _elapsedTime = ended ? time : t;
            _apply(time);

            var realElapsed = _yoyo ? time + _elapsedTime : _elapsedTime;
            _eventEmitter.emit(EVENT_UPDATE, realElapsed);

            if(ended){
                var _toCache:Map<String, FastFloat>;
                var _fromCache:Map<String, FastFloat>;

                if(yoyo && !_yoyo){
                    _yoyo = true;
                    _toCache = _to;
                    _fromCache = _from;
                    _from = _toCache;
                    _to = _fromCache;

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
                        _toCache = _to;
                        _fromCache = _from;
                        _to = _fromCache;
                        _from = _toCache;

                        //todo path

                        _yoyo = false;
                    }
                    return;
                }

                isEnded = true;
                active = false;
                _eventEmitter.emit(EVENT_END);

                //todo chain
            }
            return;
        }
    }

    public function _apply(time:FastFloat) {
        _recurseApplyTween(time);
        //todo path
    }

    private function _parseTweenData() {
        if(isStarted) return;
        if(_from == null){
            _from = new Map<String, FastFloat>();
        }

        _parseRecursiveData();

        //todo path
    }

    private function _recurseApplyTween(time:FastFloat){
        for(k in _to.keys()){
            if(!Reflect.isObject(_to[k])){
                var b = _from[k];
                var c = _to[k] - b;
                var d = time;
                var t = _elapsedTime/d;
                Reflect.setProperty(target, k, b+(c*easing(t)));
            }else{
                //todo recursive
            }
        }
    }

    private function _parseRecursiveData() {
        for(k in _to.keys()){
            _from[k] = Reflect.getProperty(target, k);
        }

        //todo parse recursive
    }
}
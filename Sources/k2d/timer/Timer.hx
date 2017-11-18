package k2d.timer;

import k2d.math.FastFloat;
import k2d.utils.EventEmitter;

class Timer {
    static private inline var EVENT_START = "start";
    static private inline var EVENT_STOP = "stop";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";
    static private inline var EVENT_INIT = "init";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_REPEAT = "repeat";
    static private inline var EVENT_UPDATE = "update";

    public var manager:TimerManager;

    public var time:FastFloat = 0;
    public var isActive:Bool = false;
    public var expire:Bool = false;
    public var repeat:Int = 0;
    public var loop:Bool = false;
    public var delay:FastFloat = 0;
    public var isStarted:Bool = false;
    public var isEnded:Bool = false;
    public var isPaused:Bool = false;

    private var _delayTime:FastFloat = 0;
    private var _repeat:Int = 0;

    public var elapsedTime(get, null):FastFloat;
    private var _elapsedTime:FastFloat = 0;

    function get_elapsedTime() : FastFloat {
        return _elapsedTime;
    }

    private var _eventEmitter:EventEmitter = new EventEmitter();

    public function new(time:FastFloat = 16, ?manager:TimerManager) {
        if(manager == null){
            manager = TimerManager.Global;
        }

        addTo(manager);
        clear();
        this.time = time;        
    }

    public function update(dt:FastFloat, ms:FastFloat) {
        if(!(time > 0 && isActive && !isPaused)){
            return;
        }

        if(delay > _delayTime){
            _delayTime += ms;
            return;
        }

        if(!isStarted){
            isStarted = true;
            _eventEmitter.emit(EVENT_INIT);
        }

        if(time > _elapsedTime) {
            var t = _elapsedTime+ms;
            var ended = (t >= time);

            _elapsedTime = ended ? time : t;
            _eventEmitter.emit(EVENT_UPDATE, [_elapsedTime]);

            if(ended){
                if(loop || repeat > _repeat) {
                    _repeat++;
                    _elapsedTime = 0;
                    _eventEmitter.emit(EVENT_REPEAT, [_repeat]);
                    return;
                }

                isEnded = true;
                isActive = false;
                _eventEmitter.emit(EVENT_END);
            }
        }
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

    public function addTo(manager:TimerManager) {
        manager.addTimer(this);
    }

    public function remove() {
        if(manager == null){
            return;
        }

        manager.removeTimer(this);
    }

    public function clear() {
        time = 0;
        isActive = false;
        expire = false;
        repeat = 0;
        loop = false;
        delay = 0;
        isStarted = false;
        isEnded = false;
        isPaused = false;

        _delayTime = 0;
        _elapsedTime = 0;
        _repeat = 0;
    }

    public function reset() {
        _elapsedTime = 0;
        _repeat = 0;
        _delayTime = 0;
        isStarted = false;
        isEnded = false;
        isEnded = false;
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

    public function subscribeOnUpdate(cb:FastFloat->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_UPDATE, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_UPDATE, cb);
    }

    public function unsubscribeOnUpdate(cb:FastFloat->Void){
        _eventEmitter.removeListener(EVENT_UPDATE, cb);
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

    public function subscribeOnRepeat(cb:Int->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_REPEAT, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_REPEAT, cb);
    }

    public function unsubscribeOnRepeat(cb:Int->Void){
        _eventEmitter.removeListener(EVENT_REPEAT, cb);
    }
}
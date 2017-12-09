package gecko.timer;

import gecko.math.FastFloat;
import gecko.utils.EventEmitter;

class Timer {
    static private inline var EVENT_START = "start";
    static private inline var EVENT_STOP = "stop";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";
    static private inline var EVENT_INIT = "init";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_REPEAT = "repeat";
    static private inline var EVENT_UPDATE = "update";

    public var onStart:Event<Void->Void>;
    public var onStartOnce:Event<Void->Void>;
    public var onStop:Event<Void->Void>;
    public var onStopOnce:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onPauseOnce:Event<Void->Void>;
    public var onResume:Event<Void->Void>;
    public var onResumeOnce:Event<Void->Void>;
    public var onInit:Event<Void->Void>;
    public var onInitOnce:Event<Void->Void>;
    public var onEnd:Event<Void->Void>;
    public var onEndOnce:Event<Void->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onRepeatOnce:Event<Int->Void>;
    public var onUpdate:Event<FastFloat->Void>;
    public var onUpdateOnce:Event<FastFloat->Void>;

    private function _bindEvents() {
        onStart = _eventEmitter.bind(new Event(EVENT_START));
        onStartOnce = _eventEmitter.bind(new Event(EVENT_START, true));
        onStop = _eventEmitter.bind(new Event(EVENT_STOP));
        onStopOnce = _eventEmitter.bind(new Event(EVENT_STOP, true));
        onPause = _eventEmitter.bind(new Event(EVENT_PAUSE));
        onPauseOnce = _eventEmitter.bind(new Event(EVENT_PAUSE, true));
        onResume = _eventEmitter.bind(new Event(EVENT_RESUME));
        onResumeOnce = _eventEmitter.bind(new Event(EVENT_RESUME, true));
        onInit = _eventEmitter.bind(new Event(EVENT_INIT));
        onInitOnce = _eventEmitter.bind(new Event(EVENT_INIT, true));
        onEnd = _eventEmitter.bind(new Event(EVENT_END));
        onEndOnce = _eventEmitter.bind(new Event(EVENT_END, true));
        onRepeat = _eventEmitter.bind(new Event(EVENT_REPEAT));
        onRepeatOnce = _eventEmitter.bind(new Event(EVENT_REPEAT, true));
        onUpdate = _eventEmitter.bind(new Event(EVENT_UPDATE));
        onUpdateOnce = _eventEmitter.bind(new Event(EVENT_UPDATE, true));
    }

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

        _bindEvents();

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
}
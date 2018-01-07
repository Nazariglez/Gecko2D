package gecko.timer;

import gecko.utils.Event;
import gecko.utils.EventEmitter;
import gecko.utils.Chain;

class TimerGroup {
    static private inline var EVENT_PROGRESS = "progress";
    static private inline var EVENT_REPEAT = "repeat";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";

    public var onProgress:Event<Timer->Void>;
    public var onProgressOnce:Event<Timer->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onRepeatOnce:Event<Int->Void>;
    public var onEnd:Event<Void->Void>;
    public var onEndOnce:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onPauseOnce:Event<Void->Void>;
    public var onResume:Event<Void->Void>;
    public var onResumeOnce:Event<Void->Void>;

    private function _bindEvents() {
        onProgress = _eventEmitter.bind(new Event(EVENT_PROGRESS));
        onProgressOnce = _eventEmitter.bind(new Event(EVENT_PROGRESS, true));
        onRepeat = _eventEmitter.bind(new Event(EVENT_REPEAT));
        onRepeatOnce = _eventEmitter.bind(new Event(EVENT_REPEAT, true));
        onEnd = _eventEmitter.bind(new Event(EVENT_END));
        onEndOnce = _eventEmitter.bind(new Event(EVENT_END, true));
        onPause = _eventEmitter.bind(new Event(EVENT_PAUSE));
        onPauseOnce = _eventEmitter.bind(new Event(EVENT_PAUSE, true));
        onResume = _eventEmitter.bind(new Event(EVENT_RESUME));
        onResumeOnce = _eventEmitter.bind(new Event(EVENT_RESUME, true));

    }
    
    public var timers:Array<Timer> = new Array<Timer>();

    public var repeat:Int = 0;
    public var loop:Bool = false;

    private var _repeat:Int = 0;
    
    public var isActive:Bool = false;
    public var isPaused:Bool = false;

    private var _isParallelActive:Bool = false;

    private var _eventEmitter:EventEmitter = new EventEmitter();
    private var _unsubscribeAll:Array<Void->Void> = new Array<Void->Void>();

    public function new(?timers:Array<Timer>) {
        if(timers != null) {
            this.timers = timers;
        }

        _bindEvents();
    }

    public function addTween(t:Timer) {
        if(isActive){
            trace("Error: timers can't be added after the group start.");
            return;
        }

        if(t.isActive){
            trace("Error: timers can't be active before added to a group");
            return;
        }

        timers.push(t);
    }

    public function pause() {
        if(!isActive || isPaused){
            return;
        }

        for(t in timers){
            t.pause();
        }

        isPaused = true;

        _eventEmitter.emit(EVENT_PAUSE);
    }

    public function resume() {
        if(!isActive || !isPaused){
            return;
        }

        for(t in timers){
            t.resume();    
        }

        isPaused = false;

        _eventEmitter.emit(EVENT_RESUME);
    }

    public function start(inParallel:Bool = false) {
        if(isActive){
            return;
        }

        _start(inParallel);
    }

    private function _start(inParallel:Bool) {
        isActive = true;
        _isParallelActive = inParallel;
        _unsubscribeAll = [];

        if(inParallel){
            Chain.each(timers, _timerEndCallback, _onEnd);
            for(t in timers){
                t.reset();
                t.start();
            }
        }else{
            Chain.eachSeries(timers, function(t:Timer, next:?String->Void){
                _timerEndCallback(t, next);
                t.reset();
                t.start();
            }, _onEnd);
        }
    }

    public function stop() {
        if(!isActive){
            return;
        }

        _stop();
    }

    private function _stop(reset:Bool = false){
        for(t in timers){
            t.stop();
            t.reset();
        }

        isActive = false;
        if(reset){
            _repeat = 0;
        }

        for(fn in _unsubscribeAll){
            fn();
        }
    }

    private function _onProgress(timer:Timer) {
        _eventEmitter.emit(EVENT_PROGRESS, [timer]);
    }

    private function _timerEndCallback(t:Timer, next:?String->Void){
        var fn = function(){
            _onProgress(t);
            next();
        }

        _unsubscribeAll.push(function(){
            t.onEnd -= fn;
        });

        t.onEndOnce += fn;
    }

    private function _onEnd(?err:String){
        if(err != null){
            trace("Error:", err);
            return;
        }

        if(loop || repeat > _repeat){
            _repeat++;
            _stop();
            start(_isParallelActive);
            _eventEmitter.emit(EVENT_REPEAT, [_repeat]);
        }else{
            _stop(true);
            _eventEmitter.emit(EVENT_END);
        }
    }
}
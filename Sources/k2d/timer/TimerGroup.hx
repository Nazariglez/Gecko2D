package k2d.timer;

import k2d.utils.EventEmitter;
import k2d.utils.Chain;

class TimerGroup {
    static private inline var EVENT_PROGRESS = "progress";
    static private inline var EVENT_REPEAT = "repeat";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";
    
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

    public function subscribeOnProgress(cb:Timer->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_PROGRESS, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_PROGRESS, cb);
    }

    public function unsubscribeOnProgress(cb:Timer->Void){
        _eventEmitter.removeListener(EVENT_PROGRESS, cb);
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

    private function _onProgress(timer:Timer) {
        _eventEmitter.emit(EVENT_PROGRESS, [timer]);
    }

    private function _timerEndCallback(t:Timer, next:?String->Void){
        var fn = function(){
            _onProgress(t);
            next();
        }

        _unsubscribeAll.push(function(){
            t.unsubscribeOnEnd(fn);
        });

        t.subscribeOnEnd(fn, true);
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
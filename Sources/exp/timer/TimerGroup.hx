package exp.timer;

import exp.utils.Chain;
import exp.utils.Event;
import exp.macros.IAutoPool;

class TimerGroup implements IAutoPool {
    public var onProgress:Event<Timer->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onEnd:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onResume:Event<Void->Void>;

    public var timers:Array<Timer> = [];
    public var repeat:Int = 0;
    public var loop:Bool = false;

    private var _repeat:Int = 0;

    public var isActive(default, null):Bool = false;
    public var isPaused(default, null):Bool = false;

    private var _isParallelActive:Bool = false;

    private var _unsubscribeAll:Array<Void->Void> = [];

    public function new(){
        onProgress = Event.create();
        onRepeat = Event.create();
        onEnd = Event.create();
        onPause = Event.create();
        onResume = Event.create();
    }

    public function init(timers:Array<Timer>){}

    public function addTimer(t:Timer) {
        if(isActive){
            throw "Timers can't be added after the group start.";
        }

        if(t.isActive){
            throw "Timers can't be active before added to a group";
        }

        timers.push(t);
    }

    public function start(inParallel:Bool = false) {
        if(isActive){
            return;
        }

        _start(inParallel);
    }

    public function stop(reset:Bool = false) {
        if(!isActive){
            return;
        }

        _stop();
    }

    public function pause() {
        if(!isActive || isPaused) {
            return;
        }

        for(t in timers){
            t.pause();
        }

        isPaused = true;
        onPause.emit();
    }

    public function resume() {
        if(!isActive || !isPaused){
            return;
        }

        for(t in timers){
            t.resume();
        }

        onResume.emit();
    }

    private function _start(inParallel:Bool) {
        isActive = true;
        _isParallelActive = inParallel;
        _unsubscribeAll = [];

        if(inParallel) {
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

    private function _onProgress(t:Timer) {
        onProgress.emit(t);
    }

    private function _timerEndCallback(t:Timer, next:?String->Void){
        function fn(){
            t.onEnd -= fn; //once
            _onProgress(t);
            next();
        }

        _unsubscribeAll.push(function(){
            t.onEnd -= fn;
        });

        t.onEnd += fn;
    }

    private function _onEnd(?err:String) {
        if(err != null){
            throw err;
        }

        if(loop || repeat > _repeat){
            _repeat++;
            _stop();
            start(_isParallelActive);
            onRepeat.emit(_repeat);
        }else{
            _stop(true);
            onEnd.emit();
        }
    }

    public function beforeDestroy(){
        var t = timers.pop();
        while(t != null){
            t.destroy();
            t = timers.pop();
        }

        onProgress.clear();
        onRepeat.clear();
        onEnd.clear();
        onPause.clear();
        onResume.clear();
    }

}
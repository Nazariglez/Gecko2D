package k2d.tween;

import k2d.utils.EventEmitter;
import k2d.utils.Chain;

class TweenGroup {
    static private inline var EVENT_PROGRESS = "progress";
    static private inline var EVENT_REPEAT = "repeat";
    static private inline var EVENT_YOYO = "yoyo";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";

    public var tweens:Array<Tween> = new Array<Tween>();
    public var yoyo:Bool = false;
    public var repeat:Int = 0;
    public var loop:Bool = false;

    private var _repeat:Int = 0;
    private var _yoyo:Bool = false;

    public var isActive:Bool = false;
    public var isPaused:Bool = false;

    private var _eventEmitter:EventEmitter = new EventEmitter();
    private var _unsubscribeAll:Array<Void->Void> = new Array<Void->Void>();

    private var _isParallelActive:Bool = false;

    public function new(?tweens:Array<Tween>){
        if(tweens != null){
            this.tweens = tweens;
        }
    }

    public function addTween(t:Tween) {
        if(isActive){
            trace("Error: tweens can't be addef after the group start.");
            return;
        }

        if(t.isActive){
            trace("Error: tweens can't be active before added to a group");
            return;
        }

        tweens.push(t);
    }

    public function start(inParallel:Bool = false) {
        if(isActive){
            return;
        }

        _start(inParallel);
    }

    private function _start(inParallel:Bool, applyYoyo:Bool = false){
        isActive = true;
        _isParallelActive = inParallel;
        _unsubscribeAll = [];

        var tweens = applyYoyo ? this.tweens.copy() : this.tweens;
        if(applyYoyo){
            tweens.reverse();
        }

        if(inParallel){
            Chain.each(tweens, _tweenEndCallback, _onEnd);
            for(t in tweens){
                t.reset();
                t.start();
            }
        }else{
            Chain.eachSeries(tweens, function(t:Tween, next:?String->Void){
                _tweenEndCallback(t, next);
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
        for(t in tweens){
            t.stop();
            t.reset();
        }

        isActive = false;
        if(reset){
            _repeat = 0;
            _yoyo = false;
        }

        for(fn in _unsubscribeAll){
            fn();
        }
    }

    public function pause() {
        if(!isActive || isPaused){
            return;
        }

        for(t in tweens){
            t.pause();
        }

        isPaused = true;

        _eventEmitter.emit(EVENT_PAUSE);
    }

    public function resume() {
        if(!isActive || !isPaused){
            return;
        }

        for(t in tweens){
            t.resume();    
        }

        isPaused = false;

        _eventEmitter.emit(EVENT_RESUME);
    }

    public function subscribeOnProgress(cb:Tween->Void, once:Bool = false){
        if(once){
            _eventEmitter.addListenerOnce(EVENT_PROGRESS, cb);
            return;
        }

        _eventEmitter.addListener(EVENT_PROGRESS, cb);
    }

    public function unsubscribeOnProgress(cb:Tween->Void){
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

    private function _tweenEndCallback(t:Tween, next:?String->Void){
        var fn = function(){
            _onProgress(t);
            next();
        }

        _unsubscribeAll.push(function(){
            t.unsubscribeOnEnd(fn);
        });

        t.subscribeOnEnd(fn, true);
    }

    private function _onProgress(tween:Tween) {
        _eventEmitter.emit(EVENT_PROGRESS, tween);
    }

    private function _onEnd(?err:String){
        if(err != null){
            trace("Error:", err);
            return;
        }

        if(yoyo && !_yoyo){
            _yoyo = true;
            _stop();
            _start(_isParallelActive, true);
            _eventEmitter.emit(EVENT_YOYO);
        }else if(loop || repeat > _repeat){
            _repeat++;
            _yoyo = false;
            _stop();
            start(_isParallelActive);
            _eventEmitter.emit(EVENT_REPEAT, _repeat);
        }else{
            _stop(true);
            _eventEmitter.emit(EVENT_END);
        }
    }

}
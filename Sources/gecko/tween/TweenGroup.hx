package gecko.tween;

import gecko.utils.Event;
import gecko.utils.EventEmitter;
import gecko.utils.Chain;

class TweenGroup {
    static private inline var EVENT_PROGRESS = "progress";
    static private inline var EVENT_REPEAT = "repeat";
    static private inline var EVENT_YOYO = "yoyo";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";

    public var onProgress:Event<Tween->Void>;
    public var onProgressOnce:Event<Tween->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onRepeatOnce:Event<Int->Void>;
    public var onYoyo:Event<Void->Void>;
    public var onYoyoOnce:Event<Void->Void>;
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
        onYoyo = _eventEmitter.bind(new Event(EVENT_YOYO));
        onYoyoOnce = _eventEmitter.bind(new Event(EVENT_YOYO, true));
        onEnd = _eventEmitter.bind(new Event(EVENT_END));
        onEndOnce = _eventEmitter.bind(new Event(EVENT_END, true));
        onPause = _eventEmitter.bind(new Event(EVENT_PAUSE));
        onPauseOnce = _eventEmitter.bind(new Event(EVENT_PAUSE, true));
        onResume = _eventEmitter.bind(new Event(EVENT_RESUME));
        onResumeOnce = _eventEmitter.bind(new Event(EVENT_RESUME, true));
    }

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
        _bindEvents();
    }

    public function addTween(t:Tween) {
        if(isActive){
            trace("Error: tweens can't be added after the group start.");
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

    private function _tweenEndCallback(t:Tween, next:?String->Void){
        var fn = function(){
            _onProgress(t);
            next();
        }

        _unsubscribeAll.push(function(){
            t.onEnd -= fn;
        });

        t.onEnd += fn;
    }

    private function _onProgress(tween:Tween) {
        _eventEmitter.emit(EVENT_PROGRESS, [tween]);
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
            _eventEmitter.emit(EVENT_REPEAT, [_repeat]);
        }else{
            _stop(true);
            _eventEmitter.emit(EVENT_END);
        }
    }

}
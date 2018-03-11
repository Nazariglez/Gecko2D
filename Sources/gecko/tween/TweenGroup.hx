package gecko.tween;

import gecko.utils.Chain;
import gecko.utils.Event;
import gecko.macros.IAutoPool;

class TweenGroup implements IAutoPool {
    public var onProgress:Event<Tween->Void>;
    public var onRepeat:Event<Int->Void>;
    public var onYoyo:Event<Void->Void>;
    public var onEnd:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onResume:Event<Void->Void>;

    public var tweens:Array<Tween> = [];
    public var yoyo:Bool = false;
    public var repeat:Int = 0;
    public var loop:Bool = false;

    private var _repeat:Int = 0;
    private var _yoyo:Bool = false;

    public var isActive(default, null):Bool = false;
    public var isPaused(default, null):Bool = false;

    private var isParallelActive(default, null):Bool = false;
    private var _unsubscribeAll:Array<Void->Void> = [];

    public function new() {
        onProgress = Event.create();
        onRepeat = Event.create();
        onYoyo = Event.create();
        onEnd = Event.create();
        onPause = Event.create();
        onResume = Event.create();
    }

    public function init(tweens:Array<Tween>) {
        this.tweens = tweens;
    }

    public function addTween(t:Tween) {
        if(isActive){
            throw "Error: tweens can't be added after the group start.";
            return;
        }

        if(t.isActive){
            throw "Error: tweens can't be active before added to a group";
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
        isParallelActive = inParallel;
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

        onPause.emit();
    }

    public function resume() {
        if(!isActive || !isPaused){
            return;
        }

        for(t in tweens){
            t.resume();
        }

        isPaused = false;

        onResume.emit();
    }

    private function _tweenEndCallback(t:Tween, next:?String->Void){
        var fn = function(){
            onProgress.emit(t);
            next();
        };

        _unsubscribeAll.push(function(){
            t.onEnd -= fn;
        });

        t.onEnd += fn;
    }

    private function _onEnd(?err:String){
        if(err != null){
            throw err;
            return;
        }

        if(yoyo && !_yoyo){
            _yoyo = true;
            _stop();
            _start(isParallelActive, true);
            onYoyo.emit();
        }else if(loop || repeat > _repeat){
            _repeat++;
            _yoyo = false;
            _stop();
            start(isParallelActive);
            onRepeat.emit(_repeat);
        }else{
            _stop(true);
            onEnd.emit();
        }
    }

    public function beforeDestroy() {
        var t = tweens.pop();
        while(t != null){
            t.destroy();
            t = tweens.pop();
        }

        var u:Void->Void;
        while((u = _unsubscribeAll.pop()) != null){}

        isActive = false;
        isPaused = false;
        isParallelActive = false;

        yoyo = false;
        repeat = 0;
        loop = false;

        _repeat = 0;
        _yoyo = false;

        onEnd.clear();
        onRepeat.clear();
        onProgress.clear();
        onPause.clear();
        onYoyo.clear();
        onResume.clear();
    }
}
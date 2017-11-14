package k2d.tween;

import k2d.utils.EventEmitter;
import k2d.utils.Chain;

class TweenGroup {
    static private inline var EVENT_PROGRESS = "progress";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";

    public var tweens:Array<Tween> = new Array<Tween>();
    public var yoyo:Bool = false;
    public var repeat:Int = 0;
    public var loop:Bool = false;

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

        isActive = true;
        _isParallelActive = inParallel;
        _unsubscribeAll = [];

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

        for(t in tweens){
            t.stop();
            t.reset();
        }

        isActive = false;

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
            t.unsubscribeOnEnd(fn);
        });

        t.subscribeOnEnd(fn, true);
    }

    private function _onProgress(tween:Tween) {
        _eventEmitter.emit(EVENT_PROGRESS, tween);
        trace("on progress");
    }

    private function _onEnd(?err:String){
        if(err != null){
            trace("Error:", err);
            return;
        }

        trace("looooooop", this.loop, loop);
        if(this.loop){
            stop();
            start(_isParallelActive);
        }else{
            _eventEmitter.emit(EVENT_END);
        }
        trace("on end");
    }

}
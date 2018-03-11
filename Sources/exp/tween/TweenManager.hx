package exp.tween;

import exp.macros.IAutoPool;
import exp.Float32;

class TweenManager implements IAutoPool {
    public var tweens:Array<Tween> = [];
    private var _tweensToDelete:Array<Tween> = [];

    public function new(){}

    public function tick() {
        for(t in tweens){
            if(!t.isActive){
                continue;
            }

            t.update(Gecko.ticker.delta);

            if(t.isEnded && t.destroyOnEnd) {
                t.destroy();
            }
        }

        if(_tweensToDelete.length > 0){
            var t = _tweensToDelete.pop();
            while(t != null){
                _remove(t);
                t = _tweensToDelete.pop();
            }
        }
    }

    inline public function createTween(target:Dynamic, valuesTo:Dynamic, time:Float32, ?easing:Ease) : Tween {
        return Tween.create(target, valuesTo, time, easing, this);
    }

    public function createGroup(tweens:Array<Tween>) : TweenGroup {
        return TweenGroup.create(tweens);
    }

    inline public function removeTween(tween:Tween) {
        _tweensToDelete.push(tween);
    }

    public function clear() {
        for(t in tweens){
            t.clear();
        }
    }

    public function cleanTweens() {
        var t:Tween = _tweensToDelete.pop();
        while(t != null){
            t.destroy();
            t = _tweensToDelete.pop();
        }

        t = tweens.pop();
        while(t != null) {
            t.destroy();
            t = tweens.pop();
        }
    }

    inline private function _remove(tween:Tween) {
        tweens.remove(tween);
    }

    public function beforeDestroy(){
        cleanTweens();
    }
}
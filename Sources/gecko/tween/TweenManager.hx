package gecko.tween;

import gecko.Float32;

class TweenManager extends BaseObject {
    public var tweens:Array<Tween> = [];
    private var _tweensToDelete:Array<Tween> = [];

    public function tick(delta:Float32) {
        for(t in tweens){
            if(!t.isActive){
                continue;
            }

            t.update(delta);

            if(t.isEnded && t.destroyOnEnd) {
                t.destroy();
            }
        }

        while(_tweensToDelete.length > 0){
            var t = _tweensToDelete.shift();
            _remove(t);
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
        while(_tweensToDelete.length > 0){
            var t = _tweensToDelete.shift();
            t.destroy();
        }

        while(tweens.length > 0){
            var t = tweens.shift();
            t.destroy();
        }
    }

    inline private function _remove(tween:Tween) {
        tweens.remove(tween);
    }

    override public function beforeDestroy(){
        super.beforeDestroy();

        cleanTweens();
    }
}
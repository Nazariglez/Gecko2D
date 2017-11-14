package k2d.tween;

import k2d.math.FastFloat;

class TweenManager {
    static public var Global:TweenManager = new TweenManager();

    public var tweens:Array<Tween> = new Array<Tween>();
    private var _toDelete:Array<Tween> = new Array<Tween>();

    private var _ms:FastFloat = 0;

    public function new(){}

    public function update(dt:FastFloat) {
        _ms = dt*1000;

        for(tween in tweens){
            if(tween.isActive){
                tween.update(dt, _ms);
                if(tween.isEnded && tween.expire){
                    tween.remove();
                }
            }
        }

        if(_toDelete.length > 0){
            for(tween in _toDelete){
                _remove(tween);
                _toDelete = new Array<Tween>();
            }
        }
    }

    public inline function createTween(target:Dynamic) : Tween {
        return new Tween(target, this);
    }

    public function addTween(tween:Tween) {
        tween.manager = this;
        tweens.push(tween);
    }

    public function removeTween(tween:Tween) {
        _toDelete.push(tween);
    }

    private function _remove(tween:Tween){
        tweens.remove(tween);
    }


}
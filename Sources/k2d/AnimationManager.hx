package k2d;

import k2d.resources.Texture;
import k2d.math.FastFloat;

class AnimationManager {
    public var sprite:Sprite;
    public var animations:Array<Animation> = [];
    
    private var _animationIndex:Int = -1;

    public function new(sprite:Sprite) {
        this.sprite = sprite;
    }

    public function addFromGrid(id:String, opts:Dynamic){
        var anim = new Animation(id);
        anim.initFromGrid(opts);
        animations.push(anim);
    }

    public function play(id:String) {
        if(animations.length == 0){
            return;
        }

        _animationIndex = _getIndexByID(id);
        animations[_animationIndex].play();
    }

    public function stop(?id:String) {
        if(id != null){
            _animationIndex = _getIndexByID(id);
            animations[_animationIndex].play();
            return;
        }

        if(_animationIndex != -1){
            animations[_animationIndex].stop();
        }
    }

    public function getByID(id:String) : Animation {
        for(anim in animations){
            if(anim.id == id){
                return anim;
            }
        }

        return null;
    }

    public function update(dt:FastFloat) {
        if(_animationIndex != -1){
            animations[_animationIndex].update(dt);
            sprite.texture = animations[_animationIndex].getCurrentTexture();
        }
    }

    private function _getIndexByID(id:String) : Int {
        for(i in 0...animations.length){
            if(animations[i].id == id){
                return i;
            }
        }
        return -1;
    }
}
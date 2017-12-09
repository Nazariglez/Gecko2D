package gecko;

import gecko.resources.Texture;
import gecko.math.FastFloat;
import gecko.Animation;

class AnimationManager {
    public var isPlaying(get, null):Bool;

    public var sprite:Sprite;
    public var animations:Array<Animation> = [];
    
    private var _animationIndex:Int = -1;
    

    public function new(sprite:Sprite) {
        this.sprite = sprite;
    }

    public function add(anim:Animation) : Animation {
        var index = _getIndexByID(anim.id);
        if(index != -1){
            animations[index] = anim;
        }else{
            animations.push(anim);
        }
        
        if(sprite.texture == null){
            sprite.texture = anim.getCurrentTexture();
        }

        return anim;
    }

    public function setTexture(anim:String, frameIndex:Int = 0) {
        var anim = getByID(anim);
        anim.frameIndex = frameIndex;
        sprite.texture = anim.getCurrentTexture();
    } 

    public function addFromGrid(id:String, opts:AnimationGridOptions) : Animation {
        var anim = new Animation(id);
        anim.initFromGrid(opts);
        return add(anim);
    }

    public function addFromFrames(id:String, opts:AnimationFramesOptions) : Animation {
        var anim = new Animation(id);
        anim.initFromFrames(opts);
        return add(anim);
    }

    public function play(?id:String) {
        if(animations.length == 0){
            return;
        }

        if(id != null){
            _animationIndex = _getIndexByID(id);
            animations[_animationIndex].play();
        }else{
            animations[(_animationIndex != -1 ? _animationIndex : 0)].play();
        }
    }

    public function stop(?id:String) {
        if(id != null){
            getByID(id).stop();
            return;
        }

        if(_animationIndex != -1){
            animations[_animationIndex].stop();
        }
    }

    public function pause(?id:String) {
        if(id != null){
            getByID(id).pause();
            return;
        }

        if(_animationIndex != -1){
            animations[_animationIndex].stop();
        }
    }

    public function resume(?id:String) {
        if(id != null){
            getByID(id).resume();
            return;
        }

        if(_animationIndex != -1){
            animations[_animationIndex].resume();
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

    function get_isPlaying() : Bool {
        return _animationIndex != -1 ? animations[_animationIndex].isPlaying : false;
    }
}
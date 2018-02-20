package exp.components.draw;

import exp.resources.Texture;

class AnimationComponent extends DrawComponent {
    public var isPlaying(default, null):Bool = false;
    public var animations:Array<AnimationData>  = [];

    private var _index:Int = -1;

    public function add(anim:AnimationData) : AnimationData {

    }

    public function play(?id:String) {

    }

    public function stop(?id:String) {

    }

    public function pause(?id:String) {

    }

    public function resume(?id:String) {

    }
}

class AnimationData {
    public var texture:Texture;
}
package exp.components.draw;

import exp.math.Rect;
import exp.Float32;
import exp.macros.IAutoPool;
import exp.resources.Texture;

using Lambda;

class AnimationComponent extends DrawComponent {
    public var isPlaying(default, null):Bool = false;
    public var animations:Array<AnimationData> = [];

    private var _texture:Texture;

    private var _index:Int = -1;

    public function init(){
        onAddedToEntity += _setTransformSize;
    }

    override public function beforeDestroy() {
        var anim = animations.pop();
        while(anim != null){
            anim.destroy();
            anim = animations.pop();
        }

        _texture = null;

        _index = -1;
        isPlaying = false;
        onAddedToEntity -= _setTransformSize;

        super.beforeDestroy();
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null && _texture != null){
            e.transform.size.set(_texture.width, _texture.height);
        }
    }

    inline public function addAnimFromGrid(id:String, time:Float32, texture:Texture, rows:Int, cols:Int, ?frames:Array<Int>, total:Int = 0, loop:Bool = false, repeat:Int = 0) : AnimationData {
        return AnimationData.createFromGrid(id, time, texture, rows, cols, frames, total, loop, repeat);
    }

    inline public function addAnimFromAssets(id:String, time:Float32, frames:Array<String>, loop:Bool = false, repeat:Int = 0) : AnimationData {
        return AnimationData.createFromAssets(id, time, frames, loop, repeat);
    }

    inline public function addAnim(id:String, time:Float32, frames:Array<Texture>, loop:Bool, repeat:Int){
        return AnimationData.create(id, time, frames, loop, repeat);
    }

    /*public function add(anim:AnimationData) {

    }*/

    public function play(?id:String) {

    }

    public function stop(?id:String) {

    }

    public function pause(?id:String) {

    }

    public function resume(?id:String) {

    }

    public function getAnim(?id:String) : AnimationData {
        //todo return current anim or anim by id
        return new AnimationData();
    }
}



class AnimationData implements IAutoPool {
    public var id:String = "";
    public var loop:Bool = false;
    public var time:Float32 = 1;

    public var frames:Array<Texture> = [];
    public var index:Int = 0;
    public var repeat:Int = 0;

    public static function createFromGrid(id:String, time:Float32, texture:Texture, rows:Int, cols:Int, ?frames:Array<Int>, total:Int = 0, loop:Bool = false, repeat:Int = 0) : AnimationData {
        var ww = texture.width/cols;
        var hh = texture.height/rows;
        var xx = texture.frame.x;
        var yy = texture.frame.y;

        var textures:Array<Texture> = [];
        for(y in 0...rows){
            for(x in 0...cols){
                textures.push(new Texture(texture.image, new Rect(xx+x*ww, yy+y*hh, ww, hh), Std.int(ww), Std.int(hh)));
            }
        }

        var _frames:Array<Texture>;
        if(total == 0 && frames == null){
            _frames = textures;
        }else if(total > 0){
            _frames = textures.slice(0, total);
        }else if(frames != null && frames.length > 0){
            _frames = [];
            for(f in frames){
                _frames.push(textures[f]);
            }
        }else{
            throw 'Animation $id: Invalid grid data';
        }

        return AnimationData.create(id, time, _frames, loop, repeat);
    }

    public static function createFromAssets(id:String, time:Float32, frames:Array<String>, loop:Bool = false, repeat:Int = 0) : AnimationData {
        var _frames = frames.map(function(str){
            var texture = Assets.textures.get(str);
            if(texture == null){
                throw 'Animation $id: Invalid texture name $str';
            }
            return texture;
        }).array();

        return AnimationData.create(id, time, _frames, loop, repeat);
    }

    public function new(){}

    public function init(id:String, time:Float32, frames:Array<Texture>, loop:Bool = false, repeat:Int = 0){
        this.id = id;
        this.time = time;
        this.frames = frames;
    }

    public function beforeDestroy() {
        id = "";
        loop = false;
        time = 1;
        frames = [];
        index = 0;
        repeat = 0;
    }

    public function destroy(){}

    private function __toPool__(){}
}
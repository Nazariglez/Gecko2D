package gecko.components.draw;

import gecko.Assets;
import gecko.Graphics;
import gecko.utils.Event;
import gecko.math.Rect;
import gecko.Float32;
import gecko.resources.Texture;

using Lambda;

class AnimationComponent extends DrawComponent {
    public var isPlaying(default, null):Bool = false;
    public var isPaused(default, null):Bool = false;
    public var animations:Array<AnimationData> = [];

    public var onPlay:Event<String->Void>;
    public var onStop:Event<String->Void>;
    public var onStart:Event<String->Void>;
    public var onEnd:Event<String->Void>;
    public var onPause:Event<String->Void>;
    public var onResume:Event<String->Void>;
    public var onLoop:Event<String->Void>;

    public var texture(get, set):Texture;
    private var _texture:Texture;

    private var _index:Int = -1;

    public function new(){
        super();
        onPlay = Event.create();
        onStop = Event.create();
        onStart = Event.create();
        onEnd = Event.create();
        onPause = Event.create();
        onResume = Event.create();
        onLoop = Event.create();
    }

    public function init(){
        onAddedToEntity += _setTransformSize;
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        var anim = animations.pop();
        while(anim != null){
            anim.destroy();
            anim = animations.pop();
        }

        _texture = null;

        _index = -1;
        isPlaying = false;
        isPaused = false;
        onAddedToEntity -= _setTransformSize;

        onPlay.clear();
        onStop.clear();
        onStart.clear();
        onEnd.clear();
        onPause.clear();
        onResume.clear();
        onLoop.clear();
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null && _texture != null){
            e.transform.size.set(_texture.width, _texture.height);
        }
    }

    inline public function addAnimFromGridAssets(name:String, time:Float32, texture:String, rows:Int, cols:Int, ?frames:Array<Int>, total:Int = 0, loop:Bool = false) : AnimationData {
        return _add(AnimationData.createFromGrid(name, time, Assets.textures.get(texture), rows, cols, frames, total, loop));
    }

    inline public function addAnimFromGrid(name:String, time:Float32, texture:Texture, rows:Int, cols:Int, ?frames:Array<Int>, total:Int = 0, loop:Bool = false) : AnimationData {
        return _add(AnimationData.createFromGrid(name, time, texture, rows, cols, frames, total, loop));
    }

    inline public function addAnimFromAssets(name:String, time:Float32, frames:Array<String>, loop:Bool = false) : AnimationData {
        return _add(AnimationData.createFromAssets(name, time, frames, loop));
    }

    inline public function addAnim(name:String, time:Float32, frames:Array<Texture>, loop:Bool){
        return _add(AnimationData.create(name, time, frames, loop));
    }

    private function _add(anim:AnimationData) : AnimationData {
        animations.push(anim);
        return anim;
    }

    private function _getIndexByName(name:String):Int {
        for(i in 0...animations.length){
            if(animations[i].name == name){
                return i;
            }
        }
        return -1;
    }

    public function setTextureFrame(id:String, frame:Int = 0){
        var anim:AnimationData = animations[_getIndexByName(id)];
        anim.index = frame;
        texture = anim.getCurrentTexture();
    }

    public function play(?name:String, loop:Bool = false, resetFrameIndex:Bool = false) {
        if(animations.length == 0){
            return;
        }

        isPlaying = true;

        if(name != null){
            _index = _getIndexByName(name);
        }else if(_index == -1){
            _index = 0;
        }

        var anim:AnimationData = animations[_index];
        anim.reset(resetFrameIndex);
        anim.loop = loop;

        texture = anim.getCurrentTexture();

        onPlay.emit(name);
    }

    public function stop() {
        if(!isPlaying){
            return;
        }

        isPlaying = false;

        onStop.emit(animations[_index].name);
    }

    public function pause() {
        if(!isPlaying || isPaused){
            return;
        }

        isPaused = true;

        onPause.emit(animations[_index].name);
    }

    public function resume() {
        if(!isPlaying || !isPaused){
            return;
        }

        isPaused = false;

        onResume.emit(animations[_index].name);
    }

    public function getAnimName() : String {
        return _index != -1 ? animations[_index].name : "";
    }

    override public function update(dt:Float32) {
        if(!isPlaying || isPaused || _texture == null || _index == -1 || animations.length == 0){
            return;
        }

        var anim:AnimationData = animations[_index];
        if(!anim.isStarted){
            anim.isStarted = true;
            onStart.emit(anim.name);
        }

        anim.elapsedTime += dt; //use raw delta? (Time.delta)
        if(anim.elapsedTime >= anim.time){
            anim.elapsedTime = 0;

            if(!anim.loop){
                anim.index = 0;
                isPlaying = false;
                anim.isStarted = false;
                onEnd.emit(anim.name);
                return;
            }else{
                onLoop.emit(anim.name);
            }
        }

        var index = Math.floor((anim.elapsedTime*anim.frames.length) / anim.time);
        if(index != anim.index){
            anim.index = index;
            texture = anim.getCurrentTexture();
        }

    }

    override public function draw(g:Graphics) {
        if(_texture == null)return;
        g.drawTexture(_texture, 0, 0);
    }

    function set_texture(value:Texture):Texture {
        if(value == _texture)return _texture;
        _texture = value;

        if(_texture != null && entity != null && entity.transform != null){
            entity.transform.size.set(_texture.width, _texture.height);
        }

        return _texture;
    }

    inline function get_texture():Texture {
        return _texture;
    }
}



class AnimationData extends BaseObject {
    public var name:String = "";
    public var loop:Bool = false;
    public var time:Float32 = 1;

    public var frames:Array<Texture> = [];
    public var index:Int = 0;

    public var isStarted:Bool = false;
    public var elapsedTime:Float32 = 0;

    public static function createFromGrid(name:String, time:Float32, texture:Texture, rows:Int, cols:Int, ?frames:Array<Int>, total:Int = 0, loop:Bool = false) : AnimationData {
        var ww = texture.width/cols;
        var hh = texture.height/rows;
        var xx = texture.frame.x;
        var yy = texture.frame.y;

        var textures:Array<Texture> = [];
        for(y in 0...rows){
            for(x in 0...cols){
                textures.push(new Texture(texture.image, Rect.create(xx+x*ww, yy+y*hh, ww, hh), Std.int(ww), Std.int(hh)));
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
            throw 'Animation $name: Invalid grid data';
        }

        return AnimationData.create(name, time, _frames, loop);
    }

    public static function createFromAssets(name:String, time:Float32, frames:Array<String>, loop:Bool = false) : AnimationData {
        var _frames = frames.map(function(str){
            var texture = Assets.textures.get(str);
            if(texture == null){
                throw 'Animation $name: Invalid texture name $str';
            }
            return texture;
        }).array();

        return AnimationData.create(name, time, _frames, loop);
    }

    public function init(name:String, time:Float32, frames:Array<Texture>, loop:Bool = false){
        this.name = name;
        this.time = time;
        this.frames = frames;
    }

    public function reset(resetIndex:Bool = false) {
        isStarted = false;
        elapsedTime = 0;
        if(resetIndex){
            index = 0;
        }
    }

    inline public function getCurrentTexture() : Texture {
        return frames[index];
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        name = "";
        loop = false;
        time = 1;
        frames = [];
        index = 0;
        isStarted = false;
        elapsedTime = 0;
    }
}
package k2d;

import k2d.resources.Texture;
import k2d.math.FastFloat;
import k2d.math.Rect;
import k2d.Assets;

typedef AnimationGridOptions = {
    var rows:Int;
    var cols:Int;
    var time:FastFloat;
    var texture:String;
    @:optional var loop:Bool;
    @:optional var total:Null<Int>; //total frames ex: 4x4, total=10. Use just the first 10 frames
    @:optional var frames:Array<Int>; //set the frames manually [0,1,2,3,4]
};

typedef AnimationFramesOptions = {
    var time:FastFloat;
    var frames:Array<String>;
    @:optional var loop:Bool;
};

class Animation {
    public var id:String;
    public var isPlaying:Bool = false;
    public var isPaused:Bool = false;

    public var time:FastFloat = 1;
    public var loop:Bool = false;
    public var frameIndex:Int = 0;

    private var _isGrid:Bool = false;
    private var _frames:Array<Texture>;
    private var _elapsedTime:FastFloat = 0;
    private var _repeat:Int = 0;

    public function new(id:String) {
        this.id = id;
    }

    public function getCurrentTexture() : Texture {
        return _frames[frameIndex];
    }

    public function initFromGrid(opts:AnimationGridOptions) {
        _isGrid = true;
        time = opts.time;
        loop = opts.loop != null ? opts.loop : false;

        var texture = Assets.textures[opts.texture];
        var ww = texture.width/opts.cols;
        var hh = texture.height/opts.rows;
        var xx = texture.frame.x;
        var yy = texture.frame.y;

        var textures:Array<Texture> = [];
        for(y in 0...opts.rows){
            for(x in 0...opts.cols){
                textures.push(new Texture(texture.image, new Rect(xx+x*ww, yy+y*hh, ww, hh), Std.int(ww), Std.int(hh)));
            }
        }

        if(opts.total == null && opts.frames == null){
            _frames = textures;
            return;
        }

        if(opts.total != null && opts.total > 0){
            _frames = textures.slice(0, opts.total);
            return;
        }

        if(opts.frames != null && opts.frames.length > 0){
            _frames = [];
            for(f in opts.frames){
                _frames.push(textures[f]);
            }
            return;
        }

        trace("Error: Invalid frame grid."); //todo set a better log
    }

    public function update(dt:FastFloat) {
        if(!isPlaying || _frames.length == 0){
            return;
        }

        _elapsedTime += dt*1000;
        if(_elapsedTime >= time){
            _elapsedTime = 0;
            if(!loop){
                frameIndex = 0;
                stop();
                return;
            }else{
                _repeat++;
            }
        }

        var index = Math.floor((_elapsedTime*_frames.length) / time);
        if(index != frameIndex){
            frameIndex = index;
        }
    }

    public function initFromFrames(opts:AnimationFramesOptions) { 
        
    }

    public function play() {
        isPlaying = true;
    }

    public function stop() {
        isPlaying = false;
    }


}
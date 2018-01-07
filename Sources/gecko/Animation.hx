package gecko;

import gecko.utils.Event;
import gecko.utils.EventEmitter;
import gecko.resources.Texture;
import gecko.math.FastFloat;
import gecko.math.Rect;
import gecko.Assets;

class Animation {
    static private inline var EVENT_PLAY = "play";
    static private inline var EVENT_STOP = "stop";
    static private inline var EVENT_START = "start";
    static private inline var EVENT_END = "end";
    static private inline var EVENT_REPEAT = "repeat";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume";

    public var onPlay:Event<Animation->Void>;
    public var onPlayOnce:Event<Animation->Void>;
    public var onStop:Event<Animation->Void>;
    public var onStopOnce:Event<Animation->Void>;
    public var onStart:Event<Animation->Void>;
    public var onStartOnce:Event<Animation->Void>;
    public var onEnd:Event<Animation->Void>;
    public var onEndOnce:Event<Animation->Void>;
    public var onRepeat:Event<Animation->Int->Void>;
    public var onRepeatOnce:Event<Animation->Int->Void>;
    public var onPause:Event<Animation->Void>;
    public var onPauseOnce:Event<Animation->Void>;
    public var onResume:Event<Animation->Void>;
    public var onResumeOnce:Event<Animation->Void>;

    private function _bindEvents() {
        onPlay = _eventEmitter.bind(new Event(EVENT_PLAY));
        onPlayOnce = _eventEmitter.bind(new Event(EVENT_PLAY, true));
        onStop = _eventEmitter.bind(new Event(EVENT_STOP));
        onStopOnce = _eventEmitter.bind(new Event(EVENT_STOP, true));
        onStart = _eventEmitter.bind(new Event(EVENT_START));
        onStartOnce = _eventEmitter.bind(new Event(EVENT_START, true));
        onEnd = _eventEmitter.bind(new Event(EVENT_END));
        onEndOnce = _eventEmitter.bind(new Event(EVENT_END, true));
        onRepeat = _eventEmitter.bind(new Event(EVENT_REPEAT));
        onRepeatOnce = _eventEmitter.bind(new Event(EVENT_REPEAT, true));
        onPause = _eventEmitter.bind(new Event(EVENT_PAUSE));
        onPauseOnce = _eventEmitter.bind(new Event(EVENT_PAUSE, true));
        onResume = _eventEmitter.bind(new Event(EVENT_RESUME));
        onResumeOnce = _eventEmitter.bind(new Event(EVENT_RESUME, true));
    }

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
    private var _isStarted:Bool = false;

    private var _eventEmitter:EventEmitter = new EventEmitter();

    public function new(id:String) {
        this.id = id;
        _bindEvents();
    }

    public function getTexture(index:Int) : Texture {
        return _frames[index];
    }

    public function getCurrentTexture() : Texture {
        return _frames[frameIndex];
    }

    public function initFromFrames(opts:AnimationFramesOptions) { 
        _isGrid = false;
        time = opts.time;
        loop = opts.loop != null ? opts.loop : false;

        var textures:Array<Texture> = [];
        for(t in opts.frames){
            if(!Assets.textures.exists(t)){
                trace('Error: Invalid texture name $t');
            }

            textures.push(Assets.textures[t]);
        }

        _frames = textures;
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
        if(!isPlaying || isPaused || _frames.length == 0){
            return;
        }

        if(!_isStarted){
            _isStarted = true;
            _eventEmitter.emit(EVENT_START, [this]);
        }

        _elapsedTime += dt;
        if(_elapsedTime >= time){
            _elapsedTime = 0;
            if(!loop){
                frameIndex = 0;
                isPlaying = false;
                _isStarted = false;
                _eventEmitter.emit(EVENT_END, [this]);
                return;
            }else{
                _repeat++;
                _eventEmitter.emit(EVENT_REPEAT, [this, _repeat]);
            }
        }

        var index = Math.floor((_elapsedTime*_frames.length) / time);
        if(index != frameIndex){
            frameIndex = index;
        }
    }

    public function play() {
        if(isPlaying){
            return;
        }

        isPlaying = true;
        _eventEmitter.emit(EVENT_PLAY, [this]);
    }

    public function stop() {
        if(!isPlaying){
            return;
        }

        isPlaying = false;
        _eventEmitter.emit(EVENT_STOP, [this]);
    }

    public function pause() {
        if(isPaused){
            return;
        }

        isPaused = true;
        _eventEmitter.emit(EVENT_PAUSE, [this]);
    }

    public function resume() {
        if(!isPaused){
            return;
        }

        isPaused = false;
        _eventEmitter.emit(EVENT_RESUME, [this]);
    }

}
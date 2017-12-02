package k2d;

import k2d.resources.Sound;
import k2d.utils.EventEmitter;
import k2d.utils.Event;
import kha.audio1.AudioChannel;
import kha.audio1.Audio in KAudio;

class Audio {
    static private inline var EVENT_FINISH = "finish";
    static private inline var EVENT_PLAY = "play";
    static private inline var EVENT_STOP = "stop";
    static private inline var EVENT_PAUSE = "pause";
    static private inline var EVENT_RESUME = "resume"; 

    public var onFinish:Event<Void->Void>;
    public var onFinishOnce:Event<Void->Void>;
    public var onPlay:Event<Void->Void>;
    public var onPlayOnce:Event<Void->Void>;
    public var onStop:Event<Void->Void>;
    public var onStopOnce:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onPauseOnce:Event<Void->Void>;
    public var onResume:Event<Void->Void>;
    public var onResumeOnce:Event<Void->Void>;

    private function _bindEvents() {
        onFinish = _eventEmitter.bind(new Event(EVENT_FINISH));
        onFinishOnce = _eventEmitter.bind(new Event(EVENT_FINISH, true));
        onPlay = _eventEmitter.bind(new Event(EVENT_PLAY));
        onPlayOnce = _eventEmitter.bind(new Event(EVENT_PLAY, true));
        onStop = _eventEmitter.bind(new Event(EVENT_STOP));
        onStopOnce = _eventEmitter.bind(new Event(EVENT_STOP, true));
        onPause = _eventEmitter.bind(new Event(EVENT_PAUSE));
        onPauseOnce = _eventEmitter.bind(new Event(EVENT_PAUSE, true));
        onResume = _eventEmitter.bind(new Event(EVENT_RESUME));
        onResumeOnce = _eventEmitter.bind(new Event(EVENT_RESUME, true));

    }

    public var sound(get, set):Sound;
    private var _sound:Sound;

    public var soundName(get, set):String;
    private var _soundName:String = "";

    private var _channel:AudioChannel;
    private var _lastLoop:Bool = false;

    public var isPlaying(get, null):Bool;
    private var _isPlaying:Bool = false;

    public var isPaused(get, null):Bool;
    private var _isPaused:Bool = false;

    public var position(get, null):Float;
    public var length(get, null):Float;

    public var volume(get, set):Float;
    private var _volume:Float = 1;

    private var _eventEmitter:EventEmitter = new EventEmitter();

    static public function fromSound(snd:Sound) : Audio {
        var a = new Audio();
        a.sound = snd;
        return a;
    }

    public function new(?sndName:String) {
        if(sndName != null){
            this.soundName = sndName;
        }

        _bindEvents();
    }


    //todo change state to stopped on stop (thanks captain obvius)

    public function play(loop:Bool = false) {
        if(_isPlaying){
            return;
        }

        if(_channel != null && loop == _lastLoop){
            _channel.play();
        }else{
            _channel = KAudio.play(sound, loop);
        }

        _channel.volume = _volume;
        _lastLoop = loop;
        _isPlaying = true;

        System.subscribeOnSystemUpdate(update);
        _eventEmitter.emit(EVENT_PLAY);
    }

    public function stop() {
        if(!_isPlaying){
            return;
        }

        _channel.stop();
        _isPlaying = false;

        System.unsubscribeOnSystemUpdate(update);
        _eventEmitter.emit(EVENT_STOP);
    }

    public function pause() {
        if(!_isPlaying && _isPaused){
            return;
        }

        _channel.pause();
        _isPaused = true;
        System.unsubscribeOnSystemUpdate(update);
        _eventEmitter.emit(EVENT_PAUSE);
    }

    public function resume() {
        if(!_isPlaying || !_isPaused){
            return;
        }

        _channel.play();
        _isPaused = false;
        System.subscribeOnSystemUpdate(update);
        _eventEmitter.emit(EVENT_RESUME);
    }

    private function _finish() {
        _channel.stop();
        _isPlaying = false;

        System.unsubscribeOnSystemUpdate(update);
        _eventEmitter.emit(EVENT_FINISH);
    }

    public function update() {
        if(_isPlaying && _channel.finished){
            _finish();
        }
    }

    public inline function copy() : Audio {
        if(soundName != null){
            return new Audio(soundName);
        }

        return Audio.fromSound(sound);
    }

    function get_soundName() : String {
        return _soundName;
    }

    function set_soundName(name:String) : String {
        if(!Assets.sounds.exists(name)){
            throw new k2d.Error('Sound $name not loaded...'); //todo better use log than error?
            return "";
        }

        this.sound = Assets.sounds[name];
        return this._soundName = name;
    }

    function get_sound() : Sound {
		return _sound;
	}

	function set_sound(snd:Sound) : Sound {
        _channel = KAudio.play(snd); //init channel
        _channel.stop();

		return _sound = snd;
	}

    function get_isPlaying() : Bool {
        return _isPlaying;
    }

    function get_isPaused() : Bool {
        return _isPaused;
    }

    function get_position() : Float {
        if(_channel != null){
            return _channel.position;
        }

        return 0;
    }

    function get_length() : Float {
        if(_channel != null){
            return _channel.length;
        }

        return 0;
    }

    function get_volume() : Float {
        return _volume;
    }

    function set_volume(v:Float) : Float {
        if(_channel != null){
            _channel.volume = v;
        }

        return _volume = v;
    }
}

//todo add a audiolist to chain audios
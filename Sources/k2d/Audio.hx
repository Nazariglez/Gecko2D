package k2d;

import k2d.resources.Sound;
import kha.audio1.AudioChannel;
import kha.audio1.Audio in KAudio;

class Audio {
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

    static public function fromSound(snd:Sound) : Audio {
        var a = new Audio();
        a.sound = snd;
        return a;
    }

    public function new(?sndName:String) {
        if(sndName != null){
            this.soundName = sndName;
        }
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

        _lastLoop = loop;
        _isPlaying = true;
    }

    public function stop() {
        if(!_isPlaying){
            return;
        }

        _channel.stop();
        _isPlaying = false;
    }

    public function pause() {
        if(!_isPlaying && _isPaused){
            return;
        }

        _channel.pause();
        _isPaused = true;
    }

    public function unpause() {
        if(!_isPlaying || !_isPaused){
            return;
        }

        _channel.play();
        _isPaused = false;
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
		return _sound = snd;
	}

    function get_isPlaying() : Bool {
        return _isPlaying;
    }

    function get_isPaused() : Bool {
        return _isPaused;
    }
}

//todo add a audiolist to chain audios
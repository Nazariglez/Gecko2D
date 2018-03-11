package exp;

import exp.macros.IAutoPool;
import exp.resources.Sound;
import exp.utils.Event;
import kha.audio1.AudioChannel;
import kha.audio1.Audio in KAudio;

class Audio implements IAutoPool {
    public var onFinish:Event<Void->Void>;
    public var onPlay:Event<Void->Void>;
    public var onStop:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onResume:Event<Void->Void>;

    public var sound(get, set):Sound;
    private var _sound:Sound;

    public var soundName(get, set):String;
    private var _soundName:String = "";

    public var isPlaying(default, null):Bool = false;
    public var isPaused(default, null):Bool = false;

    public var position(get, null):Float32;
    public var length(get, null):Float32;

    public var volume(get, set):Float32;
    private var _volume:Float32 = 1;

    private var _channel:AudioChannel;
    private var _lastLoop:Bool = false;

    public var destroyOnEnd:Bool = false;

    public function new(){
        onFinish = Event.create();
        onPlay = Event.create();
        onStop = Event.create();
        onPause = Event.create();
        onResume = Event.create();
    }

    static public function createFromSound(sound:Sound) : Audio {
        var a = new Audio();
        a.sound = sound;
        return a;
    }

    public function init(sound:String) {
        soundName = sound;
    }

    public function play(loop:Bool = false) {
        if(isPlaying){
            return;
        }

        if(_channel != null && loop == _lastLoop){
            _channel.play();
        }else{
            _channel = KAudio.play(sound, loop);
        }

        _channel.volume = _volume;
        _lastLoop = loop;
        isPlaying = true;

        Gecko.onSystemUpdate += update;
        onPlay.emit();
    }

    public function stop() {
        if(isPlaying) {
            return;
        }

        _channel.stop();
        isPlaying = false;

        Gecko.onSystemUpdate -= update;
        onStop.emit();
    }

    public function pause() {
        if(!isPlaying && isPaused) {
            return;
        }

        _channel.pause();
        isPaused = true;
        Gecko.onSystemUpdate -= update;
        onPause.emit();
    }

    public function resume() {
        if(isPlaying || !isPaused){
            return;
        }

        _channel.play();
        isPaused = false;
        Gecko.onSystemUpdate += update;
        onResume.emit();
    }

    public function update(dt:Float32) {
        if(isPlaying && _channel.finished){
            _finish();
        }
    }

    private function _finish() {
        _channel.stop();
        isPlaying = false;
        Gecko.onSystemUpdate -= update;
        onFinish.emit();

        if(destroyOnEnd){
            destroy();
        }
    }

    inline public function clone() : Audio {
        return soundName != null ? Audio.create(soundName) : Audio.createFromSound(sound);
    }

    public function beforeDestroy() {
        isPlaying = false;
        isPaused = false;

        onFinish.clear();
        onPlay.clear();
        onStop.clear();
        onPause.clear();
        onResume.clear();

        _channel = null;
        _lastLoop = false;

        destroyOnEnd = false;

        _soundName = "";
        _sound = null;

        _volume = 1;
    }

    inline function get_soundName() : String {
        return _soundName;
    }

    function set_soundName(value:String) : String {
        if(value == _soundName)return _soundName;

        var snd = Assets.sounds.get(value);
        if(snd == null){
            throw 'Sound $value not found...';
        }

        sound = snd;
        return _soundName = value;
    }

    inline function get_sound() : Sound {
        return _sound;
    }

    function set_sound(snd:Sound) : Sound {
        _channel = KAudio.play(snd);
        _channel.stop();

        return _sound = snd;
    }

    inline function get_position():Float32 {
        return _channel != null ? _channel.position : 0;
    }

    inline function get_length():Float32 {
        return _channel != null ? _channel.length : 0;
    }

    inline function get_volume() : Float32 {
        return _volume;
    }

    function set_volume(value:Float32) : Float32 {
        if(value == _volume)return _volume;
        return _channel != null ? (_channel.volume = value) : (_volume = value);
    }
}


/*class Audio implements IAutoPool {
    public var onFinish:Event<Void->Void>;
    public var onPlay:Event<Void->Void>;
    public var onStop:Event<Void->Void>;
    public var onPause:Event<Void->Void>;
    public var onResume:Event<Void->Void>;

    public var sound(get, set):Sound;
    private var _sound:Sound;

    public var soundName(get, set):String;
    private var _soundName:String = "";

    public var isPlaying(default, null):Bool = false;
    public var isPaused(default, null):Bool = false;

    public var position(get, null):Float32;
    public var length(get, null):Float32;

    public var volume(get, set):Float32;
    private var _volume:Float32 = 1;

    private var _channel:AudioChannel;
    private var _lastLoop:Bool = false;

    public var destroyOnEnd:Bool = false;

    public function new(){
        onFinish = Event.create();
        onPlay = Event.create();
        onStop = Event.create();
        onPause = Event.create();
        onResume = Event.create();
    }

    static public function createFromSound(sound:Sound) : Audio {
        var a = new Audio();
        a.sound = sound;
        return a;
    }

    public function init(sound:String) {
        soundName = sound;
    }

    public function play(loop:Bool = false) {
        if(isPlaying){
            return;
        }

        if(_channel != null && loop == _lastLoop){
            _channel.play();
        }else{
            _channel = KAudio.play(sound, loop);
        }

        _channel.volume = _volume;
        _lastLoop = loop;
        isPlaying = true;

        Gecko.onSystemUpdate += tick;
        onPlay.emit();
    }

    public function stop() {
        if(isPlaying) {
            return;
        }

        _channel.stop();
        isPlaying = false;

        Gecko.onSystemUpdate -= tick;
        onStop.emit();
    }

    public function pause() {
        if(!isPlaying && isPaused) {
            return;
        }

        _channel.pause();
        isPaused = true;
        Gecko.onSystemUpdate -= tick;
        onPause.emit();
    }

    public function resume() {
        if(isPlaying || !isPaused){
            return;
        }

        _channel.play();
        isPaused = false;
        Gecko.onSystemUpdate += tick;
        onResume.emit();
    }

    private function _finish() {
        _channel.stop();
        isPlaying = false;
        Gecko.onSystemUpdate -= tick;
        onFinish.emit();

        if(destroyOnEnd){
            destroy();
        }
    }

    public function tick() {
        if(isPlaying && _channel.finished){
            _finish();
        }
    }

    inline public function clone() : Audio {
        return soundName != null ? Audio.create(soundName) : Audio.createFromSound(sound);
    }

    public function beforeDestroy() {
        isPlaying = false;
        isPaused = false;

        onFinish.clear();
        onPlay.clear();
        onStop.clear();
        onPause.clear();
        onResume.clear();

        _channel = null;
        _lastLoop = false;

        destroyOnEnd = false;

        _soundName = "";
        _sound = null;

        _volume = 1;
    }

    inline function get_soundName() : String {
        return _soundName;
    }

    function set_soundName(value:String) : String {
        if(value == _soundName)return _soundName;

        var snd = Assets.sounds.get(value);
        if(snd == null){
            throw 'Sound $name not found...';
        }

        sound = snd;
        return _soundName = value;
    }

    inline function get_sound() : Sound {
        return _sound;
    }

    function set_sound(snd:Sound) : Sound {
        _channel = KAudio.play(snd);
        _channel.stop();

        return _sound = snd;
    }

    inline function get_position():Float32 {
        return _channel != null ? _channel.position : 0;
    }

    inline function get_length():Float32 {
        return _channel != null ? _channel.length : 0;
    }

    inline function get_volume() : Float32 {
        return _volume;
    }

    function set_volume(value:Float32) : Float32 {
        if(value == _volume)return _volume;
        return _channel != null ? (_channel.volume = value) : (_volume = value);
    }
}*/
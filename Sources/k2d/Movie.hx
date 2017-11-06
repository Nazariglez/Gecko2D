package k2d;

import k2d.resources.Video;
import k2d.render.Renderer2D;

class Movie extends Entity {
    static public var playing:Array<Movie> = new Array<Movie>();

    public var video(get, set):Video;
    private var _video:Video;

    public var videoName(get, set):String;
    private var _videoName:String = "";

    public var isPlaying(get, null):Bool;
    private var _isPlaying:Bool = false;

    public var isPaused(get, null):Bool;
    private var _isPaused:Bool = false;

    private var _loop:Bool = false;

    public var volume(get, set):Float;
    function get_volume() : Float {
        return video.getVolume();
    }

    function set_volume(v:Float) : Float {
        video.setVolume(v);
        return v;
    }

    public var time(get, set):Int;
    function get_time() : Int {
        return video.position;
    }

    function set_time(v:Int) : Int {
        return video.position = v;
    }

    public var isFinished(get, null):Bool;
    function get_isFinished() : Bool {
        return video.isFinished();
    }

    public var length(get, null):Int;
    function get_length() : Int {
        return video.getLength();
    }

    static public function stopAll() {
        for(mov in Movie.playing){
            mov.stop();
        }
    }

    static public function pauseAll() {
        for(mov in Movie.playing){
            mov.pause();
        }
    }

    static public function unpauseAll() {
        for(mov in Movie.playing){
            mov.resume();
        }
    }

    //todo check audio in osx
    //todo add controller as playAt(position)
    //todo add conttoller as stopAt(position)

    static public function fromVideo(vid:Video) : Movie {
        var m = new Movie();
        m.video = vid;
        return m;
    }

    public override function new(?vidName:String){
        super();
        if(vidName != null){
            this.videoName = vidName;
        }
    }

    //todo use the update to reproduce the video, not the render loop, because the render loop never stops

    public override function render(r:Renderer2D) {
        super.render(r);
        if(video != null){
            r.drawVideo(video, 0, 0, video.width(), video.height());
        }
    }

    public function play(loop:Bool = false) {
        if(_isPlaying){ 
            return; 
        }

        _isPlaying = true;
        _loop = loop;

        video.play(loop);
        
        //Movie.playing.push(this);
        //TODO: wtf this ^ make osx crash when the r.drawVideo is called
    }

    public function pause() {
        if(!_isPlaying){
            return;
        }

        _isPaused = true;
        video.pause();
    }

    public function resume() {
        if(!_isPlaying){
            return;
        }

        _isPaused = false;
        video.play(_loop);
    }

    public function stop() {
        if(!_isPlaying){
            return;
        }

        _isPaused = false;
        _isPlaying = false;

        video.stop();
        //Movie.playing.remove(this);
    }

    function get_videoName() : String {
        return _videoName;
    }

    function set_videoName(name:String) : String {
        if(!Assets.videos.exists(name)){
            throw new k2d.Error('Video $name not loaded...'); //todo better use log than error?
            return "";
        }

        this.video = Assets.videos[name];
        return this._videoName = name;
    }

    function get_video() : Video {
        return _video;
    }

    function set_video(vid:Video) : Video {
        if(vid != null){
            size.set(vid.width(), vid.height());
        }
        return _video = vid;
    }

    function get_isPlaying() : Bool {
        return _isPlaying;
    }

    function get_isPaused() : Bool {
        return _isPaused;
    }


}
package k2d;

import k2d.resources.Video;
import k2d.render.Renderer2D;

class Movie extends Actor {
    public var video(get, set):Video;
    private var _video:Video;

    public var videoName(get, set):String;
    private var _videoName:String = "";

    //todo add controllers, play, stop, loop, pause, speed, etc...

    static public function fromImage(vid:Video) : Movie {
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

    public override function render(r:Renderer2D) {
        super.render(r);
        if(video != null){
            r.drawVideo(video, -size.x*0.5, -size.y*0.5, video.width(), video.height());
        }
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
}
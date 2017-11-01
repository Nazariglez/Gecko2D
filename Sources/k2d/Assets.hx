package k2d;

import haxe.io.Path;
import k2d.Image;
import k2d.Video;
import k2d.Blob;
import k2d.Sound;
import k2d.Font;

class Assets {
    static public var images:Map<String, Image> = new Map<String, Image>();
    static public var videos:Map<String, Video> = new Map<String, Video>();
    static public var blobs:Map<String, Blob> = new Map<String, Blob>();
    static public var sounds:Map<String, Sound> = new Map<String, Sound>();
    static public var fonts:Map<String, Font> = new Map<String, Font>();
    //todo parse json, and toml

    //todo compare in compilation time with macros the load and unload params with kha.Assets.*.names to check if exists
    static private function _parseAssetName(name:String) : String {
        return (~/[\/\.]/gi).replace(Path.normalize(Path.withoutExtension(name)), "_");
    }

    static public function load(arr:Array<String>, done:?String->Void){
        Async.each(arr, Assets._loadAsset, done);
    }

    static private function _loadAsset(name:String, next:?String->Void) {
        var ext = Path.extension(name);
        //check images
        switch ext {
            case e if (Assets.imageFormats.indexOf(e) >= 0):
                Assets.loadImage(name, next);
            case e if (Assets.videoFormats.indexOf(e) >= 0):
                Assets.loadVideo(name, next);
            case e if (Assets.fontFormats.indexOf(e) >= 0):
                Assets.loadFont(name, next);
            case e if (Assets.soundFormats.indexOf(e) >= 0):
                Assets.loadSound(name, next);
            default:
                Assets.loadBlob(name, next);
        }

        //todo admit to extend with new extensions and parsers (maybe with macros to make the asset list?)
        //todo maybe add a "addParser(ext[], loadCb, unloadCb)" and find un "custom" or something similar
    }

    static public function loadImage(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        kha.Assets.loadImage(parsedName, function(img:Image){
            Assets.images[name] = img;
            done();
        });
    }

    static public function loadVideo(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        kha.Assets.loadVideo(parsedName, function(vid:Video){
            Assets.videos[name] = vid;
            done();
        });
    }

    static public function loadBlob(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        kha.Assets.loadBlob(parsedName, function(blob:Blob){
            Assets.blobs[name] = blob;
            done();
        });
    }

    static public function loadSound(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        kha.Assets.loadSound(parsedName, function(sound:Sound){
            Assets.sounds[name] = sound;
            done();
        });
    }

    static public function loadFont(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        kha.Assets.loadFont(parsedName, function(fnt:Font){
            Assets.fonts[name] = fnt;
            done();
        });
    }

    static public function unload(arr:Array<String>, done:?String->Void){
        Async.each(arr, _unloadAsset, done);
    }
    
    static private function _unloadAsset(name:String, next:?String->Void) {
        var ext = Path.extension(name);
        //check images
        switch ext {
            case e if (Assets.imageFormats.indexOf(e) >= 0):
                Assets.unloadImage(name, next);
            case e if (Assets.videoFormats.indexOf(e) >= 0):
                Assets.unloadVideo(name, next);
            case e if (Assets.fontFormats.indexOf(e) >= 0):
                Assets.unloadFont(name, next);
            case e if (Assets.soundFormats.indexOf(e) >= 0):
                Assets.unloadSound(name, next);
            default:
                Assets.unloadBlob(name, next);
        }
    }

    static public function unloadImage(name:String, done:?String->Void){
        Assets.images[name].unload();
        Assets.images.remove(name);
        done();
    }

    static public function unloadVideo(name:String, done:?String->Void){
        Assets.videos[name].unload();
        Assets.videos.remove(name);
        done();
    }

    static public function unloadFont(name:String, done:?String->Void){
        Assets.fonts[name].unload();
        Assets.fonts.remove(name);
        done();
    }

    static public function unloadSound(name:String, done:?String->Void){
        Assets.sounds[name].unload();
        Assets.sounds.remove(name);
        done();
    }

    static public function unloadBlob(name:String, done:?String->Void){
        Assets.blobs[name].unload();
        Assets.blobs.remove(name);
        done();
    }

    static public var imageFormats(get, null):Array<String>;
    static private function get_imageFormats() : Array<String> {
        return kha.Assets.imageFormats;
    }

    static public var videoFormats(get, null):Array<String>;
    static private function get_videoFormats() : Array<String> {
        return kha.Assets.videoFormats;
    }

    static public var soundFormats(get, null):Array<String>;
    static private function get_soundFormats() : Array<String> {
        return kha.Assets.soundFormats;
    }

    static public var fontFormats(get, null):Array<String>;
    static private function get_fontFormats() : Array<String> {
        return kha.Assets.fontFormats;
    }

    //todo add a wrapper to load from web with xhr
}
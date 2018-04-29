package gecko;

import gecko.resources.Blob;
import gecko.resources.Font;
import gecko.resources.Image;
import gecko.resources.Sound;
import gecko.resources.Texture;
import gecko.resources.Video;
import gecko.utils.Chain;
import gecko.utils.Event;
import haxe.io.Path;

class Assets {

    static public var images:Map<String, Image> = new Map<String, Image>();
    static public var videos:Map<String, Video> = new Map<String, Video>();
    static public var blobs:Map<String, Blob> = new Map<String, Blob>();
    static public var sounds:Map<String, Sound> = new Map<String, Sound>();
    static public var fonts:Map<String, Font> = new Map<String, Font>();
    static public var textures:Map<String, Texture> = new Map<String, Texture>();
    static public var json:Map<String, Dynamic> = new Map<String, Dynamic>();
    //todo parse json, and toml

    static private var _imageExtensions = ["hdr", "jpg", "png"];
    static private var _soundExtensions = ["wav"];
    static private var _fontExtensions = ["ttf"];
    static private var _videoExtensions = ["mp4"];

    //todo compare in compilation time with macros the load and unload params with kha.Assets.*.names to check if exists
    static private function _parseAssetName(name:String, ext:Bool = false) : String {
        name = ext ? name : Path.withoutExtension(name);
        name = Std.parseInt(name.charAt(0)) != null ? "_" + name : name;
        return (~/[\/\.-\s]/gi).replace(Path.normalize(name), "_");
    }

    static inline private function _existsAssetsName(name:String, type:String) : Bool {
        return Reflect.field(kha.Assets, type).names.indexOf(name) != -1;
    }

    static public function load(arr:Array<String>, ?onComplete:Void->Void, ?onError:String->Void) : Assets {
        var loader = new Assets(arr.length);

        if(onComplete != null){
            loader.onComplete += onComplete;
        }

        if(onError != null){
            loader.onError += onError;
        }

        loader.setTask(function(){
            Chain.eachSeries(arr, loader.observProgress(Assets._loadAsset), function(?err:String){
                if(err != null){
                    trace("Error: " + err);
                    loader.onError.emit(err);
                }
            });
        });
        return loader;
    }

    static private function _loadAsset(name:String, next:?String->Void) {
        var ext = Path.extension(name);
        //check images
        switch ext {
            case e if (Assets._imageExtensions.indexOf(e) >= 0):
                Assets.loadImage(name, next);
            case e if (Assets._videoExtensions.indexOf(e) >= 0):
                Assets.loadVideo(name, next);
            case e if (Assets._fontExtensions.indexOf(e) >= 0):
                Assets.loadFont(name, next);
            case e if (Assets._soundExtensions.indexOf(e) >= 0):
                Assets.loadSound(name, next);
            case "json":
                Assets.loadJson(name, next);
            default:
                Assets.loadBlob(name, next);
        }

        //todo admit to extend with new extensions and parsers (maybe with macros to make the asset list?)
        //todo maybe add a "addParser(ext[], loadCb, unloadCb)" and find un "custom" or something similar
    }

    static public function loadJson(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name, true);
        if(_existsAssetsName(parsedName, "blobs")){
            kha.Assets.loadBlob(parsedName, function(blob:Blob){
                Assets.json[name] = haxe.Json.parse(blob.toString());
                if(Assets.json[name].frames != null && Assets.json[name].meta != null && Assets.json[name].meta.image != null){
                    var json:TexturePacker = haxe.Json.parse(blob.toString());
                    Assets.loadImage(json.meta.image, function(?err:String){
                        if(err != null){
                            done(err);
                            return;
                        }

                        for(frame in Reflect.fields(json.frames)){
                            Assets.textures[frame] = Texture.fromTexturePacker(Assets.images[json.meta.image], Reflect.field(json.frames, frame));
                        }
                        done();
                    });
                }else{
                    done();
                }
            });
        }else{
            done("Invalid asset name: " + name);
        }
    }

    static public function loadImage(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        if(_existsAssetsName(parsedName, "images")){
            kha.Assets.loadImage(parsedName, function(img:Image){
                Assets.images[name] = img;
                Assets.textures[name] = new Texture(img);
                done();
            });
        }else{
            done("Invalid asset name: " + name);
        }
    }

    static public function loadVideo(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        if(_existsAssetsName(parsedName, "videos")){
            kha.Assets.loadVideo(parsedName, function(vid:Video){
                Assets.videos[name] = vid;
                done();
            });
        }else{
            done("Invalid asset name: " + name);
        }
    }

    static public function loadBlob(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name, true);
        if(_existsAssetsName(parsedName, "blobs")){
            kha.Assets.loadBlob(parsedName, function(blob:Blob){
                Assets.blobs[name] = blob;
                done();
            });
        }else{
            done("Invalid asset name: " + name);
        }
    }

    static public function loadSound(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        if(_existsAssetsName(parsedName, "sounds")){
            kha.Assets.loadSound(parsedName, function(sound:Sound){
                sound.uncompress(function(){
                    Assets.sounds[name] = sound;
                    done();
                });
            });
        }else{
            done("Invalid asset name: " + name);
        }
    }

    static public function loadFont(name:String, done:?String->Void){
        var parsedName = Assets._parseAssetName(name);
        if(_existsAssetsName(parsedName, "fonts")){
            kha.Assets.loadFont(parsedName, function(fnt:Font){
                Assets.fonts[name] = fnt;
                done();
            });
        }else{
            done("Invalid asset name: " + name);
        }
    }

    static public function unload(arr:Array<String>, ?onComplete:Void->Void, ?onError:String->Void) : Assets {
        var loader = new Assets(arr.length);

        if(onComplete != null){
            loader.onComplete += onComplete;
        }

        if(onError != null){
            loader.onError += onError;
        }

        loader.setTask(function(){
            Chain.eachSeries(arr, loader.observProgress(Assets._unloadAsset), function(?err:String){
                trace(err);
            });
        });
        return loader;
    }
    
    static private function _unloadAsset(name:String, next:?String->Void) {
        var ext = Path.extension(name);
        //check images
        switch ext {
            case e if (Assets._imageExtensions.indexOf(e) >= 0):
                Assets.unloadImage(name, next);
            case e if (Assets._videoExtensions.indexOf(e) >= 0):
                Assets.unloadVideo(name, next);
            case e if (Assets._fontExtensions.indexOf(e) >= 0):
                Assets.unloadFont(name, next);
            case e if (Assets._soundExtensions.indexOf(e) >= 0):
                Assets.unloadSound(name, next);
            default:
                Assets.unloadBlob(name, next);
        }
    }

    static public function unloadImage(name:String, done:?String->Void){
        var texture = Assets.textures.get(name);
        if(texture != null){
            texture.unload();
            Assets.textures.remove(name);
        }

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

    static public function unloadJson(name:String, done:?String->Void){
        //Assets.blobs[name].unload();
        Assets.json.remove(name);
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

    public var progress(get, null):Int;

    public var len:Int = 0;
    public var loaded:Int = 0;

    private var _task:Void->Void = function(){};

    public var onComplete:Event<Void->Void> = Event.create();
    public var onError:Event<String->Void> = Event.create();
    public var onProgressStart:Event<Int->String->Void> = Event.create();
    public var onProgressEnd:Event<Int->String->Void> = Event.create();

    private function new(len:Int){
        this.len = len;
    }

    public function start() {
        this._task();
        return this;
    }

    public function setTask(task:Void->Void){
        _task = task;
    }

    public function observProgress(task:String->(?String->Void)->Void) : String->(?String->Void)->Void {
        return function(name:String, next:?String->Void){
            onProgressStart.emit(this.progress, name);

            task(name, function(?err:String){
                if(err != null){
                    onError.emit(err);
                    next(err);
                    return;
                }

                loaded += 1;

                onProgressEnd.emit(this.progress, name);

                if(len != 0 && len == loaded){
                    onComplete.emit();
                }

                next();
            }); 
        }
    }

    function get_progress() : Int {
        return Std.int(Math.ceil(100/(len/loaded)));
    }

    //todo add a wrapper to load from web with xhr
}

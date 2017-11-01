package k2d;

import haxe.io.Path;

class Assets {
    static public var images:Map<String, kha.Image> = new Map<String, kha.Image>();

    static private function _parseAssetName(name:String) : String {
        return "" //todo, parse / \\ to _ and remove ext
    }

    static public function load(arr:Array<String>, done:?String->Void){
        Async.each(arr, function(name:String, next:?String->Void){
            trace(name, Path.extension(name));
            switch(Path.extension(name)){
                case "png" | "jpg" | "jpge" | "hdr":
                    Assets._loadImage(name, next);
                    
                default:
                //todo other extensions
                    next();
            }
        }, done);
    }

    static private function _loadImage(name:String, next:?String->Void){
        trace("loading:", name);
        kha.Assets.loadImage(name, function(img:kha.Image){
            trace("loaded:", name);
            Assets.images[name] = img;
            next();
        });
    }

    static public function unload(arr:Array<String>, done:?String->Void){

    }
}
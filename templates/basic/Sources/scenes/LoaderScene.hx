package scenes;

import gecko.Color;
import gecko.render.Renderer;
import gecko.Scene;
import gecko.Assets;

class LoaderScene extends Scene {
    static private inline var Name:String = "loader-scene";

    public var barWidth:Int = 400;
    public var barHeight:Int = 40;

    public var loader:Assets;

    public override function new(){
        super(Name);
    }

    public function loadAssets(files:Array<String>, callback:Void->Void) {
        if(files.length == 0){
            callback();
            return;
        }

        loader = Assets.load(files, function(){
            //delay of 0.5 seconds to display the bar at 100%
            var timer = timerManager.createTimer(0.5);
            timer.onEnd += callback;
            timer.start();
        }).start();
    }

    override public function render(r:Renderer){
        super.render(r);
        var xx = width/2 - barWidth/2;

        if(loader != null){
            r.color = Color.White;
            r.fillRect(xx, height/2 - barHeight/2, barWidth*(loader.progress/100), barHeight);
        }

        r.color = Color.Beige;
        r.drawRect(xx, height/2 - barHeight/2, barWidth, barHeight, 2);
    }
}
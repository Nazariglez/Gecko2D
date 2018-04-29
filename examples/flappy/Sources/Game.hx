package;

import gecko.input.Mouse;
import gecko.Gecko;
import gecko.Screen;
import gecko.Assets;
import gecko.components.draw.ProgressBarComponent;

class Game {
    private var _assetsToLoad:Array<String> = [
        //your assets here
        "images/flappydoge_bg1.png",
        "images/flappydoge_floor.png",
        "images/flappydoge_pipe.png",

        "images/flappydoge_anim01.png",
        "images/flappydoge_anim02.png",
        "images/flappydoge_anim03.png",
        "images/flappydoge_anim04.png",

        "kenpixel_mini_square.ttf"
    ];

    public function new(){
        Mouse.enable();

        if(_assetsToLoad.length != 0){
            _loadAssets();
        }else{
            _gotoMainScene();
        }
    }

    public function _gotoMainScene() {
        Gecko.world.changeScene(scenes.MainScene.create(), true);
    }

    //Add a loaderbar an go to mainScene when the load finish
    public function _loadAssets() {
        var currentScene = Gecko.currentScene;

        var entity = currentScene.createEntity();
        entity.transform.position.set(Screen.centerX, Screen.centerY);
        entity.transform.size.set(Screen.width*0.8, 20);

        var progressBar = entity.addComponent(ProgressBarComponent.create());

        var loader = Assets.load(_assetsToLoad);
        loader.onProgressEnd += function(progress:Int, assetName:String){
            progressBar.progress = progress; //update the loaderBar
        };

        loader.onComplete += function(){
            //added a little delay before go to the mainScene
            var timer = currentScene.timerManager.createTimer(0.5);
            timer.destroyOnEnd = true;

            timer.onEnd += function(){
                _gotoMainScene();
            };

            timer.start();
        };

        //start load
        loader.start();
    }
}
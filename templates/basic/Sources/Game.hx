package;

import gecko.Scene;
import gecko.Gecko;
import gecko.Screen;
import gecko.Entity;
import gecko.Assets;
import gecko.components.draw.ProgressBarComponent;

class Game {
    private var _assetsToLoad:Array<String> = [
        //your assets here
        "Ubuntu-B.ttf"
    ];

    public function new(){
        if(_assetsToLoad.length != 0){
            _loadAssets();
        }else{
            _gotoMainScene();
        }
    }

    public function _gotoMainScene() {
        Gecko.world.changeScene(scenes.MainScene.create());
    }

    //Add a loaderbar an go to mainScene when the load finish
    public function _loadAssets() {
        var entity = Entity.create();
        entity.transform.position.set(Screen.centerX, Screen.centerY);
        entity.transform.size.set(500, 40);

        var progressBar = entity.addComponent(ProgressBarComponent.create());

        Gecko.currentScene.addEntity(entity);

        var loader = Assets.load(_assetsToLoad);
        loader.onProgressEnd += function(progress:Int, assetName:String){
            progressBar.progress = progress; //update the loaderBar
        };

        loader.onComplete += function(){
            //added a little delay before go to the mainScene
            var timer = Gecko.currentScene.timerManager.createTimer(0.5);
            timer.destroyOnEnd = true;

            timer.onEnd += function(){
                Gecko.currentScene.removeEntity(entity);
                entity.destroy();

                _gotoMainScene();
            };

            timer.start();
        };

        //start load
        loader.start();
    }
}
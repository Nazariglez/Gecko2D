package;

import exp.input.Mouse;
import exp.Gecko;
import exp.Screen;
import exp.components.core.TransformComponent;
import exp.Entity;
import exp.Assets;
import exp.components.draw.LoaderBarComponent;

class Game {
    private var _assetsToLoad:Array<String> = [
        //your assets here
        "Ubuntu-B.ttf",
        "images/kenney/green_panel.png",
        "images/kenney/grey_button08.png",
        "images/kenney/red_cross.png",
        "images/kenney/elephant.png",
        "images/kenney/hippo.png",
        "images/kenney/monkey.png",
        "images/kenney/giraffe.png",
        "images/kenney/panda.png",
        "images/kenney/parrot.png",
        "images/kenney/snake.png",
        "images/kenney/penguin.png",
        "images/kenney/pig.png",
        "images/opengameart/mountain.png",
        "images/opengameart/carbon_fiber.png"
    ];

    public function new(){
        if(_assetsToLoad.length != 0){
            _loadAssets();
        }else{
            _gotoMainScene();
        }
    }

    public function _gotoMainScene() {
        Mouse.enable();

        Gecko.world.changeScene(scenes.MainScene.create());
    }

    //Add a loaderbar an go to mainScene when the load finish
    public function _loadAssets() {
        var entity = Entity.create();
        entity.addComponent(TransformComponent.create(Screen.centerX, Screen.centerY, 500, 40));

        var loaderBar = LoaderBarComponent.create();
        entity.addComponent(loaderBar);

        Gecko.currentScene.addEntity(entity);


        var loader = Assets.load(_assetsToLoad);
        loader.onProgressEnd += function(progress:Int, assetName:String){
            loaderBar.progress = progress; //update the loaderBar
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
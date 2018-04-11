package;

import gecko.input.Keyboard;
import gecko.input.Mouse;
import gecko.Gecko;
import gecko.Screen;
import gecko.Entity;
import gecko.Assets;
import gecko.components.draw.ProgressBarComponent;
//import gecko.Audio;

class Game {
    private var _assetsToLoad:Array<String> = [
        //your assets here
        "Ubuntu-B.ttf",
        "images/kenney/starBackground.png",
        "images/kenney/enemyUFO.png",
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
        "images/opengameart/carbon_fiber.png",

        "images/kenney/pixelExplosion00.png",
        "images/kenney/pixelExplosion01.png",
        "images/kenney/pixelExplosion02.png",
        "images/kenney/pixelExplosion03.png",
        "images/kenney/pixelExplosion04.png",
        "images/kenney/pixelExplosion05.png",
        "images/kenney/pixelExplosion06.png",
        "images/kenney/pixelExplosion07.png",
        "images/kenney/pixelExplosion08.png",

        "images/kenney/wingMan1.png",
        "images/kenney/wingMan2.png",
        "images/kenney/wingMan3.png",
        "images/kenney/wingMan4.png",
        "images/kenney/wingMan5.png",

        "images/opengameart/golem-walk.png",
        "images/opengameart/golem-atk.png",
        "images/opengameart/golem-die.png",
        //"audio/Retro-Beat.wav"
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
        Keyboard.enable();

        Gecko.world.changeScene(scenes.MainScene.create(), true);
    }

    //Add a loaderbar and go to mainScene when the load finish
    public function _loadAssets() {
        var entity = Gecko.currentScene.createEntity();
        entity.transform.position.set(Screen.centerX, Screen.centerY);
        entity.transform.size.set(500, 40);
        var loaderBar = entity.addComponent(ProgressBarComponent.create());

        var loader = Assets.load(_assetsToLoad);
        loader.onProgressEnd += function(progress:Int, assetName:String){
            loaderBar.progress = progress; //update the loaderBar
        };

        loader.onComplete += function(){
            //added a little delay before go to the mainScene
            var timer = Gecko.currentScene.timerManager.createTimer(0.5);
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
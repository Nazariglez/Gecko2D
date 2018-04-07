package;

import gecko.components.draw.CircleComponent;
import gecko.Color;
import gecko.components.draw.RectangleComponent;
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
        var scene = Gecko.currentScene;

        var container = scene.createEntity();
        //container.transform.size.set(500, 500);
        container.transform.position.set(Screen.centerX, Screen.centerY);
        var rect = container.addComponent(RectangleComponent.create(true, 500, 500));
        rect.color = Color.Beige;

        for(i in 0...11){
            var child = scene.createEntity();
            child.transform.parent = container.transform;
            child.transform.localPosition.set(i * 50, i * 50);
            var circle = child.addComponent(CircleComponent.create(true, 20));
            circle.color = Color.random();

            for(n in 0...3){
                var child2 = scene.createEntity();
                child2.transform.parent = child.transform;
                child2.transform.localPosition.set(child.transform.size.x/2, n*20);
                var circle2 = child2.addComponent(CircleComponent.create(true, 5));
                circle2.color = Color.random();
            }
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
package;

import gecko.Float32;
import gecko.components.draw.DrawComponent;
import gecko.components.draw.SpriteComponent;
import gecko.Screen;
import gecko.Gecko;
import gecko.systems.draw.DrawSystem;
import gecko.Assets;

class Game {
    public function new(){
        Gecko.currentScene.addSystem(DrawSystem.create());

        Assets.load([
            "car_green_small_1.png"
        ], _onAssetsLoaded).start();
    }

    private function _onAssetsLoaded() {
        //create a new container in the middle of the screen with a 200x350 of size
        var container = Gecko.currentScene.createEntity();
        container.transform.size.set(200, 350);
        container.transform.position.set(Screen.centerX, Screen.centerY);

        //add a empty draw-component to the container
        container.addComponent(DrawComponent.create());


        //create an 5x5 grid of cars
        for(x in 0...5){
            for(y in 0...5){
                var car = Gecko.currentScene.createEntity();
                car.transform.parent = container.transform; //set the container transform as the parent transform

                //localPosition is the position inside the parent
                car.transform.localPosition.set(x * 40, y * 70);

                //anchor to left-top
                car.transform.anchor.set(0,0);

                //sprite component
                car.addComponent(SpriteComponent.create("car_green_small_1.png"));
            }
        }

        //attach to the onUpdate event of gecko a simple function
        Gecko.onUpdate += function(delta:Float32) {
            //rotate the container using delta time
            container.transform.rotation += 1 * delta;
        };
    }
}
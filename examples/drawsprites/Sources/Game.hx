package;

import gecko.Gecko;
import gecko.Float32;
import gecko.components.draw.SpriteComponent;
import gecko.systems.draw.DrawSystem;

class Game {
    private var _spritesToLoad:Array<String> = [
        "kenney/elephant.png",
        "kenney/hippo.png",
        "kenney/monkey.png",
        "kenney/giraffe.png",
        "kenney/panda.png",
        "kenney/parrot.png",
        "kenney/snake.png",
        "kenney/penguin.png",
        "kenney/pig.png"
    ];

    public function new(){
        //add draw system
        Gecko.currentScene.addSystem(DrawSystem.create());

        //load the sprites
        gecko.Assets.load(_spritesToLoad, _onLoadAssets).start();
    }

    private function _onLoadAssets(){
        //Draw sprites in a grid
        var minX = 155;
        var minY = 110;

        var gapX = 250;
        var gapY = 180;

        var i = 0;
        for(x in 0...3){
            for(y in 0...3){
                _addSprite(_spritesToLoad[i], minX + gapX*x, minY + gapY*y);

                i++;
            }
        }
    }

    //Create an add the sprite
    private function _addSprite(spriteName:String, x:Float32, y:Float32) {
        var e = Gecko.currentScene.createEntity();
        e.addComponent(SpriteComponent.create(spriteName));

        e.transform.position.set(x, y);
        e.transform.scale.set(0.4, 0.4); //scale because they're too big
    }
}
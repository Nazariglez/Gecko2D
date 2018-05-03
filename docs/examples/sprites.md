---
title: Sprites
---
# Sprites
<iframe src="/builds/sprites/index.html" width="800" height="600" frameBorder="0" style="width:100%; max-height: 600px"></iframe>

```haxe
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

    //Create an add the sprite
    private function _createSprite(spriteName:String, x:Float32, y:Float32) {
        //create an entity in the current scene
        var entity = Gecko.currentScene.createEntity();

        //add a spriteComponent using the sprite name
        entity.addComponent(SpriteComponent.create(spriteName));

        //set the position and the scale
        entity.transform.position.set(x, y);
        entity.transform.scale.set(0.4, 0.4);
    }

    private function _onLoadAssets(){
        //Draw 9 sprites in a grid
        var minX = 155;
        var minY = 110;

        var gapX = 250;
        var gapY = 180;

        var i = 0;
        for(x in 0...3){
            for(y in 0...3){
                _createSprite(_spritesToLoad[i], minX + gapX*x, minY + gapY*y);

                i++;
            }
        }
    }
}
```

            
[Source Code](https://github.com/Nazariglez/Gecko2D/tree/master/examples/sprites)

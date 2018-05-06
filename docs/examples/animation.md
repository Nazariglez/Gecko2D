---
title: Animation
---
# Animation

<iframe :src="$withBase('/builds/animation/index.html')" width="800" height="600" frameBorder="0" style="width: 100vw; height:75vw; max-width:100%; max-height:600px"></iframe>

```haxe
package;

import gecko.Screen;

import gecko.Assets;
import gecko.Gecko;
import gecko.systems.draw.DrawSystem;
import gecko.components.draw.TextComponent;
import gecko.components.draw.AnimationComponent;

import gecko.input.KeyCode;
import gecko.input.Keyboard;

class Game {
    public function new(){
        //add the draw system
        Gecko.currentScene.addSystem(DrawSystem.create());

        //Load the sprites
        Assets.load([
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
            "images/kenney/wingMan4.png",
            "images/kenney/wingMan3.png",
            "images/kenney/wingMan2.png",

            "images/opengameart/golem-walk.png",
            "images/opengameart/golem-atk.png",
            "images/opengameart/golem-die.png",

            "Ubuntu-B.ttf"

        ], _onLoadAssets).start();
    }

    private function _createAnimatedEntity(x:Float, y:Float, sx:Float = 1, sy:Float = 1) : AnimationComponent {
        //create a new entity in the current scene
        var entity = Gecko.currentScene.createEntity();

        //set the entity position in the screen
        entity.transform.position.set(x, y);

        //set the entity's scale
        entity.transform.scale.set(sx, sy);

        //create and return the animationComponent
        return entity.addComponent(AnimationComponent.create());
    }

    private function _onLoadAssets() {
        //animation from assets name
        var anim1Frames = [
            "images/kenney/pixelExplosion00.png",
            "images/kenney/pixelExplosion01.png",
            "images/kenney/pixelExplosion02.png",
            "images/kenney/pixelExplosion03.png",
            "images/kenney/pixelExplosion04.png",
            "images/kenney/pixelExplosion05.png",
            "images/kenney/pixelExplosion06.png",
            "images/kenney/pixelExplosion07.png",
            "images/kenney/pixelExplosion08.png",
        ];

        //create the entity and get the animationComponent
        var animComponent1 =_createAnimatedEntity(Screen.width/4, 150);

        //add a new animation named "explosion" from frame names
        animComponent1.addAnimFromAssets("explosion", 0.9, anim1Frames);

        //play the animation explision in a loop
        animComponent1.play("explosion", true);


        //animation 2 from assets name
        var anim2Frames = [
            "images/kenney/wingMan1.png",
            "images/kenney/wingMan2.png",
            "images/kenney/wingMan3.png",
            "images/kenney/wingMan4.png",
            "images/kenney/wingMan5.png",
            "images/kenney/wingMan4.png",
            "images/kenney/wingMan3.png",
            "images/kenney/wingMan2.png",
        ];

        //create the entity and get the animationComponent
        var animComponent2 =_createAnimatedEntity(Screen.width/4*3, 150);

        //add a new animation named "wings" from frame names
        animComponent2.addAnimFromAssets("wings", 0.5, anim2Frames);

        //play the animation explision in a loop
        animComponent2.play("wings", true);


        //Golem animation is created from a grid
        var golem = _createAnimatedEntity(Screen.centerX, Screen.height - 100, 3, 3);

        //set the anchor to middle-bottom to display the anim
        golem.entity.transform.anchor.set(0.5,1);

        //add a new anim named walk from a grid of 4 rows and 7 columns, and select 7 frames of the grid
        golem.addAnimFromGridAssets("walk", 0.5, "images/opengameart/golem-walk.png", 4, 7, [14, 15, 16, 17, 18, 19, 20]);

        //add a new anim named attack from a grid of 4 rows and 7 columns, and select 7 frames of the grid
        golem.addAnimFromGridAssets("attack", 0.8, "images/opengameart/golem-atk.png", 4, 7, [14, 15, 16, 17, 18, 19, 20]);

        //add a new anim die walk from a grid of 2 rows and 7 columns, and select the 7 first frames
        golem.addAnimFromGridAssets("die", 0.9, "images/opengameart/golem-die.png", 2, 7, null, 7);

        //play the anim walk
        golem.play("walk", true);



        //UI and extras
        var text = Gecko.currentScene.createEntity();
        text.addComponent(TextComponent.create("Press 'z' to walk, 'x' to attack, 'c' to die", "Ubuntu-B.ttf", 30));
        text.transform.position.set(Screen.centerX, Screen.height - 60);
        text.transform.fixedToCamera = true;

        Keyboard.enable();
        Keyboard.onPressed += function(key:KeyCode) {
            if(golem != null){
                switch(key){
                    case KeyCode.Z: golem.play("walk", true);
                    case KeyCode.X: golem.play("attack", true);
                    case KeyCode.C: golem.play("die", true);
                    default:
                }
            }
        };
    }
}
```


[Source Code](https://github.com/Nazariglez/Gecko2D/tree/master/examples/animation)

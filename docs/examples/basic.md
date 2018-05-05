---
title: Basic
---
# Basic

<iframe :src="$withBase('/builds/basic/index.html')" width="800" height="600" frameBorder="0" style="width: 100vw; height:75vw; max-width:100%; max-height:600px"></iframe>

```haxe
package;

import gecko.Screen;
import gecko.components.draw.SpriteComponent;
import gecko.Gecko;
import gecko.Assets;
import gecko.systems.draw.DrawSystem;

class Game {
    public function new(){
        //add the draw system to the current scene
        Gecko.currentScene.addSystem(DrawSystem.create());

        //load assets
        Assets.load([
            "shipYellow_manned.png"
        ], _onAssetsLoaded).start();
    }

    private function _onAssetsLoaded() {
        //create a new entity in the current scene
        var entity = Gecko.currentScene.createEntity();

        //center the entity in the middle of the screen
        entity.transform.position.set(Screen.centerX, Screen.centerY);

        //add a sprite component to the scene
        entity.addComponent(SpriteComponent.create("shipYellow_manned.png"));
    }
}
```


[Source Code](https://github.com/Nazariglez/Gecko2D/tree/master/examples/basic)

---
title: Text
---
# Text

<iframe :src="$withBase('/builds/text/index.html')" width="800" height="600" frameBorder="0" style="width: 100vw; height:75vw; max-width:100%; max-height:600px"></iframe>

```haxe
package;

import gecko.Color;
import gecko.Screen;
import gecko.components.draw.TextComponent;
import gecko.Gecko;
import gecko.Assets;
import gecko.systems.draw.DrawSystem;

class Game {
    public function new(){
        //add the draw system to the currentScene
        Gecko.currentScene.addSystem(DrawSystem.create());

        //load the fonts
        Assets.load([
            "Ubuntu-B.ttf",
            "kenpixel_mini_square.ttf"
        ], _onAssetsLoad).start();
    }

    private function _onAssetsLoad() {
        //create an entity in the current scene
        var entity1 = Gecko.currentScene.createEntity();

        //set the entity position
        entity1.transform.position.set(20, 20);

        //set the anchor to top-left
        entity1.transform.anchor.set(0, 0);

        //add a textComponent using ubuntu and the 50px as size
        entity1.addComponent(TextComponent.create("A basic line of text.", "Ubuntu-B.ttf", 50));


        //create an entity in the current scene
        var entity2 = Gecko.currentScene.createEntity();
        entity2.transform.position.set(Screen.centerX, Screen.centerY);

        //add a textComponent using ubuntu and the 30px as size and return it
        var text2:TextComponent = entity2.addComponent(TextComponent.create("A basic line of text in other color.", "Ubuntu-B.ttf", 30));

        //change the color
        text2.color = Color.Red;


        //multiline text
        var entity3 = Gecko.currentScene.createEntity();
        entity3.transform.position.set(150, Screen.centerY + 100);

        //add a textComponent using ubuntu and the 20px as size and using \n to split in lines the text
        entity3.addComponent(TextComponent.create("Hey! I'm other example,\nbut, i'm a multiline\nexample of text!!!", "kenpixel_mini_square.ttf", 20));


        //multiline text aligned to center
        var entity4 = Gecko.currentScene.createEntity();
        entity4.transform.position.set(400, Screen.centerY + 150);
        entity4.addComponent(TextComponent.create("Hey! I'm the same example,\nbut, i'm a multiline\nand center aligned!", "kenpixel_mini_square.ttf", 20, "center"));


        //multiline text aligned to right
        var entity5 = Gecko.currentScene.createEntity();
        entity5.transform.position.set(650, Screen.centerY + 100);
        entity5.addComponent(TextComponent.create("Hey! I'm the same example,\nbut, i'm a multiline\nand right aligned!", "kenpixel_mini_square.ttf", 20, "right"));


        //multiline with line spacing
        var entity6 = Gecko.currentScene.createEntity();
        entity6.transform.position.set(650, Screen.centerY - 200);

        var textToDraw = '
Multiline text,
it\'s stored in a variable
using \'\' in differents lines.
Also, i\'m playing with line spacing.
';
        var text2:TextComponent = entity6.addComponent(TextComponent.create(textToDraw, "kenpixel_mini_square.ttf", 20, "center"));
        text2.lineSpacing = 20;


        //multiline text wrapping in a 200px width
        var entity7 = Gecko.currentScene.createEntity();
        entity7.transform.position.set(200, Screen.centerY - 100);
        var text3:TextComponent = entity7.addComponent(TextComponent.create("I'm a a text in a simple line, but wrapping with 'lineWidth' to 200px.", "Ubuntu-B.ttf", 20));
        text3.lineWidth = 200;

    }
}
```


[Source Code](https://github.com/Nazariglez/Gecko2D/tree/master/examples/text)

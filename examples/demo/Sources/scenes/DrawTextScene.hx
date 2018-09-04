package scenes;

import gecko.Color;
import gecko.Entity;
import gecko.Screen;
import gecko.components.draw.TextComponent;

class DrawTextScene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init(closeButton);

        //create an entity in the current scene
        var entity1 = createEntity();

        //set the entity position
        entity1.transform.position.set(20, 20);

        //set the anchor to top-left
        entity1.transform.anchor.set(0, 0);

        //add a textComponent using ubuntu and the 50px as size
        entity1.addComponent(TextComponent.create("A basic line of text.", "Ubuntu-B.ttf", 50));

        //create an entity in the current scene
        var entity2 = createEntity();
        entity2.transform.position.set(Screen.centerX, Screen.centerY);

        //add a textComponent using ubuntu and the 30px as size and return it
        var text2:TextComponent = entity2.addComponent(TextComponent.create("A basic line of text in other color.", "Ubuntu-B.ttf", 30));

        //change the color
        text2.color = Color.Red;

        //multiline text
        var entity3 = createEntity();
        entity3.transform.position.set(150, Screen.centerY + 100);

        //add a textComponent using ubuntu and the 20px as size and using \n to split in lines the text
        entity3.addComponent(TextComponent.create("Hey! I'm other example,\nbut, i'm a multiline\nexample of text!!!", "kenpixel_mini_square.ttf", 20));

        //multiline text aligned to center
        var entity4 = createEntity();
        entity4.transform.position.set(400, Screen.centerY + 150);
        entity4.addComponent(TextComponent.create("Hey! I'm the same example,\nbut, i'm a multiline\nand center aligned!", "kenpixel_mini_square.ttf", 20, "center"));

        //multiline text aligned to right
        var entity5 = createEntity();
        entity5.transform.position.set(650, Screen.centerY + 100);
        entity5.addComponent(TextComponent.create("Hey! I'm the same example,\nbut, i'm a multiline\nand right aligned!", "kenpixel_mini_square.ttf", 20, "right"));

        //multiline with line spacing
        var entity6 = createEntity();
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
        var entity7 = createEntity();
        entity7.transform.position.set(200, Screen.centerY - 100);
        var text3:TextComponent = entity7.addComponent(TextComponent.create("I'm a a text in a simple line, but wrapping with 'lineWidth' to 200px.", "Ubuntu-B.ttf", 20));
        text3.lineWidth = 200;
    }
}
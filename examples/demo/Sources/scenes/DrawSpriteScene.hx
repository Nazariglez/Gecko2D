package scenes;

import gecko.components.draw.SpriteComponent;
import gecko.Float32;

class DrawSpriteScene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init(closeButton);

        //sprites to draw
        var spriteNames = [
            "images/kenney/elephant.png",
            "images/kenney/hippo.png",
            "images/kenney/monkey.png",
            "images/kenney/giraffe.png",
            "images/kenney/panda.png",
            "images/kenney/parrot.png",
            "images/kenney/snake.png",
            "images/kenney/penguin.png",
            "images/kenney/pig.png"
        ];


        //Draw sprites in a grid
        var minX = 155;
        var minY = 110;

        var gapX = 250;
        var gapY = 180;

        var i = 0;
        for(x in 0...3){
            for(y in 0...3){
                _addSprite(spriteNames[i], minX + gapX*x, minY + gapY*y);

                i++;
            }
        }
    }

    //Create an add the sprite
    private function _addSprite(sprite:String, x:Float32, y:Float32) {
        var e = createEntity();
        e.addComponent(SpriteComponent.create(sprite));

        e.transform.position.set(x, y);
        e.transform.scale.set(0.4, 0.4); //scale because they're too big
    }
}
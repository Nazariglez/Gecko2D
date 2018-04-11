package scenes;

import gecko.input.KeyCode;
import gecko.input.Keyboard;
import gecko.components.draw.TextComponent;
import gecko.Screen;
import gecko.Float32;
import gecko.components.draw.AnimationComponent;

class DrawAnimationScene extends CustomScene {
    public var golem:AnimationComponent;

    override public function init(closeButton:Bool = false){
        super.init(closeButton);

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

        var animComponent1 =_createAnimatedEntity(Screen.width/4, 150);
        animComponent1.addAnimFromAssets("explosion", 0.9, anim1Frames);
        animComponent1.play("explosion", true);


        //animation from assets name
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

        var animComponent2 =_createAnimatedEntity(Screen.width/4*3, 150);
        animComponent2.addAnimFromAssets("wings", 0.5, anim2Frames);
        animComponent2.play("wings", true);


        //golem, animations from grid
        golem = _createAnimatedEntity(Screen.centerX, Screen.height - 100, 3, 3);
        golem.entity.transform.anchor.set(0.5,1); //set the anchor to middle-bottom to display the anim

        //grid 4 rows, 7 cols, 7 frames
        golem.addAnimFromGridAssets("walk", 0.5, "images/opengameart/golem-walk.png", 4, 7, [14, 15, 16, 17, 18, 19, 20]);
        golem.addAnimFromGridAssets("attack", 0.8, "images/opengameart/golem-atk.png", 4, 7, [14, 15, 16, 17, 18, 19, 20]);

        //2 rows, 7 cols, 7 first frames
        golem.addAnimFromGridAssets("die", 0.9, "images/opengameart/golem-die.png", 2, 7, null, 7);

        golem.play("walk", true);


        //extras
        var text = createEntity();
        text.addComponent(TextComponent.create("Press 'z' to walk, 'x' to attack, 'c' to die", "Ubuntu-B.ttf", 30));
        text.transform.position.set(Screen.centerX, Screen.height - 60);


        Keyboard.onPressed += _onKeyPressed;
    }

    private function _onKeyPressed(key:KeyCode) {
        if(golem != null){
            switch(key){
                case KeyCode.Z: golem.play("walk", true);
                case KeyCode.X: golem.play("attack", true);
                case KeyCode.C: golem.play("die", true);
                default:
            }
        }
    }

    private function _createAnimatedEntity(x:Float32, y:Float32, sx:Float32 = 1, sy:Float32 = 1) : AnimationComponent {
        var e = createEntity();
        e.transform.position.set(x, y);
        e.transform.scale.set(sx, sy);
        return e.addComponent(AnimationComponent.create());
    }

    override public function beforeDestroy() {
        super.beforeDestroy();
        Keyboard.onPressed -= _onKeyPressed;
    }
}
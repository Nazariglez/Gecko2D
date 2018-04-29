package scenes;

import gecko.Gecko;
import gecko.input.Keyboard;
import gecko.input.KeyCode;
import gecko.Screen;
import gecko.components.draw.TextComponent;
import gecko.Entity;
import gecko.Float32;
import gecko.systems.draw.DrawSystem;
import gecko.Scene;

class MainScene extends Scene {
    public function init() {
        addSystem(DrawSystem.create());

        _createText("KHA SHMUP", Screen.centerX, 100, 80);
        _createText("Arrow keys to move, 'Z' key to shoot.\nPress 'Z' to start.", Screen.centerX, Screen.height-120, 30, "center");

        //bind keyboard
        Keyboard.onPressed += _onPressed;
    }

    private function _onPressed(key:KeyCode){
        //on pressed Z start the game
        if(key == KeyCode.Z) {
            //unbind the event attached to the keyboard to start the game
            Keyboard.onPressed -= _onPressed;

            //goto the gamescene and destroy this scene
            Gecko.world.changeScene(GameScene.create(), true);
        }
    }

    public function _createText(text:String, x:Float32, y:Float32, size:Int, align:String = "left"){
        var e:Entity = createEntity();
        e.transform.position.set(x, y);
        e.addComponent(TextComponent.create(text, "kenpixel_mini_square.ttf", size, align));
    }
}
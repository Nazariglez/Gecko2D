package;

import gecko.Assets;
import gecko.Gecko;

import gecko.math.Random;
import gecko.systems.draw.DrawSystem;
import gecko.components.draw.NineSliceComponent;

class Game {
    var _spritesToLoad = ["images/kenney/grey_button08.png", "images/kenney/green_panel.png"];

    public function new(){
        //add the draw system to the current scene
        Gecko.currentScene.addSystem(DrawSystem.create());

        //load the assets
        Assets.load(_spritesToLoad, _onLoadAssets).start();
    }

    //create nine-slice sprites using positon and size
    private function _createNineSlice(x:Float, y:Float, width:Float, height:Float) {
        //create an entity in the current scene
        var entity = Gecko.currentScene.createEntity();

        //set his position in the screen
        entity.transform.position.set(x, y);

        //add the nine-slice component using a random spritename and a size
        entity.addComponent(NineSliceComponent.create(_getRandomSprite(), width, height));

        //e.renderer.color = _getRandomColor();
        entity.transform.anchor.set(0,0);
    }

    private function _onLoadAssets() {
        //add a lot of nine-slice components in the screen
        _createNineSlice(50, 50, 200, 100);
        _createNineSlice(50, 170, 100, 400);
        _createNineSlice(170, 170, 400, 400);
        _createNineSlice(270, 50, 60, 100);
        _createNineSlice(350, 50, 40, 40);
        _createNineSlice(350, 110, 40, 40);
        _createNineSlice(410, 50, 120, 100);
        _createNineSlice(550, 50, 200, 40);
        _createNineSlice(550, 110, 200, 40);
        _createNineSlice(590, 170, 160, 80);
        _createNineSlice(590, 270, 60, 300);
        _createNineSlice(670, 270, 80, 300);
    }

    //return a random spritename
    private function _getRandomSprite() : String {
        return _spritesToLoad[Random.getUpTo(_spritesToLoad.length-1)];
    }
}
package scenes;

import gecko.Color;
import gecko.components.draw.NineSliceComponent;
import gecko.Float32;
import gecko.math.Random;

class DrawNineSliceScene extends CustomScene {
    var _colors = [Color.Red, Color.Green, Color.Blue, Color.White, Color.Yellow, Color.Orange, Color.Brown, Color.Magenta];
    var _sprites = ["images/kenney/grey_button08.png", "images/kenney/green_panel.png"];

    override public function init(closeButton:Bool = false){
        super.init(closeButton);

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

    private function _createNineSlice(x:Float32, y:Float32, width:Float32, height:Float32) {
        var e = createEntity();
        e.transform.position.set(x, y);
        e.addComponent(NineSliceComponent.create(_getRandomSprite(), width, height));

        //e.renderer.color = _getRandomColor();
        e.transform.anchor.set(0,0);
    }

    private function _getRandomSprite() : String {
        return _sprites[Random.getUpTo(_sprites.length-1)];
    }

    private function _getRandomColor() : Color {
        return _colors[Random.getUpTo(_colors.length-1)];
    }
}
package scenes;

import gecko.components.draw.CircleComponent;
import gecko.Camera;
import gecko.Graphics;
import gecko.Scene;
import gecko.Gecko;
import gecko.Color;
import gecko.components.input.MouseComponent;
import gecko.components.draw.NineSliceComponent;
import gecko.Float32;
import gecko.Screen;
import gecko.Entity;
import gecko.math.Point;
import gecko.components.draw.TextComponent;
import gecko.Transform;

import scenes.DrawSpriteScene;
import scenes.DrawTextScene;
import scenes.DrawShapeScene;
import scenes.DrawNineSliceScene;
import scenes.DrawScrollingSpriteScene;
import scenes.Camera1Scene;

typedef ExamplesDef = {
    name:String,
    callback:Void->Void
};

@:expose
class MainScene extends CustomScene {
    static var _examples:Array<ExamplesDef> = [];

    override public function init(closeButton:Bool = false) {
        super.init(closeButton);

        //var cam = createCamera(0, 0, Std.int(Screen.width/2), 0);
        //var cam2 = createCamera(Std.int(Screen.width/2), 0);

        _addTitle(Screen.centerX, 60);

        //buttons and scenes to go
        _initExamples();

        //create buttons
        var minX = 140;
        var minY = 150;

        var gapX = 175;
        var gapY = 60;

        var xx = minX;
        var yy = minY;

        for(example in _examples){
            _createButton(example.name, xx, yy, function(x, y){
               example.callback();
            });

            yy += gapY;

            if(yy > Screen.height-60){
                xx += gapX;
                yy = minY;
            }
        }

    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        _examples = [];
    }

    private function _initExamples() {
        if(_examples.length == 0){
            _examples = [
                {
                    name: "Draw Sprites",
                    callback: function() {
                        _gotoScene(DrawSpriteScene.create(true));
                    }
                },
                {
                    name: "Draw Shapes",
                    callback: function() {
                        _gotoScene(DrawShapeScene.create(true));
                    }
                },
                {
                    name: "Draw Animations",
                    callback: function(){

                    }
                },
                {
                    name: "Draw NineSlices",
                    callback: function() {
                        _gotoScene(DrawNineSliceScene.create(true));
                    }
                },
                {
                    name: "Draw ScrollingSprites",
                    callback: function() {
                        _gotoScene(DrawScrollingSpriteScene.create(true));
                    }
                },
                {
                    name: "Draw Text",
                    callback: function(){
                        _gotoScene(DrawTextScene.create(true));
                    }
                },
                {
                    name: "Transform Rotation",
                    callback: function(){

                    }
                },
                {
                    name: "Transform Anchors",
                    callback: function(){

                    }
                },
                {
                    name: "Transform Pivots",
                    callback: function(){

                    }
                },
                {
                    name: "Transform Skew",
                    callback: function(){

                    }
                },
                {
                    name: "Transform Pivot",
                    callback: function(){

                    }
                },
                {
                    name: "Transform Parents",
                    callback: function(){

                    }
                },
                {
                    name: "Camera 1",
                    callback: function(){
                        _gotoScene(Camera1Scene.create(true));
                    }
                }
            ];
        }
    }

    private function _gotoScene(scene:Scene){
        Gecko.world.changeScene(scene, true);
    }

    private function _createButton(text:String, x:Float32, y:Float32, callback:Float32->Float32->Void) {
        //Button sprite
        var btn = createEntity();
        btn.transform.position.set(x, y);

        var nineSlice = btn.addComponent(NineSliceComponent.create("images/kenney/green_panel.png", 160, 50));

        //button text
        var txt = createEntity();
        txt.transform.position.set(x, y);
        txt.addComponent(TextComponent.create(text, "Ubuntu-B.ttf", 20));

        //Text must be inside the text
        var maxWidth = btn.transform.width - 20;
        if(txt.transform.width > maxWidth){
            var scale = maxWidth/txt.transform.width;
            txt.transform.scale.set(scale, scale);
        }

        //over and out color effect
        var mouse = btn.addComponent(MouseComponent.create());
        mouse.onOver += function(x:Float32, y:Float32) {
            nineSlice.color = Color.LightGreen;
        };

        mouse.onOut += function(x:Float32, y:Float32){
            nineSlice.color = Color.White;
        };

        //trigger the callback when the button it's clicked
        mouse.onClick += callback;
    }

    private function _addTitle(x:Float32, y:Float32) {
        var entity = createEntity();
        entity.transform.position.set(x, y);
        entity.addComponent(TextComponent.create("Gecko2D Demo", "Ubuntu-B.ttf", 70));
    }
}
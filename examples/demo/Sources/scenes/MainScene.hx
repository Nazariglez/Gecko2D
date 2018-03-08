package scenes;

import exp.Scene;
import exp.Gecko;
import exp.Color;
import exp.components.input.MouseComponent;
import exp.components.draw.NineSliceComponent;
import exp.Float32;
import exp.Screen;
import exp.Entity;
import exp.components.core.TransformComponent;
import exp.components.draw.TextComponent;

import scenes.DrawSpriteScene;
import scenes.DrawTextScene;
import scenes.DrawShapeScene;

class MainScene extends CustomScene {
    override public function init(closeButton:Bool = false) {
        super.init(closeButton);
        _addTitle(Screen.centerX, 60);

        //buttons and scenes to go
        var _examples = [
            { name: "Draw Sprites", scene: DrawSpriteScene.create(true) },
            { name: "Draw Shapes", scene: DrawShapeScene.create(true) },
            { name: "Draw Animations", scene: null },
            { name: "Draw NineSlices", scene: null },
            { name: "Draw ScrollingSprites", scene: null },
            { name: "Draw Text", scene: DrawTextScene.create(true) },

            { name: "Transform Rotation", scene: null },
            { name: "Transform Anchors", scene: null },
            { name: "Transform Pivots", scene: null },
            { name: "Transform Skew", scene: null },
            { name: "Transform Pivot", scene: null },
            { name: "Transform Parents", scene: null },

        ];

        //create buttons
        var minX = 140;
        var minY = 150;

        var gapX = 175;
        var gapY = 60;

        var xx = minX;
        var yy = minY;

        for(example in _examples){
            _createButton(example.name, xx, yy, function(x, y){
               _gotoScene(example.scene);
            });

            yy += gapY;

            if(yy > Screen.height-60){
                xx += gapX;
                yy = minY;
            }
        }

    }

    private function _gotoScene(scene:Scene){
        Gecko.world.changeScene(scene);
    }

    private function _createButton(text:String, x:Float32, y:Float32, callback:Float32->Float32->Void) {
        //Button sprite
        var btn = Entity.create();
        btn.addComponent(TransformComponent.create(x, y));
        btn.addComponent(NineSliceComponent.create("images/green_panel.png", 160, 50));

        //button text
        var txt = Entity.create();
        txt.addComponent(TransformComponent.create(x, y));
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
            btn.renderer.color = Color.LightGreen;
        };

        mouse.onOut += function(x:Float32, y:Float32){
            btn.renderer.color = Color.White;
        };

        //trigger the callback when the button it's clicked
        mouse.onClick += callback;

        //add the entities to this scene
        addEntity(btn);
        addEntity(txt);
    }

    private function _addTitle(x:Float32, y:Float32) {
        var entity = Entity.create();
        entity.addComponent(TransformComponent.create(x, y));
        entity.addComponent(TextComponent.create("Gecko2D Demo", "Ubuntu-B.ttf", 70));
        addEntity(entity);
    }
}
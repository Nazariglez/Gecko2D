package scenes;

import gecko.render.Graphics;
import gecko.Scene;
import gecko.Gecko;
import gecko.Color;
import gecko.components.input.MouseComponent;
import gecko.components.draw.NineSliceComponent;
import gecko.Float32;
import gecko.Screen;
import gecko.Entity;
import gecko.math.Point;
import gecko.components.core.TransformComponent;
import gecko.components.draw.TextComponent;
import gecko.Transform;

import scenes.DrawSpriteScene;
import scenes.DrawTextScene;
import scenes.DrawShapeScene;
import scenes.DrawNineSliceScene;
import scenes.DrawScrollingSpriteScene;

typedef ExamplesDef = {
    name:String,
    scene:Scene
};

class MainScene extends CustomScene {
    static var _examples:Array<ExamplesDef> = [];

    override public function init(closeButton:Bool = false) {
        super.init(closeButton);

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
            if(example.scene != null)trace(example.scene.isAlreadyDestroyed);
            _createButton(example.name, xx, yy, function(x, y){
               _gotoScene(example.scene);
            });

            yy += gapY;

            if(yy > Screen.height-60){
                xx += gapX;
                yy = minY;
            }
        }

        var e1 = Entity.create();
        e1.trans.size.set(20, 20);
        //e1.trans.localScale.set(4,4);
        e1.trans.position.set(450, 200);

        var e2 = Entity.create();
        e2.trans.parent = e1.trans;
        e2.trans.size.set(20, 20);
        e2.trans.position.set(460, 210);
        //e2.trans.localPosition.set(5,5);

        var e3 = Entity.create();
        e3.trans.parent = e2.trans;
        e3.trans.size.set(20, 20);
        e3.trans.position.set(470, 220);
        //e3.trans.localPosition.set(5,5);

        var e4 = Entity.create();
        e4.trans.parent = e3.trans;
        e4.trans.size.set(20, 20);
        e4.trans.position.set(480,230);
        //e4.trans.localPosition.set(10,10);

        var list:Map<String, Entity> = [
            "e1" => e1,
            "e2" => e2,
            "e3" => e3,
            "e4" => e4
        ];

        untyped js.Browser.window.e = list;
        untyped js.Browser.window.test = function(){
          for(en in list.keys()){
              trace(en, list.get(en).trans);
          }
        };

        //trace("1 - ",e1.trans, e2.trans, e3.trans, e4.trans);

        Gecko.onDraw += function(g:Graphics) {
            var m = g.matrix;

            g.matrix = e1.trans.worldMatrix;
            g.color = Color.Red;
            g.drawRect(0,0, e1.trans.size.x, e1.trans.size.y, 2);
            g.color = Color.White;
            g.drawRect(0,0, 1, 1, 2);

            g.matrix = e2.trans.worldMatrix;
            g.color = Color.Blue;
            g.drawRect(0,0, e2.trans.size.x, e2.trans.size.y, 2);
            g.color = Color.White;
            g.drawRect(0,0, 1, 1, 2);

            g.matrix = e3.trans.worldMatrix;
            g.color = Color.Green;
            g.drawRect(0,0, e3.trans.size.x, e3.trans.size.y, 2);
            g.color = Color.White;
            g.drawRect(0,0, 1, 1, 2);

            g.matrix = e4.trans.worldMatrix;
            g.color = Color.Yellow;
            g.drawRect(0,0, e4.trans.size.x, e4.trans.size.y, 2);
            g.color = Color.White;
            g.drawRect(0,0, 1, 1, 2);

            g.reset();
            g.color = Color.Orange;
            g.drawRect(480, 230, 2, 2, 2);
            g.drawRect(470, 220, 2, 2, 2);
            g.drawRect(460, 210, 2, 2, 2);
            g.drawRect(450, 200, 2, 2, 2);

            for(en in list.keys()){
                //list.get(en).trans.rotation += 0.5* Math.PI/180;
                //@:privateAccess list.get(en).trans._setDirty(true);
            }

            //e1.trans.localPosition.x += 0.5;
            //e2.trans.localPosition.y += 1;
        };

        //e2.trans.localPosition.set(0, 0);

        //trace("2 - ",e1.trans, e2.trans, e3.trans);

    }

    private function _initExamples() {
        if(_examples.length == 0){
            trace("INIT");
            _examples = [
                { name: "Draw Sprites", scene: DrawSpriteScene.create(true) },
                { name: "Draw Shapes", scene: DrawShapeScene.create(true) },
                { name: "Draw Animations", scene: null },
                { name: "Draw NineSlices", scene: DrawNineSliceScene.create(true) },
                { name: "Draw ScrollingSprites", scene: DrawScrollingSpriteScene.create(true) },
                { name: "Draw Text", scene: DrawTextScene.create(true) },

                { name: "Transform Rotation", scene: null },
                { name: "Transform Anchors", scene: null },
                { name: "Transform Pivots", scene: null },
                { name: "Transform Skew", scene: null },
                { name: "Transform Pivot", scene: null },
                { name: "Transform Parents", scene: null },
            ];
        }
    }

    private function _gotoScene(scene:Scene){
        Gecko.world.changeScene(scene, true);
    }

    private function _createButton(text:String, x:Float32, y:Float32, callback:Float32->Float32->Void) {
        //Button sprite
        var btn = Entity.create();
        btn.addComponent(TransformComponent.create(x, y));
        btn.addComponent(NineSliceComponent.create("images/kenney/green_panel.png", 160, 50));

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
package scenes;

import gecko.Scene;
import gecko.Entity;
import gecko.Color;
import gecko.render.Renderer;

class MainScene extends Scene {
    static public inline var Name:String = "main-scene";

    override public function new(){
        super(Name);

        var demoEntity = new DemoEntity();
        demoEntity.position.set(400, 300);
        demoEntity.addTo(this);
    }
}

class DemoEntity extends Entity {
    public function new(){
        super();
        size.set(50, 50);
        rotationSpeed = 45*Math.PI/180;
        tint = Color.Red;
    }

    override public function render(r:Renderer){
        super.render(r);
        r.color = tint;
        r.fillRect(0, 0, width, height);
    }
}
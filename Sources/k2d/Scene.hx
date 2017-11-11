package k2d;

import k2d.utils.Color;
import k2d.render.Renderer;

class Scene extends Container {
    public var id:String = "";
    public var transparent:Bool = true;
    public var backgroundColor:Color = Color.BLACK;

    public override function new(id:String){
        super();
        this.id = id;

        anchor.set(0,0);
        pivot.set(0,0);
        sizeByChildren = false;
    }

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);
        
        if(!transparent){
            //draw background color
            r.color = backgroundColor;
            r.fillRect(0, 0, this.size.x, this.size.y);
        }

        super.render(r);
    }
}
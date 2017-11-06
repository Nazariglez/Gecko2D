package k2d;

import k2d.render.Renderer2D;
import k2d.math.FastFloat;

class Container extends Entity {
    public var children:Array<Entity> = new Array<Entity>();

    public function addChild(child:Entity) {
        child.parent = this;
        children.push(child);
    }

    public function removeChild(child:Entity) {
        child.parent = null;
        children.remove(child);
    }

    public override function update(dt:FastFloat) {
        super.update(dt);
        var minX:FastFloat = Math.POSITIVE_INFINITY;
        var maxX:FastFloat = Math.NEGATIVE_INFINITY;
        var minY:FastFloat = Math.POSITIVE_INFINITY;
        var maxY:FastFloat = Math.NEGATIVE_INFINITY;

        for(child in children){
            child.update(dt);

            var cMinX:FastFloat = child.position.x - child.width * child.anchor.x;
            var cMaxX:FastFloat = child.position.x + child.width * (1-child.anchor.x);
            var cMinY:FastFloat = child.position.y - child.height * child.anchor.y;
            var cMaxY:FastFloat = child.position.y + child.height * (1-child.anchor.y);

            if(cMinX < minX)minX = cMinX;
            if(cMinY < minY)minY = cMinY;
            if(cMaxX > maxX)maxX = cMaxX;
            if(cMaxY > maxY)maxY = cMaxY;
        }

        size.x = maxX - minX;
        size.y = maxY - minY;
    }

    public override function render(r:Renderer2D) {
        super.render(r);
        for(child in children){
            if(child.isVisible()){
                child.render(r);
            }
        }
    }
}
package k2d;

import k2d.render.Renderer2D;

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

    public override function update(dt:Float) {
        super.update(dt);
        var minX:Float = Math.POSITIVE_INFINITY;
        var maxX:Float = Math.NEGATIVE_INFINITY;
        var minY:Float = Math.POSITIVE_INFINITY;
        var maxY:Float = Math.NEGATIVE_INFINITY;

        for(child in children){
            child.update(dt);

            var cMinX:Float = child.position.x + child.size.x * child.anchor.x;
            var cMaxX:Float = child.position.x - child.size.x * child.anchor.x;
            var cMinY:Float = child.position.y + child.size.x * child.anchor.y;
            var cMaxY:Float = child.position.y - child.size.y * child.anchor.y;

            if(cMinX < minX)minX = cMinX;
            if(cMinY < minY)minY = cMinY;
            if(cMaxX > maxX)maxX = cMaxX;
            if(cMaxY > maxY)maxY = cMaxY;
        }

        size.x = Math.abs(maxX - minX);
        size.y = Math.abs(maxY - minY);
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
package k2d;

import k2d.render.Renderer2D;
import k2d.math.FastFloat;

class Container extends Entity {
    public var children:Array<Entity> = new Array<Entity>();
    public var sizeByChildren:Bool = true;

    private var _minX:FastFloat;
    private var _maxX:FastFloat;
    private var _minY:FastFloat;
    private var _maxY:FastFloat;

    private var _cMinX:FastFloat;
    private var _cMaxX:FastFloat;
    private var _cMinY:FastFloat;
    private var _cMaxY:FastFloat;

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
        if(!sizeByChildren){
            for(child in children){
                child.update(dt);
            }
        } else {
            _minX = Math.POSITIVE_INFINITY;
            _maxX = Math.NEGATIVE_INFINITY;
            _minY = Math.POSITIVE_INFINITY;
            _maxY = Math.NEGATIVE_INFINITY;

            for(child in children){
                child.update(dt);

                _cMinX = child.position.x - child.width * child.anchor.x;
                _cMaxX = child.position.x + child.width * (1-child.anchor.x);
                _cMinY = child.position.y - child.height * child.anchor.y;
                _cMaxY = child.position.y + child.height * (1-child.anchor.y);

                if(_cMinX < _minX)_minX = _cMinX;
                if(_cMinY < _minY)_minY = _cMinY;
                if(_cMaxX > _maxX)_maxX = _cMaxX;
                if(_cMaxY > _maxY)_maxY = _cMaxY;
            }

            _setSize(_maxX - _minX, _maxY - _minY);
        }
    }

    private function _setSize(width:FastFloat, height:FastFloat) {
        //override in some entites like sprite
        size.x = width;
        size.y = height;
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
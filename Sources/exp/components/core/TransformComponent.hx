package exp.components.core;

import exp.math.Vector2g;
import exp.math.Matrix;
import exp.math.Point;
import exp.Float32;

private typedef SkewCache = {
    var cosX:Float32;
    var sinX:Float32;
    var cosY:Float32;
    var sinY:Float32;
};

class TransformComponent extends Component {
    public var parent(get, set):Entity;
    public var _parent:Entity;
    public var children:Array<Entity> = [];

    public var _branch:Int = 0;
    public var _nextChild:Entity = null;

    public var x(get, set):Float32;
    public var y(get, set):Float32;
    public var width(get, set):Float32;
    public var height(get, set):Float32;
    public var rotation(get, set):Float32;
    private var _rotation:Float32 = 0;

    public var position:Point;
    public var scale:Point;
    public var skew:Point;
    public var pivot:Point;
    public var anchor:Point;
    public var size:Point;
    public var flip:Vector2g<Bool> = new Vector2g(false, false);

    public var localMatrix:Matrix = Matrix.identity();
    public var worldMatrix:Matrix = Matrix.identity();

    public var dirtyChildrenSort = true;
    public var dirtySkew:Bool = true;
    public var dirty:Bool = true;

    public var skewCache:SkewCache = {
        cosX: 0,
        cosY: 0,
        sinX: 0,
        sinY: 0
    };

    public function init(x:Float32, y:Float32, ?xSize:Float32, ?ySize:Float32) {
        enabled = true;

        dirtyChildrenSort = true;
        dirtySkew = true;
        dirty = true;

        position = Point.create(x, y);
        position.setObserver(_setDirty);

        scale = Point.create(1, 1);
        scale.setObserver(_setDirty);

        skew = Point.create();
        skew.setObserver(_setDirtySkew);

        pivot = Point.create(0.5, 0.5);
        pivot.setObserver(_setDirty);

        anchor = Point.create(0.5, 0.5);
        anchor.setObserver(_setDirty);

        size = Point.create(xSize != null ? xSize : 1, ySize != null ? ySize : xSize);
        size.setObserver(_setDirty);
    }

    override public function reset(){
        enabled = false;

        parent = null;
        if(children.length != 0){
            var copyChildren = children.copy();
            for(e in copyChildren){
                e.transform.parent = null;
            }
        }

        position.removeObserver();
        position.destroy();

        scale.removeObserver();
        scale.destroy();

        skew.removeObserver();
        skew.destroy();

        pivot.removeObserver();
        pivot.destroy();

        anchor.removeObserver();
        anchor.destroy();

        size.removeObserver();
        size.destroy();

        flip.set(false, false); //todo add observer

        rotation = 0;
        skewCache.cosX = 0;
        skewCache.cosY = 0;
        skewCache.sinX = 0;
        skewCache.sinY = 0;
    }

    public function apply(point:Point, cachePoint:Point = null) : Point {
        if(cachePoint == null){
            cachePoint = Point.create();
        }

        cachePoint.x = worldMatrix._00 * point.x + worldMatrix._10 * point.y + worldMatrix._20;
        cachePoint.y = worldMatrix._01 * point.x + worldMatrix._11 * point.y + worldMatrix._21;

        return cachePoint;
    }

    public function applyInverse(point:Point, cachePoint:Point = null) : Point {
        if(cachePoint == null){
            cachePoint = Point.create();
        }

        var id = 1 / ((worldMatrix._00 * worldMatrix._11) + (worldMatrix._10 * -worldMatrix._01));
        cachePoint.x = (worldMatrix._11 * id * point.x) + (-worldMatrix._10 * id * point.y) + (((worldMatrix._21 * worldMatrix._10) - (worldMatrix._20 * worldMatrix._11)) * id);
        cachePoint.y = (worldMatrix._00 * id * point.y) + (-worldMatrix._01 * id * point.x) + (((-worldMatrix._21 * worldMatrix._00) + (worldMatrix._20 * worldMatrix._01)) * id);

        return cachePoint;
    }

    private function _setDirtySkew(point:Point) {
        dirtySkew = true;
        dirty = true;
    }

    private function _setDirty(point:Point) {
        dirty = true;
    }

    public function setDirtyChildrenSort(entity:Entity) {
        dirtyChildrenSort = true;
    }

    inline function get_x():Float32 {
        return position.x;
    }

    inline function set_x(value:Float32):Float32 {
        return position.x = value;
    }

    inline function set_y(value:Float32):Float32 {
        return position.y = value;
    }

    inline function get_y():Float32 {
        return position.y;
    }

    inline function get_width():Float32 {
        return scale.x * size.x;
    }

    inline function set_width(value:Float32):Float32 {
        scale.x = value / size.x;
        return value;
    }

    inline function set_height(value:Float32):Float32 {
        scale.y = value / size.y;
        return value;
    }

    inline function get_height():Float32 {
        return scale.y * size.y;
    }

    inline function get_rotation():Float32 {
        return _rotation;
    }

    function set_rotation(value:Float32):Float32 {
        dirty = true;
        dirtySkew = true;
        return _rotation = value;
    }

    inline function get_parent():Entity {
        return _parent;
    }

    function set_parent(value:Entity):Entity {
        if(value == _parent)return value;

        if(_parent != null){
            _parent.transform.children.remove(this.entity);
            this.entity.onDepthChanged -= _parent.transform.setDirtyChildrenSort;
        }

        _parent = value;

        if(_parent != null){
            _parent.transform.children.push(this.entity);
            this.entity.onDepthChanged += _parent.transform.setDirtyChildrenSort;
            _parent.transform.setDirtyChildrenSort(null);
        }

        return _parent;
    }

}
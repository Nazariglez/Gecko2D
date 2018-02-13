package exp.components;

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
    public var parent:Entity;

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

    public var worldMatrix(get, set):Matrix;
    private var _worldMatrix:Matrix = Matrix.identity();

    public var dirtySkew:Bool = true;
    public var dirtyWorldTransform:Bool = true;
    public var dirty:Bool = true;

    public var skewCache:SkewCache = {
        cosX: 0,
        cosY: 0,
        sinX: 0,
        sinY: 0
    };

    public function init(x:Float32, y:Float32, ?xSize:Float32, ?ySize:Float32) {
        dirtySkew = true;
        dirtyWorldTransform = true;
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

    private function _calculateWorldTransform() {
        if(parent == null){
            _worldMatrix.setFrom(localMatrix);
        }else{
            var _parentTransform = parent.transform.worldMatrix;

            _worldMatrix._00 = (localMatrix._00 * _parentTransform._00) + (localMatrix._01 * _parentTransform._10);
            _worldMatrix._01 = (localMatrix._00 * _parentTransform._01) + (localMatrix._01 * _parentTransform._11);
            _worldMatrix._10 = (localMatrix._10 * _parentTransform._00) + (localMatrix._11 * _parentTransform._10);
            _worldMatrix._11 = (localMatrix._10 * _parentTransform._01) + (localMatrix._11 * _parentTransform._11);

            _worldMatrix._20 = (localMatrix._20 * _parentTransform._00) + (localMatrix._21 * _parentTransform._10) + _parentTransform._20;
            _worldMatrix._21 = (localMatrix._20 * _parentTransform._01) + (localMatrix._21 * _parentTransform._11) + _parentTransform._21;
        }
        dirtyWorldTransform = false;
    }

    public function apply(point:Point, newPoint:Point = null) : Point {
        if(newPoint == null){
            newPoint = Point.create();
        }

        newPoint.x = _worldMatrix._00 * point.x + _worldMatrix._10 * point.y + _worldMatrix._20;
        newPoint.y = _worldMatrix._01 * point.x + _worldMatrix._11 * point.y + _worldMatrix._21;

        return newPoint;
    }

    public function applyInverse(point:Point, newPoint:Point = null) : Point {
        if(newPoint == null){
            newPoint = Point.create();
        }

        var id = 1 / ((_worldMatrix._00 * _worldMatrix._11) + (_worldMatrix._10 * -_worldMatrix._01));
        newPoint.x = (_worldMatrix._11 * id * point.x) + (-_worldMatrix._10 * id * point.y) + (((_worldMatrix._21 * _worldMatrix._10) - (_worldMatrix._20 * _worldMatrix._11)) * id);
        newPoint.y = (_worldMatrix._00 * id * point.y) + (-_worldMatrix._01 * id * point.x) + (((-_worldMatrix._21 * _worldMatrix._00) + (_worldMatrix._20 * _worldMatrix._01)) * id);

        return newPoint;
    }

    private function _setDirtySkew(point:Point) {
        dirtySkew = true;
        dirty = true;
    }

    private function _setDirty(point:Point) {
        dirty = true;
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

    function get_worldMatrix():Matrix {
        if(dirtyWorldTransform){
            _calculateWorldTransform();
        }
        return _worldMatrix;
    }

    inline function set_worldMatrix(value:Matrix):Matrix {
        return _worldMatrix = value;
    }

}
package gecko;

import gecko.math.Matrix;
import gecko.math.Vector2g;
import gecko.math.Point;

using gecko.utils.ArrayHelper;

//todo https://www.gamedev.net/articles/programming/math-and-physics/making-a-game-engine-transformations-r3566/
    //todo https://www.gamedev.net/articles/programming/general-and-gameplay-programming/making-a-game-engine-core-design-principles-r3210

@:access(gecko.math.Point)
class Transform {
    public var parent(get, set):Transform;
    private var _parent:Transform;

    private var _children:Array<Transform> = [];

    private var _branch:Int = 0;
    private var _nexChild:Transform = null;

    public var entity(default, null):Entity;

    /*public var width(get, set):Float32;
    public var height(get, set):Float32;
    public var position(get, set):Point;
    public var scale(get, set):Point;

    public var localWidth(get, set):Float32;
    public var localHeight(get, set):Float32;
    public var localPosition(get, set):Point;
    public var localScale(get, set):Point;*/

    public var localPosition(get, null):Point;
    private var _localPosition:Point;

    public var position(get, null):Point;
    private var _position:Point;

    public var scale(get, null):Point;
    private var _scale:Point;

    public var localScale(get, null):Point;
    private var _localScale:Point;

    public var skew(get, null):Point;
    private var _skew:Point;

    public var pivot(get, null):Point;
    private var _pivot:Point;

    public var anchor(get, null):Point;
    private var _anchor:Point;

    public var size(get, null):Point;
    private var _size:Point;

    public var flip(get, null):Vector2g<Bool>;
    private var _flip:Vector2g<Bool>;

    public var rotation(get, set):Float32;
    private var _rotation:Float32 = 0;

    public var localMatrix:Matrix = Matrix.identity();
    public var worldMatrix:Matrix = Matrix.identity();

    private var _dirty:Bool = true;
    private var _dirtySkew:Bool = true;
    private var _dirtyDepth:Bool = false;
    private var _dirtyPosition:Bool = true;

    private var _skewCache:SkewCache = {
        cosX: 0,
        cosY: 0,
        sinX: 0,
        sinY: 0
    };

    public function new(entity:Entity) {
        this.entity = entity;
        _flip = new Vector2g(false, false);
        _flip.setObserver(_vecDirty);

        _skew = Point.create();
        _skew.setObserver(function(p:Point){
            _dirtySkew = true;
            _pointDirty(p);
        });

        _pivot = Point.create(0.5, 0.5);
        _pivot.setObserver(_pointDirty);

        _anchor = Point.create(0.5,0.5);
        _anchor.setObserver(_pointDirty);

        _size = Point.create();
        _size.setObserver(_pointDirty);

        _position = Point.create();
        _position.setObserver(_onSetPosition);

        _localPosition = Point.create();
        _localPosition.setObserver(function(p){
            trace("setted local point");
            _pointDirtyPosition(p);
        });

        _scale = Point.create(1, 1);

        _localScale = Point.create(1, 1);

    }

    public function reset() {
        parent = null;

        while(_children.length > 0){
            _children[0].parent = null;
        }
    }

    public function updateTransform() {
        if(!_dirty)return;

        if(_parent != null){
            _parent.updateTransform();
        }

        if(_dirtySkew){
            //todo fixme it's ok this? sin in cos, X on Y. Maybe i changed the vars in the refactor to ecs?
            _skewCache.cosX = Math.cos(_rotation + _skew.y);
            _skewCache.sinX = Math.sin(_rotation + _skew.y);
            _skewCache.cosY = -Math.sin(_rotation - _skew.x);
            _skewCache.sinY = Math.cos(_rotation - _skew.x);
            
            _dirtySkew = false;
        }

        var _scX = _localScale.x * (_flip.x ? -1 : 1);
        var _scY = _localScale.y * (_flip.y ? -1 : 1);
        var _anX = _flip.x ? 1-_anchor.x : _anchor.x;
        var _anY = _flip.y ? 1-_anchor.y : _anchor.y;
        var _piX = _flip.x ? 1-_pivot.x : _pivot.x;
        var _piY = _flip.y ? 1-_pivot.y : _pivot.y;

        localMatrix._00 = _skewCache.cosX * _scX;
        localMatrix._01 = _skewCache.sinX * _scX;
        localMatrix._10 = _skewCache.cosY * _scY;
        localMatrix._11 = _skewCache.sinY * _scY;

        var _aW = _anX * _size.x;
        var _aH = _anY * _size.y;
        var _pW = _piX * _size.x;
        var _pH = _piY * _size.y;

        localMatrix._20 = _localPosition.x - _aW * _scX + _pW * _scX;
        localMatrix._21 = _localPosition.y - _aH * _scY + _pH * _scY;

        if(_pW != 0 || _pH != 0){
            localMatrix._20 -= _pW * localMatrix._00 + _pH * localMatrix._10;
            localMatrix._21 -= _pW * localMatrix._01 + _pH * localMatrix._11;
        }

        if(_parent != null){
            var _parentTransform = _parent.worldMatrix;

            worldMatrix._00 = (localMatrix._00 * _parentTransform._00) + (localMatrix._01 * _parentTransform._10);
            worldMatrix._01 = (localMatrix._00 * _parentTransform._01) + (localMatrix._01 * _parentTransform._11);
            worldMatrix._10 = (localMatrix._10 * _parentTransform._00) + (localMatrix._11 * _parentTransform._10);
            worldMatrix._11 = (localMatrix._10 * _parentTransform._01) + (localMatrix._11 * _parentTransform._11);

            worldMatrix._20 = (localMatrix._20 * _parentTransform._00) + (localMatrix._21 * _parentTransform._10) + _parentTransform._20;
            worldMatrix._21 = (localMatrix._20 * _parentTransform._01) + (localMatrix._21 * _parentTransform._11) + _parentTransform._21;
            
            if(_dirtyPosition){
                _position._setX(_parentTransform._00 * _localPosition.x + _parentTransform._10 * _localPosition.y + _parentTransform._20);
                _position._setY(_parentTransform._01 * _localPosition.x + _parentTransform._11 * _localPosition.y + _parentTransform._21);
            }

        }else{
            worldMatrix.setFrom(localMatrix);

            if(_dirtyPosition){
                _position._setX(_localPosition.x);
                _position._setY(_localPosition.y);
            }
        }

        _dirtyPosition = false;
        _dirty = false;
    }

    private function _onSetPosition(p:Point) {
        if(_parent != null){
            var pm = _parent.worldMatrix;
            var id = 1 / ((pm._00 * pm._11) + (pm._10 * -pm._01));
            _localPosition._setX((pm._11 * id * p.x) + (-pm._10 * id * p.y) + (((pm._21 * pm._10) - (pm._20 * pm._11)) * id));
            _localPosition._setY((pm._00 * id * p.y) + (-pm._01 * id * p.x) + (((-pm._21 * pm._00) + (pm._20 * pm._01)) * id));
        }else{
            _localPosition._setX(p.x);
            _localPosition._setY(p.y);
        }

        _setDirty(true);

        //avoid to recaulate the coords of this transform
        //because its the origin of the change
        _dirtyPosition = false;
    }

    private function _vecDirty(vec:Vector2g<Bool>) {
        _setDirty();
    }

    private function _pointDirty(point:Point) {
        _setDirty();
    }

    private function _pointDirtyPosition(point:Point) {
        _setDirty(true);
    }

    private function _setDirty(positionDirty:Bool = false, rotationDirty:Bool = false){
        if(_dirty && _dirtySkew == rotationDirty && _dirtyPosition == positionDirty)return;

        _dirty = true;
        if(rotationDirty && !_dirtySkew){
            _dirtySkew = true;
        }

        if(positionDirty && !_dirtyPosition){
            _dirtyPosition = true;
        }

        for(child in _children){
            child._setDirty(_dirtyPosition, _dirtySkew);
        }
    }

    public function localToScreen(point:Point, cachePoint:Point = null) : Point {
        if(cachePoint == null){
            cachePoint = Point.create();
        }

        var xx = point.x;
        var yy = point.y;

        cachePoint.x = worldMatrix._00 * xx + worldMatrix._10 * yy + worldMatrix._20;
        cachePoint.y = worldMatrix._01 * xx + worldMatrix._11 * yy + worldMatrix._21;

        return cachePoint;
    }


    public function screenToLocal(point:Point, cachePoint:Point = null) : Point {
        if(cachePoint == null){
            cachePoint = Point.create();
        }

        var xx = point.x;
        var yy = point.y;

        var id = 1 / ((worldMatrix._00 * worldMatrix._11) + (worldMatrix._10 * -worldMatrix._01));
        cachePoint.x = (worldMatrix._11 * id * xx) + (-worldMatrix._10 * id * yy) + (((worldMatrix._21 * worldMatrix._10) - (worldMatrix._20 * worldMatrix._11)) * id);
        cachePoint.y = (worldMatrix._00 * id * yy) + (-worldMatrix._01 * id * xx) + (((-worldMatrix._21 * worldMatrix._00) + (worldMatrix._20 * worldMatrix._01)) * id);

        return cachePoint;
    }

    inline public function localToLocal(from:Transform, point:Point, cachePoint:Point = null) : Point {
        return screenToLocal(cachePoint = from.localToScreen(point, cachePoint), cachePoint);
    }

    inline public function getChildrenLength() : Int {
        return _children.length;
    }

    inline public function getChild(index:Int) : Transform {
        return _children[index];
    }

    inline public function toString() : String {
        return 'Transform: position -> ${position}, localPosition -> ${localPosition}';
    }

    inline function get_parent():Transform {
        return _parent;
    }

    function set_parent(value:Transform):Transform {
        if(value == _parent)return _parent;

        if(_parent != null){
            _parent._children.remove(this);
        }

        _parent = value;

        if(_parent != null){
             _parent._children.push(this);
            //todo sort children
        }

        _setDirty(true);

        return _parent;
    }

    function get_localPosition():Point {
        if(_dirty)updateTransform();
        return _localPosition;
    }

    function get_position():Point {
        if(_dirty)updateTransform();

        return _position;
    }

    function get_scale():Point {
        if(_dirty)updateTransform();
        return _scale;
    }

    function get_localScale():Point {
        if(_dirty)updateTransform();
        return _localScale;
    }

    function get_size():Point {
        if(_dirty)updateTransform();
        return _size;
    }

    function get_anchor():Point {
        if(_dirty)updateTransform();
        return _anchor;
    }

    function get_skew():Point {
        if(_dirty)updateTransform();
        return _skew;
    }

    function get_pivot():Point {
        if(_dirty)updateTransform();
        return _pivot;
    }

    function get_flip():Vector2g<Bool> {
        if(_dirty)updateTransform();
        return _flip;
    }

    function get_rotation():Float32 {
        if(_dirty)updateTransform();
        return _rotation;
    }

    function set_rotation(value:Float32):Float32 {
        if(value == _rotation)return _rotation;
        _dirtySkew = true;
        _setDirty();
        return _rotation = value;
    }

}

private typedef SkewCache = {
    var cosX:Float32;
    var sinX:Float32;
    var cosY:Float32;
    var sinY:Float32;
};
package gecko;

import gecko.math.Matrix;
import gecko.math.Vector2g;
import gecko.math.Point;

using gecko.utils.ArrayHelper;

//todo https://www.gamedev.net/articles/programming/math-and-physics/making-a-game-engine-transformations-r3566/
    //todo https://www.gamedev.net/articles/programming/general-and-gameplay-programming/making-a-game-engine-core-design-principles-r3210

@:access(gecko.math.Point)
class Transform {
    dynamic static function sortChildrenHandler(a:Transform, b:Transform) : Int {
        if (a.depth < b.depth) return -1;
        if (a.depth > b.depth) return 1;
        return 0;
    }

    public var parent(get, set):Transform;
    private var _parent:Transform;

    private var _children:Array<Transform> = [];

    private var _branch:Int = 0;
    private var _nexChild:Transform = null;

    public var entity(default, null):Entity;

    public var width(get, set):Float32;
    public var localWidth(get, set):Float32;

    public var height(get, set):Float32;
    public var localHeight(get, set):Float32;

    public var localPosition(get, null):Point;
    private var _localPosition:Point;

    public var position(get, null):Point;
    private var _position:Point;

    public var scale(get, null):Point;
    private var _scale:Point;

    public var localScale(get, null):Point;
    private var _localScale:Point;

    //public var skew(get, null):Point;
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

    public var localRotation(get, set):Float32;
    private var _localRotation:Float32 = 0;

    public var top(get, null):Float32;
    public var localTop(get, null):Float32;
    public var bottom(get, null):Float32;
    public var localBottom(get, null):Float32;
    public var left(get, null):Float32;
    public var localLeft(get, null):Float32;
    public var right(get, null):Float32;
    public var localRight(get, null):Float32;

    public var depth:Int = 0; //todo

    public var localMatrix:Matrix = Matrix.identity();
    public var worldMatrix:Matrix = Matrix.identity();

    private var _dirty:Bool = true;
    private var _dirtyAngle:Bool = true;
    private var _dirtyScale:Bool = true;
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
        _skew.setObserver(_onSetSkew);

        _pivot = Point.create(0.5, 0.5);
        _pivot.setObserver(_pointDirtyPosition);

        _anchor = Point.create(0.5,0.5);
        _anchor.setObserver(_pointDirtyPosition);

        _size = Point.create();
        _size.setObserver(_pointDirtyPosition);

        _position = Point.create();
        _position.setObserver(_onSetPosition);

        _localPosition = Point.create();
        _localPosition.setObserver(_pointDirtyPosition);

        _scale = Point.create(1, 1);
        _scale.setObserver(_onSetScale);

        _localScale = Point.create(1, 1);
        _localScale.setObserver(_onSetLocalScale);
    }

    public function sortChildren(?handler:Transform->Transform->Int) {
        if(handler == null){
            handler = Transform.sortChildrenHandler;
        }

        _children.sort(handler);

        //todo emit onSortChirldren
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

        if(_dirtyAngle){
            //todo fixme it's ok this? sin in cos, X on Y. Maybe i changed the vars in the refactor to ecs?
            _skewCache.cosX = Math.cos(_rotation + _skew.y);
            _skewCache.sinX = Math.sin(_rotation + _skew.y);
            _skewCache.cosY = -Math.sin(_rotation - _skew.x);
            _skewCache.sinY = Math.cos(_rotation - _skew.x);
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

            //set world position
            if(_dirtyPosition){
                _position._setX(_parentTransform._00 * _localPosition.x + _parentTransform._10 * _localPosition.y + _parentTransform._20);
                _position._setY(_parentTransform._01 * _localPosition.x + _parentTransform._11 * _localPosition.y + _parentTransform._21);
            }

            //set world scale
            if(_dirtyScale){
                _scale._setX(_localScale.x*_parent._scale.x);
                _scale._setY(_localScale.y*_parent._scale.y);
            }

            //set world rotation
            if(_dirtyAngle) {
                _rotation = _localRotation + _parent._rotation;
            }

        }else{
            worldMatrix.setFrom(localMatrix);

            if(_dirtyPosition){
                _position._setX(_localPosition.x);
                _position._setY(_localPosition.y);
            }

            if(_dirtyScale){
                _scale._setX(_localScale.x);
                _scale._setY(_localScale.y);
            }

            if(_dirtyAngle) {
                _rotation = _localRotation;
            }
        }

        _dirtyAngle = false;
        _dirtyScale = false;
        _dirtyPosition = false;
        _dirty = false;
    }

    private function _onSetSkew(p:Point){
        _setDirty(true, false, true);
    }

    private function _onSetScale(p:Point) {
        if(_parent != null){
            _localScale._setX(_scale.x/_parent._scale.x);
            _localScale._setY(_scale.y/_parent._scale.y);
        }else{
            _localScale._setX(_scale.x);
            _localScale._setY(_scale.y);
        }

        _setDirty(true, true);
        _dirtyPosition = false;
        _dirtyScale = false;
    }

    private function _onSetLocalScale(p:Point) {
        _setDirty(true, true);
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
        _setDirty(true);
        _dirtyPosition = false;
    }

    private function _pointDirtyPosition(point:Point) {
        _setDirty(true);
    }

    private function _setDirty(positionDirty:Bool = false, scaleDirty:Bool = false, rotationDirty:Bool = false){
        if( _dirty
            && _dirtyAngle == rotationDirty
            && _dirtyPosition == positionDirty
            && _dirtyScale == scaleDirty
        ) return;

        _dirty = true;
        if(rotationDirty && !_dirtyAngle){
            _dirtyAngle = true;
        }

        if(positionDirty && !_dirtyPosition){
            _dirtyPosition = true;
        }

        if(scaleDirty && !_dirtyScale){
            _dirtyScale = true;
        }

        for(child in _children){
            child._setDirty(_dirtyPosition, _dirtyScale, _dirtyAngle);
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
        return 'Transform: position -> ${position}, localPosition -> ${localPosition}, ';
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

        _setDirty(true, true, true);

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

    /*function get_skew():Point {
        if(_dirty)updateTransform();
        return _skew;
    }*/

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
        _rotation = value;

        if(_parent != null){
            _localRotation = _rotation + _parent._rotation;
        }else{
            _localRotation = _rotation;
        }

        _setDirty(true, false, true);
        _dirtyPosition = false;
        return _rotation;
    }

    function get_localRotation():Float32 {
        if(_dirty)updateTransform();
        return _localRotation;
    }

    function set_localRotation(value:Float32):Float32 {
        if(value == _localRotation)return _localRotation;
        _localRotation = value;
        _setDirty(true, false, true);
        _dirtyPosition = false;
        return _localRotation;
    }

    inline function get_width():Float32 {
        return scale.x * size.x;
    }

    inline function get_localWidth():Float32 {
        return localScale.x * size.x;
    }

    inline function set_width(value:Float32):Float32 {
        return scale.x = value / size.x;
    }

    inline function set_localWidth(value:Float32):Float32 {
        return localScale.x = value / size.x;
    }

    inline function get_height():Float32 {
        return scale.y * size.y;
    }

    inline function get_localHeight():Float32 {
        return localScale.y * size.y;
    }

    inline function set_height(value:Float32):Float32 {
        return scale.y = value / size.y;
    }

    inline function set_localHeight(value:Float32):Float32 {
        return localScale.y = value / size.y;
    }

    inline function get_top():Float32 {
        return position.y - height * anchor.x;
    }

    inline function get_bottom():Float32 {
        return position.y + height * anchor.y;
    }

    inline function get_left():Float32 {
        return position.x - width * anchor.x;
    }

    inline function get_right():Float32 {
        return position.x + width * anchor.x;
    }

    inline function get_localTop():Float32 {
        return localPosition.y - localHeight * anchor.x;
    }

    inline function get_localBottom():Float32 {
        return localPosition.y + localHeight * anchor.y;
    }

    inline function get_localLeft():Float32 {
        return localPosition.x - localWidth * anchor.x;
    }

    inline function get_localRight():Float32 {
        return localPosition.x + localWidth * anchor.x;
    }

}

private typedef SkewCache = {
    var cosX:Float32;
    var sinX:Float32;
    var cosY:Float32;
    var sinY:Float32;
};
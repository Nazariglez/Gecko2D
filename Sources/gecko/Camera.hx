package gecko;

import gecko.macros.IAutoPool;
import gecko.resources.Image;
import gecko.math.Matrix;
import gecko.math.Point;

using gecko.utils.MathHelper;

//todo merge _transform and _containerTransform to avoid extra clacultaions

class Camera implements IAutoPool implements IUpdatable {
    public var id(default, null):Int = Gecko.getUniqueID();

    private var _transform:Transform;
    private var _containerTransform:Transform;

    public var lookAt(default, null):Point;
    //public var scale(get, null):Point;

    public var rotation(get, set):Float32;

    public var zoom(get, set):Float32;
    private var _zoom:Float32 = 1;

    public var matrix(get, null):Matrix;
    private var _matrix:Matrix = Matrix.identity();

    public var buffer(default, null):Image;

    public var x:Int = 0;
    public var y:Int = 0;
    public var width(default, null):Int = 0;
    public var height(default, null):Int = 0;
    public var bgColor:Color = Color.Black;

    public var followTarget(default, null):Entity;

    private var _dirty:Bool = true;

    public var wasChanged(get, set):Bool;
    private var _wasChanged:Bool = true;

    public function new(){
        _containerTransform = new Transform(null);
        _transform = new Transform(null);
    }

    public function init(x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0){
        this.x = x;
        this.y = y;

        resize(
            width == 0 ? Std.int(Screen.width) - x : width,
            height == 0 ? Std.int(Screen.height) - y : height
        );

        _containerTransform.anchor.set(0.5, 0.5);
        _containerTransform.pivot.set(0.5,0.5);
        _containerTransform.size.set(this.width, this.height);
        _containerTransform.position.set(this.width/2, this.height/2);

        lookAt = Point.create(0,0);
        lookAt.setObserver(_onSetLookAt);
        lookAt.set(this.width/2, this.height/2);
        
        _dirty = true;
    }

    public function update(delta:Float32) {
        if(followTarget != null){
            lookAt.copy(followTarget.transform.position);
        }
    }

    public function follow(entity:Entity) {
        followTarget = entity;
    }

    public function resize(width:Int, height:Int) {
        this.width = width;
        this.height = height;

        if(buffer != null){
            buffer.unload();
        }

        var antialiasing = @:privateAccess Gecko._opts.antialiasing;
        buffer = Image.createRenderTarget(width, height, antialiasing);
    }

    inline public function containsScreenPoint(p:Point) : Bool {
        return (p.x >= x && p.x <= x+width) && (p.y >= y && p.y <= y+height);
    }
    
    public function updateMatrix() {
        if(!_dirty)return;

        _matrix.inheritTransform(_transform.localMatrix, _containerTransform.worldMatrix);
        _dirty = false;

        _wasChanged = true;
    }

    public function beforeDestroy() {
        buffer.unload();
        buffer = null;

        x = 0;
        y = 0;
        width = 0;
        height = 0;
        bgColor = Color.Black;

        _zoom = 1;

        _dirty = true;

        _wasChanged = true;

        @:privateAccess _containerTransform._reset();
        @:privateAccess _transform._reset();
    }

    private function _onSetLookAt(p:Point) {
        _transform.position.set(
            -p.x + width/2, -p.y + height/2
        );
        _dirty = true;
    }

    /*inline public function toString() : String {
        return 'Camera: ';
    }*/

    /*function get_scale():Point {
        return _transform.scale;
    }*/

    inline function get_zoom():Float32 {
        return _zoom;
    }

    function set_zoom(value:Float32):Float32 {
        _dirty = true;
        _containerTransform.scale.set(value, value);
        return _zoom = value;
    }

    function get_matrix():Matrix {
        if(_dirty)updateMatrix();
        return _matrix;
    }

    inline function get_rotation():Float32 {
        return _containerTransform.rotation;
    }

    function set_rotation(value:Float32):Float32 {
        _dirty = true;
        return _containerTransform.rotation = value;
    }

    function get_wasChanged():Bool {
        if(_dirty)updateMatrix();
        return _wasChanged;
    }

    inline function set_wasChanged(value:Bool):Bool {
        return _wasChanged = value;
    }

}
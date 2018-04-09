package gecko;

import gecko.math.Rect;
import gecko.utils.Event;
import gecko.macros.IAutoPool;
import gecko.resources.Image;
import gecko.math.Matrix;
import gecko.math.Point;

using gecko.utils.MathHelper;

//todo merge _transform and _containerTransform to avoid extra calculations

    //TODO add bounds, deadzone and pltaform modes

class Camera implements IAutoPool implements IUpdatable {
    public var id(default, null):Int = Gecko.getUniqueID();

    public var scene(get, set):Scene;
    private var _scene:Scene = null;

    private var _transform:Transform;
    private var _containerTransform:Transform;

    public var lookAt(default, null):Point;
    public var followLerp(default, null):Point;
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
    public var bgColor:Null<Color> = null;

    public var target(default, null):Entity;

    private var _dirty:Bool = true;

    public var wasChanged(get, set):Bool;
    private var _wasChanged:Bool = true;

    public var bounds:Rect = null;
    public var deadzone:Rect = null;
    public var style:CameraStyle = CameraStyle.LOCKON;

    public var onAddedToScene:Event<Camera->Scene->Void>;
    public var onRemovedFromScene:Event<Camera->Scene->Void>;

    public function new(){
        _containerTransform = new Transform(null);
        _transform = new Transform(null);

        onAddedToScene = Event.create();
        onRemovedFromScene = Event.create();
    }

    public function init(x:Int = 0, y:Int = 0, width:Int = 0, height:Int = 0, ?color:Color){
        this.x = x;
        this.y = y;

        this.bgColor = color;

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

        followLerp = Point.create(1,1);
        
        _dirty = true;
    }

    private function _onSetPoint(p:Point) {
        _dirty = true;
    }

    public function update(dt:Float32) {
        if(target != null){
            var pos = target.transform.position;

            if(deadzone != null){
                var sx = width/2;
                var sy = height/2;

                var xx = lookAt.x;
                var yy = lookAt.y;

                var offset = (lookAt.x - sx + deadzone.left) - pos.x;
                if(offset > 0){
                    xx = followLerp.x.lerp(lookAt.x, lookAt.x - offset);
                }else{

                    offset = (lookAt.x - sx + deadzone.right) - pos.x;
                    if(offset < 0){
                        xx = followLerp.x.lerp(lookAt.x, lookAt.x - offset);
                    }

                }

                offset = (lookAt.y - sy + deadzone.top) - pos.y;
                if(offset > 0){
                    yy = followLerp.y.lerp(lookAt.y, lookAt.y - offset);
                }else{

                    offset = (lookAt.y - sy + deadzone.bottom) - pos.y;
                    if(offset < 0){
                        yy = followLerp.y.lerp(lookAt.y, lookAt.y - offset);
                    }

                }

                lookAt.set(xx,yy);

            }else{
                lookAt.set(
                    followLerp.x.lerp(lookAt.x, pos.x),
                    followLerp.y.lerp(lookAt.y, pos.y)
                );
            }
        }

        if(bounds != null){
            var sx = (width/_containerTransform.scale.x)/2;
            var sy = (height/_containerTransform.scale.y)/2;

            var left = lookAt.x - sx;
            var right = lookAt.x + sx;

            var top = lookAt.y - sy;
            var bottom = lookAt.y + sy;

            if(left < bounds.left){
                lookAt.x = bounds.left + sx;
            }else if(right > bounds.right){
                lookAt.x = bounds.right - sx;
            }

            if(top < bounds.top){
                lookAt.y = bounds.top + sy;
            }else if(bottom > bounds.bottom){
                lookAt.y = bounds.bottom - sy;
            }
        }

    }

    public function preDraw(g:Graphics) {}
    public function postDraw(g:Graphics) {}

    inline public function lookAtEntity(entity:Entity) {
        lookAt.copy(entity.transform.position);
    }

    public function follow(entity:Entity, ?style:CameraStyle, lerpX:Float32 = 1, lerpY:Float32 = 1) {
        target = entity;
        lookAtEntity(target);
        followLerp.set(lerpX, lerpY);

        this.style = style != null ? style : CameraStyle.LOCKON;

        switch(this.style){
            case CameraStyle.LOCKON:
                deadzone = null;

            case CameraStyle.PLATFORMER:
                var ww = width/8;
                var hh = height/3;
                deadzone = Rect.create((width - ww) / 2, (height - hh) / 2 - hh * 0.25, ww, hh);

            case CameraStyle.TOPDOWN:
                var size = Math.max(width, height)/4;
                deadzone = Rect.create((width - size) / 2, (height - size) / 2, size, size);

            case CameraStyle.TOPDOWN_TIGHT:
                var size = Math.max(width, height)/8;
                deadzone = Rect.create((width - size) / 2, (height - size) / 2, size, size);
        }
    }

    public function unfollow() {
        target = null;
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
        if(scene != null){
            scene.removeCamera(this);
        }

        buffer.unload();
        buffer = null;

        target = null;

        lookAt.destroy();
        lookAt = null;


        followLerp.destroy();
        followLerp = null;

        x = 0;
        y = 0;
        width = 0;
        height = 0;
        bgColor = Color.Black;

        _zoom = 1;

        _dirty = true;

        _wasChanged = true;

        onAddedToScene.clear();
        onRemovedFromScene.clear();

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

    inline function get_scene():Scene {
        return _scene;
    }

    function set_scene(value:Scene):Scene {
        if(value == _scene)return _scene;

        if(_scene != null){
            onRemovedFromScene.emit(this, _scene);
        }

        _scene = value;

        if(_scene != null){
            onAddedToScene.emit(this, _scene);
        }

        return _scene;
    }
}

enum CameraStyle {
    LOCKON;
    PLATFORMER;
    TOPDOWN;
    TOPDOWN_TIGHT;
}
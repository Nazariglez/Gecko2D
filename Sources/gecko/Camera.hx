package gecko;

import gecko.math.Matrix;
import gecko.math.Point;
import gecko.math.FastFloat;
import gecko.render.Renderer;

class Camera extends Container {
    public var watch:Entity;

    public var lookPosition(get, set):Point;
    public var lookZoom(get, set):FastFloat;
    public var lookRotation(get, set):FastFloat;
    public var lookPivot(get, set):Point;

    private var _matrix:Matrix = Matrix.identity();

    function get_lookPosition() : Point {
        return _internalEntity.position;
    }

    function set_lookPosition(value:Point) : Point {
        _internalEntity.position = value;
        return _internalEntity.position;
    }

    function get_lookZoom() : FastFloat {
        return _internalEntity.scale.x;
    }

    function set_lookZoom(value:FastFloat) : FastFloat {
        _internalEntity.scale.set(value, value);
        return _internalEntity.scale.x;
    }

    function get_lookRotation() : FastFloat {
        return _internalEntity.rotation;
    }

    function set_lookRotation(value:FastFloat) : FastFloat {
        _internalEntity.rotation = value;
        return _internalEntity.rotation;
    }

    function get_lookPivot() : Point {
        return _internalEntity.pivot;
    }

    function set_lookPivot(value:Point) : Point {
        _internalEntity.pivot = value;
        return _internalEntity.pivot;
    }

    private var _internalEntity:Entity;

    override public function new(width:FastFloat, height:FastFloat, ?watch:Entity){
        super(width, height);
        this.watch = watch;
        anchor.set(0,0);
        pivot.set(0,0);

        _internalEntity = new Entity(width, height);
        _internalEntity.anchor.set(0,0);
        _internalEntity.pivot.set(0,0);
        _internalEntity.parent = this;

        untyped js.Browser.window.camera = this;
    }

    override public function updateTransform(?camera:Camera){
        super.updateTransform(camera);

        _matrix.setFrom(matrixTransform.world);
        _internalEntity.updateTransform();
        matrixTransform.world.setFrom(_internalEntity.matrixTransform.world);
    }

    override public function preRender(r:Renderer){
        super.preRender(r);

        if(watch != null){
            //todo check this coords
            r.g2.scissor(Std.int(position.x), Std.int(position.y), Std.int(size.x), Std.int(size.y));
        }
    }

    override public function render(r:Renderer) {
        if(watch != null){
            watch.processRender(r, this);
        }

        matrixTransform.world.setFrom(_matrix);
        r.applyTransform(matrixTransform);

        super.render(r);
    }

    override public function postRender(r:Renderer) {
        super.postRender(r);

        if(watch != null){
            r.g2.disableScissor();
        }
    }

    public function shake(intensisty:FastFloat, duration:FastFloat) {
        //todo
    }
}
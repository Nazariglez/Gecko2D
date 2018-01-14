package gecko;

import gecko.resources.Texture;
import gecko.math.Matrix;
import gecko.math.Point;
import gecko.math.Vector2g;
import gecko.math.MatrixTransform;
import gecko.math.FastFloat;
import gecko.render.Renderer;
import gecko.render.BlendMode;
import gecko.resources.Image;

//todo @:autoBuild EntityBuilder where add static methds to pool with Entity.create and Entity.destroy
class Entity {
    public static var entityID:Int = 0;

    private var _entityID:Int = -1;

    public var position:Point = new Point(0, 0);
    public var scale:Point = new Point(1,1);
    public var skew:Point = new Point(0, 0);
    public var pivot:Point = new Point(0.5, 0.5);
    public var anchor:Point = new Point(0.5, 0.5);
    public var size:Point = new Point(1,1);
    public var speed:Point = new Point(0, 0);
    public var blendMode:BlendMode = null;
    
    public var rotationSpeed:FastFloat = 0;
    public var flip:Vector2g<Bool> = new Vector2g<Bool>(false, false);

    public var visible:Bool = true;
    public var alpha:FastFloat = 1;
    public var tint:Color = Color.White;

    public var parent:Entity = null;

    public var matrixTransform:MatrixTransform = new MatrixTransform();

    public var rotation(get, set):FastFloat;
    private var _rotation:FastFloat = 0;

    public var width(get, set):FastFloat;
    private var _width:FastFloat = 10;

    public var height(get, set):FastFloat;
    private var _height:FastFloat = 10;

    public var renderOnlyOnCamera:Bool = false;

    public function new(sizeX:FastFloat = 10, sizeY:FastFloat = 10){
        _entityID = Entity.entityID++;
        size.set(sizeX, sizeY);
        skew.setObserver(_observSkewPoint);
    }

    private function _observSkewPoint(p:Point) {
        matrixTransform.updateSkew(this);
    }

    public function updateTransform(?camera:Camera) {
        matrixTransform.updateLocal(this);
        if(parent == null){
            matrixTransform.world.setFrom(matrixTransform.local);
            matrixTransform.alpha = alpha;
        }else if(camera != null){
            matrixTransform.updateWorld(camera.matrixTransform.world);
            matrixTransform.alpha = camera.matrixTransform.alpha * alpha;
        }else{
            matrixTransform.updateWorld(parent.matrixTransform.world);
            matrixTransform.alpha = parent.matrixTransform.alpha * alpha;
        }
        matrixTransform.tint = tint;
    }

    dynamic public function update(dt:FastFloat) {
        //updateTransform();
        if(speed.x != 0){
            position.x += speed.x*dt;
        }

        if(speed.y != 0){
            position.y += speed.y*dt;
        }

        if(rotationSpeed != 0){
            rotation += rotationSpeed*dt;
        }
    }

    public function processRender(r:Renderer, ?camera:Camera) {
        if(!isVisible()){
            return;
        }

        if(renderOnlyOnCamera && camera == null){
            return;
        }

        updateTransform(camera);
        preRender(r);
        render(r);
        postRender(r);
    }

    public function processRenderWithMatrix(r:Renderer, matrix:Matrix) {
        var mm = matrixTransform.world;
        matrixTransform.world = matrix;
        matrixTransform.updateLocal(this);
        preRender(r);
        render(r);
        postRender(r);
        matrixTransform.world = mm;
    }

    public function preRender(r:Renderer) {
        r.blendMode = blendMode;
        r.applyTransform(matrixTransform);
    }
    
    dynamic public function render(r:Renderer) {}

    public function postRender(r:Renderer) {
        r.blendMode = null;
    }

    //todo get movementSpeed (cos sin speedX speedY) and direction as methods
    public function getDirection() : FastFloat {
        //todo
        return 0;
    }

    public function setSpeedDirection(speed:FastFloat, direction:FastFloat) {
        //todo
    }

    public function generateTexture() : Texture {
        var buffer = Image.createRenderTarget(Std.int(Math.ceil(size.x)), Std.int(Math.ceil(size.y)));
        var r = Gecko.renderer;
        r.beginRenderTarget(buffer);
        processRenderWithMatrix(r, Renderer.emptyMatrix);
        r.endRenderTarget();
        return new Texture(buffer);
    }

    public function scaleToFill(width:FastFloat, height:FastFloat) {
        this.width = width;
        this.height = height;
    }

    public function scaleToAspectFit(width:FastFloat, height:FastFloat) {
        scale.set(Math.min(width/size.x, height/size.y));
    }

    public function scaleToVerticalAspectFill(width:FastFloat, height:FastFloat) {
        scale.set(height/size.y);
    }

    public function scaleToHorizontalAspectFill(width:FastFloat, height:FastFloat) {
        scale.set(width/size.x);
    }

    public function toScreen(position:Point, ?point:Point) : Point {
        updateTransform(); //todo improve or cache this
        return matrixTransform.apply(position, point);
    }

    public function toLocalFrom(position:Point, from:Entity, ?point:Point) : Point {
        return matrixTransform.applyInverse(from.toScreen(position, point), point);
    }

    public function toLocal(position:Point, ?point:Point) : Point {
        updateTransform(); //todo improve or cache this
        return matrixTransform.applyInverse(position, point);
    }

    public inline function addTo(parent:Container) {
        parent.addChild(this);
    }

    dynamic public function debugRender(r:Renderer) {
        //can be overwrited dynamicaly
    }

    public inline function isVisible() : Bool {
        return visible && scale.x != 0 && scale.y != 0 && alpha > 0 && matrixTransform.alpha > 0;
    }

    function get_rotation() : FastFloat {
		return _rotation;
	}

	function set_rotation(value:FastFloat) : FastFloat {
		_rotation = value;
		matrixTransform.updateSkew(this);
		return _rotation;
	}

    function get_width() : FastFloat {
		return scale.x * size.x;
	}

	function set_width(value:FastFloat) : FastFloat {
		scale.x = value / size.x;
		return _width = value;
	}

	function get_height() : FastFloat {
		return scale.y * size.y;
	}

	function set_height(value:FastFloat) : FastFloat {
		scale.y = value / size.y;
		return _height = value;
	}
    
}
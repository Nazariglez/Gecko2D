package gecko;

import gecko.math.Point;
import gecko.math.Vector2g;
import gecko.math.MatrixTransform;
import gecko.math.FastFloat;
import gecko.render.Renderer;
import gecko.resources.Image;

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
    
    public var rotationSpeed:FastFloat = 0;
    public var flip:Vector2g<Bool> = new Vector2g<Bool>(false, false);

    public var visible:Bool = true;
    public var alpha:FastFloat = 1;
    public var worldAlpha:FastFloat = 1;
    public var tint:Color = Color.White;

    public var parent:Entity = null;

    public var matrixTransform:MatrixTransform = new MatrixTransform();

    public var rotation(get, set):FastFloat;
    private var _rotation:FastFloat = 0;

    public var width(get, set):FastFloat;
    private var _width:FastFloat = 10;

    public var height(get, set):FastFloat;
    private var _height:FastFloat = 10;

    private var _toCamera:Camera;

    public function new(sizeX:FastFloat = 10, sizeY:FastFloat = 10){
        _entityID = Entity.entityID++;
        size.set(sizeX, sizeY);
        skew.setObserver(_observSkewPoint);
    }

    private function _observSkewPoint(p:Point) {
        matrixTransform.updateSkew(this);
    }

    public function updateTransform() {
        matrixTransform.updateLocal(this);
        if(parent == null){
            matrixTransform.world.setFrom(matrixTransform.local);
            matrixTransform.alpha = alpha;
        }else if(_toCamera != null){
            matrixTransform.updateWorld(_toCamera.matrixTransform.world);
            matrixTransform.alpha = _toCamera.matrixTransform.alpha * alpha;
        }else{
            matrixTransform.updateWorld(parent.matrixTransform.world);
            matrixTransform.alpha = parent.matrixTransform.alpha * alpha;
        }
        matrixTransform.tint = tint;
    }

    public function update(dt:FastFloat) {
        updateTransform();
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

    //todo get movementSpeed (cos sin speedX speedY) and direction as methods
    
    public function render(r:Renderer) {
        if(!isVisible() || worldAlpha <= 0){ 
            return; 
        }

        r.applyTransform(matrixTransform);
    }

    public function renderToCamera(camera:Camera, r:Renderer) {
        _toCamera = camera;
        render(r);
        _toCamera = null;
    }

    public function generateTexture() : Image {
        //todo wrong position with anchors and rotations
        //todo refactor avoid extra allocations and improve/simplify this method
        var texture = Image.createRenderTarget(Std.int(Math.ceil(size.x)), Std.int(Math.ceil(size.y)));
        Renderer.helperRenderer.beginTexture(texture);
        updateTransform();
        var xx = matrixTransform.world._20;
        var yy = matrixTransform.world._21;
        matrixTransform.world._20 = 0;
        matrixTransform.world._21 = 0;
        render(Renderer.helperRenderer);
        matrixTransform.world._20 = xx;
        matrixTransform.world._21 = yy;
        Renderer.helperRenderer.endTexture();
        return texture;
    }

    public inline function addTo(parent:Container) {
        parent.addChild(this);
    }

    dynamic public function debugRender(r:Renderer) {
        //can be overwrited dynamicaly
    }

    public inline function isVisible() : Bool {
        return visible && scale.x != 0 && scale.y != 0 && alpha > 0;
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
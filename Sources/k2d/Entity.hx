package k2d;

import k2d.math.Point;
import k2d.math.Vector2g;
import k2d.math.MatrixTransform;
import k2d.math.FastFloat;
import k2d.render.Renderer2D;

class Entity {
    public static var entityID:Int = 0;

    private var _entityID:Int = -1;

    public var position:Point = new Point(0, 0);
    public var scale:Point = new Point(1,1);
    public var skew:Point = new Point(0, 0);
    public var pivot:Point = new Point(0.5, 0.5);
    public var anchor:Point = new Point(0.5, 0.5);
    public var size:Point = new Point(1,1);
    public var flip:Vector2g<Bool> = new Vector2g<Bool>(false, false);

    public var visible:Bool = true;
    public var alpha:FastFloat = 1;
    public var worldAlpha:FastFloat = 1;
    public var tint:Int = 0xffffff;

    public var parent:Entity = null;

    public var matrixTransform:MatrixTransform = new MatrixTransform();

    public var rotation(get, set):FastFloat;
    private var _rotation:FastFloat = 0;

    public var width(get, set):FastFloat;
    private var _width:FastFloat = 10;

    public var height(get, set):FastFloat;
    private var _height:FastFloat = 10;

    public function new(sizeX:FastFloat = 10, sizeY:FastFloat = 10){
        _entityID = Entity.entityID++;
        skew.setObserver(_observSkewPoint);
    }

    private function _observSkewPoint(p:Point) {
        matrixTransform.updateSkew(this);
    }

    public function update(dt:FastFloat) {
        matrixTransform.updateLocal(this);
        if(parent == null){
            matrixTransform.world.setFrom(matrixTransform.local);
            worldAlpha = alpha;
        }else{
            matrixTransform.updateWorld(parent.matrixTransform.world);
            worldAlpha = parent.worldAlpha * alpha;
        }
    }
    
    public function render(r:Renderer2D) {
        if(!isVisible() || worldAlpha <= 0){ 
            return; 
        }

        r.color = tint;
        r.alpha = worldAlpha;
        r.matrix = matrixTransform.world;
    }

    public function debugRender(r:Renderer2D) {
        
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
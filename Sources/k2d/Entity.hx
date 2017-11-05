package k2d;

import k2d.math.Point;
import k2d.math.Vector2g;
import k2d.math.MatrixTransform;
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
    public var alpha:Float = 1;
    public var worldAlpha:Float = 1;
    public var tint:Int = 0xffffff;

    public var parent:Entity = null;

    public var matrixTransform:MatrixTransform = new MatrixTransform();

    public var rotation(get, set):Float;
    private var _rotation:Float = 0;

    public var width(get, set):Float;
    private var _width:Float = 10;

    public var height(get, set):Float;
    private var _height:Float = 10;

    public function new(sizeX:Float = 10, sizeY:Float = 10){
        _entityID = Entity.entityID++;
        skew.setObserver(_observSkewPoint);
    }

    private function _observSkewPoint(p:Point) {
        matrixTransform.updateSkew(this);
    }

    private inline function _updateMatrixTransform() {
        if(parent == null){
            matrixTransform.updateLocal(this);
            matrixTransform.world.setFrom(matrixTransform.local);
            worldAlpha = alpha;
        }else{
            matrixTransform.update(this, parent.matrixTransform.world);
            worldAlpha = parent.worldAlpha * alpha;
        }
    }

    public function update(dt:Float) {}
    public function render(r:Renderer2D) {
        if(!isVisible() || worldAlpha <= 0){ 
            return; 
        }

        _updateMatrixTransform();
        r.color = tint;
        r.alpha = worldAlpha;
        r.matrix = matrixTransform.world;
    }

    public function isVisible() : Bool {
        return visible && scale.x != 0 && scale.y != 0 && alpha > 0;
    }

    function get_rotation() : Float {
		return _rotation;
	}

	function set_rotation(value:Float) : Float {
		_rotation = value;
		matrixTransform.updateSkew(this);
		return _rotation;
	}

    function get_width() : Float {
		return scale.x * size.x;
	}

	function set_width(value:Float) : Float {
		scale.x = scale.x * value / size.x;
		return _width = value;
	}

	function get_height() : Float {
		return scale.y * size.y;
	}

	function set_height(value:Float) : Float {
		scale.y = scale.y * value / size.y;
		return _height = value;
	}
    
}
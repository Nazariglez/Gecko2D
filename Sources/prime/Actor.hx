package prime;

class Actor {
	public var position:Point = new Point();
	public var scale:Point = new Point(1,1);
	public var skew:Point = new Point();
	public var pivot:Point = new Point(0.5, 0.5);
	public var anchor:Point = new Point(0.5, 0.5);
	public var visible:Bool = true;
	public var alpha:Float = 1;
	public var worldAlpha:Float = 1;
	public var zIndex:Int = 0;
	public var parent:Actor;
	public var matrix:Matrix = new Matrix();
	public var tint:Int = Color.White;
	public var flipX:Bool = false;
	public var flipY:Bool = false;

	public var rotation(get, set):Float;

	private var _rotation:Float = 0;
	
	private var _bounds:Rectangle = Rectangle.empty();
	public var bounds(get, null):Rectangle;

	private var _width:Float = 0;
	public var width(get, set):Float;

	private var _height:Float = 0;
	public var height(get, set):Float;

	public var box:Rectangle;

	public function new(){
		skew.setObserver(_skewObserver);
	}

	private function _skewObserver(point:Point) : Void {
		matrix.updateSkew(this);
	}

	private function _updateMatrix() : Void {
		if(parent == null){
			matrix.updateLocal(this);
			matrix.world.setFrom(matrix.local);
			worldAlpha = alpha;
		}else{
			matrix.update(this, parent.matrix.world);
			worldAlpha = parent.worldAlpha * alpha;
		}
	}

	public function update(delta:Float) : Void {}
	public function render(renderer:Renderer) : Void {
		if(!visible || worldAlpha <= 0)return;
		_updateMatrix();
		renderer.color = tint;
		renderer.alpha = worldAlpha;
		renderer.setMatrix(matrix.world);
	}

	public function checkBounds() : Void {
		if(box != null){
			_bounds.x = box.x - box.width * anchor.x;
			_bounds.y = box.y - box.height * anchor.y;
			_bounds.width = _bounds.x + box.width;
			_bounds.height = _bounds.y + box.height;
			return;
		}

		calculateBounds();
	}

	public function calculateBounds() : Void {
		//todo override this
	}

	function get_rotation() : Float {
		return _rotation;
	}

	function set_rotation(value:Float) : Float {
		_rotation = value;
		matrix.updateSkew(this);
		return _rotation;
	}

	function get_bounds() : Rectangle {
		//todo update bounds
		return _bounds;
	}

	function get_width() : Float {
		return _width;
	}

	function set_width(value:Float) : Float {
		return _width = value;
	}

	function get_height() : Float {
		return _height;
	}

	function set_height(value:Float) : Float {
		return _height = value;
	}

}
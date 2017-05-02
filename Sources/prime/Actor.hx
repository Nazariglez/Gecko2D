package prime;

class Actor {
	public static var actorID:Int = 0;

	public var position:Point = new Point(0,0);
	public var scale:Point = new Point(1,1);
	public var skew:Point = new Point(0,0);
	public var pivot:Point = new Point(0.5, 0.5);
	public var anchor:Point = new Point(0.5, 0.5);
	public var size:Point = new Point(1,1);
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
	
	private var _bounds:Rectangle = new Rectangle();
	public var bounds(get, null):Rectangle;

	private var _width:Float = 0;
	public var width(get, set):Float;

	private var _height:Float = 0;
	public var height(get, set):Float;

	public var box:Rectangle;
	private var _actorId:Int = -1;

	public function new(){
		_actorId = Actor.actorID++;
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
		checkBounds();
	}

	public function update(delta:Float) : Void {}
	public function render(renderer:Renderer) : Void {
		if(!visible || worldAlpha <= 0)return;
		_updateMatrix();
		renderer.color = tint;
		renderer.alpha = worldAlpha;
		renderer.setMatrix(matrix.world);
	}

	public function debugRender(renderer:Renderer) : Void {
		renderer.color = Color.Magenta;
		renderer.drawRect(0, 0, size.x, size.y, 1);
		renderer.color = Color.White;
	}

	public function checkBounds() : Void {
		if(box != null){
			_bounds.x = box.x - box.width * anchor.x;
			_bounds.y = box.y - box.height * anchor.y;
			_bounds.width = box.width;
			_bounds.height = box.height;
			return;
		}

		calculateBounds();
	}

	public function calculateBounds() : Void {
		_bounds.x = -width * anchor.x;
		_bounds.y = -height * anchor.y;
		_bounds.width = width;
		_bounds.height = height;
	}

	public inline function addTo(container:Container) : Void {
		container.addChild(this);
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
		//todo don't recalculate use a cacheId
		checkBounds();
		return _bounds;
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
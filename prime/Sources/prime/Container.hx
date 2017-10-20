package prime;

class Container extends Actor {
	public var children:Array<Actor> = [];

	private var _boundMinX:Float;
	private var _boundMinY:Float;
	private var _boundMaxX:Float;
	private var _boundMaxY:Float;

	override public function update(delta:Float) : Void {
		if(children.length > 0) {
			for(i in 0...children.length) {
				children[i].update(delta);
			}
		}
	}

	override public function render(renderer:Renderer) : Void {
		super.render(renderer);
		renderer.color = Color.Red;
		renderer.drawRect(bounds.x, bounds.y, bounds.width, bounds.height, 2);
		renderer.color = Color.White;
		
		if(children.length > 0) {
			for(i in 0...children.length) {
				children[i].render(renderer);
				/*#if debug
				children[i].debugRender(renderer);
				#end*/
			}
		}

		renderer.setMatrix(matrix.world);
		trace(bounds);
	}

	override function calculateBounds() : Void {
		_clearBoundsMinMax();

		if(children.length > 0){
			var x1 = Math.POSITIVE_INFINITY;
			var y1 = Math.POSITIVE_INFINITY;
			var x2 = Math.NEGATIVE_INFINITY;
			var y2 = Math.NEGATIVE_INFINITY;

			//trace("a1", x1, y1, x2, y2);
			//trace("a2", _boundMinX, _boundMinY, _boundMaxX, _boundMaxY);
			for(i in 0...children.length) {
				children[i].checkBounds();
				x1 = children[i].bounds.x + children[i].position.x;
				y1 = children[i].bounds.y + children[i].position.y;
				x2 = children[i].bounds.width + x1;
				y2 = children[i].bounds.height + y1;

				//trace("a3", x1, y1, x2, y2);
				if(x1 < _boundMinX)_boundMinX = x1;
				//trace("n", i, "x1", x1, _boundMinX);
				if(y1 < _boundMinY)_boundMinY = y1;
				//trace("n", i, "y1", y1, _boundMinY);
				if(x2 > _boundMaxX)_boundMaxX = x2;
				//trace("n", i, "x2", x2, _boundMaxX);
				if(y2 > _boundMaxY)_boundMaxY = y2;
				//trace("n", i, "y2", y2, _boundMaxY);
			}
		}else{
			_boundMinX = 0;
			_boundMinY = 0;
			_boundMaxX = 0;
			_boundMaxY = 0;
		}


		size.x = _boundMaxX - _boundMinX;
		size.y = _boundMaxY - _boundMinY;

		//trace("a4", _boundMinX, _boundMinY, _boundMaxX, _boundMaxY);

		_bounds.x = _boundMinX;
		_bounds.y = _boundMinY;
		_bounds.width = width;
		_bounds.height = height;

		//trace(_bounds);
	}

	private function _clearBoundsMinMax() : Void {
		_boundMinX = Math.POSITIVE_INFINITY;
		_boundMinY = Math.POSITIVE_INFINITY;
		_boundMaxX = Math.NEGATIVE_INFINITY;
		_boundMaxY = Math.NEGATIVE_INFINITY;
	}

	public function addChild(actor:Actor) : Void {
		actor.parent = this;
		children.push(actor);
	}

	public function removeChild(actor:Actor) : Void {
		actor.parent = null;
		children.remove(actor);
	}
}
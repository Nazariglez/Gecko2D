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
		
		if(children.length > 0) {
			for(i in 0...children.length) {
				children[i].render(renderer);
				#if debug
				children[i].debugRender(renderer);
				#end
			}
		}
	}

	override function calculateBounds() : Void {
		_clearBoundsMinMax();

		if(children.length > 0){
			for(i in 0...children.length) {
				children[i].checkBounds();
				if(children[i].bounds.x < _boundMinX)_boundMinX = children[i].bounds.x;
				if(children[i].bounds.y < _boundMinY)_boundMinY = children[i].bounds.y;
				if(children[i].bounds.x+children[i].bounds.width > _boundMaxX)_boundMaxX = children[i].bounds.x+children[i].bounds.width;
				if(children[i].bounds.y+children[i].bounds.height > _boundMaxY)_boundMaxY = children[i].bounds.y+children[i].bounds.height;
			}
		}else{
			_boundMinX = 0;
			_boundMinY = 0;
			_boundMaxX = 0;
			_boundMaxY = 0;
		}


		size.x = _boundMaxX - _boundMinX;
		size.y = _boundMaxY - _boundMinY;

		_bounds.x = _boundMinX;
		_bounds.y = _boundMinY;
		_bounds.width = width;
		_bounds.height = height;

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
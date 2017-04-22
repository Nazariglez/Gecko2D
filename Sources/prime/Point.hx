package prime;

class Point {
	public var x:Float = 0;
	public var y:Float = 0;

	public function new(x:Float = 0, y:Float = 0) {
		this.set(x,y);
	}

	public function set(x:Float, ?y:Float) {
		this.x = x;
		if(y == null){
			this.y = x;
		}
	}

	public function clone(point:Point) : Point {
		return new Point(this.x, this.y);
	}

	public function copy(point:Point) : Void {
		this.set(point.x, point.y);
	}

	public function isEqual(point:Point) : Bool {
		return (x == point.x && y == point.y);
	}
}
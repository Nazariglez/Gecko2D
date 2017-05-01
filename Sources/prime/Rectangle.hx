package prime;
 class Rectangle {
	 public var x:Float = 0;
	 public var y:Float = 0;
	 public var width:Float = 0;
	 public var height:Float = 0;

	 public var top(get, null):Float;
	 public var bottom(get, null):Float;
	 public var left(get, null):Float;
	 public var right(get, null):Float;

	 public static function empty() : Rectangle {
		 return new Rectangle(0,0,0,0);
	 }

	 public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		 this.x = x;
		 this.y = y;
		 this.width = width;
		 this.height = height;
	 }

	 public function copy(rect:Rectangle) : Void {
		 this.x = rect.x;
		 this.y = rect.y;
		 this.width = rect.width;
		 this.height = rect.height;
	 }

	 public function clone() : Rectangle {
		 return new Rectangle(x, y, width, height);
	 }

	 public function contains(x:Float, y:Float) : Bool {
		 if(this.width <= 0 || this.height <= 0){
			 return false;
		 }

		 if(x >= this.x && x < this.x+this.width) {
			 if(y >= this.y && y < this.y+this.height){
				 return true;
			 }
		 }

		 return false;
	 }

	 public function containsPoint(point:Point) : Bool {
		 return contains(point.x, point.y);
	 }

	 public function containsRectangle(rect:Rectangle) : Bool {
		 return contains(rect.x, rect.y) || contains(rect.x, rect.y+rect.height) || contains(rect.x+rect.width, rect.y) || contains(rect.x+rect.width, rect.y+rect.height);
	 }

	 public function clear() : Void {
		 x = 0;
		 y = 0;
		 width = 0;
		 height = 0;
	 }

	 public function get_top() : Float {
		 return y;
	 }

	 public function get_bottom() : Float {
		 return y+height;
	 }

	 public function get_left() : Float {
		 return x;
	 }

	 public function get_right() : Float {
		 return x+width;
	 }

 }
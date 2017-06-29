package prime;

import kha.System;
import kha.Framebuffer;
import prime.utils.Stats;

class Stage extends Container {
	override public function render(renderer:Renderer) : Void {
		for(x in 0...30){
			renderer.drawCircle(x*50, 0, 4);
		}

		for(y in 0...30){
			renderer.drawCircle(0, y*50, 4);
		}

		super.render(renderer);
		trace("stage", "bounds", bounds);
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
}

class Game {
	private var _initiated:Bool = false;
	private var _title:String = "My Game";
	private var _width:Int = 800;
	private var _height:Int = 600;
	private var _loop:Loop = new Loop();
	private var _renderer:Renderer = new Renderer();

	public var stats:Stats = new Stats();
	public var isRunning(get, null):Bool;
	public var stage:Container = new Stage();

	public var windowWidth(get, null):Int;
	public var windowHeight(get, null):Int;

	public function new(title:String, width:Int, height:Int) {
		_title = title;
		_width = width;
		_height = height;
	}

	static function init(title:String, width:Int, height:Int) : Game {
		var game = new Game(title, width, height);
		game.initialize();
		return game;
	}

	public function initialize() : Void {
		if(!_initiated){
			_initiated = true;
			System.init({
				title: _title,
				width: _width,
				height: _height
			}, _onInit);
		}
	}

	public function start() : Void {
		if(!_loop.isRunning){
			_loop.start();
		}
	}

	public function stop() : Void {
		if(_loop.isRunning){
			_loop.stop();
		}
	}

	public function update(delta:Float) : Void {
		#if debug
		stats.updateTick();
		#end
		stage.update(delta);
	}

	private function _render(framebuffer:Framebuffer) : Void {
		if(_renderer.framebuffer == null){
			_renderer.setFramebuffer(framebuffer);
		}
	
		#if debug
		stats.renderTick();
		#end

		_renderer.g2d.begin();
		render(_renderer);
		_renderer.g2d.end();
	}

	public function render(renderer:Renderer) : Void {
		stage.render(_renderer);
		#if debug
		//stage.debugRender(_renderer);
		#end
		_renderer.reset();
	}

	private function _onInit() : Void {
		System.notifyOnRender(_render);
		_loop.onTick(update);
		start();
		onInit();
	}

	public function onInit() : Void {
		trace("Game initiated");
	}

	function get_isRunning() : Bool {
		return _loop.isRunning;
	}

	function get_windowWidth() : Int {
		return System.windowWidth();
	}

	function get_windowHeight() : Int {
		return System.windowHeight();
	}

}
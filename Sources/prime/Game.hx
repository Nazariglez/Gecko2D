package prime;

import kha.System;
import kha.Framebuffer;
import kha.graphics2.Graphics;

class Game {
	private var _initiated:Bool = false;
	private var _title:String = "My Game";
	private var _width:Int = 800;
	private var _height:Int = 600;
	private var _loop:Loop = new Loop();
	private var _renderer:Renderer = new Renderer();

	public var isRunning(get, null):Bool;
	public var stage:Container = new Container();

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
		stage.update(delta);
	}

	private function _render(framebuffer:Framebuffer) : Void {
		if(_renderer.framebuffer == null){
			_renderer.setFramebuffer(framebuffer);
		}
	
		render();
	}

	public function render() : Void {
		_renderer.g2d.begin();
		stage.render(_renderer);
		_renderer.g2d.end();
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

}
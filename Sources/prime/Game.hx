package prime;

import kha.System;
import kha.Scheduler;
import kha.Framebuffer;
import kha.graphics2.Graphics;

class Game {
	private var _initiated:Bool = false;
	private var _title:String = "My Game";
	private var _width:Int = 800;
	private var _height:Int = 600;

	public var isRunning:Bool = false;
	public var stage:Container = new Container();

	public function new(title:String, width:Int, height:Int) {
		_title = title;
		_width = width;
		_height = height;
	}

	public function start() : Void {
		if(!_initiated){
			_initiated = true;
			isRunning = true;
			System.init({
				title: _title,
				width: _width,
				height: _height
			}, _onInit);
		}else if(Scheduler.isStopped()){
			isRunning = true;
			Scheduler.start();
		}
	}

	public function stop() : Void {
		isRunning = false;
		Scheduler.stop();
	}

	private function _update() : Void {
		update(1/60);
	}

	public function update(delta:Float) : Void {
		stage.update(delta);
	}

	private function _render(framebuffer:Framebuffer) : Void {
		render(framebuffer.g2);
	}

	public function render(graphics:Graphics) : Void {
		graphics.begin();
		stage.render(graphics);
		graphics.end();
	}

	private function _onInit() : Void {
		System.notifyOnRender(_render);
		Scheduler.addTimeTask(_update, 0, 1/60);
	}

}
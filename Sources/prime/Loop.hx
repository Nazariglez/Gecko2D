package prime;

import kha.Scheduler;

class Loop {
	public var isRunning:Bool = false;
	public var speed:Float = 1;
	public var delta:Float = 0;
	public var deltaMS:Float = 0;
	public var time:Float = 0;
	
	private var _last:Float = 0;
	private var _lastTime:Float = 0;
	private var _firstDate:Float = 0;

	private var _fps:Int = 60;
	private var _fpsTimeMS:Int = 0;
	private var _onTickCallback:Float->Void = function(delta:Float){};
	private var _rafId:Int = -1;

	public function new(fps:Int = 60) {
		setFPS(fps);
	}

	private inline function _now() : Float {
		return Date.now().getTime();
	}

	public function start() : Void {
		if(isRunning)return;

		isRunning = true;
		_last = _now();
		if(_firstDate == 0) {
			_firstDate = _last;
		}

		#if js
		_animate();
		#else
		_rafId = Scheduler.addTimeTask(_animate, 0, 1/_fps);
		#end
	}

	public function stop() : Void {
		if(!isRunning)return;

		isRunning = false;

		#if js 
		js.Browser.window.cancelAnimationFrame(_rafId);
		#else
		Scheduler.removeTimeTask(_rafId);
		#end
	}

	public function setFPS(fps:Int) : Void {
		var running = false;
		if(isRunning){
			running = true;
			stop();
		}

		_fps = fps;
		_fpsTimeMS = Std.int(1000/_fps);

		if(running){
			start();
		}
	}

	#if js 
	private inline function _jsAnimate(t:Float) : Void {
		_animate();
	}

	private function _raf() : Void {
		if(_fps == 60){
			js.Browser.window.requestAnimationFrame(_jsAnimate);
		}else{
			haxe.Timer.delay(_animate, _fpsTimeMS);
		}
	}
	#end

	private function _animate() : Void {
		if(!isRunning)return;

		#if js 
		_raf();
		#end

		var now = _now();
		time += (now - _last)*speed;
		deltaMS = time - _lastTime;
		delta = deltaMS/1000;
		_lastTime = time;
		_last = now;

		_onTickCallback(delta);
	}

	public function onTick(callback:Float->Void) {
		_onTickCallback = callback;
	}
}
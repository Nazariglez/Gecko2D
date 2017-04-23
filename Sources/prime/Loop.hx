package prime;

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

	public function new(fps:Int = 60) {
		setFPS(fps);
	}

	public function start() : Void {
		if(isRunning)return;

		isRunning = true;
		_last = Date.now().getTime();
		if(_firstDate == 0) {
			_firstDate = _last;
		}

		_animate();
	}

	public function stop() : Void {
		if(!isRunning)return;

		isRunning = false;
	}

	public function setFPS(fps:Int) : Void {
		_fps = fps;
		_fpsTimeMS = Std.int(1000/_fps);
	}

	#if js 
	private inline function _jsAnimate(t:Float) : Void {
		_animate();
	}
	#end

	private function _animate() : Void {
		if(!isRunning)return;

		#if js 
		if(_fps == 60){
			js.Browser.window.requestAnimationFrame(_jsAnimate);
		}else{
			haxe.Timer.delay(_animate, _fpsTimeMS);
		}
		#else
		haxe.Timer.delay(_animate, _fpsTimeMS);
		#end

		var now = Date.now().getTime();
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
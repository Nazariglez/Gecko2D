package prime.utils;

import kha.FastFloat;
import kha.Scheduler;

class Stats {
	public var renderFps:FastFloat = 0;
	public var renderMs:FastFloat = 0;

	private var _renderFrames:FastFloat = 0;
	private var _renderElapsed:FastFloat = 0;
	private var _renderLastNow:Float = 0;

	public var updateFps:FastFloat = 0;
	public var updateMs:FastFloat = 0;

	private var _updateFrames:FastFloat = 0;
	private var _updateElapsed:FastFloat = 0;
	private var _updateLastNow:Float = 0;

	public function new(){}

	public function renderTick() : Void {
		var now = Scheduler.realTime();
		_renderFrames++;
		_renderElapsed += now - _renderLastNow;
		_renderLastNow = now;
		if(_renderElapsed >= 1) {
			renderFps = Math.round((_renderFrames/_renderElapsed)*100)/100;
			renderMs = Math.round((_renderElapsed/_renderFrames)*1000);
			_renderFrames = 0;
			_renderElapsed = 0;
		}
	}

	public function updateTick() : Void {
		var now = Scheduler.realTime();
		_updateFrames++;
		_updateElapsed += now - _updateLastNow;
		_updateLastNow = now;
		if(_renderElapsed >= 1) {
			updateFps = Math.round((_updateFrames/_updateElapsed)*100)/100;
			updateMs = Math.round((_updateElapsed/_updateFrames)*1000);
			_updateFrames = 0;
			_updateElapsed = 0;
		}
	}
}
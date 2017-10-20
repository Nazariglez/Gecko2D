package kha.js;

import js.html.AudioElement;
import kha.audio1.AudioChannel;

class AEAudioChannel implements kha.audio1.AudioChannel {
	private var element: AudioElement;
	private static var todo: Array<AEAudioChannel> = [];
	private var stopped = false;
	
	public function new(element: AudioElement) {
		this.element = element;
	}
	
	public function play(): Void {
		stopped = false;
		if (SystemImpl.mobile) {
			if (SystemImpl.insideInputEvent) {
				element.play();
				SystemImpl.mobileAudioPlaying = true;
			}
			else if (SystemImpl.mobileAudioPlaying) {
				element.play();
			}
			else {
				todo.push(this);
			}
		}
		else {
			element.play();
		}
	}
	
	public function pause(): Void {
		try {
			element.pause();
		}
		catch (e: Dynamic) {
			trace(e);
		}
	}

	public function stop(): Void {
		try {
			element.pause();
			element.currentTime = 0;
			stopped = true;
		}
		catch (e: Dynamic) {
			trace(e);
		}
	}

	public var length(get, null): Float; // Seconds
	
	private function get_length(): Float {
		if (Math.isFinite(element.duration)) {
			return element.duration;
		}
		else {
			return Math.POSITIVE_INFINITY;
		}
	}

	public var position(get, null): Float; // Seconds
	
	private function get_position(): Float {
		return element.currentTime;
	}

	public var volume(get, set): Float;

	private function get_volume(): Float {
		return element.volume;
	}

	private function set_volume(value: Float): Float {
		return element.volume = value;
	}

	public var finished(get, null): Bool;

	private function get_finished(): Bool {
		return stopped || position >= length;
	}
}

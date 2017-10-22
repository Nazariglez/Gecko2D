package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import k2d.Game;

class Empty {
	public function new() {
		Game.init();
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);
	}

	function update(): Void {
		
	}

	function render(framebuffer: Framebuffer): Void {		
	}
}
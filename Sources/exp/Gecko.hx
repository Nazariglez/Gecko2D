package exp;

import kha.Scheduler;
import kha.FastFloat;
import kha.Framebuffer;
import kha.System;

class Gecko {
    static public function init(
        onReady:Void->Void,
        onRender:Framebuffer->Void,
        onUpdate:Void->Void,
        opts:kha.SystemOptions
    ) {
        System.init(opts, function(){
            var canvas:js.html.CanvasElement = getHtml5Canvas();
            canvas.style.width = opts.width + "px";
            canvas.style.height = opts.height + "px";
            System.notifyOnRender(onRender);
            Scheduler.addTimeTask(onUpdate, 0, 1 / 60);
            onReady();
        });
    }

    static public function getHtml5Canvas() : #if kha_js js.html.CanvasElement #else Dynamic #end {
        #if kha_js
        return cast js.Browser.document.getElementById(kha.CompilerDefines.canvas_id);
        #else
        return null;
        #end
    }
}
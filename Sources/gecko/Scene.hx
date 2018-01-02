package gecko;

import gecko.Color;
import gecko.render.Renderer;
import gecko.tween.TweenManager;
import gecko.timer.TimerManager;
import gecko.math.FastFloat;

class Scene extends Container {
    private var SCENE_COUNT:Int = 0;

    public var id:String = "";
    public var transparent:Bool = true;
    public var backgroundColor:Color = Color.Black;

    public var tweenManager:TweenManager = new TweenManager();
    public var timerManager:TimerManager = new TimerManager();

    public var isPaused(get, null):Bool;
    private var _isPaused:Bool = false;

    public override function new(?id:String){
        super();
        this.id = id != null ? id : 'scene_${SCENE_COUNT}';
        SCENE_COUNT++;

        anchor.set(0,0);
        pivot.set(0,0);
        sizeByChildren = false;
    }

    public function pause() {
        if(_isPaused){
            return;
        }

        _isPaused = true;
    }

    public function resume() {
        if(!_isPaused){
            return;
        }

        _isPaused = false;
    }

    public override function update(dt:FastFloat) {
        if(_isPaused){
            return;
        }

        super.update(dt);
        timerManager.update(dt);
        tweenManager.update(dt);
    }

    public override function render(r:Renderer) {
        if(!transparent){
            //draw background color
            r.color = backgroundColor;
            r.fillRect(0, 0, this.size.x, this.size.y);
        }

        super.render(r);
    }

    function get_isPaused() : Bool {
        return _isPaused;
    }
}
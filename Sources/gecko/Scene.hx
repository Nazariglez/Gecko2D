package gecko;

import gecko.Color;
import gecko.render.Renderer;
import gecko.tween.TweenManager;
import gecko.timer.TimerManager;
import gecko.math.FastFloat;

class Scene extends Container {
    public var id:String = "";
    public var transparent:Bool = true;
    public var backgroundColor:Color = Color.Black;

    public var tweenManager:TweenManager = new TweenManager();
    public var timerManager:TimerManager = new TimerManager();

    public var isPaused(get, null):Bool;
    private var _isPaused:Bool = false;

    public var cameras:Array<Camera> = [];

    //todo add pause|resume

    public override function new(id:String){
        super();
        this.id = id;

        anchor.set(0,0);
        pivot.set(0,0);
        sizeByChildren = false;

        var camera = new Camera(this, 400, 600);
        //camera.lookZoom = 0.5;
        cameras.push(camera);

        var camera2 = new Camera(this, 400, 600);
        camera2.position.set(400, 0);
        //camera2.lookZoom = 0.5;
        cameras.push(camera2);
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

        /*for(camera in cameras){
            camera.update(dt);
        }*/

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

        //super.render(r);

        for(camera in cameras){
            camera.processRender(r);
        }
    }

    function get_isPaused() : Bool {
        return _isPaused;
    }
}
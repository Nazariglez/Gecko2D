package k2d;

import k2d.utils.Color;
import k2d.render.Renderer;
import k2d.tween.TweenManager;
import k2d.math.FastFloat;

class Scene extends Container {
    public var id:String = "";
    public var transparent:Bool = true;
    public var backgroundColor:Color = Color.BLACK;

    public var tweenManager:TweenManager = new TweenManager();

    public var isPaused(get, null):Bool;
    private var _isPaused:Bool = false;

    //todo add pause|resume

    public override function new(id:String){
        super();
        this.id = id;

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
        tweenManager.update(dt);
    }

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);
        
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
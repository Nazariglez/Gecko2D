package gecko;

import gecko.math.Matrix;
import gecko.math.Point;
import gecko.math.FastFloat;
import gecko.render.Renderer;

class Camera extends Entity {
    public var watch:Scene;

    public var lookPosition:Point = new Point(0,0);
    public var lookZoom:FastFloat = 1;
    public var lookRotation:FastFloat = 0;

    private var _rCos:FastFloat = 0;
    private var _rSin:FastFloat = 0;
    private var _pw:FastFloat = 0;
    private var _ph:FastFloat = 0;

    public var matrixCamera:Matrix = Matrix.identity();

    override public function new(scene:Scene, width:FastFloat, height:FastFloat){
        super(width, height);
        this.watch = scene;
        anchor.set(0,0);
        //position.set(100, 0);
        //lookPosition.set(width*0.5, height*0.5);
        //lookZoom = 0.5;
        //lookRotation = Math.PI;
        trace(matrixCamera);
        //untyped js.Browser.window.camera = this;
    }

    override public function updateTransform(?camera:Camera){
        super.updateTransform(camera);
        _rCos = Math.cos(lookRotation);
        _rSin = Math.sin(lookRotation);

        matrixCamera._00 = _rCos * lookZoom;
        matrixCamera._01 = _rSin * lookZoom;
        matrixCamera._10 = -_rSin * lookZoom;
        matrixCamera._11 = _rCos * lookZoom;

        _pw = 0.5*size.x;
        _ph = 0.5*size.y;

        matrixCamera._20 = -lookPosition.x + _pw;
        matrixCamera._21 = -lookPosition.y + _ph;

        matrixCamera._20 -= _pw * matrixCamera._00 + _ph * matrixCamera._10;
        matrixCamera._21 -= _pw * matrixCamera._01 + _ph * matrixCamera._11;

        matrixTransform.world._00 = (matrixTransform.local._00 * matrixCamera._00) + (matrixTransform.local._01 * matrixCamera._10);
        matrixTransform.world._01 = (matrixTransform.local._00 * matrixCamera._01) + (matrixTransform.local._01 * matrixCamera._11);
        matrixTransform.world._10 = (matrixTransform.local._10 * matrixCamera._00) + (matrixTransform.local._11 * matrixCamera._10);
        matrixTransform.world._11 = (matrixTransform.local._10 * matrixCamera._01) + (matrixTransform.local._11 * matrixCamera._11);

        matrixTransform.world._20 = (matrixTransform.local._20 * matrixCamera._00) + (matrixTransform.local._21 * matrixCamera._10) + matrixCamera._20;
        matrixTransform.world._21 = (matrixTransform.local._20 * matrixCamera._01) + (matrixTransform.local._21 * matrixCamera._11) + matrixCamera._21;
    }

    override public function preRender(r:Renderer){
        super.preRender(r);

        if(watch != null){
            r.g2.scissor(Std.int(position.x), Std.int(position.y), Std.int(size.x), Std.int(size.y));
        }
    }

    override public function render(r:Renderer) {
        super.render(r);

        r.color = Color.Aqua;
        r.fillRect(0, 0, size.x, size.y);

        if(watch != null){
            for(child in watch.children){
                if(child.isVisible()){
                    child.processRender(r, this);
                }
            }
            r.applyTransform(matrixTransform);
        }

        //lookRotation += 1*Math.PI/180;
        //lookZoom -= 0.0005;
    }

    override public function postRender(r:Renderer) {
        super.postRender(r);

        if(watch != null){
            r.g2.disableScissor();
        }
    }

    public function shake(intensisty:FastFloat, duration:FastFloat) {
        //todo
    }
}
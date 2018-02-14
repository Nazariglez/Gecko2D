package exp.components;

import exp.render.Graphics;
import exp.IDrawable;
import exp.Float32;

class DrawComponent extends Component implements IDrawable {
    public var visible:Bool = true;
    public var color:Color = Color.White;
    public var alpha:Float32 = 1;

    public var worldAlpha(get, null):Float32;
    private var _worldAlpha:Float32 = 1;

    public var dirtyAlpha:Bool = true;

    public function draw(graphics:Graphics){}

    function get_worldAlpha():Float32 {
        if(entity.transform == null || entity.transform.parent == null){
            return alpha;
        }

        if(dirtyAlpha){
            _worldAlpha = entity.transform.parent.renderer.worldAlpha * alpha;
            dirtyAlpha = false;
        }

        //todo avoid recursive functions, iterative to better performance

        return _worldAlpha;
    }

}
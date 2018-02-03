package exp.components;

import exp.render.BlendMode;
import exp.IDrawable;
import exp.Float32;

class DrawComponent extends Component implements IDrawable {
    public var visible:Bool = true;
    public var drawOrder:Int = 0;

    public function draw(){}
}
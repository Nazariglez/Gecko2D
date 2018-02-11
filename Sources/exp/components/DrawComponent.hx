package exp.components;

import exp.render.Graphics;
import exp.IDrawable;
import exp.Float32;

class DrawComponent extends Component implements IDrawable {
    public var visible:Bool = true;
    public var color:Color = Color.White;
    public var alpha:Float32 = 1;

    public function draw(graphics:Graphics){}
}
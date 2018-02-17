package exp.components;

import exp.render.Graphics;
import exp.IDrawable;
import exp.Float32;

class DrawComponent extends Component implements IDrawable implements IUpdatable {
    public var visible:Bool = true;
    public var color:Color = Color.White;
    public var alpha:Float32 = 1;

    public var worldAlpha:Float32 = 1;

    public function update(dt:Float32){}
    public function draw(graphics:Graphics){}
}
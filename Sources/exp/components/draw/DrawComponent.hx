package exp.components.draw;

import exp.render.Graphics;
import exp.IDrawable;
import exp.IUpdatable;
import exp.Float32;

class DrawComponent extends Component implements IDrawable implements IUpdatable {
    public var visible:Bool = true;
    public var color:Color = Color.White;
    public var alpha:Float32 = 1;

    public var worldAlpha:Float32 = 1;

    public function update(dt:Float32){}
    //public function preDraw(g:Graphics){}
    //public function postDraw(g:Graphics){}
    public function draw(graphics:Graphics){}
}
package gecko.components.draw;

import gecko.Graphics;
import gecko.IDrawable;
import gecko.IUpdatable;
import gecko.Float32;

class DrawComponent extends Component implements IDrawable implements IUpdatable {
    public var visible:Bool = true;
    public var color:Color = Color.White;
    public var alpha:Float32 = 1;

    public var worldAlpha:Float32 = 1;
    public var isVisible(get, null):Bool;

    public function update(dt:Float32){}
    //public function preDraw(g:Graphics){} //pipeline shader and blends
    //public function postDraw(g:Graphics){}
    public function draw(graphics:Graphics){}

    override public function beforeDestroy() {
        super.beforeDestroy();

        visible = true;
        color = Color.White;
        alpha = 1;
        worldAlpha = 1;
    }

    inline function get_isVisible():Bool {
        return visible && worldAlpha > 0;
    }

    //TODO generate texture
}
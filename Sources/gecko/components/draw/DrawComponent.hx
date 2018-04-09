package gecko.components.draw;

import gecko.resources.Image;
import gecko.resources.Texture;
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

    public function preDraw(g:Graphics){}
    public function draw(graphics:Graphics){}
    public function postDraw(g:Graphics){}

    public function generateTexture(?g:Graphics) : Texture {
        if(entity == null){
            trace('DrawComponent.generateTexture() needs a entity to work.');
            return null;
        }

        if(g == null){
            g = gecko.Gecko.graphics;
        }

        var image = Image.createRenderTarget(Std.int(entity.transform.size.x), Std.int(entity.transform.size.y));
        var isRendering = g.isRendering;
        var prevBuffer = g.buffer;

        if(isRendering){
            g.end();
        }

        g.setRenderTarget(image);
        g.begin();

        //todo

        g.end();
        g.setRenderTarget(prevBuffer);

        if(isRendering){
            g.begin();
        }

        return new Texture(image);
    }

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
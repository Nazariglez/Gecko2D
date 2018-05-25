package gecko.components.draw;

import gecko.render.BlendMode;
import gecko.resources.Image;
import gecko.resources.Texture;
import gecko.Graphics;
import gecko.IDrawable;
import gecko.IUpdatable;


class DrawComponent extends Component implements IDrawable implements IUpdatable {
    public var visible:Bool = true;
    public var color:Color = Color.White;

    public var localAlpha(get, set):Float;
    private var _localAlpha:Float = 1;

    public var alpha(get, set):Float;
    private var _alpha:Float = 1;

    private var _dirtyAlpha:Bool = true;

    public var isVisible(get, null):Bool;

    public var blendMode:BlendMode = BlendMode.Normal;

    public function update(dt:Float){}

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
        _alpha = 1;
        _localAlpha = 1;
        _dirtyAlpha = true;
    }

    inline function get_isVisible():Bool {
        return visible && alpha > 0;
    }

    inline function get_localAlpha():Float {
        return _localAlpha;
    }

    function set_localAlpha(value:Float):Float {
        if(value == _localAlpha)return _localAlpha;

        _dirtyAlpha = true;
        return _localAlpha = value;
    }

    function get_alpha():Float {
        if(_dirtyAlpha){
            if(entity != null && entity.transform.parent != null){
                var drawComponent:DrawComponent = entity.transform.parent.entity.getDrawComponent();
                _alpha = drawComponent.alpha * _localAlpha;
                _dirtyAlpha = false;
            }else{
                _alpha = _localAlpha;
                if(entity.isRoot){
                    _dirtyAlpha = false;
                }
            }
        }

        return _alpha;
    }

    function set_alpha(value:Float):Float {
        if(value == _alpha)return _alpha;
        if(entity != null && entity.transform.parent != null){
            var drawComponent:DrawComponent = entity.transform.parent.entity.getDrawComponent();
            _localAlpha = drawComponent.alpha * value;
        }else{
            _localAlpha = value;
        }

        return _alpha = value;
    }

    //TODO generate texture
}
package gecko;

import gecko.math.FastFloat;
import gecko.render.Renderer;
import gecko.resources.Image;
import gecko.resources.Texture;

typedef NineSliceOptions = {
    var top:FastFloat;
    var bottom:FastFloat;
    var left:FastFloat;
    var right:FastFloat;
}

class NineSlice extends Sprite {
    private var _options:NineSliceOptions;

    private var _top:FastFloat = 0;
    private var _bottom:FastFloat = 0;
    private var _left:FastFloat = 0;
    private var _right:FastFloat = 0;
    private var _centerW:FastFloat = 0;
    private var _centerH:FastFloat = 0;
    private var _sw:FastFloat = 0;
    private var _sh:FastFloat = 0;

    static public function fromTexture(texture:Texture, ?opts:NineSliceOptions) : NineSlice {
        var n = new NineSlice(null, opts);
        n.texture = texture;
        return n;
    }

    static public function fromImage(img:Image, ?opts:NineSliceOptions) : NineSlice {
        var n = new NineSlice(null, opts);
        n.texture = new Texture(img);
        return n;
    }

    public override function new(textureName:String, ?opts:NineSliceOptions) {
        super(textureName);
        _options = opts;
    }

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);
        if(_texture != null){
            if(_options != null){
                _top = _options.top;
                _bottom = _options.bottom;
                _left = _options.left;
                _right = _options.right;
            } else {
                _top = _texture.height/3;
                _bottom = _texture.height/3;
                _left = _texture.width/3;
                _right = _texture.width/3;
            }

            _centerW = _texture.width - (_left + _right);
            _centerH = _texture.height - (_top + _bottom);
            _sw = size.x - (_left + _right); 
            _sh = size.y - (_top + _bottom); 

            r.drawScaledSubTexture(_texture, 0, 0, _left, _top, 0, 0, _left, _top);
            r.drawScaledSubTexture(_texture, _left, 0, _centerW, _top, _left, 0, _sw, _top);
            r.drawScaledSubTexture(_texture, _left+_centerW, 0, _right, _top, _left+_sw, 0, _right, _top);

            r.drawScaledSubTexture(_texture, 0, _top, _left, _centerH, 0, _top, _left, _sh);
            r.drawScaledSubTexture(_texture, _left, _top, _centerW, _centerH, _left, _top, _sw, _sh);
            r.drawScaledSubTexture(_texture, _left+_centerW, _top, _right, _top, _left+_sw, _top, _right, _sh);
            
            r.drawScaledSubTexture(_texture, 0, _top+_centerH, _left, _bottom, 0, _top+_sh, _left, _bottom);
            r.drawScaledSubTexture(_texture, _left, _top+_centerH, _centerW, _bottom, _left, _top+_sh, _sw, _bottom);
            r.drawScaledSubTexture(_texture, _left+_centerW, _top+_centerH, _right, _bottom, _left+_sw, _top+_sh, _right, _bottom);
            
        }   

        _renderChildren(r);
        r.applyTransform(matrixTransform);
    }

    override function set_width(value:FastFloat) : FastFloat {
        size.x = value / scale.x;
        return _width = value;
    }

    override function set_height(value:FastFloat) : FastFloat {
        size.y = value / scale.y;
        return _height = value;
    }

    override function set_texture(texture:Texture) : Texture {
        if(texture != null){
            if(_texture == null){
                //keep the size if it's a change
                size.set(texture.width, texture.height);
            }
        }
        return _texture = texture;
    }

    //todo add tile mode
    //todo https://docs.unity3d.com/Manual/9SliceSprites.html
}
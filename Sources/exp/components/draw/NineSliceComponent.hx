package exp.components.draw;

import exp.resources.Texture;
import exp.render.Graphics;
import exp.Float32;

typedef NineSliceOptions = {
    var top:Float32;
    var bottom:Float32;
    var left:Float32;
    var right:Float32;
}

class NineSliceComponent extends DrawComponent {
    public var texture(get, set):Texture;
    private var _texture:Texture;

    private var _options:NineSliceOptions;

    private var _top:Float32 = 0;
    private var _bottom:Float32 = 0;
    private var _left:Float32 = 0;
    private var _right:Float32 = 0;
    private var _centerW:Float32 = 0;
    private var _centerH:Float32 = 0;
    private var _sw:Float32 = 0;
    private var _sh:Float32 = 0;

    public function init(texture:String, ?options:NineSliceOptions) {
        this.texture = Assets.textures.get(texture);
        _options = options;

        onAddedToEntity += _setTransformSize;
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            //todo
        }
    }
    
    override public function draw(g:Graphics) {
        if(_texture == null)return;

        if(_options != null){
            _top = _options.top;
            _bottom = _options.bottom;
            _left = _options.left;
            _right = _options.right;
        } else { //todo optimize this with a dirty flag
            _top = _texture.height/3;
            _bottom = _texture.height/3;
            _left = _texture.width/3;
            _right = _texture.width/3;
        }

        _centerW = _texture.width - (_left + _right);
        _centerH = _texture.height - (_top + _bottom);
        _sw = entity.transform.size.x - (_left + _right);
        _sh = entity.transform.size.y - (_top + _bottom);

        g.drawScaledSubTexture(_texture, 0, 0, _left, _top, 0, 0, _left, _top);
        g.drawScaledSubTexture(_texture, _left, 0, _centerW, _top, _left, 0, _sw, _top);
        g.drawScaledSubTexture(_texture, _left+_centerW, 0, _right, _top, _left+_sw, 0, _right, _top);

        g.drawScaledSubTexture(_texture, 0, _top, _left, _centerH, 0, _top, _left, _sh);
        g.drawScaledSubTexture(_texture, _left, _top, _centerW, _centerH, _left, _top, _sw, _sh);
        g.drawScaledSubTexture(_texture, _left+_centerW, _top, _right, _top, _left+_sw, _top, _right, _sh);

        g.drawScaledSubTexture(_texture, 0, _top+_centerH, _left, _bottom, 0, _top+_sh, _left, _bottom);
        g.drawScaledSubTexture(_texture, _left, _top+_centerH, _centerW, _bottom, _left, _top+_sh, _sw, _bottom);
        g.drawScaledSubTexture(_texture, _left+_centerW, _top+_centerH, _right, _bottom, _left+_sw, _top+_sh, _right, _bottom);
    }

    function get_texture():Texture {
        return texture;
    }

    function set_texture(value:Texture):Texture {
        return this.texture = value;
    }
}
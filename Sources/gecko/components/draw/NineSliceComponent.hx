package gecko.components.draw;

import gecko.resources.Texture;
import gecko.render.Graphics;
import gecko.Float32;

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

    public var width(get, set):Float32;
    private var _width:Float32 = 0;

    public var height(get, set):Float32;
    private var _height:Float32 = 0;

    public function init(texture:String, width:Float32 = 0, height:Float32 = 0, ?options:NineSliceOptions) {
        this.texture = Assets.textures.get(texture);
        _options = options;

        _width = width != 0 ? width : cast this.texture.width;
        _height = height != 0 ? height : cast this.texture.height;

        onAddedToEntity += _setTransformSize;
    }

    override public function beforeDestroy() {
        _options = null;
        texture = null;
        onAddedToEntity -= _setTransformSize;

        super.beforeDestroy();
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            e.transform.size.set(_width, _height);
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

    inline function get_texture():Texture {
        return _texture;
    }

    function set_texture(value:Texture):Texture {
        if(value == _texture)return _texture;
        _texture = value;

        if(_texture != null && entity != null && entity.transform != null){
            _width = cast _texture.width;
            _height = cast _texture.height;
            entity.transform.size.set(_width, _height);
        }

        return _texture;
    }

    inline function get_width():Float32 {
        return _width;
    }

    function set_width(value:Float32):Float32 {
        if(entity != null && entity.transform != null){
            entity.transform.size.x = value / entity.transform.scale.x;
        }
        return _width = value;
    }

    inline function get_height():Float32 {
        return _height;
    }

    function set_height(value:Float32):Float32 {
        if(entity != null && entity.transform != null){
            entity.transform.size.y = value / entity.transform.scale.y;
        }
        return _height = value;
    }
}
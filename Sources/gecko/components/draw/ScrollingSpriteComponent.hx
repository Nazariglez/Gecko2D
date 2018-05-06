package gecko.components.draw;

import gecko.math.Point;
import gecko.Graphics;
import gecko.resources.Texture;
import gecko.Assets;

class ScrollingSpriteComponent extends DrawComponent {
    public var texture(get, set):Texture;
    private var _texture:Texture;

    public var scale:Point;
    public var position:Point;
    public var speed:Point;

    public var width(get, set):Float;
    private var _width:Float;

    public var height(get, set):Float;
    private var _height:Float;

    private var _scrollX:Float = 0;
    private var _scrollY:Float = 0;
    private var _lenX:Int = 0;
    private var _lenY:Int = 0;
    private var _offsetX:Float = 0;
    private var _offsetY:Float = 0;

    private var _xx:Float = 0;
    private var _yy:Float = 0;
    private var _sx:Float = 0;
    private var _sy:Float = 0;
    private var _sw:Float = 0;
    private var _sh:Float = 0;
    private var _dw:Float = 0;
    private var _dh:Float = 0;

    private var _sizeScrollX:Float = 0;
    private var _sizeScrollY:Float = 0;

    public function init(texture:String, width:Float, height:Float){
        this.width = width;
        this.height = height;
        this.texture = Assets.textures.get(texture);

        scale = Point.create(1, 1);
        position = Point.create(0, 0);
        speed = Point.create(0, 0);

        onAddedToEntity += _setTransformSize;
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            e.transform.size.set(_width, _height);
        }
        onAddedToEntity -= _setTransformSize;
    }

    override public function beforeDestroy(){
        super.beforeDestroy();

        scale.destroy();
        position.destroy();
        speed.destroy();

        texture = null;
    }

    override public function update(dt:Float) {
        if(_texture == null)return;

        if(speed.x != 0){
            position.x += speed.x*dt;
        }

        if(speed.y != 0){
            position.y += speed.y*dt;
        }

        _sizeScrollX = entity.transform.size.x/scale.x;
        _sizeScrollY = entity.transform.size.y/scale.y;

        _scrollX = position.x%_texture.width;
        _scrollX = _scrollX < 0 ? _texture.width+_scrollX : _scrollX;

        _scrollY = position.y%_texture.height;
        _scrollY = _scrollY < 0 ? _texture.height+_scrollY : _scrollY;

        _lenX = Math.ceil((_sizeScrollX + _scrollX)/_texture.width);
        _lenY = Math.ceil((_sizeScrollY + _scrollY)/_texture.height);

        _offsetX = _sizeScrollX-((_lenX*_texture.width)-_scrollX);
        _offsetY = _sizeScrollY-((_lenY*_texture.height)-_scrollY);
    }

    override public function draw(g:Graphics){
        if(_texture == null)return;

        _yy = 0;
        for(y in 0..._lenY){
            if(_yy >= entity.transform.size.y){
                continue;
            }

            _xx = 0;
            _sx = _scrollX;

            if(y == 0){
                _sy = _scrollY;
            }else{
                _sy = 0;
            }

            if(y == _lenY-1) {
                _sh = (_texture.height+_offsetY)-_sy;
            }else{
                _sh = _texture.height-_sy;
            }

            _dh = _sh*scale.y;

            for(x in 0..._lenX){
                if(_xx >= entity.transform.size.x){
                    continue;
                }

                if(x == _lenX-1){
                    _sw = (_texture.width+_offsetX)-_sx;
                }else{
                    _sw = _texture.width-_sx;
                }

                _dw = _sw*scale.x;

                g.drawScaledSubTexture(
                    _texture,
                    _sx,
                    _sy,
                    _sw,
                    _sh,
                    _xx,
                    _yy,
                    _dw,
                    _dh
                );

                _xx += _dw;
                _sx = 0;
            }

            _yy += _dh;
        }

    }

    inline function get_texture():Texture {
        return _texture;
    }

    function set_texture(value:Texture):Texture {
        if(value == _texture)return _texture;
        _texture = value;

        if(_texture != null && entity != null && entity.transform != null){
            entity.transform.size.set(_width, _height);
        }

        return _texture = value;
    }

    inline function get_width():Float {
        return _width;
    }

    function set_width(value:Float):Float {
        if(entity != null && entity.transform != null){
            entity.transform.size.x = value / entity.transform.scale.x;
        }
        return _width = value;
    }

    function set_height(value:Float):Float {
        if(entity != null && entity.transform != null){
            entity.transform.size.y = value / entity.transform.scale.y;
        }
        return _height = value;
    }

    inline function get_height():Float {
        return _height;
    }
}
package gecko;

import gecko.math.Point;
import gecko.math.FastFloat;
import gecko.render.Renderer;

//todo maybe pass a width and height initial to generate a "big" texture(pot2) to use?
//todo do this with a shader instead the render methods
class ScrollingSprite extends Sprite {
    public var scrollScale:Point = new Point(1,1);
    public var scrollPosition:Point = new Point(0,0);
    public var scrollSpeed:Point = new Point(0, 0);

    private var _scrollX:FastFloat = 0;
    private var _scrollY:FastFloat = 0;
    private var _lenX:Int = 0;
    private var _lenY:Int = 0;
    private var _offsetX:FastFloat = 0;
    private var _offsetY:FastFloat = 0;

    private var _xx:FastFloat = 0;
    private var _yy:FastFloat = 0;
    private var _sx:FastFloat = 0;
    private var _sy:FastFloat = 0;
    private var _sw:FastFloat = 0;
    private var _sh:FastFloat = 0;
    private var _dw:FastFloat = 0;
    private var _dh:FastFloat = 0;

    private var _sizeScrollX:FastFloat = 0;
    private var _sizeScrollY:FastFloat = 0;

    public override function new(textureName:String, width:FastFloat, height:FastFloat){
        super(textureName);
        size.set(width, height);
    }

    public override function update(dt:FastFloat) {
        super.update(dt);
        
        if(scrollSpeed.x != 0){
            scrollPosition.x += scrollSpeed.x*dt;
        }
        
        if(scrollSpeed.y != 0){
            scrollPosition.y += scrollSpeed.y*dt;
        }

        _updateScrollingInfo();
    }

    private function _updateScrollingInfo() {
        _sizeScrollX = size.x/scrollScale.x;
        _sizeScrollY = size.y/scrollScale.y;

        _scrollX = scrollPosition.x%_texture.width;
        _scrollX = _scrollX < 0 ? _texture.width+_scrollX : _scrollX;

        _scrollY = scrollPosition.y%_texture.height;
        _scrollY = _scrollY < 0 ? _texture.height+_scrollY : _scrollY;
        
        _lenX = Math.ceil((_sizeScrollX + _scrollX)/_texture.width);
        _lenY = Math.ceil((_sizeScrollY + _scrollY)/_texture.height);

        _offsetX = _sizeScrollX-((_lenX*_texture.width)-_scrollX);
        _offsetY = _sizeScrollY-((_lenY*_texture.height)-_scrollY);
    }

    public override function render(r:Renderer) {
        if(_texture != null) {
            
            _yy = 0;
            for(y in 0..._lenY){
                if(_yy >= size.y){
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

                _dh = _sh*scrollScale.y;

                for(x in 0..._lenX){
                    if(_xx >= size.x){
                        continue;
                    }

                    if(x == _lenX-1){
                        _sw = (_texture.width+_offsetX)-_sx;
                    }else{
                        _sw = _texture.width-_sx;
                    }

                    _dw = _sw*scrollScale.x;

                    r.drawScaledSubTexture(
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

        _renderChildren(r);
    }

    override function set_width(value:FastFloat) : FastFloat {
        size.x = value / scale.x;
        return _width = value;
    }

    override function set_height(value:FastFloat) : FastFloat {
        size.y = value / scale.y;
        return _height = value;
    }
}
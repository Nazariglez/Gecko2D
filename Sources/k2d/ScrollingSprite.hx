package k2d;

import k2d.math.Point;
import k2d.math.FastFloat;
import k2d.render.Renderer;

//todo maybe pass a width and height initial to generate a "big" texture(pot2) to use?
//todo do this with a shader instead the render methods
class ScrollingSprite extends Sprite {
    public var scrollScale:Point = new Point(1,1);
    public var scrollPosition:Point = new Point(0,0);

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

    public override function new(textureName:String, width:FastFloat, height:FastFloat){
        super(textureName);
        size.set(width, height);
    }

    public override function update(dt:FastFloat) {
        super.update(dt);
        _updateScrollingInfo();
    }

    private function _updateScrollingInfo() {
        _scrollX = scrollPosition.x%_texture.width;
        _scrollX = _scrollX < 0 ? _texture.width+_scrollX : _scrollX;

        _scrollY = scrollPosition.y%_texture.height;
        _scrollY = _scrollY < 0 ? _texture.height+_scrollY : _scrollY;
        
        _lenX = Math.ceil((size.x + _scrollX)/_texture.width);
        _lenY = Math.ceil((size.y + _scrollY)/_texture.height);

        _offsetX = size.x-((_lenX*_texture.width)-_scrollX);
        _offsetY = size.y-((_lenY*_texture.height)-_scrollY);
    }

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);

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

                for(x in 0..._lenX){
                    if(_xx >= size.x){
                        continue;
                    }

                    if(x == _lenX-1){
                        _sw = (_texture.width+_offsetX)-_sx;
                    }else{
                        _sw = _texture.width-_sx;
                    }

                    r.drawSubTexture(
                        _texture,
                        _xx, 
                        _yy,
                        _sx, 
                        _sy,
                        _sw, 
                        _sh
                    );

                    _xx += _sw;
                    _sx = 0;
                }

                _yy += _sh;
            }

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
}
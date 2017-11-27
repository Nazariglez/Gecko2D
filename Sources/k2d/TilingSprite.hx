package k2d;

import k2d.math.Point;
import k2d.math.FastFloat;
import k2d.render.Renderer;

//todo maybe pass a width and height initial to generate a "big" texture(pot2) to use?
class TilingSprite extends Sprite {
    public var tileScale:Point = new Point(1,1);
    public var tilePosition:Point = new Point(0,0);

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);

        var tpx = tilePosition.x%_texture.width;
        var tpy = tilePosition.y%_texture.height;

        //todo
        if(_texture != null){
            var xLen:Int = Math.ceil((size.x+tpx)/_texture.width);
            var yLen:Int = Math.ceil((size.y+tpy)/_texture.height);

            for(_y in 0...yLen){
                for(_x in 0...xLen){
                    var xx:FastFloat = _x*_texture.width;
                    var ww:FastFloat = xx+_texture.width;
                    var yy:FastFloat = _y*_texture.height;
                    var hh:FastFloat = yy+_texture.height;

                    var sx:FastFloat = 0;
                    var sy:FastFloat = 0;

                    var sw:FastFloat = _texture.width;
                    var sh:FastFloat = _texture.height;

                    if(_y == 0){
                        sy = tpy >= 0 ? tpy : tpy+_texture.height;
                        //trace(sy, _texture.height, tpy, _texture.height-tpy);
                    }else{
                        yy -= tpy;
                        if(yy+_texture.height > size.y){
                            if(_y == yLen-1){
                                sh = size.y-yy;
                            }else{
                                sh = size.y%_texture.height+tpy;
                            }
                        }
                        //sh = yy+_texture.height > size.y ? (size.y%_texture.height+tpy)-texture.height : _texture.height;
                    }

                    if(_x == 0){
                        sx = tpx >= 0 ? tpx : tpx+_texture.width;
                    }else{
                        xx -= tpx;
                        if(xx+_texture.width > size.x){
                            if(_x == xLen-1){
                                sw = size.x-xx;
                            }else{
                                sw = size.x%_texture.width+tpx;
                            }
                        }
                        //sw = xx+_texture.width > size.x ? (size.x%_texture.width+tpx) : _texture.width;
                    }

                    r.drawSubTexture(
                        _texture, 
                        xx, 
                        yy, 
                        sx, 
                        sy, 
                        sw, 
                        sh
                    );
                }
            }
        }
        
        _renderChildren(r);
        r.applyTransform(matrixTransform);
    }
}
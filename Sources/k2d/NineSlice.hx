package k2d;

import k2d.math.FastFloat;
import k2d.render.Renderer;
import k2d.resources.Image;

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

    static public function fromImage(img:Image, ?opts:NineSliceOptions) : NineSlice {
        var n = new NineSlice(null, opts);
        n.image = img;
        return n;
    }

    public override function new(imgName:String, ?opts:NineSliceOptions) {
        super(imgName);
        _options = opts;
    }

    public override function render(r:Renderer) {
        r.applyTransform(matrixTransform);
        if(image != null){
            if(_options != null){
                _top = _options.top;
                _bottom = _options.bottom;
                _left = _options.left;
                _right = _options.right;
            } else {
                _top = image.height/3;
                _bottom = image.height/3;
                _left = image.width/3;
                _right = image.width/3;
            }

            _centerW = image.width - (_left + _right);
            _centerH = image.height - (_top + _bottom);
            _sw = size.x - (_left + _right); 
            _sh = size.y - (_top + _bottom); 

            r.drawScaledSubImage(image, 0, 0, _left, _top, 0, 0, _left, _top);
            r.drawScaledSubImage(image, _left, 0, _centerW, _top, _left, 0, _sw, _top);
            r.drawScaledSubImage(image, _left+_centerW, 0, _right, _top, _left+_sw, 0, _right, _top);

            r.drawScaledSubImage(image, 0, _top, _left, _centerH, 0, _top, _left, _sh);
            r.drawScaledSubImage(image, _left, _top, _centerW, _centerH, _left, _top, _sw, _sh);
            r.drawScaledSubImage(image, _left+_centerW, _top, _right, _top, _left+_sw, _top, _right, _sh);
            
            r.drawScaledSubImage(image, 0, _top+_centerH, _left, _bottom, 0, _top+_sh, _left, _bottom);
            r.drawScaledSubImage(image, _left, _top+_centerH, _centerW, _bottom, _left, _top+_sh, _sw, _bottom);
            r.drawScaledSubImage(image, _left+_centerW, _top+_centerH, _right, _bottom, _left+_sw, _top+_sh, _right, _bottom);
            
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

    override function set_image(img:Image) : Image {
        if(img != null){
            if(_image == null){
                //keep the size if it's a change
                size.set(img.width, img.height);
            }
        }
        return _image = img;
    }

    //todo add tile mode
    //todo https://docs.unity3d.com/Manual/9SliceSprites.html
}
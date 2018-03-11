package gecko.components.draw;

import gecko.render.Graphics;
import gecko.Entity;
import gecko.components.draw.DrawComponent;

class RectangleComponent extends DrawComponent {
    public var width(get, set):Float32;
    private var _width:Float32 = 0;

    public var height(get, set):Float32;
    private var _height:Float32 = 0;

    public var strength:Int = 2;
    public var fill:Bool = false;

    public function init(fill:Bool, width:Float32, height:Float32, strength:Int = 2) {
        this.width = width;
        this.height = height;
        this.fill = fill;
        this.strength = strength;

        onAddedToEntity += _setTransformSize;
    }

    override public function draw(g:Graphics) {
        if(fill){
            g.fillRect(0, 0, _width, _height);
        }else{
            g.drawRect(0, 0, _width, _height, strength);
        }
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            e.transform.size.set(_width, _height);
        }
    }

    override public function beforeDestroy(){
        width = 0;
        height = 0;
        fill = false;
        strength = 2;

        onAddedToEntity -= _setTransformSize;

        super.beforeDestroy();
    }

    inline function get_width():Float32 {
        return _width;
    }

    inline function get_height():Float32 {
        return _height;
    }

    function set_width(value:Float32):Float32 {
        if(value == _width)return _width;

        _width = value;

        if(entity != null && entity.transform != null){
            entity.transform.size.x = _width;
        }

        return _width;
    }

    function set_height(value:Float32):Float32 {
        if(value == _height)return _height;

        _height = value;

        if(entity != null && entity.transform != null){
            entity.transform.size.y = _height;
        }

        return _height;
    }
}
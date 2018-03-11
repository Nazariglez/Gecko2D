package gecko.components.draw;

import gecko.render.Graphics;
import gecko.Entity;
import gecko.components.draw.DrawComponent;

class CircleComponent extends DrawComponent {
    public var radius(get, set):Float32;
    private var _radius:Float32 = 1;

    public var fill:Bool = false;
    public var strength:Float32 = 2;
    public var segments:Int = 0;
    public var diameter(default, null):Float32 = 4;

    public function init(fill:Bool, radius:Float32 = 1, strength:Float32 = 2, segments:Int = 0) {
        this.radius = radius;
        this.fill = fill;
        this.strength = strength;
        this.segments = segments;

        onAddedToEntity += _setTransformSize;
    }

    override public function draw(g:Graphics) {
        if(fill){
            g.fillCircle(_radius, _radius, _radius);
        }else{
            g.drawCircle(_radius, _radius, _radius, strength, segments);
        }
    }

    override public function beforeDestroy() {
        onAddedToEntity -= _setTransformSize;

        radius = 1;
        fill = false;
        strength = 2;

        super.beforeDestroy();
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            e.transform.size.set(diameter, diameter);
        }
    }

    inline function get_radius():Float32 {
        return _radius;
    }

    function set_radius(value:Float32):Float32 {
        if(value == _radius)return _radius;

        _radius = value;
        diameter = _radius * 2;

        if(entity != null && entity.transform != null){
            entity.transform.size.set(diameter, diameter);
        }

        return _radius;
    }

}
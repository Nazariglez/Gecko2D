package gecko.components.draw;

import gecko.math.Point;
import gecko.Graphics;
import gecko.Entity;
import gecko.components.draw.DrawComponent;

class PolygonComponent extends DrawComponent {
    private var _points:Array<Point>;

    public var fill:Bool = false;
    public var strength:Float32 = 2;

    private var _width:Float32 = 0;
    private var _height:Float32 = 0;

    public function init(fill:Bool, points:Array<Point>, strength:Float32 = 2) {
        this.fill = fill;
        this.strength = strength;
        setPoints(points);

        onAddedToEntity += _setTransformSize;
    }

    public function setPoints(points:Array<Point>) {
        _points = points;
        checkBounds();
    }

    public function checkBounds() {
        var minX = Math.POSITIVE_INFINITY;
        var minY = Math.POSITIVE_INFINITY;
        var maxX = Math.NEGATIVE_INFINITY;
        var maxY = Math.NEGATIVE_INFINITY;

        for(p in _points) {
            if(p.x < minX)minX = p.x;
            if(p.x > maxX)maxX = p.x;
            if(p.y < minY)minY = p.y;
            if(p.y > maxY)maxY = p.y;
        }

        _width = maxX - minX;
        _height = maxY - minY;

        if(entity != null){
            _setTransformSize(entity);
        }
    }

    inline public function getPoints() : Array<Point> {
        return _points;
    }

    override public function draw(g:Graphics) {
        if(fill){
            g.fillPolygon(0, 0, _points);
        }else{
            g.drawPolygon(0, 0, _points, strength);
        }
    }

    override public function beforeDestroy() {
        super.beforeDestroy();

        onAddedToEntity -= _setTransformSize;

        fill = false;

        while(_points.length > 0){
            _points.pop().destroy();
        }
    }

    private function _setTransformSize(e:Entity) {
        if(e.transform != null){
            e.transform.size.set(_width, _height);
        }
    }
}
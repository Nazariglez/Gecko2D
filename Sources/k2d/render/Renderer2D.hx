package k2d.render;

import kha.graphics2.Graphics;
import kha.graphics2.GraphicsExtension;
import kha.math.Vector2;
import k2d.Image;
import k2d.math.FastFloat;
import k2d.math.Vec2Pool;
import k2d.math.Point;
import k2d.math.Matrix;
import k2d.utils.Color;
import k2d.i.IRenderer;


class Renderer2D extends Renderer {
    public var graphics:Graphics;

    public var color(get, set):Int;
    private var _color:Int = Color.WHITE;

    public var alpha(get, set):Float;
    private var _alpha:Float = 1;

    private var _emptyMatrix:Matrix = Matrix.identity();
    public var matrix(get, set):Matrix;

    public function new(){}

    private static function _pointsToVec2(points:Array<Point>) : Array<Vector2> {
        var vecs:Array<Vector2> = [];
        for(p in points){
            vecs.push(Vec2Pool.getFromPoint(p));
        }

        return vecs;
    }

    override public function begin() {
        graphics.begin();
    }

    override public function end() {
        graphics.end();
    }

    override public function clear() {
        color = 0xffffff;
        alpha = 1;
        matrix = _emptyMatrix;
    }

    override public function setFramebuffer(framebuffer:Framebuffer) {
        _framebuffer = framebuffer;
        graphics = framebuffer.g2;
        clear();
    }

    @:extern public inline function drawLine(x1:Float, y1:Float, x2:Float, y2:Float, ?strength:Float) : Void {
		graphics.drawLine(x1, y1, x2, y2, strength);
	}

    @:extern public inline function drawImage(img:Image, x:FastFloat, y:FastFloat) : Void {
		graphics.drawImage(img, x, y);
	}

    @:extern public inline function drawString(text:String, x:Float, y:Float) : Void {
		graphics.drawString(text, x, y);
	}

    @:extern public inline function drawRect(x:Float, y:Float, width:Float, height:Float, ?strength:Float) : Void {
		graphics.drawRect(x, y, width, height, strength);
	}

    @:extern public inline function fillRect(x:Float, y:Float, width:Float, height:Float) : Void {
		graphics.fillRect(x, y, width, height);
	}

    @:extern public inline function fillTriangle(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) : Void {
		graphics.fillTriangle(x1, y1, x2, y2, x3, y3);
	}

    @:extern public inline function drawCircle(cx:Float, cy:Float, radius:Float, ?strength:Float, ?segments:Int) : Void {
		GraphicsExtension.drawCircle(graphics, cx, cy, radius, strength, segments);
	}

    @:extern public inline function drawCubicBezier(x:Array<Float>, y:Array<Float>, ?segments:Int, ?strength:Float) : Void {
		GraphicsExtension.drawCubicBezier(graphics, x, y, segments, strength);
	}

	@:extern public inline function drawCubicBezierPath(x:Array<Float>, y:Array<Float>, ?segments:Int, ?strength:Float) : Void {
		GraphicsExtension.drawCubicBezierPath(graphics, x, y, segments, strength);
	}

	//todo change Vector2 for Point and use a pool of vector2 to pass to the drawPolygon.
	@:extern public inline function drawPolygon(x:Float, y:Float, vertices:Array<Point>, ?strength:Float) : Void {
        var _pointVerts = Renderer2D._pointsToVec2(vertices);
		GraphicsExtension.drawPolygon(graphics, x, y, _pointVerts, strength);
        
        for(p in _pointVerts){ 
            Vec2Pool.put(p);
        }
	}

	@:extern public inline function fillCircle(cx:Float, cy:Float, radius:Float, ?segments:Int) : Void {
		GraphicsExtension.fillCircle(graphics, cx, cy, radius, segments);
	}

	@:extern public inline function fillPolygon(x:Float, y:Float, vertices:Array<Point>) : Void {
        var _pointVerts = Renderer2D._pointsToVec2(vertices);
		GraphicsExtension.fillPolygon(graphics, x, y, _pointVerts);

        for(p in _pointVerts){ 
            Vec2Pool.put(p);
        }
	}


    public function get_color() : Int {
		return _color;
	}

	public function set_color(value:Int) : Int {
		graphics.color = value + 0xff000000;
		return _color = value;
	}

	public function get_alpha() : Float {
		return _alpha;
	}

	public function set_alpha(value:Float) : Float {
		graphics.opacity = value;
		return _alpha = value;
    }

    public function get_matrix() : Matrix {
		return graphics.transformation;
	}

	public function set_matrix(matrix:Matrix) : Matrix {
        graphics.transformation.setFrom(matrix);
		return graphics.transformation;
	}	
}
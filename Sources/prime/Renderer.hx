package prime;

import kha.graphics2.Graphics in Graphics2d;
import kha.graphics4.Graphics in Graphics3d;
import kha.graphics2.GraphicsExtension;
import kha.math.FastMatrix3;
import kha.math.Vector2;
import kha.Image;
import kha.Video;
import kha.FastFloat;
import kha.Framebuffer;
import kha.Font;

class Renderer {
	public var framebuffer:Framebuffer;
	public var g2d:Graphics2d;
	public var g3d:Graphics3d;

	private var _font:Font;
	public var font(get, set):Font;

	private var _fontSize:Int;
	public var fontSize(get, set):Int;

	private var _color:Int = 0xffffff;
	public var color(get, set):Int;

	private var _alpha:Float = 1;
	public var alpha(get, set):Float;

	private var _cleanMatrix:FastMatrix3 = FastMatrix3.identity();

	public function new(){}

	public function setFramebuffer(framebuffer:Framebuffer) : Void {
		this.framebuffer = framebuffer;
		g2d = framebuffer.g2;
		g3d = framebuffer.g4;
	}

	public function reset() : Void {
		color = Color.White;
		g2d.opacity = 1;
		_alpha = 1;
		g2d.color = 0xffffffff;
		_color = 0xffffff;
		g2d.transformation.setFrom(_cleanMatrix);
	}

	public function renderActor(actor:Actor) : Void {
		actor.render(this);
	}

	public function setMatrix(matrix:FastMatrix3) : Void {
		g2d.transformation.setFrom(matrix);
	}

	public inline function drawImage(img:Image, x:FastFloat, y:FastFloat) : Void {
		g2d.drawImage(img, x, y);
	}

	public inline function drawLine(x1:Float, y1:Float, x2:Float, y2:Float, ?strength:Float) : Void {
		g2d.drawLine(x1, y1, x2, y2, strength);
	}

	public inline function drawRect(x:Float, y:Float, width:Float, height:Float, ?strength:Float) : Void {
		g2d.drawRect(x, y, width, height, strength);
	}

	public inline function drawString(text:String, x:Float, y:Float) : Void {
		g2d.drawString(text, x, y);
	}

	public inline function drawVideo(video:Video, x:Float, y:Float, width:Float, height:Float) : Void {
		g2d.drawVideo(video, x, y, width, height);
	}

	public inline function fillRect(x:Float, y:Float, width:Float, height:Float) : Void {
		g2d.fillRect(x, y, width, height);
	}

	public inline function fillTriangle(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) : Void {
		g2d.fillTriangle(x1, y1, x2, y2, x3, y3);
	}

	public inline function drawCircle(cx:Float, cy:Float, radius:Float, ?strength:Float, ?segments:Int) : Void {
		GraphicsExtension.drawCircle(g2d, cx, cy, radius, strength, segments);
	}

	public inline function drawCubicBezier(x:Array<Float>, y:Array<Float>, ?segments:Int, ?strength:Float) : Void {
		GraphicsExtension.drawCubicBezier(g2d, x, y, segments, strength);
	}

	public inline function drawCubicBezierPath(x:Array<Float>, y:Array<Float>, ?segments:Int, ?strength:Float) : Void {
		GraphicsExtension.drawCubicBezierPath(g2d, x, y, segments, strength);
	}

	//todo change Vector2 for Point and use a pool of vector2 to pass to the drawPolygon.
	public inline function drawPolygon(x:Float, y:Float, vertices:Array<Vector2>, ?strength:Float) : Void {
		GraphicsExtension.drawPolygon(g2d, x, y, vertices, strength);
	}

	public inline function fillCircle(cx:Float, cy:Float, radius:Float, ?segments:Int) : Void {
		GraphicsExtension.fillCircle(g2d, cx, cy, radius, segments);
	}

	public inline function fillPolygon(x:Float, y:Float, vertices:Array<Vector2>) : Void {
		GraphicsExtension.fillPolygon(g2d, x, y, vertices);
	}

	public function get_color() : Int {
		return _color;
	}

	public function set_color(value:Int) : Int {
		g2d.color = value + 0xff000000;
		return _color = value;
	}

	public function get_alpha() : Float {
		return _alpha;
	}

	public function set_alpha(value:Float) : Float {
		g2d.opacity = value;
		return _alpha = value;
	}	

	public function get_font() : Font {
		return _font;
	}

	public function set_font(value:Font) : Font {
		g2d.font = value;
		return _font = value;
	}	

	public function get_fontSize() : Int {
		return _fontSize;
	}

	public function set_fontSize(value:Int) : Int {
		g2d.fontSize = value;
		return _fontSize = value;
	}	
}
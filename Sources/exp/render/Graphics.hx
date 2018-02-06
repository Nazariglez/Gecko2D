package exp.render;

import exp.Color;
import exp.math.FastFloat;
import exp.math.Matrix;
import exp.math.Point;
import exp.math.Vec2Pool;
import exp.render.BlendMode;
import exp.resources.Font;
import exp.resources.Image;
import exp.resources.Texture;
import exp.resources.Video;
import kha.graphics2.GraphicsExtension;
import kha.graphics4.PipelineState;
import kha.math.Vector2;

class Graphics {
	static public var emptyMatrix:Matrix = Matrix.identity();

	public var buffer(get, null):Image;
	private var _buffer:Image;

	public var isRendering(get, null):Bool;
	private var _isRendering:Bool = false;

	public var g2:kha.graphics2.Graphics;
    public var g4:kha.graphics4.Graphics;
	private var _g2Cache:kha.graphics2.Graphics;
    private var _g4Cache:kha.graphics4.Graphics;
	
    public var color(get, set):Color;
    private var _color:Color = Color.White;

    public var alpha(get, set):Float;
    private var _alpha:Float = 1;

    public var font(get, set):Font;
    private var _font:Font;

    public var fontSize(get, set):Int;
    private var _fontSize:Int = 1;

	public var blendMode(get, set):BlendMode;
	private var _blendMode:BlendMode;

	private var _blendPipeline:PipelineState;

    public var matrix(get, set):Matrix;

	private var _swtTemp:FastFloat;
	private var _shtTemp:FastFloat;
	private var _dwTemp:FastFloat;
	private var _dhTemp:FastFloat;

	private var _temp1:FastFloat;
	private var _temp2:FastFloat;
	private var _temp3:FastFloat;
	private var _temp4:FastFloat;
	private var _temp5:FastFloat;
	private var _temp6:FastFloat;

    public function new(){}

    private static function _pointsToVec2(points:Array<Point>) : Array<Vector2> {
        var vecs:Array<Vector2> = [];
        for(p in points){
            vecs.push(Vec2Pool.getFromPoint(p));
        }

        return vecs;
    }


	public function setBuffer(buffer:Image) {
		if(_isRendering){
			throw "You can't change the buffer while rendering";
		}
		_buffer = buffer;
	}

	public function beginRenderTarget(img:Image) {
		g2.end();

		_g2Cache = g2;
		_g4Cache = g4;

		g2 = img.g2;
		g4 = img.g4;

		g2.begin(false);
	}

	public function endRenderTarget() {
		g2.end();

		g2 = _g2Cache;
		g4 = _g4Cache;

		_g2Cache = null;
		_g4Cache = null;

		g2.begin();
	}

    public function begin(clear: Bool = true, ?color:Color) {
		_isRendering = true;
        buffer.g2.begin(clear, color);
    }

    public function end() {
        buffer.g2.end();
		_isRendering = false;
    }

	public function clear(color:Color = null) {
		buffer.g2.clear(color);
	}

    public function reset() {
        color = 0xffffff;
        alpha = 1;
        matrix = Graphics.emptyMatrix;
    }

	public function applyTransform(transform:gecko.math.MatrixTransform) {
		color = transform.tint;
		alpha = transform.alpha;
		matrix = transform.world;
	}

    public inline function drawLine(x1:Float, y1:Float, x2:Float, y2:Float, ?strength:Float) : Void {
		buffer.g2.drawLine(x1, y1, x2, y2, strength);
	}

    public inline function drawImage(img:Image, x:FastFloat, y:FastFloat) : Void {
		buffer.g2.drawImage(img, x, y);
	}

	public inline function drawTexture(texture:Texture, x:FastFloat, y:FastFloat) : Void {
		if(texture.rotated){
			_swtTemp = texture.frame.width*texture.pivot.x;
			_shtTemp = texture.frame.height*texture.pivot.y;
			buffer.g2.pushTransformation(kha.math.FastMatrix3.translation(-_swtTemp, -_shtTemp));
			buffer.g2.rotate(-0.5*Math.PI, x, y);
			buffer.g2.transformation._20 += _shtTemp;
            buffer.g2.transformation._21 += _swtTemp;

			if(texture.trimmed){
            	buffer.g2.drawSubImage(texture.image, x-texture.trim.x, y+texture.trim.y, texture.frame.x, texture.frame.y, texture.trim.width, texture.trim.height);
			}else{
            	buffer.g2.drawSubImage(texture.image, x, y, texture.frame.x, texture.frame.y, texture.frame.width, texture.frame.height);
			}

			buffer.g2.popTransformation();
		}else{
			if(texture.trimmed){
				buffer.g2.drawSubImage(texture.image, x+texture.trim.x, y+texture.trim.y, texture.frame.x, texture.frame.y, texture.trim.width, texture.trim.height);
			}else{
				buffer.g2.drawSubImage(texture.image, x, y, texture.frame.x, texture.frame.y, texture.frame.width, texture.frame.height);
			}
		}
	}

	public inline function drawSubImage(img: Image, x: FastFloat, y: FastFloat, sx: FastFloat, sy: FastFloat, sw: FastFloat, sh: FastFloat): Void {
		buffer.g2.drawSubImage(img, x, y, sx, sy, sw, sh);
	}

	private inline function _drawSubTextureRotated(texture: Texture, x: FastFloat, y: FastFloat, sx: FastFloat, sy: FastFloat, sw: FastFloat, sh: FastFloat) : Void {
		_temp3 = texture.frame.width*texture.pivot.x;
		_temp4 = texture.frame.height*texture.pivot.y;
		buffer.g2.pushTransformation(kha.math.FastMatrix3.translation(-_temp3, -_temp4));
		buffer.g2.rotate(-0.5*Math.PI, x, y);
		buffer.g2.transformation._20 += _temp4;
		buffer.g2.transformation._21 += _temp3;
		
		if(texture.trimmed){
			_swtTemp = (sx > texture.trim.x ? sx-texture.trim.x : 0);
			_temp1 = texture.trim.x-sx;
			_temp1 = _temp1 < 0 ? 0 : _temp1;

			_shtTemp = (sy > texture.trim.y ? sy-texture.trim.y : 0);
			_temp2 = texture.trim.y-sy;
			_temp2 = _temp2 < 0 ? 0 : _temp2;

			_temp5 = sw - _temp1;
			_temp5 = _temp5 > texture.trim.width ? texture.trim.width : _temp5;

			_temp6 = sh - _temp2;
			_temp6 = _temp6 > texture.trim.height ? texture.trim.height : _temp6;

			buffer.g2.drawSubImage(
				texture.image, 
				x-(_temp2 < 0 ? 0 : _temp2),//_temp2,
				y+(_temp1 < 0 ? 0 : _temp1), 
				texture.frame.x - _shtTemp,
				texture.frame.y + _swtTemp, 
				_temp6,
				_temp5
			);
		}else{
			buffer.g2.drawSubImage(
				texture.image, 
				x,
				y,
				texture.frame.x - sy, 
				texture.frame.y + sx, 
				sh, //(sw > _swtTemp ? _swtTemp : sw) + _temp3, 
				sw //(sh > _shtTemp ? _shtTemp : sh)
			);
		}

		buffer.g2.popTransformation();
	}

	private inline function _drawSubTexture(texture:Texture, x:FastFloat, y:FastFloat, sx:FastFloat, sy:FastFloat, sw:FastFloat, sh:FastFloat) {
		if(texture.trimmed){
				_swtTemp = (sx > texture.trim.x ? sx-texture.trim.x : 0);
				_shtTemp = (sy > texture.trim.y ? sy-texture.trim.y : 0);

				_temp1 = texture.trim.x-sx;
				_temp1 = _temp1 < 0 ? 0 : _temp1;

				_temp2 = texture.trim.y-sy;
				_temp2 = _temp2 < 0 ? 0 : _temp2;

				_temp3 = sw - _temp1;
				_temp3 = _temp3 > texture.trim.width ? texture.trim.width : _temp3;

				_temp4 = sh - _temp2;
				_temp4 = _temp4 > texture.trim.height ? texture.trim.height : _temp4;

				buffer.g2.drawSubImage(
					texture.image, 
					x + _temp1, 
					y + _temp2, 
					texture.frame.x + _swtTemp,
					texture.frame.y + _shtTemp, 
					_temp3,
					_temp4
				);
			}else{
				_swtTemp = texture.frame.width-sx;
				_shtTemp = texture.frame.height-sy;

				buffer.g2.drawSubImage(
					texture.image, 
					x, 
					y, 
					texture.frame.x + sx, 
					texture.frame.y + sy, 
					sw > _swtTemp ? _swtTemp : sw, 
					sh > _shtTemp ? _shtTemp : sh
				);
			}
	}

	public inline function drawSubTexture(texture: Texture, x: FastFloat, y: FastFloat, sx: FastFloat, sy: FastFloat, sw: FastFloat, sh: FastFloat): Void {
		if(texture.rotated){
			_drawSubTextureRotated(texture, x, y, sx, sy, sw, sh);
		}else{
			_drawSubTexture(texture, x, y, sx, sy, sw, sh);
		}
	}

	public inline function drawScaledImage(img: Image, dx: FastFloat, dy: FastFloat, dw: FastFloat, dh: FastFloat): Void {
		buffer.g2.drawScaledImage(img, dx, dy, dw, dh);
	}

	public inline function drawScaledTexture(texture: Texture, dx: FastFloat, dy: FastFloat, dw: FastFloat, dh: FastFloat): Void {
		if(texture.trimmed){
			buffer.g2.drawScaledSubImage(
				texture.image, 
				texture.frame.x-texture.trim.x, 
				texture.frame.y-texture.trim.y, 
				texture.trim.width+texture.trim.x, 
				texture.trim.height+texture.trim.y, 
				dx, 
				dy, 
				dw - texture.trim.x, 
				dh - texture.trim.y
			);
		}else{
			buffer.g2.drawScaledSubImage(texture.image, texture.frame.x, texture.frame.y, texture.frame.width, texture.frame.height, texture.frame.x + dx, texture.frame.y + dy, dw, dh);
		}
	}

	public inline function drawScaledSubImage(image: Image, sx: FastFloat, sy: FastFloat, sw: FastFloat, sh: FastFloat, dx: FastFloat, dy: FastFloat, dw: FastFloat, dh: FastFloat): Void {
		buffer.g2.drawScaledSubImage(image, sx, sy, sw, sh, dx, dy, dw, dh);
	}

	public inline function drawScaledSubTexture(texture: Texture, sx: FastFloat, sy: FastFloat, sw: FastFloat, sh: FastFloat, dx: FastFloat, dy: FastFloat, dw: FastFloat, dh: FastFloat): Void {
		if(texture.trimmed){
			_swtTemp = texture.trim.width+texture.trim.x-sx;
			_swtTemp = sw < _swtTemp ? sw : _swtTemp;

			_shtTemp = texture.trim.height+texture.trim.y-sy;
			_shtTemp = sh < _shtTemp ? sh : _shtTemp;

			_dwTemp = dw-texture.trim.x;
			_dhTemp = dh-texture.trim.y;

			buffer.g2.drawScaledSubImage( //todo fix
				texture.image, 
				texture.frame.x - texture.trim.x + sx, 
				texture.frame.y - texture.trim.y + sy, 
				_swtTemp, 
				_shtTemp, 
				dx,
				dy,
				dw,
				dh
			);
		}else{
			buffer.g2.drawScaledSubImage(
				texture.image, 
				texture.frame.x + sx, 
				texture.frame.y + sy, 
				sw < texture.frame.width ? sw : texture.frame.width, 
				sh < texture.frame.height ? sh : texture.frame.height, 
				dx, 
				dy, 
				dw, 
				dh
			);
		}
	}

	public inline function drawVideo(video:Video, x:Float, y:Float, width:Float, height:Float) : Void {
		buffer.g2.drawVideo(video, x, y, width, height);
	}

    public inline function drawText(text:String, x:Float, y:Float) : Void {
		buffer.g2.drawString(text, x, y);
	}

    public inline function drawAlignedText(text:String, x:Float, y:Float, horAlign:HorizontalTextAlign, verAlign:VerticalTextAlign) : Void {
        GraphicsExtension.drawAlignedString(g2, text, x, y, horAlign, verAlign);
    }

    public inline function drawAlignedCharacters(text:Array<Int>, start:Int, end:Int, x:Float, y:Float, horAlign:HorizontalTextAlign, verAlign:VerticalTextAlign) : Void {
        GraphicsExtension.drawAlignedCharacters(g2, text, start, end, x, y, horAlign, verAlign);
    }

    public inline function drawRect(x:Float, y:Float, width:Float, height:Float, ?strength:Float) : Void {
		buffer.g2.drawRect(x, y, width, height, strength);
	}

    public inline function fillRect(x:Float, y:Float, width:Float, height:Float) : Void {
		buffer.g2.fillRect(x, y, width, height);
	}

    public inline function fillTriangle(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float) : Void {
		buffer.g2.fillTriangle(x1, y1, x2, y2, x3, y3);
	}

	public inline function drawArc(cx: Float, cy: Float, radius: Float, sAngle: Float, eAngle: Float, strength: Float = 1.0, ccw: Bool = false) {
		GraphicsExtension.drawArc(g2, cx, cy, radius, sAngle, eAngle, strength, ccw);
	}

	public inline function fillArc(cx: Float, cy: Float, radius: Float, sAngle: Float, eAngle: Float, ccw: Bool = false) {
		GraphicsExtension.fillArc(g2, cx, cy, radius, sAngle, eAngle, ccw);
	}

	public inline function drawCircle(cx:Float, cy:Float, radius:Float, ?strength:Float, ?segments:Int) : Void {
		GraphicsExtension.drawCircle(g2, cx, cy, radius, strength, segments);
	}

    public inline function drawCubicBezier(x:Array<Float>, y:Array<Float>, ?segments:Int, ?strength:Float) : Void {
		GraphicsExtension.drawCubicBezier(g2, x, y, segments, strength);
	}

	public inline function drawCubicBezierPath(x:Array<Float>, y:Array<Float>, ?segments:Int, ?strength:Float) : Void {
		GraphicsExtension.drawCubicBezierPath(g2, x, y, segments, strength);
	}

	//todo change Vector2 for Point and use a pool of vector2 to pass to the drawPolygon.
	public inline function drawPolygon(x:Float, y:Float, vertices:Array<Point>, ?strength:Float) : Void {
        var _pointVerts = Graphics._pointsToVec2(vertices);
		GraphicsExtension.drawPolygon(g2, x, y, _pointVerts, strength);
        
        for(p in _pointVerts){ 
            Vec2Pool.put(p);
        }
	}

	public inline function fillCircle(cx:Float, cy:Float, radius:Float, ?segments:Int) : Void {
		GraphicsExtension.fillCircle(g2, cx, cy, radius, segments);
	}

	public inline function fillPolygon(x:Float, y:Float, vertices:Array<Point>) : Void {
        var _pointVerts = Graphics._pointsToVec2(vertices);
		GraphicsExtension.fillPolygon(g2, x, y, _pointVerts);

        for(p in _pointVerts){ 
            Vec2Pool.put(p);
        }
	}


    inline function get_color() : Color {
		return _color;
	}

	inline function set_color(value:Color) : Color {
		buffer.g2.color = value;
		return _color = value;
	}

	inline function get_alpha() : Float {
		return _alpha;
	}

	inline function set_alpha(value:Float) : Float {
		buffer.g2.opacity = value;
		return _alpha = value;
    }

    inline function get_matrix() : Matrix {
		return buffer.g2.transformation;
	}

	inline function set_matrix(matrix:Matrix) : Matrix {
        buffer.g2.transformation.setFrom(matrix);
		return buffer.g2.transformation;
    }

    inline function get_font() : Font {
		return _font;
	}

	inline function set_font(value:Font) : Font {
		buffer.g2.font = value;
		return _font = value;
	}	

	inline function get_fontSize() : Int {
		return _fontSize;
	}

	inline function set_fontSize(value:Int) : Int {
		buffer.g2.fontSize = value;
		return _fontSize = value;
	}

	inline function set_blendMode(blend:BlendMode) : BlendMode {
		if(blend != _blendMode){
			_blendMode = blend;
			buffer.g2.pipeline = blend != null ? blend.getPipeline() : null;
		}

		return _blendMode;
	}

	inline function get_blendMode() : BlendMode {
		return _blendMode;
	}

	inline function get_isRendering():Bool {
		return _isRendering;
	}

	inline function get_buffer():Image {
		return _buffer;
	}
}
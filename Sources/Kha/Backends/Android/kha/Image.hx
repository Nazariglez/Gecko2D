package kha;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.opengl.GLES20;
import android.opengl.GLES11Ext;
import android.opengl.GLUtils;
import haxe.io.Bytes;
import java.lang.ref.WeakReference;
import java.NativeArray;
import java.nio.Buffer;
import java.nio.ByteBuffer;
import java.io.IOException;
import kha.graphics4.TextureFormat;
import kha.graphics4.DepthStencilFormat;
import kha.graphics4.Usage;

class Image implements Canvas implements Resource {
	public static var assets: AssetManager;

	private var myWidth: Int;
	private var myHeight: Int;
	private var myRealWidth: Int;
	private var myRealHeight: Int;
	private var format: TextureFormat;
	public var tex: Int = -1;
	public var framebuffer: Int = -1;
	private var depthStencilBuffers: NativeArray<Int>;

	private var graphics1: kha.graphics1.Graphics;
	private var graphics2: kha.graphics2.Graphics;
	private var graphics4: kha.graphics4.Graphics;

	public function new(width: Int, height: Int, format: TextureFormat, renderTarget: Bool, depthAndStencil: DepthStencilFormat) {
		myWidth = width;
		myHeight = height;
		myRealWidth = upperPowerOfTwo(width);
		myRealHeight = upperPowerOfTwo(height);
		this.format = format;
		tex = createTexture();
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex);
		//Sys.gl.pixelStorei(Sys.gl.UNPACK_FLIP_Y_WEBGL, true);

		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, GLES20.GL_LINEAR);
		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_LINEAR);
		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_S, GLES20.GL_CLAMP_TO_EDGE);
		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_T, GLES20.GL_CLAMP_TO_EDGE);

		if (renderTarget) {
			framebuffer = createFramebuffer();
			GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, framebuffer);
			GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, realWidth, realHeight, 0, GLES20.GL_RGBA, format == TextureFormat.RGBA128 ? GLES20.GL_FLOAT : GLES20.GL_UNSIGNED_BYTE, null);
			GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_COLOR_ATTACHMENT0, GLES20.GL_TEXTURE_2D, tex, 0);

			switch (depthAndStencil) {
				case NoDepthAndStencil: { }
				case DepthOnly: setupDepthBufferOnly();
				case DepthAutoStencilAuto: runDepthAndStencilSetupChain();
				case Depth24Stencil8: {
					#if debug
					trace('DepthAndStencilFormat "Depth24Stencil8" not (yet?) supported on android, using target defaults');
					#end
					runDepthAndStencilSetupChain();
				}
				case Depth32Stencil8: {
					#if debug
					trace('DepthAndStencilFormat "Depth32Stencil8" not (yet?) supported on android, using target defaults');
					#end
					runDepthAndStencilSetupChain();
				}
				case Depth16: {
					#if debug
					trace('DepthAndStencilFormat "Depth16" not (yet?) supported on android, using target defaults');
					#end
					runDepthAndStencilSetupChain();
				}
			}

			GLES20.glBindFramebuffer(GLES20.GL_FRAMEBUFFER, 0);
		} else {
			//GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, GLES20.GL_RGBA, format == TextureFormat.RGBA128 ? GLES20.GL_FLOAT : GLES20.GL_UNSIGNED_BYTE, image);
			switch (format) {
			case L8:
				GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_LUMINANCE, realWidth, realHeight, 0, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, null);
			case RGBA128:
				GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, realWidth, realHeight, 0, GLES20.GL_RGBA, GLES20.GL_FLOAT, null);
			case RGBA32:
				GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, realWidth, realHeight, 0, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);
			default:
				GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, realWidth, realHeight, 0, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);
			}
		}
		//Sys.gl.generateMipmap(Sys.gl.TEXTURE_2D);
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, 0);
	}

	function runDepthAndStencilSetupChain() {
		var setupModes = [setup_oesExtension, setup_separateBuffers];
		var succeeded = false;

		for (setup in setupModes) {
			var result = setup();
			logFramebufferStatus(result);
			if (result == GLES20.GL_FRAMEBUFFER_COMPLETE) {
				succeeded = true;
				trace('working depth/stencil combination found');
				break;
			}
			trace('trying next setup');
		}

		if (!succeeded) {
			trace('no valid depth/stencil combination found');
		}
	}

	function setupDepthBufferOnly(): Int {
		trace('GL_DEPTH_COMPONENT16 setup');

		depthStencilBuffers = new NativeArray<Int>(1);
		GLES20.glGenRenderbuffers(1, depthStencilBuffers, 0);

		var depthBuffer = depthStencilBuffers[0];

		GLES20.glBindRenderbuffer(GLES20.GL_RENDERBUFFER, depthBuffer);
		GLES20.glRenderbufferStorage(GLES20.GL_RENDERBUFFER, GLES20.GL_DEPTH_COMPONENT16, realWidth, realHeight);
		GLES20.glFramebufferRenderbuffer(GLES20.GL_FRAMEBUFFER, GLES20.GL_DEPTH_ATTACHMENT, GLES20.GL_RENDERBUFFER, depthBuffer);

		GLES20.glBindRenderbuffer(GLES20.GL_RENDERBUFFER, 0);

		var result = GLES20.glCheckFramebufferStatus(GLES20.GL_FRAMEBUFFER);

		if (result != GLES20.GL_FRAMEBUFFER_COMPLETE) {
			GLES20.glDeleteRenderbuffers(depthStencilBuffers.length, depthStencilBuffers, 0);
		}

		return result;
	}

	function setup_oesExtension(): Int {
		trace('GL_DEPTH_STENCIL_OES setup');

		depthStencilBuffers = new NativeArray<Int>(1);
		GLES20.glGenTextures(1, depthStencilBuffers, 0);

		var dsBuffer = depthStencilBuffers[0];

		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, dsBuffer);

		GLES20.glTexParameteri(GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, GLES20.GL_LINEAR);
		GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES11Ext.GL_DEPTH_STENCIL_OES, realWidth, realHeight, 0, GLES11Ext.GL_DEPTH_STENCIL_OES, GLES11Ext.GL_UNSIGNED_INT_24_8_OES, null);
		GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_DEPTH_ATTACHMENT, GLES20.GL_TEXTURE_2D, dsBuffer, 0);
		GLES20.glFramebufferTexture2D(GLES20.GL_FRAMEBUFFER, GLES20.GL_STENCIL_ATTACHMENT, GLES20.GL_TEXTURE_2D, dsBuffer, 0);
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, 0);

		var result = GLES20.glCheckFramebufferStatus(GLES20.GL_FRAMEBUFFER);

		if (result != GLES20.GL_FRAMEBUFFER_COMPLETE) {
			GLES20.glDeleteRenderbuffers(depthStencilBuffers.length, depthStencilBuffers, 0);
		}

		return result;
	}

	// TODO (DK)
	//	-doesn't fail, but doesn't work on my htc desire x -.-
	//	-fails on galaxy s4 at work
	function setup_separateBuffers(): Int {
		trace('GL_DEPTH_COMPONENT16 / GL_STENCIL_INDEX8 setup');

		depthStencilBuffers = new NativeArray<Int>(2);
		GLES20.glGenRenderbuffers(2, depthStencilBuffers, 0);

		var depthBuffer = depthStencilBuffers[0];
		var stencilBuffer = depthStencilBuffers[1];

		GLES20.glBindRenderbuffer(GLES20.GL_RENDERBUFFER, depthBuffer);
		GLES20.glRenderbufferStorage(GLES20.GL_RENDERBUFFER, GLES20.GL_DEPTH_COMPONENT16, realWidth, realHeight);

		GLES20.glBindRenderbuffer(GLES20.GL_RENDERBUFFER, stencilBuffer);
		GLES20.glRenderbufferStorage(GLES20.GL_RENDERBUFFER, GLES20.GL_STENCIL_INDEX8, realWidth, realHeight);

		GLES20.glFramebufferRenderbuffer(GLES20.GL_FRAMEBUFFER, GLES20.GL_DEPTH_ATTACHMENT, GLES20.GL_RENDERBUFFER, depthBuffer);
		GLES20.glFramebufferRenderbuffer(GLES20.GL_FRAMEBUFFER, GLES20.GL_STENCIL_ATTACHMENT, GLES20.GL_RENDERBUFFER, stencilBuffer);

		GLES20.glBindRenderbuffer(GLES20.GL_RENDERBUFFER, 0);

		var result = GLES20.glCheckFramebufferStatus(GLES20.GL_FRAMEBUFFER);

		if (result != GLES20.GL_FRAMEBUFFER_COMPLETE) {
			GLES20.glDeleteRenderbuffers(depthStencilBuffers.length, depthStencilBuffers, 0);
		}

		return result;
	}
	
	private static function convertFramebufferStatus(status: Int): String {
		if (status == GLES20.GL_FRAMEBUFFER_COMPLETE) return "complete";
		else if (status == GLES20.GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT) return "incomplete attachments";
		else if (status == GLES20.GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT) return "incomplete missing attachments";
		else if (status == GLES20.GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS) return "incomplete dimensions";
		else if (status == GLES20.GL_FRAMEBUFFER_UNSUPPORTED) return "invalid combination of attachments";
		else return "unknown";
	}

	private static function logFramebufferStatus(status: Int) {
		var message = convertFramebufferStatus(status);
		trace('framebuffer status "${message}"');
	}

	@:allow(kha.LoaderImpl)
	private static function createFromFile(filename: String): Image {
		try {
			var b = BitmapFactory.decodeStream(assets.open(filename));
			var image = new Image(b.getWidth(), b.getHeight(), TextureFormat.RGBA32, false, DepthStencilFormat.NoDepthAndStencil);
			GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, image.tex);

			GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, image.realWidth, image.realHeight, 0, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, null);

			GLUtils.texSubImage2D(GLES20.GL_TEXTURE_2D, 0, 0, 0, b, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE);

			//var buffer = ByteBuffer.allocateDirect(b.getWidth() * b.getHeight() * 4);
			//b.copyPixelsToBuffer(buffer);
			//GLES20.glTexImage2D(GLES20.GL_TEXTURE_2D, 0, GLES20.GL_RGBA, image.realWidth, image.realHeight, 0, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer);
			//GLES20.glTexSubImage2D(GLES20.GL_TEXTURE_2D, 0, 0, 0, b.getWidth(), b.getHeight(), GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, buffer);

			//GLUtils.texImage2D(GLES20.GL_TEXTURE_2D, 0, b, 0);

			return image;
		}
		catch (ex: IOException) {
			ex.printStackTrace();
			return null;
		}
	}

	public static function create(width: Int, height: Int, format: TextureFormat = null, usage: Usage = null): Image {
		if (format == null) format = TextureFormat.RGBA32;
		if (usage == null) usage = Usage.StaticUsage;
		return new Image(width, height, format, false, DepthStencilFormat.NoDepthAndStencil);
	}

	public static function create3D(width: Int, height: Int, depth: Int, format: TextureFormat = null, usage: Usage = null): Image {
		return null;
	}

	public static function createRenderTarget(width: Int, height: Int, format: TextureFormat = null, depthStencil: DepthStencilFormat = DepthStencilFormat.NoDepthAndStencil, antiAliasingSamples: Int = 1, contextId: Int = 0): Image {
		if (format == null) format = TextureFormat.RGBA32;
		return new Image(width, height, format, true, depthStencil);
	}
	
	public static function fromBytes(bytes: Bytes, width: Int, height: Int, format: TextureFormat = null, usage: Usage = null): Image {
		return null;
	}

	public static function fromBytes3D(bytes: Bytes, width: Int, height: Int, depth: Int, format: TextureFormat = null, usage: Usage = null): Image {
		return null;
	}

	public var g1(get, null): kha.graphics1.Graphics;

	private function get_g1(): kha.graphics1.Graphics {
		if (graphics1 == null) {
			graphics1 = new kha.graphics2.Graphics1(this);
		}
		return graphics1;
	}

	public var g2(get, null): kha.graphics2.Graphics;

	private function get_g2(): kha.graphics2.Graphics {
		if (graphics2 == null) {
			graphics2 = new kha.graphics4.Graphics2(this);
		}
		return graphics2;
	}

	public var g4(get, null): kha.graphics4.Graphics;

	private function get_g4(): kha.graphics4.Graphics {
		if (graphics4 == null) {
			graphics4 = new kha.android.Graphics(this);
		}
		return graphics4;
	}

	public function unload(): Void {
		if (tex >= 0) {
			var textures = new NativeArray<Int>(1);
			textures[0] = tex;
			GLES20.glDeleteTextures(1, textures, 0);
		}
		if (framebuffer >= 0) {
			var framebuffers = new NativeArray<Int>(1);
			framebuffers[0] = framebuffer;
			GLES20.glDeleteFramebuffers(1, framebuffers, 0);
		}
		if (depthStencilBuffers != null) {
			GLES20.glDeleteRenderbuffers(depthStencilBuffers.length, depthStencilBuffers, 0);
			depthStencilBuffers = null;
		}
	}

	private static function createFramebuffer(): Int {
		var framebuffers = new NativeArray<Int>(1);
		GLES20.glGenFramebuffers(1, framebuffers, 0);
		return framebuffers[0];
	}

	private static function createTexture(): Int {
		var textures = new NativeArray<Int>(1);
		GLES20.glGenTextures(1, textures, 0);
		return textures[0];
	}

	public function set(stage: Int): Void {
		GLES20.glActiveTexture(GLES20.GL_TEXTURE0 + stage);
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex);
	}

	public var width(get, null): Int;

	private function get_width(): Int {
		return myWidth;
	}

	public var height(get, null): Int;

	private function get_height(): Int {
		return myHeight;
	}

	public var depth(get, null): Int;

	private function get_depth(): Int {
		return 1;
	}

	public var realWidth(get, null): Int;

	private function get_realWidth(): Int {
		return myRealWidth;
	}

	public var realHeight(get, null): Int;

	private function get_realHeight(): Int {
		return myRealHeight;
	}

	public function at(x: Int, y: Int): Int {
		return 0;
	}

	public function isOpaque(x: Int, y: Int): Bool {
		//return (b.getPixel(x, y) >> 24) != 0;
		return true;
	}

	private var bytes: Bytes = null;

	public function lock(level: Int = 0): Bytes {
		bytes = Bytes.alloc(format == TextureFormat.RGBA32 ? 4 * width * height : (format == TextureFormat.RGBA128 ? 16 * width * height : width * height));
		return bytes;
	}

	public function unlock(): Void {
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, tex);
		//Sys.gl.pixelStorei(Sys.gl.UNPACK_FLIP_Y_WEBGL, true);

		switch (format) {
		case L8:
			GLES20.glTexSubImage2D(GLES20.GL_TEXTURE_2D, 0, 0, 0, width, height, GLES20.GL_LUMINANCE, GLES20.GL_UNSIGNED_BYTE, ByteBuffer.wrap(bytes.getData()));
		case RGBA128:
			GLES20.glTexSubImage2D(GLES20.GL_TEXTURE_2D, 0, 0, 0, width, height, GLES20.GL_RGBA, GLES20.GL_FLOAT, ByteBuffer.wrap(bytes.getData()));
		case RGBA32:
			GLES20.glTexSubImage2D(GLES20.GL_TEXTURE_2D, 0, 0, 0, width, height, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, ByteBuffer.wrap(bytes.getData()));
		default:
			GLES20.glTexSubImage2D(GLES20.GL_TEXTURE_2D, 0, 0, 0, width, height, GLES20.GL_RGBA, GLES20.GL_UNSIGNED_BYTE, ByteBuffer.wrap(bytes.getData()));
		}

		//Sys.gl.generateMipmap(Sys.gl.TEXTURE_2D);
		GLES20.glBindTexture(GLES20.GL_TEXTURE_2D, 0);
		bytes = null;
	}

	public function getPixels(): Bytes {
		return null;
	}

	public function generateMipmaps(levels: Int): Void {
		
	}

	public function setMipmaps(mipmaps: Array<Image>): Void {

	}

	public function setDepthStencilFrom(image: Image): Void {
		
	}

	public function clear(x: Int, y: Int, z: Int, width: Int, height: Int, depth: Int, color: Color): Void {
		
	}

	public static var maxSize(get, null): Int;

	public static function get_maxSize(): Int {
		return 2048;
	}

	public static var nonPow2Supported(get, null): Bool;

	public static function get_nonPow2Supported(): Bool {
		return false;
	}

	private static function upperPowerOfTwo(v: Int): Int {
		v--;
		v |= v >>> 1;
		v |= v >>> 2;
		v |= v >>> 4;
		v |= v >>> 8;
		v |= v >>> 16;
		v++;
		return v;
	}
}

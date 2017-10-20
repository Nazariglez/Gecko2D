package kha.js;

import haxe.ds.Vector;
import kha.graphics4.BlendingOperation;
import kha.graphics4.CompareMode;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CubeMap;
import kha.graphics4.CullMode;
import kha.graphics4.Graphics;
import kha.graphics4.IndexBuffer;
import kha.graphics4.MipMapFilter;
import kha.graphics4.PipelineState;
import kha.graphics4.StencilAction;
import kha.graphics4.TextureAddressing;
import kha.graphics4.TextureFilter;
import kha.graphics4.TextureFormat;
import kha.graphics4.TextureUnit;
import kha.graphics4.Usage;
import kha.graphics4.VertexBuffer;
import kha.math.FastMatrix3;
import kha.math.FastMatrix4;
import kha.math.FastVector2;
import kha.math.FastVector3;
import kha.math.FastVector4;
import kha.math.Matrix4;
import kha.math.Vector2;
import kha.math.Vector3;
import kha.math.Vector4;

class EmptyGraphics4 implements Graphics {
	public function new(width: Int, height: Int) {
		
	}
	
	public function init(?backbufferFormat: TextureFormat, antiAliasingSamples: Int = 1): Void {

	}
	
	public function begin(additionalRenderTargets: Array<Canvas> = null): Void {
		
	}

	public function beginFace(face: Int): Void {

	}

	public function beginEye(eye: Int): Void {
		
	}

	public function end(): Void {
		
	}
	
	public function flush(): Void {
		
	}
	
	public function vsynced(): Bool {
		return true;
	}

	public function refreshRate(): Int {
		return 60;
	}
	
	public function clear(?color: Color, ?depth: Float, ?stencil: Int): Void {
		
	}

	public function viewport(x : Int, y : Int, width : Int, height : Int): Void{
		
	}
	
	public function setCullMode(mode: CullMode): Void {
		
	}
	
	public function setDepthMode(write: Bool, mode: CompareMode): Void {
		
	}

	public function setBlendingMode(source: BlendingOperation, destination: BlendingOperation): Void {
		
	}

	public function setStencilParameters(compareMode: CompareMode, bothPass: StencilAction, depthFail: StencilAction, stencilFail: StencilAction, referenceValue: Int, readMask: Int = 0xff, writeMask: Int = 0xff): Void {
		
	}

	public function scissor(x: Int, y: Int, width: Int, height: Int): Void {
		
	}

	public function disableScissor(): Void {
		
	}
	
	public function setVertexBuffer(vertexBuffer: VertexBuffer): Void {
		
	}
	
	public function setVertexBuffers(vertexBuffers: Array<kha.graphics4.VertexBuffer>): Void {
		
	}

	public function setIndexBuffer(indexBuffer: IndexBuffer): Void {
		
	}
	
	public function setTexture(unit: TextureUnit, texture: Image): Void {
		
	}
	
	public function setTextureDepth(unit: TextureUnit, texture: Image): Void {
		
	}

	public function setVideoTexture(unit: kha.graphics4.TextureUnit, texture: kha.Video): Void {

	}

	public function setImageTexture(unit: kha.graphics4.TextureUnit, texture: kha.Image): Void {

	}

	public function setTextureParameters(texunit: TextureUnit, uAddressing: TextureAddressing, vAddressing: TextureAddressing, minificationFilter: TextureFilter, magnificationFilter: TextureFilter, mipmapFilter: MipMapFilter): Void {
		
	}

	public function setTexture3DParameters(texunit: TextureUnit, uAddressing: TextureAddressing, vAddressing: TextureAddressing, wAddressing: TextureAddressing, minificationFilter: TextureFilter, magnificationFilter: TextureFilter, mipmapFilter: MipMapFilter): Void {
	
	}

	public function setCubeMap(stage: kha.graphics4.TextureUnit, cubeMap: kha.graphics4.CubeMap): Void {
		
	}
	
	public function setCubeMapDepth(stage: kha.graphics4.TextureUnit, cubeMap: kha.graphics4.CubeMap): Void {
		
	}
	
	public function renderTargetsInvertedY(): Bool {
		return false;
	}
	
	public function setPipeline(pipeline: PipelineState): Void {
		
	}
	
	public function setBool(location: ConstantLocation, value: Bool): Void {
		
	}

	public function setInt(location: ConstantLocation, value: Int): Void {
		
	}

	public function setFloat(location: ConstantLocation, value: Float): Void {
		
	}

	public function setFloat2(location: ConstantLocation, value1: Float, value2: Float): Void {
		
	}

	public function setFloat3(location: ConstantLocation, value1: Float, value2: Float, value3: Float): Void {
		
	}

	public function setFloat4(location: ConstantLocation, value1: Float, value2: Float, value3: Float, value4: Float): Void {
		
	}

	public function setFloats(location: ConstantLocation, floats: Vector<FastFloat>): Void {
		
	}

	public function setVector2(location: ConstantLocation, value: FastVector2): Void {
		
	}

	public function setVector3(location: ConstantLocation, value: FastVector3): Void {
		
	}

	public function setVector4(location: ConstantLocation, value: FastVector4): Void {
		
	}

	public function setMatrix(location: ConstantLocation, value: FastMatrix4): Void {
		
	}

	public function setMatrix3(location: ConstantLocation, value: FastMatrix3): Void {
		
	}
	
	public function drawIndexedVertices(start: Int = 0, count: Int = -1): Void {
		
	}
	
	public function instancedRenderingAvailable(): Bool {
		return true;
	}
	
	public function drawIndexedVerticesInstanced(instanceCount: Int, start: Int = 0, count: Int = -1): Void {
		
	}
}

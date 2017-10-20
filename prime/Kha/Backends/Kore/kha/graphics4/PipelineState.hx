package kha.graphics4;

import kha.graphics4.FragmentShader;
import kha.graphics4.VertexData;
import kha.graphics4.VertexElement;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexStructure;

@:headerCode('
#include <Kore/pch.h>
#include <Kore/Graphics4/Graphics.h>
')

@:headerClassCode("Kore::Graphics4::Program* program;")
@:keep
class PipelineState extends PipelineStateBase {
	public function new() {
		super();
		untyped __cpp__('program = new Kore::Graphics4::Program;');
	}
	
	public function delete(): Void {
		untyped __cpp__('delete program; program = nullptr;');
	}
	
	@:functionCode('
		program->setVertexShader(vertexShader->shader);
		program->setFragmentShader(fragmentShader->shader);
		if (geometryShader != null()) program->setGeometryShader(geometryShader->shader);
		if (tessellationControlShader != null()) program->setTessellationControlShader(tessellationControlShader->shader);
		if (tessellationEvaluationShader != null()) program->setTessellationEvaluationShader(tessellationEvaluationShader->shader);
		Kore::Graphics4::VertexStructure s0, s1, s2, s3;
		Kore::Graphics4::VertexStructure* structures2[4] = { &s0, &s1, &s2, &s3 };
		::kha::graphics4::VertexStructure* structures[4] = { &structure0, &structure1, &structure2, &structure3 };
		for (int i1 = 0; i1 < size; ++i1) {
			for (int i2 = 0; i2 < (*structures[i1])->size(); ++i2) {
				Kore::Graphics4::VertexData data;
			switch ((*structures[i1])->get(i2)->data->index) {
				case 0:
					data = Kore::Graphics4::Float1VertexData;
					break;
				case 1:
					data = Kore::Graphics4::Float2VertexData;
					break;
				case 2:
					data = Kore::Graphics4::Float3VertexData;
					break;
				case 3:
					data = Kore::Graphics4::Float4VertexData;
					break;
				case 4:
					data = Kore::Graphics4::Float4x4VertexData;
					break;
				}
				structures2[i1]->add((*structures[i1])->get(i2)->name, data);
			}
		}
		program->link(structures2, size);
	')
	private function linkWithStructures2(structure0: VertexStructure, structure1: VertexStructure, structure2: VertexStructure, structure3: VertexStructure, size: Int): Void {
		
	}
	
	public function compile(): Void {
		linkWithStructures2(
			inputLayout.length > 0 ? inputLayout[0] : null,
			inputLayout.length > 1 ? inputLayout[1] : null,
			inputLayout.length > 2 ? inputLayout[2] : null,
			inputLayout.length > 3 ? inputLayout[3] : null,
			inputLayout.length);
	}
	
	public function getConstantLocation(name: String): kha.graphics4.ConstantLocation {
		var location = new kha.kore.graphics4.ConstantLocation();
		initConstantLocation(location, name);
		return location;
	}
	
	@:functionCode('
		location->location = program->getConstantLocation(name.c_str());
	')
	private function initConstantLocation(location: kha.kore.graphics4.ConstantLocation, name: String): Void {
		
	}
		
	public function getTextureUnit(name: String): kha.graphics4.TextureUnit {
		var unit = new kha.kore.graphics4.TextureUnit();
		initTextureUnit(unit, name);
		return unit;
	}
	
	@:functionCode('
		unit->unit = program->getTextureUnit(name.c_str());
	')
	private function initTextureUnit(unit: kha.kore.graphics4.TextureUnit, name: String): Void {
		
	}
	
	@:functionCode('
		program->set();
	')
	public function set(): Void {
		
	}
	
	@:noCompletion
	public static function _unused1(): VertexElement {
		return null;
	}
	
	@:noCompletion
	public static function _unused2(): VertexData {
		return null;
	}
	
	@:noCompletion
	public static function _unused3(): VertexShader {
		return null;
	}
	
	@:noCompletion
	public static function _unused4(): FragmentShader {
		return null;
	}
	
	@:noCompletion
	public static function _unused5(): GeometryShader {
		return null;
	}
	
	@:noCompletion
	public static function _unused6(): TessellationControlShader {
		return null;
	}
	
	@:noCompletion
	public static function _unused7(): TessellationEvaluationShader {
		return null;
	}
}

#pragma once

#include "Texture.h"
#include "VertexStructure.h"
#include <Kore/Math/Matrix.h>
#include <Kore/ProgramImpl.h>
#include <Kore/ShaderImpl.h>

namespace Kore {
	namespace Graphics4 {
		enum ShaderType { FragmentShader, VertexShader, GeometryShader, TessellationControlShader, TessellationEvaluationShader };

		class Shader : public ShaderImpl {
		public:
			Shader(void* data, int length, ShaderType type);
			Shader(const char* source, ShaderType type); // Beware, this is not portable
		};

		class ConstantLocation : public ConstantLocationImpl {};

		class Program : public ProgramImpl {
		public:
			Program();
			void setVertexShader(Shader* shader);
			void setFragmentShader(Shader* shader);
			void setGeometryShader(Shader* shader);
			void setTessellationControlShader(Shader* shader);
			void setTessellationEvaluationShader(Shader* shader);
			void link(VertexStructure& structure) {
				VertexStructure* structures[1] = { &structure };
				link(structures, 1);
			}
			void link(VertexStructure** structures, int count);
			ConstantLocation getConstantLocation(const char* name);
			TextureUnit getTextureUnit(const char* name);
			void set();
		};
	}
}

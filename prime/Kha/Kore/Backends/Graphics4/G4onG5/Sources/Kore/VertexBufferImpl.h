#pragma once

#include <Kore/Graphics5/Graphics.h>

namespace Kore {
	namespace Graphics4 {
		class VertexStructure;
	}

	class VertexBufferImpl {
	protected:
		VertexBufferImpl(int count, const Graphics4::VertexStructure& structure, int instanceDataStepRate);

	public:
		Graphics5::VertexBuffer _buffer;
	};
}

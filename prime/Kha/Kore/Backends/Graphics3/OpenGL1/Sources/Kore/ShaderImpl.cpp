#include "pch.h"
#include <Kore/Graphics4/Shader.h>
#include <Kore/Math/Core.h>
#include <Kore/Graphics3/Graphics.h>
#include "ogl.h"

using namespace Kore;

ShaderImpl::ShaderImpl(void* source, int length) : length(length), id(0) {
	this->source = new char[length + 1];
	for (int i = 0; i < length; ++i) {
		this->source[i] = ((char*)source)[i];
	}
	this->source[length] = 0;
}

ShaderImpl::~ShaderImpl() {
	delete[] source;
	source = nullptr;
	if (id != 0) glDeleteShader(id);
}

Graphics4::Shader::Shader(void* source, int length, Graphics4::ShaderType type) : ShaderImpl(source, length) {
	
}

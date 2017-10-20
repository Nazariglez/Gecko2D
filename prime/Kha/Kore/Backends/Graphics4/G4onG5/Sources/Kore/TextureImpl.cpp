#include "pch.h"

#include <Kore/Graphics4/Graphics.h>

#include "TextureImpl.h"

using namespace Kore;

void Graphics4::Texture::init(const char* format, bool readable) {
	_texture->_init(format, readable);
}

Graphics4::Texture::Texture(int width, int height, Format format, bool readable) : Image(width, height, format, readable), TextureImpl(width, height, format, readable) {}

Graphics4::Texture::Texture(int width, int height, int depth, Image::Format format, bool readable) : Image(width, height, depth, format, readable), TextureImpl(width, height, depth, format, readable) {}

TextureImpl::TextureImpl() : _texture(nullptr) {
	// TODO
}

TextureImpl::TextureImpl(int width, int height, Kore::Image::Format format, bool readable) {
	_texture = new Graphics5::Texture(width, height, format, readable);
}

TextureImpl::TextureImpl(int width, int height, int depth, Image::Format format, bool readable) {
	_texture = new Graphics5::Texture(width, height, depth, format, readable);
}

TextureImpl::~TextureImpl() {
	unset();
}

void TextureImpl::unset() {
	// TODO
}

void TextureImpl::unmipmap() {
	// TODO
}

u8* Graphics4::Texture::lock() {
	return _texture->lock();
}

void Graphics4::Texture::unlock() {
	_texture->unlock();
}

void Graphics4::Texture::clear(int x, int y, int z, int width, int height, int depth, uint color) {
	_texture->clear(x, y, z, width, height, depth, color);
}

int Graphics4::Texture::stride() {
	return _texture->stride();
}

void Graphics4::Texture::generateMipmaps(int levels) {
	_texture->generateMipmaps(levels);
}

void Graphics4::Texture::setMipmap(Texture* mipmap, int level) {
	_texture->setMipmap(mipmap->_texture, level);
}

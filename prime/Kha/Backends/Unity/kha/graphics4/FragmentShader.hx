package kha.graphics4;

import kha.Blob;

class FragmentShader {
	public var name: String;
	
	public function new(source: Blob, file: String) {
		name = source.toString();
	}
}

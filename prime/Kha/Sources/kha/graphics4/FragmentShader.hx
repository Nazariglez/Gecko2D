package kha.graphics4;

import kha.Blob;

extern class FragmentShader {
	public function new(source: Blob, file: String);
	public function delete(): Void;

	/**
	Beware: This function is not portable.
	**/
	public static function fromSource(source: String): FragmentShader;
}

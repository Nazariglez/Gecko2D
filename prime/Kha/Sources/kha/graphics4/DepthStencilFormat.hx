package kha.graphics4;

// normal 'enum DepthStencilFormat' declaration can't be used as default parameter
@:enum abstract DepthStencilFormat(Int) {
	var NoDepthAndStencil = 0;
	var DepthOnly = 1;
	var DepthAutoStencilAuto = 2;

	// This is platform specific, use with care!
	var Depth24Stencil8 = 3;
	var Depth32Stencil8 = 4;
	var Depth16 = 5;

	//var StencilOnlyIndex1 = 5;
	//var StencilOnlyIndex4 = 6;
	//var StencilOnlyIndex8 = 7;
	//var StencilOnlyIndex16 = 8;
}

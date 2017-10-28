package k2d;

import haxe.CallStack;

class Error {
	public var message: String;
	public var stackTrace: Array<StackItem>;

	public function new(message: String) {
		this.message = message;
		this.stackTrace = CallStack.callStack();
	}

	public function toString() : String {
		return this.message + '\n' + CallStack.toString(this.stackTrace);
	}
}
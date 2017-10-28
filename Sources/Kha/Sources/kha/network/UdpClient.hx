package kha.network;

import haxe.io.Bytes;
#if sys_server
import js.node.Buffer;
import js.node.Dgram;
#end

class UdpClient implements Client {
	private var myId: Int;
	public var onReceive: Bytes->Void = null;
	#if sys_server
	private var socket: Dynamic;
	#end
	private var address: String;
	private var port: Int;

	#if sys_server
	public function new(id: Int, socket: Dynamic, address: String, port: Int) {
		myId = id;
		this.socket = socket;
		this.address = address;
		this.port = port;
	}
	#end

	public function send(bytes: Bytes, mandatory: Bool): Void {
		#if sys_server
		var buffer = new Buffer(bytes.length);
		for (i in 0...bytes.length) {
			buffer[i] = bytes.get(i);
		}
		socket.send(buffer, 0, bytes.length, port, address);
		#end
	}
	
	public function receive(receiver: Bytes->Void): Void {
		onReceive = receiver;
	}
	
	public function onClose(close: Void->Void): Void {
		
	}
	
	public var controllers(get, null): Array<Controller>;
	
	public function get_controllers(): Array<Controller> {
		return null;
	}
	
	public var id(get, null): Int;
	
	public function get_id(): Int {
		return myId;
	}
}

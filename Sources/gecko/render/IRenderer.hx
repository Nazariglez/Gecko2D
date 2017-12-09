package gecko.render;

interface IRenderer {
    public var g2:kha.graphics2.Graphics;
    public var g4:kha.graphics4.Graphics;
    public function begin(clear:Bool = true):Void;
    public function end():Void;
    public function reset():Void;
}
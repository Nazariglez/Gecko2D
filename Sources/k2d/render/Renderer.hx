package k2d.render;

class Renderer implements IRenderer {
    public var g2:kha.graphics2.Graphics;
    public var g4:kha.graphics4.Graphics;
    
    public function begin():Void {};
    public function end():Void {};
    public function reset():Void {};
}
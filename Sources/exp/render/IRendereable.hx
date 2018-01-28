package exp.render;

interface IRendereable {
    public var alpha:exp.Float32;
    public var color:exp.Color;
    public var blendMode:BlendMode;

    public function baseRender(r:Renderer) : Void;
    dynamic public function render(r:Renderer) : Void;
}
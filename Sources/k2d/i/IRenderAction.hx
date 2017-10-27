package k2d.i;

interface IRenderAction {
    public var name:string
    public var renderer:IRenderer;
    public var action:() -> Void
}
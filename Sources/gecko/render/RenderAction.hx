package gecko.render;

typedef RenderAction<T:IRenderer> = {
    public var id:String;
    public var renderer:IRenderer;
    public var action:T->Void;
}
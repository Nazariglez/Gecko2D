package gecko.render;

import kha.graphics4.BlendingOperation;
import kha.graphics4.BlendingFactor;


class BlendMode {
    static public var Normal:BlendMode = BlendMode.Create(BlendingFactor.SourceAlpha, BlendingFactor.InverseSourceAlpha);
    static public var Add:BlendMode = BlendMode.Create(BlendingFactor.SourceAlpha, BlendingFactor.DestinationAlpha);
    static public var Multiply:BlendMode = BlendMode.Create(BlendingFactor.DestinationColor, BlendingFactor.InverseSourceAlpha);
    static public var Screen:BlendMode = BlendMode.Create(BlendingFactor.BlendOne, BlendingFactor.InverseSourceColor);
    static public var Subtract:BlendMode = BlendMode.Create(BlendingFactor.BlendZero, BlendingFactor.InverseSourceColor);
    static public var Lighten:BlendMode = BlendMode.Create(BlendingFactor.BlendOne, BlendingFactor.BlendOne, BlendingOperation.Max);

    static public function Create(source:BlendingFactor, destination:BlendingFactor, ?operation:BlendingOperation) : BlendMode {
        return new BlendMode(source, destination, operation != null ? operation : BlendingOperation.Add);
    }

    public var source:BlendingFactor;
    public var destination:BlendingFactor;
    public var operation:BlendingOperation;

    private function new(source:BlendingFactor, destination:BlendingFactor, operation:BlendingOperation){
        this.source = source;
        this.destination = destination;
        this.operation = operation;
    };
}
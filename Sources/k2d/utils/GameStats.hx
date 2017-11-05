package k2d.utils;

class GameStats {
    public var renderer = new FPSCounter();
    public var update = new FPSCounter();
    public var system = new FPSCounter();

    public function new(){}
}
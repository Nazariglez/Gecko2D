package;

enum FlappyState {
    Idle;
    Playing;
    Falling;
    End;
}

class GameState {
    static public var State:FlappyState = FlappyState.Idle;
}
package gecko.math;

class Vector2i extends BaseObject {
    public var x: Int;
    public var y: Int;

    public function init(x: Int = 0, y: Int = 0): Void {
        this.x = x;
        this.y = y;
    }

    public inline function setFrom(v: Vector2i): Void {
        this.x = v.x;
        this.y = v.y;
    }

    public inline function add(vec: Vector2i): Vector2i {
        return Vector2i.create(x + vec.x, y + vec.y);
    }

    public inline function sub(vec: Vector2i): Vector2i {
        return Vector2i.create(x - vec.x, y - vec.y);
    }

    public inline function mult(value: Int): Vector2i {
        return Vector2i.create(x * value, y * value);
    }

    public inline function div(value: Int): Vector2i {
        return Vector2i.create(Std.int(x / value), Std.int(y / value));
    }

    public inline function dot(v: Vector2i): Float {
        return x * v.x + y * v.y;
    }
}
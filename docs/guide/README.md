# Base Object
This framework use object pooling to avoid garbage collector issues. Some objects, like scenes, entites, componentes, or systems (among other objects) inherit from `gecko.BaseObject`, which is a special object without functionality defined, but allow us to recycle our instances. 

Every object inherited from `gecko.BaseObject` must be instantiated via the static method `MyObject.create()`, this will check his pool to get and reuse an old instance, or if no one exists create it. When you're done with your object, just destroy it with the instance method `myObject.destroy()` and it will be returned to his pool.

To manage how your objects are created or destroyed you can use two instance methods, `init` and `beforeDestroy`.
- __init__: this method is executed always when you use `MyObject.create()`. You can add some parameters to it, and this params will be passed to the __create__ method.
- __beforeDestroy__: this method is executed before your object is destroyed, use it to clean it or do whatever you need before recycle it. This methods needs to be override because is inherited from __BaseObject__. 

For example: 
```haxe
class MyObject extends gecko.BaseObject {
    var name:String = "";

    public function init(name:String){
        this.name = name;
        trace(name);
    }

    override public function beforeDestroy() {
        trace("i will be destroyed!!!!");
    }
}
``` 

```haxe
var myObject = MyObject.create("Jonh Doe"); //print "Jonh Doe"

//do something with your object and when you're done just destroy it
myObject.destroy(); 
```

Keep in mind that is possible `beforeDestroy` may not be executed when you use `myObject.destroy()`. If the game loop o the rendering loop is running the destruction of your object will be delayed to the end of the frame. If you need to know the state of your object use `myObject.isAlreadyDestroyed` which is a boolean value. 

In some (unsual) cases maybe you want acces to your object's pool to check their length, clear, debug, or whatever, just use `MyObject.getPool()`.
---
title: TestTitle
---
# TestTitle
<iframe src="/builds/test/index.html" width="800" height="600" frameBorder="0" style="width:100%; max-height: 600px"></iframe>

```haxe
package;

import gecko.Scene;
import gecko.Gecko;

class Game {
    public function new(){
        trace("welcome!");
        var scene = Gecko.currentScene;
        scene.addSystem(gecko.systems.draw.DrawSystem.create());
        var e = scene.createEntity();
        e.addComponent(gecko.components.draw.CircleComponent.create(true, 60));

        e.transform.position.set(gecko.Screen.centerX, gecko.Screen.centerY);
    }
}
```

[Source Code](https://github.com/Nazariglez/Gecko2D/tree/master/examples/test)

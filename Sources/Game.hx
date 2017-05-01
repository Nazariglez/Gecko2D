package;

import prime.Game;
import prime.Actor;
import prime.Sprite;
import prime.Container;
import prime.Renderer;
import prime.Color;
import prime.Text;
import kha.math.FastMatrix3;
import kha.Assets;
import kha.input.Mouse;
import kha.Font;

class Game extends prime.Game {
  public function new() {
    super("Mi Juego", 1024, 768);
  }

  var rabbit:Sprite;
  override function onInit() : Void {
    super.onInit();
    Assets.loadEverything(function(){
      rabbit = new Sprite(Assets.images.rabbit);
      rabbit.position.set(
       1024*0.5, 768*0.5
      );
      //rabbit.flipY = true;
      rabbit.scale.set(5);
      rabbit.anchor.set(1,0);
      rabbit.pivot.set(0.5);
      stage.addChild(rabbit);
    });
  }

  override function render(r:Renderer) : Void {
    if(rabbit != null)rabbit.rotation += 1*Math.PI/180;
    super.render(r);
    r.color = Color.Red;
    r.drawCircle(1024*0.5, 768*0.5, 2);
  }
}
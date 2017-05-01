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
      rabbit.scale.set(5);
      //rabbit.skew.x = 1;
      //rabbit.anchor.set(0.5);
      //rabbit.pivot.set(0.5);
      stage.addChild(rabbit);

      var text = new Text("PrimeGame Engine", Assets.fonts.mainfont);
      text.tint = Color.Red;
      text.size = 50;
      text.anchor.set(0);
      //text.rotation = 90*Math.PI/180;
      text.flipX = true;
      text.position.set(
        1024*0.5, 768*0.5
      );
      stage.addChild(text);
    });
  }

  override function render(r:Renderer) : Void {
    //if(rabbit != null)rabbit.rotation += 1*Math.PI/180;
    super.render(r);
    r.color = Color.Red;
    r.drawCircle(1024*0.5, 768*0.5, 2);
  }
}
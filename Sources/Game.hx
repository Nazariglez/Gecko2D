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
  public function new(){
    super("Mi Juego", 1024, 768);
    //_loop.setFPS(30);
  }

  var bunny:Sprite;
  override function onInit() : Void {
    super.onInit();
    Assets.loadEverything(function(){
      stage.anchor.set(0);
      bunny = new Sprite(Assets.images.rabbit);
      bunny.position.set(1024*0.5, 768*0.5);
      bunny.scale.set(10, 10);
      bunny.addTo(stage);

      /*
      	height : 555, 
	width : 390, 
	y : -185, 
	x : -130*/

      var bunny2 = new Sprite(Assets.images.rabbit);
      bunny2.position.set(
        bunny.position.x+180, bunny.position.y+180
      );
      bunny2.scale.set(bunny.scale.x, bunny.scale.y);
      bunny2.tint = Color.Cyan;
      bunny2.matrix.local._22 = 20;
      bunny2.addTo(stage);

    });
  }

  override function render(r:Renderer) : Void {
    super.render(r);
    if(bunny != null){
      //bunny.rotation += 2*Math.PI/180;
    }
    r.color = Color.Red;
    r.drawCircle(1024*0.5, 768*0.5, 4);

    r.color = Color.Magenta;
    var b = stage.bounds;
    //r.drawRect(stage.position.x + b.x, stage.position.y + b.y, b.width, b.height, 4);
    r.drawCircle(b.x, b.y, 5);
  }
}
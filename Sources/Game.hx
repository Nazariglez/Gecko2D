package;

import prime.Game;
import prime.Actor;
import prime.Container;
import kha.graphics2.Graphics;
import kha.Color;

class Game extends prime.Game {
  public function new(){
    super("Mi Juego", 800, 600);
  }

  override function onInit() : Void {
    super.onInit();
    var actor = new Actor1();
    actor.scale.set(2.5);
    actor.position.set(
      _width*0.5, _height*0.5
    );
    actor.skew.set(0.1, 0.5);
    stage.addChild(actor);

    var container = new Container();
    container.rotation = Math.PI/180 * 25;
    stage.addChild(container);

    var actor2 = new Actor1();
    actor2.scale.set(0.8);
    actor2.alpha = 0.2;
    actor2.color = Color.Blue;
    container.addChild(actor2);

    var actor3 = new Actor1();
    actor3.scale.set(0.5);
    actor3.color = Color.Pink;
    actor3.position.set(_width*0.5, 0);
    actor3.rotation += Math.PI/180 * 45;
    container.addChild(actor3);
  }
}

class Actor1 extends Actor {
  public var color:Color = Color.Orange;

  override public function render(g:Graphics) : Void {
      super.render(g);
      g.color = color;
      g.fillRect(0,0, 100, 100);
  }

  override public function update(delta:Float) : Void {
    super.update(delta);
    position.x += 30*delta;
    position.y += 20*delta;
    //rotation += (Math.PI/180 * 45)*delta;
  }
}
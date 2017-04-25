package;

import prime.Game;
import prime.Actor;
import prime.Sprite;
import prime.Container;
import prime.Renderer;
import kha.graphics2.Graphics;
import kha.math.FastMatrix3;
import kha.Color;
import kha.Assets;
import kha.input.Mouse;
import kha.Font;

class Game extends prime.Game {
  var rabbits:Array<Rabbit> = [];
  var gravity:Float = 0.5;

  var count:Int = 0;

  var minX:Float = 0;
  var maxX:Float = 800;
  var minY:Float = 0;
  var maxY:Float = 600;

  var font:Font;

  var cleanMatrix:FastMatrix3 = FastMatrix3.identity();
  var counter:Counter = new Counter();
  var container:Container = new Container();

  var fps:Float = 0;
  var totalFrames:Float = 0;
  var elapsed:Float = 0;

  public function new(){
    super("Mi Juego", 800, 600);
  }

  override function onInit() : Void {
    super.onInit();
    Assets.loadEverything(function(){
      stage.addChild(container);

      counter.font = Assets.fonts.mainfont;
      counter.position.set(
        615, 5
      );
      stage.addChild(counter);
      font = Assets.fonts.mainfont;
      Mouse.get().notify(mouseDown, null, null, null);

      for(i in 0...2000){
        addRabbit();
      }
    });
  }

  function mouseDown(button:Int, x:Int, y:Int) : Void {
    for(i in 0...2000){
      addRabbit();
    }
  }

  public function addRabbit(){
    var rabbit = new Rabbit();
    rabbit.speed.x = Math.random() * 5;
    rabbit.speed.y = Math.random() * 5 - 2.5;
    container.addChild(rabbit);

    rabbits.push(rabbit);
    count++;
    counter.count = count;
  }

  override function update(delta:Float) : Void {
    super.update(delta);

    totalFrames++;
    elapsed += delta;
    if(totalFrames == 30){
      counter.fps = Math.round(1/(60*(elapsed/totalFrames))*60);
      totalFrames = 0;
      elapsed = 0;
    }

    if(rabbits.length > 0){
      for(i in 0...rabbits.length){
        var bunny = rabbits[i];
        bunny.position.x += bunny.speed.x;
        bunny.position.y += bunny.speed.y;
        bunny.speed.y += gravity;

        if (bunny.position.x > maxX) {
          bunny.speed.x *= -1;
          bunny.position.x = maxX;
        } else if (bunny.position.x < minX) {
          bunny.speed.x *= -1;
          bunny.position.x = minX;
        } if (bunny.position.y > maxY) {
          bunny.speed.y *= -0.8;
          bunny.position.y = maxY;
          if (Math.random() > 0.5) bunny.speed.y -= 3 + Math.random() * 4;
        }  else if (bunny.position.y < minY) {
          bunny.speed.y = 0;
          bunny.position.y = minY;
        }	

      }
    }
  }
}

class Rabbit extends Sprite {
  public var speed:prime.Point = new prime.Point();

  public function new(){
    super(Assets.images.rabbit);
  }
}

class Counter extends Actor {
  public var font:Font;
  public var count:Int = 0;
  public var fps:Float = 0;

  override function render(r:Renderer) : Void {
    super.render(r);
    r.color = 0xffff00;
    r.fillRect(0, 0, 180, 20);

    /*if(font != null){
      g.color = Color.White;
      g.font = font;
      g.fontSize = 16;
      g.drawString("Actors: " + count + " - FPS: " + fps, 5, 0);
    }*/
  }
}
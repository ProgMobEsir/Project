
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/GameEngine/shapes/ImageRenderer.dart';
import 'package:wifi_direct_json/Games/FruitSlasher/Particle.dart';
import '../../GameEngine/GameObject.dart';
import '../../GameEngine/Vector2D.dart';
import '../../GameEngine/colliders/RectCollider.dart';

import 'Blade.dart';

class Fruit extends GameObject {
  static List<Fruit> list = [];
  String name = "";
  String type = "";
  int life = 0;
  int maxLife = 1000;
  var velocity = Vector2D.up();
  var gravity = 0.1;

  Fruit.fromData(x,y,dx,dy,type){
    velocity+=Vector2D(dx,dy);

    list.add(this);

    if( type == "bomb"){
      renderer = new ImageRenderer(this, "bomb");
      renderer.color = Color.fromARGB(255, 0, 0, 0);
      gravity = 0.07;
    }

    else if( type == "banana"){

      renderer = new ImageRenderer(this, "banane");
      renderer.color = Color.fromARGB(255, 238, 202, 36);
    }

    transform.position = Vector2D(x, y);
    transform.scale = Vector2D(50, 50);

  }


  Fruit(x, y,this.type){
    if (x == 0){
      velocity+=Vector2D.right()*(1+Random().nextDouble()*4);
    }else{
      velocity+=Vector2D.left()*(1+Random().nextDouble()*4);
    }
    list.add(this);

    if( type == "bomb"){
      renderer = new ImageRenderer(this, "bomb");
      renderer.color = Color.fromARGB(255, 0, 0, 0);
      gravity = 0.07;
    }

    else if( type == "banana"){

      renderer = new ImageRenderer(this, "banane");
      renderer.color = Color.fromARGB(255, 238, 202, 36);
    }

    transform.position = Vector2D(x, y);
    transform.scale = Vector2D(50, 50);

  }

  void particles() {
    double centerx = transform.position.x + transform.scale.x / 2;
    double centery = transform.position.y + transform.scale.y / 2;
    Particle particle = new Particle(
        centerx,
        centery,
        this.name);
    particle.renderer.color = this.renderer.color;

    engine!.addGameObject(particle);
  }

  bool isCollidingBlade(Blade b){
    return (b.collider.isCollidingRectCollider(this.collider as RectCollider) && !this.destroy_);
  }

  @override
  void update() {
    life++;
    if (life > maxLife) {
      list.remove(this);
      destroy();
    }
    particles();
    velocity += Vector2D.down() *gravity;
    transform.position += velocity;
  }


}

import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/Vector2D.dart';

import '../../GameEngine/shapes/Circle.dart';

class Particle extends GameObject {
  static var list = [];
  var speed = 5;
  var life = 0;
  var maxLife = 20;
  String owner = "";

  Particle(x, y, this.owner) {
    list.add(this);
    renderer = new Circle(this, 1);
    transform.position.x = x;
    transform.position.y = y;
    transform.scale.x = 10;
    transform.scale.y = 10;

  }
  @override
  void update() {
    transform.position += Vector2D.random() * speed.toDouble();
    life++;
    if (life > maxLife) {
      list.remove(this);
      destroy();
    }
  }

}
import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

class Player extends GameObject {
  var speed = 5;
  var foodEaten = 0;
  Player(x, y) {
    transform.position.x = x;
    transform.position.y = y;
    transform.scale.x = 50;
    transform.scale.y = 50;
  }
  // ...
  void update() {
    // ...
  }
}

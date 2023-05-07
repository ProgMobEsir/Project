import 'package:wifi_direct_json/GameEngine/GameObject.dart';

import '../../GameEngine/Camera.dart';

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
    Camera.dx = transform.position.x - 200;
    Camera.dy = transform.position.y - 200;
    // ...
  }
}

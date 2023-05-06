import 'dart:ui';

import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/ImageRenderer.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

class Food extends GameObject {
  Food(x, y) {
    transform.position.x = x;
    transform.position.y = y;
    transform.scale.x = 50;
    transform.scale.y = 50;

    renderer = new ImageRenderer(this,"food");
    renderer.color = Color.fromARGB(255, 145, 28, 20);
  }
  // ...
  void update() {
    // ...
  }
}
 
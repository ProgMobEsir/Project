import 'package:flutter/material.dart';
import 'package:wifi_direct_json/GameEngine/shapes/LineRenderer.dart';

import '../../GameEngine/Camera.dart';
import '../../GameEngine/GameObject.dart';
import '../../GameEngine/Vector2D.dart';
import '../../Utils/GameManager.dart';
import 'Blade.dart';

class GuestBlade extends Blade {
  GuestBlade(x, y, name) : super(x, y, name) {
    renderer.color = Color.fromARGB(100,255,0,0);

  }

  void move(Vector2D pos) {
    transform.position = pos;
    particles();
  }
}

import 'package:flutter/material.dart';
import '../../GameEngine/Vector2D.dart';
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

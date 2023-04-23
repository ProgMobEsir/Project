import 'dart:ui';

import '../GameObject.dart';
import 'Rectangle.dart';

import 'Circle.dart';

class Renderer {

  GameObject? parent;
  Color color;

  Renderer(this.parent, this.color);
  bool intersects(Renderer r) {
    return false;
  }

  bool intersectsCircle(Circle o) {
    return false;
  }

  bool intersectsRectangle(Rectangle rect) {
    return false;
  }

  draw(Canvas canvas, Paint paint) {}
}

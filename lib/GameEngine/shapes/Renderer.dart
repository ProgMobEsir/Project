import 'dart:ui';

import '../GameObject.dart';
import 'ImageRenderer.dart';
import 'Rectangle.dart';

import 'Circle.dart';

class Renderer {
  GameObject? parent;
  Color color;

  Renderer(this.parent, this.color);

  draw(Canvas canvas, Paint paint) {}
}

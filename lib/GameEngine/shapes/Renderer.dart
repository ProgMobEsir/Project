import 'dart:ui';
import '../GameObject.dart';

class Renderer {
  GameObject? parent;
  Color color;

  Renderer(this.parent, this.color);

  draw(Canvas canvas, Paint paint) {}
}

import 'dart:ui';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

import '../Camera.dart';
import 'Renderer.dart';

class Circle extends Renderer {
  double radius;

  Circle(parent, this.radius) : super(parent, new Color(0xFF0000FF)) {}

  Circle.withColor(parent, this.radius, Color color) : super(parent, color) {}


  bool draw(Canvas canvas, Paint paint) {
    paint.color = this.color;
    canvas.drawCircle(
        Offset(parent!.transform.position.x.toDouble() - Camera.dx,
            parent!.transform.position.y.toDouble() - Camera.dx) ,
        radius,
        paint);
    return true;
  }
}

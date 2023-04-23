import 'dart:ui';
import 'package:wifi_direct_json/GameEngine/shapes/Rectangle.dart';

import 'Renderer.dart';

class Circle extends Renderer {
  double radius;

  Circle(parent, this.radius) : super(parent, new Color(0xFF0000FF)) {}

  Circle.withColor(parent, this.radius, Color color) : super(parent, color) {}

  bool contains(int x, int y) {
    return (x - this.parent!.transform.position.x) *
                (x - this.parent!.transform.position.x) +
            (y - this.parent!.transform.position.y) *
                (y - this.parent!.transform.position.y) <
        radius;
  }

  @override
  bool intersectsCircle(Circle other) {
    return (parent!.transform.position.x - other.parent!.transform.position.x) *
                (parent!.transform.position.x -
                    other.parent!.transform.position.x) +
            (parent!.transform.position.y -
                    other.parent!.transform.position.y) *
                (parent!.transform.position.y -
                    other.parent!.transform.position.y) <
        (radius + other.radius) * (radius + other.radius);
  }

  bool draw(Canvas canvas, Paint paint) {
    paint.color = this.color;
    canvas.drawCircle(
        Offset(parent!.transform.position.x.toDouble(),
            parent!.transform.position.y.toDouble()),
        radius,
        paint);
    return true;
  }
}

import 'dart:ui';
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
            parent!.transform.position.y.toDouble() - Camera.dy) ,
        radius,
        paint);
    return true;
  }
}

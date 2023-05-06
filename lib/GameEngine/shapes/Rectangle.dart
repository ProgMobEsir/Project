import 'dart:ui';
import 'Renderer.dart';

class Rectangle extends Renderer {

  Rectangle(parent) : super(parent, new Color(0xFF0000FF)) {}

  Rectangle.withColor(parent, Color color)
      : super(parent, color) {}

  bool draw(Canvas canvas, Paint paint) {
    paint.color = this.color;

    canvas.drawRect(
        Rect.fromLTWH(parent!.transform.position.x.toDouble(),
            parent!.transform.position.y.toDouble(), parent!.transform.scale.x, parent!.transform.scale.y),
        paint);
    return true;
  }
}

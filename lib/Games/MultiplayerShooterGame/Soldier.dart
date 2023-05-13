import 'package:flutter/material.dart';
import 'package:wifi_direct_json/GameEngine/shapes/LineRenderer.dart';

import '../../GameEngine/Camera.dart';
import '../../GameEngine/Vector2D.dart';
import 'ISoldier.dart';

class Soldier extends ISoldier {
  LineRenderer? lr;
  double radius = 50;
  Soldier(x, y, name) : super(x, y, name) {
    lr = new LineRenderer(this, new Vector2D(0, 0), new Vector2D(50, 50));
  }

  @override
  void update() {
    Camera.dx = transform.position.x - 350;
    Camera.dy = transform.position.y - 100;
    double centerx = transform.position.x + transform.scale.x / 2;
    double centery = transform.position.y + transform.scale.y / 2;
    Vector2D aim = new Vector2D(aimx, aimy);
    aim = aim.normalized;
    lr!.p1 = new Vector2D(centerx, centery);
    lr!.p2 = new Vector2D(centerx + aim.x * radius, centery + aim.y * radius);
    Paint paint = new Paint();
    paint.color = new Color(0xFF0000FF);
    paint.strokeWidth = 5;
    lr!.draw(engine!.canva, paint);
  }
}

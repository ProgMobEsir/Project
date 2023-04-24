import 'package:flutter/material.dart';
import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import '/GameEngine/shapes/Circle.dart';
import 'shapes/Renderer.dart';

class GameEngine {
  List<GameObject> list = [];

  void addGameObject(GameObject s) {
    list.add(s);
  }

  Widget getWidget() {
    return CustomPaint(
      painter: MyPainter(0, 0, this),
    );
  }
}

class MyPainter extends CustomPainter {
  int x, y;
  GameEngine gameEngine;

  MyPainter(this.x, this.y, this.gameEngine);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    List<GameObject> tmp = [];
    gameEngine.list.forEach((element) {
      if (element.destroy_) {
        tmp.add(element);
      }
      element.getRenderer().draw(canvas, paint);
    });
    
    tmp.forEach((element) {
      gameEngine.list.remove(element);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

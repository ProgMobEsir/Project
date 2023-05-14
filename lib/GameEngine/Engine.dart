import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/Games/GameState.dart';

class GameEngine {
  bool run = true;
  List<GameObject> list = [];
  GameState? game;
  static GameEngine instance = GameEngine(null);
  Canvas canva = new Canvas(PictureRecorder());
  List<GameObject> toBeAdded = [];
  GameEngine(this.game) {
    instance = this;
  }

  void addGameObject(GameObject s) {
    s.setEngine(this);
    toBeAdded.add(s);
  }

  void stop() {
    run = false;
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
    gameEngine.canva = canvas;
    if (!gameEngine.run) return;
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;
    List<GameObject> tmp = [];
    gameEngine.list.addAll(gameEngine.toBeAdded);
    gameEngine.toBeAdded.clear();
    gameEngine.list.forEach((element) {
      if (element.destroy_) {
        tmp.add(element);
      }
      element.update();
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

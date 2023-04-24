import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Games/DragGame/Player.dart';
import 'package:wifi_direct_json/Games/DragGame/food.dart';
import 'package:wifi_direct_json/Menus/ConnPage.dart';
import '../../GameEngine/shapes/Rectangle.dart';
import '../GameState.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class DragGame extends StatefulWidget {
  const DragGame({super.key});

  @override
  State<DragGame> createState() => DragGameState();
}

class DragGameState extends GameState<DragGame> {
  var sequence = [];
  String data = "";
  var guestPos = [0, 0];

  var joyX = 0.0;
  var joyY = 0.0;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  void onRecieve(req) {
    super.onRecieve(req);
    data = req;

    if (req.toString().startsWith("POS")) {
      var tmp = req
          .toString()
          .replaceAll("POS[", "")
          .replaceAll("]", "")
          .replaceAll(",", "")
          .split(" ")
          .cast();
      guestPos[0] = int.parse(tmp[0]);
      guestPos[1] = int.parse(tmp[1]);

      guest.transform.position.x = guestPos[0].toDouble();
      guest.transform.position.y = guestPos[1].toDouble();
      print(guestPos);
    }
    update();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        var x = details.globalPosition.dx.toInt();
        var y = details.globalPosition.dy.toInt();
        sendPosition(x, y);
        setState(() {});
        update();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            //add a button to the home page :
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConnPage(),
                    ),
                  );
                },
              ),
            ],
            title: const Text('Drag Game'),
          ),
          body: Stack(
            children: [
              engine.getWidget(),
              Align(
                alignment: const Alignment(0, 0.8),
                child: Joystick(
                  mode: JoystickMode.all,
                  listener: (details) {
                    setState(() {
                      joyX = details.x;
                      joyY = details.y;
                    });
                  },
                ),
              ),
              Text("Food Eaten " + player.foodEaten.toString()),
            ],
          )),
    );
  }

  sendPosition(int dx, int dy) {
    send("POS" + "[" + dx.toString() + ", " + dy.toString() + "]");
  }

  Player player = new Player(0.0, 0.0);

  Player guest = new Player(100.0, 100.0);

  //list of food
  List<Food> foods = [];

  initGame() {
    engine.addGameObject(player);
    engine.addGameObject(guest);

    //spawn food randomly on the screen every 5 seconds
    new Timer.periodic(new Duration(seconds: 5), (timer) {
      var x = Random().nextInt(200);
      var y = Random().nextInt(500);
      var food = new Food(x.toDouble(), y.toDouble());
      foods.add(food);
      engine.addGameObject(food);
    });
  }

  @override
  update() {
    super.update();
    player.transform.position.x += joyX * player.speed;
    player.transform.position.y += joyY * player.speed;
    List<Food> toRemove = [];
    for (var food in foods) {
      if (player.renderer.intersectsRectangle(food.renderer as Rectangle)) {
        print("food eaten");
        player.foodEaten += 1;
        food.destroy();
        toRemove.add(food);
      }
    }

    foods.removeWhere((element) => toRemove.contains(element));

    if (guest.renderer.intersectsRectangle(player.renderer as Rectangle)) {
      player.renderer.color = new Color(0xFF00FF00);
      guest.renderer.color = new Color(0xFF00FF00);
    } else {
      player.renderer.color = new Color(0xFF0000FF);
      guest.renderer.color = new Color(0xFF0000FF);
    }
  }
}

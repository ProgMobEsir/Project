import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/GameEngine/colliders/RectCollider.dart';
import 'package:wifi_direct_json/Games/DragGame/Player.dart';
import 'package:wifi_direct_json/Games/DragGame/food.dart';
import 'package:wifi_direct_json/Games/DragGame/guest.dart';
import 'package:wifi_direct_json/Menus/ConnPage.dart';
import 'package:wifi_direct_json/Menus/GameMenu.dart';
import 'package:wifi_direct_json/Utils/Requests/PositionRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/WinRequest.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../../Utils/AudioManager.dart';
import '../../Utils/GameManager.dart';
import '../../Utils/Requests/InstanciationRequest.dart';
import '../../Utils/Requests/JsonRequest.dart';
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

  var spawnRate = 100;

  var mapSize = [1000,1000];

  var joyX = 0.0;
  var joyY = 0.0;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  @override
  void onRecieve(JsonRequest request) {
    super.onRecieve(request);
    data = request.body;

    if (request.type == "position") {
      PositionRequest posReq = request.getPositionRequest();
      guest.transform.position.x = posReq.x.toDouble();
      guest.transform.position.y = posReq.y.toDouble();
    }
    if (request.type == "instanciation") {
      InstanciationRequest posReq = request.getInstanciationRequest();
      if (posReq.type == "food") {
        Food f = new Food(posReq.x, posReq.y);
        foods.add(f);
        engine.addGameObject(f);
      }
    }
    if (request.type == "win") {
      AudioManager.getInstance().playEffect("loose.mp3");
      
      onWin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        var x = details.globalPosition.dx.toInt();
        var y = details.globalPosition.dy.toInt();
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
                  NavigationService.instance.navigateTo("GAMES");
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
              Align(
                alignment: AlignmentDirectional.topCenter,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Your Food :  " + player.foodEaten.toString(),
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        backgroundColor: Colors.amber),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  sendPosition(int dx, int dy) {
    send(new PositionRequest(dx.toDouble(), dy.toDouble(), "0"));
  }

  Player player = new Player(100.0, 100.0);
  Guest guest = new Guest(100.0, 250.0);

  //list of food
  List<Food> foods = [];

  initGame() {
    engine.addGameObject(player);
    engine.addGameObject(guest);
  }

  void boundPlayer(){
    if (player.transform.position.x > mapSize[0]/2) {
      player.transform.position.x = mapSize[0]/2;
    }
    if (player.transform.position.x < -mapSize[0]/2) {
      player.transform.position.x = -mapSize[0]/2;
    }
    if (player.transform.position.y > mapSize[1]/2) {
      player.transform.position.y = mapSize[1]/2;
    }
    if (player.transform.position.y < -mapSize[1]/2) {
      player.transform.position.y = -mapSize[1]/2;
    }

  }

  @override
  update() {
    super.update();

    if (GameManager.instance!.wifiP2PInfo?.isGroupOwner == true &&
      this.frames % spawnRate == 0) {
      //get the size of the screen in pixel
      var x = Random().nextInt(mapSize[0]) - mapSize[0]/2;
      var y = Random().nextInt(mapSize[1]) - mapSize[1]/2;
      var food = new Food(x.toDouble(), y.toDouble());
      foods.add(food);
      engine.addGameObject(food);
      send(new InstanciationRequest(x.toDouble(), y.toDouble(), "food", "0"));
    }

    player.transform.position.x += joyX * player.speed;
    player.transform.position.y += joyY * player.speed;

    List<Food> toRemove = [];
    for (var food in foods) {
      if (player.collider.isCollidingRectCollider(food.collider as RectCollider)) {
        print("food eaten");
        player.foodEaten += 1;
        food.destroy();
        toRemove.add(food);
        AudioManager.getInstance().playEffect("powerup.mp3");

      }

      if (guest.collider.isCollidingRectCollider(food.collider as RectCollider)) {
        print("food eaten");
        guest.foodEaten += 1;
        food.destroy();
        toRemove.add(food);
      }
    }

    foods.removeWhere((element) => toRemove.contains(element));

    if (guest.collider.isCollidingRectCollider(player.collider as RectCollider)) {
      player.renderer.color = Color.fromARGB(255, 216, 73, 255);
      guest.renderer.color = new Color(0xFF00FF00);
    } else {
      player.renderer.color = Color.fromARGB(255, 31, 155, 53);
      guest.renderer.color = new Color(0xFF0000FF);
    }

    sendPosition(player.transform.position.x.toInt(),
        player.transform.position.y.toInt());

    //si le score est de 10, on arrete le jeu
    if (player.foodEaten == 10) {
      AudioManager.getInstance().playEffect("win.mp3");
      onWin();
    }
  }

  onWin() {
    dispatchOnWin();
    this.stop();
    send(new WinRequest(true, "0"));
  }

  dispatchOnWin() {
    if (GameManager.instance!.wifiP2PInfo?.isGroupOwner == true) { 
      NavigationService.instance.navigateTo("GAMES");
    } else {
      NavigationService.instance.navigateTo("WAIT");
    }
  }
}

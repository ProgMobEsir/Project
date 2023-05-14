import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_direct_json/GameEngine/Vector2D.dart';
import 'package:wifi_direct_json/Games/MultiplayerShooterGame/playerTag.dart';
import 'package:wifi_direct_json/Utils/Requests/PositionRequest.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../../Utils/AudioManager.dart';
import '../../Utils/GameManager.dart';
import '../../Utils/Requests/DeafRequest.dart';
import '../../Utils/Requests/JsonRequest.dart';
import '../../Utils/Requests/LifeRequest.dart';
import '../../Utils/Requests/ShootRequest.dart';
import '../DragGame/mapBorder.dart';
import '../GameState.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'Soldier.dart';
import 'SoldierGuest.dart';
import 'bullet.dart';

class ShooterGame extends StatefulWidget {
  const ShooterGame({super.key});

  @override
  State<ShooterGame> createState() => ShooterGameState();
}

class ShooterGameState extends GameState<ShooterGame> {
  var mapSize = [1000, 1000];

  var aimx = 0.0;
  var aimy = 0.0;
  var velx = 0.0;
  var vely = 0.0;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.initState();
    initGame();
    AudioManager.getInstance().playMusic("intro.mp3");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void onRecieve(JsonRequest request) {
    super.onRecieve(request);

    if (request.type == "position") {
      PositionRequest posReq = request.getPositionRequest();
      guests.forEach((guest) {
        if (guest.name == request.peer) {
          guest.transform.position.x = posReq.x.toDouble();
          guest.transform.position.y = posReq.y.toDouble();
        }
      });
    } else if (request.type == "shoot") {
      ShootRequest shootReq = request.getShootRequest();
      guests.forEach((guest) {
        if (guest.name == request.peer) {
          guest.aimx = shootReq.aimx;
          guest.aimy = shootReq.aimy;
          guest.shoot();
        }
      });
    } else if (request.type == "life") {
      LifeRequest lifeReq = request.getLifeRequest();
      print("life" + lifeReq.life.toString());
      guests.forEach((guest) {
        if (guest.name == request.peer) {
          guest.life = lifeReq.life;
        }
      });
    } else if (request.type == "deaf") {
      SoldierGuest? g;
      print("deaf");

      guests.forEach((guest) {
        if (guest.name == request.peer) {
          g = guest;
        }
      });

      if (g != null) {
        guests.remove(g);
      }
      if (guests.isEmpty) {
        onWin();
      }
    } else if (request.type == "win") {
      wined = true;
      winner = request.getWinRequest().peer;
      AudioManager.getInstance().stop();
      onLoose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        engine!.getWidget(),
        Align(
          alignment: const Alignment(-0.9, -0.9),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              this.stop();
              NavigationService.instance.navigateToReplacement("GAMES");
            },
          ),
        ),
        Align(
          alignment: const Alignment(-0.9, 0.1),
          child: Joystick(
            mode: JoystickMode.all,
            listener: (details) {
              velx = details.x;
              vely = details.y;
            },
          ),
        ),
        Align(
          alignment: const Alignment(0.9, 0.1),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              shoot();
            },
            child: Joystick(
              onStickDragEnd: () {
                shoot();
              },
              mode: JoystickMode.all,
              listener: (details) {
                player.aimx = aimx;
                player.aimy = aimy;
                aimx = details.x;
                aimy = details.y;
              },
            ),
          ),
        ),
      ],
    ));
  }

  sendPosition(int dx, int dy) {
    send(new PositionRequest(dx.toDouble(), dy.toDouble()));
  }

  Soldier player = new Soldier(100.0, 100.0, GameManager.instance!.getMyID());

  List<SoldierGuest> guests = [];
  List<PlayerTag> tags = [];

  shoot() {
    player.shoot();
    send(ShootRequest(player.aimx, player.aimy));
  }

  initGame() {
    MapBorder bordern = new MapBorder(
        -mapSize[0] / 2.0, -mapSize[1] / 2.0, mapSize[0].toDouble(), 10.0);
    MapBorder borderw = new MapBorder(
        -mapSize[0] / 2.0, -mapSize[1] / 2.0, 10.0, mapSize[1].toDouble());
    MapBorder borders = new MapBorder(
        mapSize[0] / 2.0, mapSize[1] / 2.0, -mapSize[0].toDouble(), 10.0);
    MapBorder borderse = new MapBorder(
        mapSize[0] / 2.0, mapSize[1] / 2.0, 10.0, -mapSize[1].toDouble());

    engine!.addGameObject(bordern);
    engine!.addGameObject(borderw);
    engine!.addGameObject(borders);
    engine!.addGameObject(borderse);
    GameManager.instance!.players.forEach((element) {
      if (element != GameManager.instance!.getMyID()) {
        var g = new SoldierGuest(100.0, 250.0, element);
        var ptag = new PlayerTag(g);
        guests.add(g);
        tags.add(ptag);
        engine!.addGameObject(g);
        engine!.addGameObject(ptag);
      }
    });
    PlayerTag playerTag = new PlayerTag(player);
    tags.add(playerTag);
    engine!.addGameObject(player);
    engine!.addGameObject(playerTag);
  }

  void boundPlayer() {
    if (player.transform.position.x > mapSize[0] / 2) {
      player.transform.position.x = mapSize[0] / 2;
    }
    if (player.transform.position.x < -mapSize[0] / 2) {
      player.transform.position.x = -mapSize[0] / 2;
    }
    if (player.transform.position.y > mapSize[1] / 2) {
      player.transform.position.y = mapSize[1] / 2;
    }
    if (player.transform.position.y < -mapSize[1] / 2) {
      player.transform.position.y = -mapSize[1] / 2;
    }
  }

  @override
  update() {
    super.update();

    boundPlayer();
    player.transform.position.x += (velx * player.speed).toInt();
    player.transform.position.y += (vely * player.speed).toInt();

    sendPosition(player.transform.position.x.toInt(),
        player.transform.position.y.toInt());

    Bullet.list.forEach((bullet) {
      if (bullet.isCollidingPlayer(player)) {
        bullet.destroy();
        player.life -= 1;
        send(new LifeRequest(player.life));
        if (player.life <= 0) {
          player.life = 10;
          send(new DeafRequest());
          onLoose();
        }
      }
    });
    Bullet.list.forEach((bullet) {
      guests.forEach((guest) {
        if (bullet.isCollidingPlayer(guest)) {
          bullet.destroy();
        }
      });
    });
  }

  onLoose() {
    this.stop();
    goToWaitMenu(false, "you loosed");
  }

  onWin() {
    this.stop();
    goToWaitMenu(true, "you won the battle ! ");
  }
}

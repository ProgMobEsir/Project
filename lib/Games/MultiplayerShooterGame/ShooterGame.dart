import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_direct_json/Games/MultiplayerShooterGame/LifeBar.dart';
import 'package:wifi_direct_json/Games/MultiplayerShooterGame/playerTag.dart';
import 'package:wifi_direct_json/Utils/GameMods.dart';
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
              AudioManager.getInstance().stop();
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

  Soldier player = new Soldier(0.0, 0.0, GameManager.instance!.getMyID());

  List<SoldierGuest> guests = [];
  List<PlayerTag> tags = [];
  List<LifeBar> lbars = [];
  shoot() {
    AudioManager.getInstance().playEffect("throw.wav");
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
    if (GameManager.instance!.gameMode == GameMode.Multi) {
      var i = 0;
      GameManager.instance!.players.forEach((element) {
        if (element != GameManager.instance!.getMyID()) {
          var g = new SoldierGuest(100 + i * 100.0, 100 + i * 100.0, element);
          var ptag = new PlayerTag(g);
          var lbar = new LifeBar(g);
          guests.add(g);
          tags.add(ptag);
          lbars.add(lbar);
          engine!.addGameObject(g);
          engine!.addGameObject(ptag);
          engine!.addGameObject(lbar);
        }
        i++;
      });
    } else {
      int nbIA = 3;

      for (var i = 0; i < nbIA; i++) {
        var g = new SoldierGuest(100 + i*100.0, 100+i*100.0, "AI" + i.toString());
        var ptag = new PlayerTag(g);
        var lbar = new LifeBar(g);
        guests.add(g);
        tags.add(ptag);
        engine!.addGameObject(g);
        engine!.addGameObject(ptag);
        engine!.addGameObject(lbar);
      }
    }
    PlayerTag playerTag = new PlayerTag(player);
    var lbar = new LifeBar(player);
    tags.add(playerTag);
    lbars.add(lbar);
    engine!.addGameObject(player);
    engine!.addGameObject(playerTag);
    engine!.addGameObject(lbar);
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

    if (GameManager.instance!.gameMode == GameMode.Solo) {
      Bullet.list.forEach((bullet) {
        if (bullet.isCollidingPlayer(player)) {
          bullet.destroy();
          player.life -= 1;

          if (player.life <= 0) {
            player.life = 10;
            onLoose();
          }
        }
      });

      Bullet.list.forEach((bullet) {
        SoldierGuest? g;
        guests.forEach((guest) {
          if (bullet.isCollidingPlayer(guest)) {
            bullet.destroy();
            guest.life -= 1;
            if (guest.life <= 0) {
              g = guest;
            }
          }
        });
        if (g!=null) guests.remove(g);

      });
      if (guests.length == 0) {
        onWin();
      }

    }else{
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
  }

  onLoose() {
    var msg = "";
    if (GameManager.instance!.gameMode == GameMode.Solo){
      winner = "ia";
      msg = "you loosed, battle is over for you\n" + "winner is " + winner ;
    }
    else{
      winner = "friends";
      msg =" wait until the end of the battle ! ";
    }
    this.stop();
    AudioManager.getInstance().playMusic("loose.mp3");
    goToWaitMenu(false, msg);
  }

  onWin() {
    winner = GameManager.instance!.getMyID();
    this.stop();
    AudioManager.getInstance().playMusic("win.mp3");
    goToWaitMenu(true, "you won the battle ! ");
  }

}

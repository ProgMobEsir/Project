import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_direct_json/GameEngine/Camera.dart';

import 'package:wifi_direct_json/Games/FruitSlasher/BladeLife.dart';
import 'package:wifi_direct_json/Games/FruitSlasher/BladeTag.dart';
import 'package:wifi_direct_json/Games/FruitSlasher/GuestBlade.dart';

import 'package:wifi_direct_json/Utils/GameMods.dart';
import 'package:wifi_direct_json/Utils/Requests/InstanciationRequest.dart';
import 'package:wifi_direct_json/Utils/Requests/PositionRequest.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../../Utils/AudioManager.dart';
import '../../Utils/GameManager.dart';
import '../../Utils/Requests/DeafRequest.dart';
import '../../Utils/Requests/JsonRequest.dart';
import '../../Utils/Requests/LifeRequest.dart';

import '../GameState.dart';

import 'Fruit.dart';
import 'PlayerBlade.dart';

class FruitSlasherGame extends StatefulWidget {
  const FruitSlasherGame({super.key});

  @override
  State<FruitSlasherGame> createState() => FruitSlasherGameState();
}

class FruitSlasherGameState extends GameState<FruitSlasherGame> {

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
    } else if (request.type == "instanciation") {
      AudioManager.getInstance().playEffect("throw.wav");
      InstanciationRequest instReq = request.getInstanciationRequest();
      engine!.addGameObject(new Fruit.fromData(instReq.x, instReq.y,instReq.dx, instReq.dy, instReq.type));
    }
    else if (request.type == "life") {
      LifeRequest lifeReq = request.getLifeRequest();
      print("life" + lifeReq.life.toString());
      guests.forEach((guest) {
        if (guest.name == request.peer) {
          guest.life = lifeReq.life;
        }
      });
    } else if (request.type == "deaf") {
      GuestBlade ? g;

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

  var posx = 0.0;
  var posy = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            engine!.getWidget(),
            GestureDetector(

              onPanUpdate: (details) {
                sendPosition(details.globalPosition.dx.toInt(), details.globalPosition.dy.toInt());
                posx = details.globalPosition.dx;
                posy = details.globalPosition.dy;
                player.transform.position.x = posx;
                player.transform.position.y = posy;
                player.particles();
              },
            ),

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
              alignment: AlignmentDirectional.topCenter,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Score " + player.score.toString(),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.amber),
                ),
              ),
            ),
          ],
        ));
  }

  sendPosition(int dx, int dy) {
    send(new PositionRequest(dx.toDouble(), dy.toDouble()));
  }

  PlayerBlade player = new PlayerBlade(0.0, 0.0, GameManager.instance!.getMyID());

  List<GuestBlade> guests = [];
  List<BladeTag> tags = [];
  List<BladeLife> lbars = [];

  initGame() {
    Camera.dx = 0;
    Camera.dy = 0;
    if (GameManager.instance!.gameMode == GameMode.Multi) {
      var i = 0;
      GameManager.instance!.players.forEach((element) {
        if (element != GameManager.instance!.getMyID()) {
          var g = new GuestBlade(0, 0, element);
          var ptag = new BladeTag(g);
          var lbar = new BladeLife(g);
          guests.add(g);
          tags.add(ptag);
          lbars.add(lbar);
          engine!.addGameObject(g);
          engine!.addGameObject(ptag);
          engine!.addGameObject(lbar);
        }
        i++;
      });
    }
    BladeTag playerTag = new BladeTag(player);
    var lbar = new BladeLife(player);
    tags.add(playerTag);
    lbars.add(lbar);
    engine!.addGameObject(player);
    engine!.addGameObject(playerTag);
    engine!.addGameObject(lbar);
  }

  var frames = 0;
  @override
  update() {
    super.update();
    frames++;
    if (frames % 100 == 0) {
      var proba = Random().nextInt(100);
      Fruit frt;
      if (proba < 80) {
        frt = new Fruit(Random().nextInt(2)*500.0 , 50.0,"banana");
      }else{
        frt = new Fruit(Random().nextInt(2)*500.0 , 50.0,"bomb");
      }
      AudioManager.getInstance().playEffect("throw.wav");
      send(new InstanciationRequest(frt.transform.position.x,frt.transform.position.y, frt.type, frt.transform.scale.x, frt.transform.scale.y, frt.renderer.color.toString(), frt.velocity.x, frt.velocity.y));
      engine!.addGameObject(frt);
    }

    if (GameManager.instance!.gameMode == GameMode.Solo) {
      Fruit.list.forEach((frt) {

        if (frt.isCollidingBlade(player)) {

          frt.destroy();
          if (frt.type == "bomb"){
            AudioManager.getInstance().playEffect("beep1.mp3");
            player.life -= 1;
          }

          if (frt.type == "banana"){
            AudioManager.getInstance().playEffect("hit.wav");
            player.score += 1;
          }


          if (player.life <= 0) {
            player.life = 10;
            onLoose();
          }
        }
      });

      Fruit.list.forEach((frt) {
        GuestBlade? g;
        guests.forEach((guest) {
          if (frt.isCollidingBlade(guest)) {
            frt.destroy();
            if (frt.type == "bomb"){
              AudioManager.getInstance().playEffect("beep1.mp3");
              guest.life -= 1;
            }

            if (frt.type == "banana"){
              AudioManager.getInstance().playEffect("hit.wav");
              guest.score += 1;
            }

          }
        });
        if (g!=null) guests.remove(g);
      });

    }else{

      sendPosition(player.transform.position.x.toInt(),
          player.transform.position.y.toInt());
      Fruit.list.forEach((frt) {
        if (frt.isCollidingBlade(player)) {
          frt.destroy();

          if (frt.type == "bomb"){
            AudioManager.getInstance().playEffect("beep1.mp3");
            player.life -= 1;
          }

          if (frt.type == "banana"){
            AudioManager.getInstance().playEffect("hit.wav");
            player.score += 1;
          }
          send(new LifeRequest(player.life));
          if (player.life <= 0) {
            player.life = 10;
            send(new DeafRequest());
            onLoose();
          }
        }
      });
      Fruit.list.forEach((frt) {
        guests.forEach((guest) {
          if (frt.isCollidingBlade(guest)) {
            frt.destroy();
          }
        });
      });
    }
  }

  onLoose() {
    var msg = "";
    if (GameManager.instance!.gameMode == GameMode.Solo){
      winner = "ia";
      msg = "you loosed with "+player.score.toString() +" fruits cut, battle is over for you\n" + "winner is " + winner ;
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
    GameManager.instance!.fileManager.addScoreToHost(1);
    goToWaitMenu(true, "you won the battle with "+player.score.toString() +" fruits cut! ");
  }

}

import 'dart:async';
import 'package:flutter/material.dart';
import '../GameEngine/Engine.dart';
import '../Menus/WaitsMenus/GuestWaitMenu.dart';
import '../Menus/WaitsMenus/HostWaitMenu.dart';
import '../Utils/AudioManager.dart';
import '../Utils/Requests/JsonRequest.dart';
import '../Utils/Requests/ScoreRequest.dart';
import '../Utils/Requests/WinRequest.dart';
import '/Utils/Reciever.dart';
import '/Utils/GameManager.dart';

class GameState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, Reciever {
  GameEngine? engine;

  String winner = "";
  bool wined = false;
  late Timer timer;
  bool run = true;
  int frames = 0;
  void stop() {
    run = false;
    GameManager.instance!.unsubscribe(this);
    timer.cancel();
    this.engine!.stop();
  }

  @override
  void initState() {
    engine = GameEngine(this);
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (run) Mupdate();
    });
    GameManager.instance!.subscribe(this);

    print("subscribed");
  }

  @override
  void dispose() {
    super.dispose();
    AudioManager.getInstance().stop();
    stop();
    print("unsubscribed");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  void send(JsonRequest req) {
    GameManager.instance!.sendJsonRequest(req);
  }

  @override
  void onRecieve(JsonRequest req) {
    setState(() {});
  }

  void Mupdate() {
    this.frames += 1;
    if (this.frames > 100000) this.frames = 0;
    if (mounted) setState(() {});
    update();
  }

  int getFrames() {
    return this.frames;
  }

  void update() {}

  void goToWaitMenu(bool win, String message) {
    GameManager.instance!.lastWinner = winner;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // ignore: prefer_const_constructors
        builder: (_) => HostWaitMenu(
          message: message,
        ),
      ),
    );
  }

  dispatchOnEnd(bool hostIsLoosing) {
    if (GameManager.instance!.wifiP2PInfo?.isGroupOwner == true) {
      if (hostIsLoosing) {
        // pour chaques joueurs dans la liste des joueurs si le joueur n'est pas le joueur actuel alors on +=1

        for (var i = 0; i < GameManager.instance!.players.length; i++) {
          if (GameManager.instance!.players[i] !=
              GameManager.instance!.getMyID()) {
            GameManager.instance!.scores[GameManager.instance!.players[i]] += 1;
            GameManager.instance!
                .setLastWinner(GameManager.instance!.players[i]);
          }
        }
      } else {
        GameManager.instance!.setLastWinner(winner);
        GameManager.instance!.scores[winner] += 1;
      }
      //set the new score

      send(new ScoreRequest(GameManager.instance!.scores));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (_) => HostWaitMenu(
            message: wined ? "You win !" : "You loose !",
          ),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // ignore: prefer_const_constructors
          builder: (_) => GuestWaitMenu(
            message: wined ? "You win !" : "You loose !",
          ),
        ),
      );
    }
  }

  onLoose() {
    this.stop();
    dispatchOnEnd(true);
    send(new WinRequest(false));
  }

  onWin() {
    this.stop();
    dispatchOnEnd(false);
    send(new WinRequest(true));
  }
}

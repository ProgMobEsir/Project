import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import '../GameEngine/Engine.dart';
import '../Utils/Requests/JsonRequest.dart';
import '/Utils/Reciever.dart';

import '/Utils/GameManager.dart';

class GameState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver, Reciever {
  GameEngine engine = GameEngine();

  late Timer timer;
  bool run = true;
  int frames = 0;
  void stop() {
    run = false;
    GameManager.instance!.unsubscribe(this);
    timer.cancel();
    this.engine.stop();
  }

  @override
  void initState() {
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
}

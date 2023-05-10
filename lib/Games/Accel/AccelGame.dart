import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Utils/GameManager.dart';
import '../../Utils/GameMods.dart';
import '../../Utils/Requests/JsonRequest.dart';
import '../../Utils/Requests/WinRequest.dart';
import '../../navigation/NavigationService.dart';
import '../GameState.dart';
import 'package:wifi_direct_json/Games/Accel/Bubble.dart';
import 'package:sensors_plus/sensors_plus.dart';

enum Mode { write, guess, wait }

class AccelGame extends StatefulWidget {
  const AccelGame({super.key});

  @override
  State<AccelGame> createState() => AccelGameState();
}

class AccelGameState extends GameState<AccelGame> {
  List<double>? _userAccelerometerValues = [0.0, 0.0, 0.0];
  List<double>? _accelerometerValues = [0.0, 0.0, 0.0];
  List<double>? _gyroscopeValues = [0.0, 0.0, 0.0];
  List<double>? _magnetometerValues = [0.0, 0.0, 0.0];
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void initSensors() {
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) {
          setState(() {
            _userAccelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      accelerometerEvents.listen(
        (AccelerometerEvent event) {
          setState(() {
            _accelerometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          setState(() {
            _gyroscopeValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
        (MagnetometerEvent event) {
          setState(() {
            _magnetometerValues = <double>[event.x, event.y, event.z];
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
    ]);

    initGame();
    initSensors();
    var userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    var accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    var gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    var magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void onRecieve(JsonRequest req) {
    super.onRecieve(req);

    if (req.type == "win") {
      wined = false;
      winner = req.getWinRequest().peer;
      onReceiveLoose();
    }
  }

  @override
  Widget build(BuildContext context) {
    //return the widget with a text displaying the number
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {},
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.amber,
              //add a button to the home page :
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    NavigationService.instance.navigateToReplacement("GAMES");
                  },
                ),
              ],
              title: const Text('AccelGame'),
            ),
            body:
                //add four buttons numbered 1 to 4 :
                Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    engine.getWidget(),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var bubble = new Bubble(50, 50, 10);

  var cible = new Bubble(
      Random().nextInt(100).toDouble(), Random().nextInt(100).toDouble(), 30);

  initGame() {
    engine.addGameObject(cible);
    engine.addGameObject(bubble);

    cible.renderer.color = Colors.red;

    print("init");
  }

  var nb = 0;

  @override
  void update() {
    bubble.transform.position.x += _gyroscopeValues![1] * 2;
    bubble.transform.position.y += _gyroscopeValues![0] * 5;

    //bound the bubble in the screen :
    if (bubble.transform.position.x > 100) {
      bubble.transform.position.x = 100;
    }
    if (bubble.transform.position.x < -100) {
      bubble.transform.position.x = -100;
    }
    if (bubble.transform.position.y > 100) {
      bubble.transform.position.y = 100;
    }
    if (bubble.transform.position.y < -100) {
      bubble.transform.position.y = -100;
    }

    var dist = bubble.transform.position - cible.transform.position;

    if (dist.length < 40) {
      cible.transform.position.x = Random().nextInt(200).toDouble() - 100;

      cible.transform.position.y = Random().nextInt(200).toDouble() - 100;
      nb += 1;
    }

    if (nb > 10) {
      if (GameManager.instance!.gameMode == GameMode.Solo) {
        wined = true;
        onSoloWin();
      } else {
        wined = true;
        winner = GameManager.instance!.getMyID();
        onWin();
      }
    }
  }

  onWin() {
    this.stop();
    dispatchOnEnd(false);
    send(new WinRequest(true));
  }

  onReceiveWin() {
    this.stop();
    dispatchOnEnd(true);
  }

  onReceiveLoose() {
    this.stop();
    dispatchOnEnd(false);
  }

  onLoose() {
    this.stop();
    dispatchOnEnd(true);
    send(new WinRequest(false));
  }

  onSoloLoose() {
    this.stop();
    goToWaitMenu(false, "time played " + 0.toString() + " seconds");
  }

  onSoloWin() {
    this.stop();
    goToWaitMenu(true, "you won in " + 0.toString() + " seconds");
  }
}

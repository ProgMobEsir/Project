import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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


  List<double>? _userAccelerometerValues;
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  void initSensors(){
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
    initGame();
    initSensors();

  }
  @override
  void dispose(){
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void onRecieve(JsonRequest req) {
    super.onRecieve(req);

    if (req.type == "win") {
      wined = true;
      winner = req.getWinRequest().peer;
      dispatchOnWin();
    }
  }

  @override
  Widget build(BuildContext context) {
       final userAccelerometer = _userAccelerometerValues
        ?.map((double v) => v.toStringAsFixed(1))
        .toList();
    final accelerometer =
        _accelerometerValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final gyroscope =
        _gyroscopeValues?.map((double v) => v.toStringAsFixed(1)).toList();
    final magnetometer =
        _magnetometerValues?.map((double v) => v.toStringAsFixed(1)).toList();




    //return the widget with a text displaying the number
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {},
      child: Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  engine.getWidget(),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  var bubble = new Bubble(50, 50, 10);
  
  var cible = new Bubble(Random().nextInt(300).toDouble(), Random().nextInt(500).toDouble(), 30);


  initGame() {

    engine.addGameObject(cible);
    engine.addGameObject(bubble);
    
    cible.renderer.color = Colors.red;

    print("init");
    
  }
  @override
  void update(){
    bubble.transform.position.x += _gyroscopeValues![1];
    bubble.transform.position.y += _gyroscopeValues![0];

    var dist = bubble.transform.position - cible.transform.position;

    if(dist.length < 40){
      print(dist);
    }
  
  }


  onWin() {
    this.stop();
    dispatchOnWin();
    send(new WinRequest(true));
  }

  onLoose() {
    this.stop();
    dispatchOnWin();
    send(new WinRequest(false));
  }
}

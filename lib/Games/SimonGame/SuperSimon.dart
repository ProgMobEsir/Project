import 'dart:async';
import '../../Utils/AudioManager.dart';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Utils/Requests/SequenceRequest.dart';
import '../../Utils/GameManager.dart';
import '../../Utils/Requests/JsonRequest.dart';
import '../../Utils/Requests/WinRequest.dart';
import '../../navigation/NavigationService.dart';
import '../GameState.dart';

enum Mode { write, guess, wait }

class SuperSimon extends StatefulWidget {
  const SuperSimon({super.key});

  @override
  State<SuperSimon> createState() => SuperSimonState();
}

class SuperSimonState extends GameState<SuperSimon> {
  var sequence = [];
  var currentSequence = -1;
  var currentGuess = 0;
  var mode = Mode.write;
  var modeMessage = "";

  void setMode(Mode m) {
    mode = m;
    if (mode == Mode.write) {
      modeMessage = "Write the sequence";
    }
    if (mode == Mode.guess) {
      modeMessage = "Guess the sequence";
    }
    if (mode == Mode.wait) {
      modeMessage = "Wait for the other player";
    }
  }

  @override
  void initState() {
    super.initState();

    if (GameManager.instance?.wifiP2PInfo?.isGroupOwner == true) {
      setMode(Mode.write);
    } else {
      setMode(Mode.wait);
    }
  }

  @override
  void onRecieve(JsonRequest req) {
    super.onRecieve(req);

    if (req.type == "sequence") {
      String seq = req.getSequenceRequest().sequence;
      sequence = seq.split(",");
      playSequence();
      setMode(Mode.guess);
    }
    if (req.type == "win") {
      wined = true;
      winner = req.getWinRequest().peer;
      dispatchOnWin();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('Simon Game'),
        ),
        body:
            //add four buttons numbered 1 to 4 :
            Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                modeMessage,
                style: const TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    key: const Key('bt1'),
                    onPressed: () {
                      AudioManager.getInstance().playEffect("beep1.mp3");
                      setState(() {
                        onButtonPushed(1);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: getButtonColor(1),
                    ),
                    child: Text(
                      '1',
                    ),
                  ),
                  ElevatedButton(
                    key: const Key('bt3'),
                    onPressed: () {
                      AudioManager.getInstance().playEffect("beep3.mp3");
                      setState(() {
                        onButtonPushed(3);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: getButtonColor(3),
                    ),
                    child: Text(
                      '3',
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  key: const Key('bt2'),
                  onPressed: () {
                    AudioManager.getInstance().playEffect("beep2.mp3");
                    setState(() {
                      onButtonPushed(2);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: getButtonColor(2),
                  ),
                  child: Text(
                    '2',
                  ),
                ),
                ElevatedButton(
                  key: const Key('bt4'),
                  onPressed: () {
                    AudioManager.getInstance().playEffect("beep4.mp3");
                    setState(() {
                      onButtonPushed(4);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: getButtonColor(4),
                  ),
                  child: Text(
                    '4',
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  sendSequence() {
    var formedSeq = sequence.join(",");
    send(new SequenceRequest(formedSeq));
    setMode(Mode.wait);
  }

  void onButtonPushed(int button) {
    if (mode == Mode.guess) {
      if (button.toString() == sequence[currentGuess]) {
        if (currentGuess == sequence.length - 1) {
          currentGuess = 0;
          setMode(Mode.write);
        } else {
          setState(() {
            currentGuess++;
          });
        }
      } else {
        onLoose();
      }
    } else if (mode == Mode.write) {
      sequence.add(button.toString());
      sendSequence();
      mode = Mode.wait;
    }
  }

  var textSeq = "";
  var seqTimer;
  playSequence() {
    for (var i = 0; i <= sequence.length; i++) {
      seqTimer = Timer(Duration(seconds: i), () {
        if (i < sequence.length && seqTimer.isActive) {
          textSeq = sequence[i];

          AudioManager.getInstance().playEffect("beep" + sequence[i] + ".mp3");
          setState(() {
            currentSequence = int.parse(textSeq);
          });
        } else {
          textSeq = "";
          setState(() {
            currentSequence = -1;
          });
        }
      });
    }
  }

  Color getButtonColor(int button) {
    if (currentSequence == button) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  onWin() {
    seqTimer.cancel();
    this.stop();
    dispatchOnWin();
    send(new WinRequest(true));
  }

  onLoose() {
    seqTimer.cancel();
    this.stop();
    dispatchOnWin();
    send(new WinRequest(false));
  }
}

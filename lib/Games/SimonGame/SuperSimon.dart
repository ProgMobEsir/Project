import 'dart:async';
import 'dart:math';
import 'package:wifi_direct_json/Utils/GameMods.dart';

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
  var nbTurns = 0;
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
    if (GameManager.instance?.gameMode == GameMode.Solo) {
      setMode(Mode.wait);
      iaPlayTurn();
    } else {
      if (GameManager.instance?.wifiP2PInfo?.isGroupOwner == true) {
        setMode(Mode.write);
      } else {
        setMode(Mode.wait);
      }
    }
  }

  @override
  void onRecieve(JsonRequest req) {
    super.onRecieve(req);

    if (req.type == "sequence") {
      String seq = req.getSequenceRequest().sequence;
      sequence = seq.split(",");
      playSequence();
    }
    if (req.type == "win") {
      wined = true;
      winner = GameManager.instance!.getMyID();
      dispatchOnEnd(false);
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
                AudioManager.getInstance().stop();
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
    if (GameManager.instance?.gameMode == GameMode.Solo) {
    } else {
      send(new SequenceRequest(formedSeq));
      setMode(Mode.wait);
    }
  }

  iaPlayTurn() {
    nbTurns++;
    Timer(Duration(seconds: 1), () {
      sequence.add((1 + Random().nextInt(4)).toString());
      playSequence();
      setMode(Mode.guess);
    });
  }

  void onButtonPushed(int button) {
    if (mode == Mode.guess) {
      if (button.toString() == sequence[currentGuess]) {
        if (currentGuess == sequence.length - 1) {
          currentGuess = 0;
          if (GameManager.instance?.gameMode == GameMode.Solo) {
            if (nbTurns == 4) {
              onSoloWin();
            }
            setMode(Mode.wait);
            iaPlayTurn();
          } else {
            setMode(Mode.write);
          }
        } else {
          setState(() {
            currentGuess++;
          });
        }
      } else {
        if (GameManager.instance?.gameMode == GameMode.Solo) {
          onSoloLoose();
        } else {
          onLoose();
        }
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
          setMode(Mode.guess);
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

  onSoloLoose() {
    seqTimer.cancel();
    this.stop();
    winner = "IA";
    AudioManager.getInstance().playMusic("loose.mp3");
    goToWaitMenu(false, "you played " + nbTurns.toString() + " turns");
  }

  onSoloWin() {
    seqTimer.cancel();
    winner = GameManager.instance!.getMyID();
    this.stop();
    AudioManager.getInstance().playMusic("win.mp3");
    goToWaitMenu(true, "you played " + nbTurns.toString() + " turns");
  }

  onWin() {
    seqTimer.cancel();
    this.stop();
    send(new WinRequest(true));
    AudioManager.getInstance().playMusic("win.mp3");
    dispatchOnEnd(false);


  }

  onLoose() {
    winner = "ALL";
    seqTimer.cancel();
    this.stop();
    send(new WinRequest(false));
    AudioManager.getInstance().playMusic("loose.mp3");
    dispatchOnEnd(true);

  }
}

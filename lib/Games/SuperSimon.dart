import 'dart:async';
import 'package:flutter/material.dart';
import '/Menus/ConnPage.dart';
import '/Utils/Reciever.dart';
import '/Utils/GameManager.dart';

enum Mode { write, guess, wait }

class SuperSimon extends StatefulWidget {
  const SuperSimon({super.key});

  @override
  State<SuperSimon> createState() => SuperSimonState();
}

class SuperSimonState extends State<SuperSimon>
    with WidgetsBindingObserver, Reciever {
  //list of the peer devices :

  var sequence = [];
  int currentIndex = 10000;
  int currentGuessIndex = 0;
  Mode mode = Mode.write;
  int addbyTurn = 1;
  int CurrentAdded = 0;
  String data = "";

  @override
  void onRecieve(req) {
    super.onRecieve(req);

    data = req;
  }

  @override
  void initState() {
    super.initState();
    GameManager.instance!.subscribe(this);
    print("subscribed");
  }

  @override
  void dispose() {
    super.dispose();
    GameManager.instance!.unsubscribe(this);
    print("unsubscribed");
  }

  @override
  Widget build(BuildContext context) {
    //return the widget with a text displaying the number
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        //add a button to the home page :
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnPage(),
                ),
              );
            },
          ),
        ],
        title: const Text('Simon Game'),
      ),
      body: Center(
        //add four buttons numbered 1 to 4 :
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: const Key('bt1'),
                  onPressed: () {
                    setState(() {
                      if (mode == Mode.write) {
                        sequence.add(1);
                        CurrentAdded++;
                      }
                      if (mode == Mode.guess) {
                        if (sequence[currentGuessIndex] == 1) {
                          currentGuessIndex++;
                        } else {
                          loose();
                          currentIndex = 10000;
                        }
                      }
                      verifyTurnEnded();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      getColorForButton(1),
                    ),
                  ),
                  child: Text(
                    '1',
                  ),
                ),
                ElevatedButton(
                  key: const Key('bt2'),
                  onPressed: () {
                    setState(() {
                      if (mode == Mode.write) {
                        sequence.add(2);
                        CurrentAdded++;
                      }
                      if (mode == Mode.guess) {
                        if (sequence[currentGuessIndex] == 2) {
                          currentGuessIndex++;
                        } else {
                          loose();
                          currentIndex = 10000;
                        }
                      }
                      verifyTurnEnded();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      getColorForButton(2),
                    ),
                  ),
                  child: Text(
                    '2',
                  ),
                ),
                ElevatedButton(
                  key: const Key('bt3'),
                  onPressed: () {
                    setState(() {
                      if (mode == Mode.write) {
                        sequence.add(3);
                        CurrentAdded++;
                      }
                      if (mode == Mode.guess) {
                        if (sequence[currentGuessIndex] == 3) {
                          currentGuessIndex++;
                        } else {
                          loose();
                          currentIndex = 10000;
                        }
                      }
                      verifyTurnEnded();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      getColorForButton(3),
                    ),
                  ),
                  child: Text(
                    '3',
                  ),
                ),
                ElevatedButton(
                  key: const Key('bt4'),
                  onPressed: () {
                    setState(() {
                      if (mode == Mode.write) {
                        sequence.add(4);
                        CurrentAdded++;
                      }
                      if (mode == Mode.guess) {
                        if (sequence[currentGuessIndex] == 4) {
                          currentGuessIndex++;
                        } else {
                          loose();
                          currentIndex = 10000;
                        }
                      }
                      verifyTurnEnded();
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      getColorForButton(4),
                    ),
                  ),
                  child: Text(
                    '4',
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: Text(
                'fake recieve',
              ),
              onPressed: () {
                mode = Mode.guess;
                initGuess();
              },
            ),
            Text(
              sequence.toString(),
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              //condition ternaire :
              mode == Mode.write
                  ? 'add a number to the sequence and send it'
                  : mode == Mode.guess
                      ? 'Guess the sequence'
                      : 'Waiting ',

              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Current index : $currentIndex',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Data recieved : $data',
              style: const TextStyle(fontSize: 20),
            ),
            ElevatedButton(
              onPressed: () {
                playSequence();
                sendSequence();
              },
              child: const Text('Send sequence'),
            ),
          ],
        ),
      ),
    );
  }

  void sendSequence() {
    //send the sequence to the other device :
    print("sending string");

    GameManager.instance!.sendMessage(sequence.toString());
  }

  void loose() {
    sequence = [];
  }

  void initGuess() {
    mode = Mode.guess;
    currentGuessIndex = 0;
  }

  void initWrite() {
    mode = Mode.write;
    CurrentAdded = 0;
  }

  void verifyTurnEnded() {
    if (mode == Mode.guess) {
      if (currentGuessIndex >= sequence.length) {
        mode = Mode.wait;
        Timer(const Duration(seconds: 2), () {
          initWrite();
        }).cancel();
      }
    } else if (mode == Mode.write) {
      if (CurrentAdded == addbyTurn) {
        CurrentAdded = 0;
        mode = Mode.wait;
        return;
      }
    }
  }

  void playSequence() {
    // Reset the current index
    currentIndex = -1;
    // Play the sequence
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentIndex >= sequence.length) {
        // End the sequence playback
        timer.cancel();
        return;
      }
      setState(() {
        // Update the current index
        currentIndex++;
      });
    });

    currentIndex = 0;
  }

  // Add a method to get the color for the button based on the current number
  Color getColorForButton(int number) {
    if (currentIndex >= sequence.length) {
      // Sequence playback has ended, reset color
      return Colors.blue;
    }
    return number == sequence[currentIndex] ? Colors.green : Colors.red;
  }
}

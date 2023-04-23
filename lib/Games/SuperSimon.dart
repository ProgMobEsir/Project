import 'package:flutter/material.dart';
import '/Menus/ConnPage.dart';

import 'GameState.dart';

enum Mode { write, guess, wait }

class SuperSimon extends StatefulWidget {
  const SuperSimon({super.key});

  @override
  State<SuperSimon> createState() => SuperSimonState();
}

class SuperSimonState extends GameState {
  var sequence = [];
  String data = "";
  var guestPos = [];

  @override
  void onRecieve(req) {
    super.onRecieve(req);
    data = req;

    if (req.toString().startsWith("SEQ")) {
      sequence = req
          .toString()
          .replaceAll("SEQ[", "")
          .replaceAll("]", "")
          .replaceAll(",", "")
          .split(" ");
    }
    if (req.toString().startsWith("POS")) {
      guestPos = req
          .toString()
          .replaceAll("POS[", "")
          .replaceAll("]", "")
          .replaceAll(",", "")
          .split(" ");

      print(guestPos);
    }
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
        child: GestureDetector(
          onVerticalDragDown: (DragDownDetails details) {
            sendPosition(details.globalPosition.dx.toInt(),
                details.globalPosition.dy.toInt());
          },
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
                        sequence.add("1");
                      });
                    },
                    child: Text(
                      '1',
                    ),
                  ),
                ],
              ),
              Text(
                'Current Sequence : $sequence',
                style: const TextStyle(fontSize: 20),
              ),
              Draggable(

                child: Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.pink,
                ),
                // This will be displayed when the widget is being dragged
                feedback: Container(
                  
                  width: 100.0,
                  height: 100.0,
                  color: Colors.pink,
                ),
                onDragCompleted: () => print("drag completed"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    sendSequence();
                  });
                },
                child: const Text('end turn'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendSequence() {
    send("SEQ" + sequence.toString());
  }

  sendPosition(int dx, int dy) {
    send("POS" + "[" + dx.toString() + ", " + dy.toString() + "]");
  }
}

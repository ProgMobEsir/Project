import 'package:flutter/material.dart';
import '../../Utils/Requests/JsonRequest.dart';
import '/Menus/ConnPage.dart';
import '../GameState.dart';

enum Mode { write, guess, wait }

class SuperSimon extends StatefulWidget {
  const SuperSimon({super.key});

  @override
  State<SuperSimon> createState() => SuperSimonState();
}

class SuperSimonState extends GameState<SuperSimon> {
  var sequence = [];
  String data = "";
  var guestPos = [0, 0];

  @override
  void onRecieve(JsonRequest req) {
    super.onRecieve(req);
    data = req.body;

    if (req.toString().startsWith("SEQ")) {
      sequence = req
          .toString()
          .replaceAll("SEQ[", "")
          .replaceAll("]", "")
          .replaceAll(",", "")
          .split(" ");
    }
  }

  @override
  Widget build(BuildContext context) {
    //return the widget with a text displaying the number
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        sendPosition(details.globalPosition.dx.toInt(),
            details.globalPosition.dy.toInt());
      },
      child: Scaffold(
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
        body:

            //add four buttons numbered 1 to 4 :
            Center(
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
    send(new JsonRequest("", "", "", ""));
  }

  sendPosition(int dx, int dy) {
    send(new JsonRequest("", "", "", ""));
  }
}

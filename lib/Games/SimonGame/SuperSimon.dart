import 'dart:async';


import '../../Utils/AudioManager.dart';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Utils/Requests/SequenceRequest.dart';
import '../../Utils/GameManager.dart';
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
  var mode = Mode.write;

  @override
  void initState() {
    super.initState();

    if (GameManager.instance?.wifiP2PInfo?.isGroupOwner == true ) {
      mode = Mode.guess; 
    }
    else {
      mode = Mode.write;
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
  }

  @override
  Widget build(BuildContext context) {
    //return the widget with a text displaying the number
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
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
                                                    ElevatedButton(
                    key: const Key('bt3'),
                    onPressed: () {
                      setState(() {
                        sequence.add("3");
                      });
                    },
                    child: Text(
                      '3',
                    ),
                  ),
                  
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                                  ElevatedButton(
                    key: const Key('bt2'),
                    onPressed: () {
                      setState(() {
                        sequence.add("2");
                      });
                    },
                    child: Text(
                      '2',
                    ),
                  ),
                  ElevatedButton(
                    key: const Key('bt4'),
                    onPressed: () {
                      setState(() {
                        sequence.add("4");
                      });
                    },
                    child: Text(
                      '4',
                    ),
                  ),]),
              Text(
                'Current Sequence : $sequence',
                style: const TextStyle(fontSize: 20),
              ),
              Text(textSeq),
              
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
    var formedSeq = sequence.join(",");
    send(new SequenceRequest(formedSeq, ""));
  }

  var textSeq = "";
  playSequence(){
    for (var i = 0; i <= sequence.length ; i++) {
      Timer(Duration(seconds: i), () {

        if (i < sequence.length ){
          textSeq = sequence[i];
           
          AudioManager.getInstance().play("beep.mp3");
        }
        else{
          textSeq = "";
        }
        
      });
    }

  }

}

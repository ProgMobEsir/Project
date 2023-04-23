import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Menus/ConnPage.dart';

import 'GameState.dart';

class DragGame extends StatefulWidget {
  const DragGame({super.key});

  @override
  State<DragGame> createState() => DragGameState();
}

class DragGameState extends GameState<DragGame> {
  var sequence = [];
  String data = "";
  var guestPos = [0, 0];
  var circlePos = [0, 0];

  @override
  void onRecieve(req) {
    super.onRecieve(req);
    data = req;

    if (req.toString().startsWith("POS")) {
      var tmp = req
          .toString()
          .replaceAll("POS[", "")
          .replaceAll("]", "")
          .replaceAll(",", "")
          .split(" ")
          .cast();
      guestPos[0] = int.parse(tmp[0]);
      guestPos[1] = int.parse(tmp[1]);

      circlePos[0] = guestPos[0];
      circlePos[1] = guestPos[1];
      print(guestPos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        var x = details.globalPosition.dx.toInt();
        var y = details.globalPosition.dy.toInt();
        sendPosition(x, y);
        setState(() {
          circlePos[0] = x;
          circlePos[1] = y;
        });
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
          title: const Text('Drag Game'),
        ),
        body: CustomPaint(
          painter: MyPainter(
              circlePos[0].ceilToDouble(), circlePos[1].ceilToDouble()),
        ), //add four buttons numbered 1 to 4
      ),
    );
  }

  sendPosition(int dx, int dy) {
    send("POS" + "[" + dx.toString() + ", " + dy.toString() + "]");
  }
}

class MyPainter extends CustomPainter {
  double x, y;

  MyPainter(this.x, this.y);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5;

    canvas.drawCircle(Offset(x, y), 50, paint); // Draw a circle
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

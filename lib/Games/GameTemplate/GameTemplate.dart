import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Menus/ConnPage.dart';
import '../GameState.dart';

class DragGame extends StatefulWidget {
  const DragGame({super.key});

  @override
  State<DragGame> createState() => DragGameState();
}

class DragGameState extends GameState<DragGame> {
  var pos = [0, 0];

  @override
  void initState() {
    super.initState();
  }

  @override
  void onRecieve(req) {
    super.onRecieve(req);
    update();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        var x = details.globalPosition.dx.toInt();
        var y = details.globalPosition.dy.toInt();
        pos[0] = x;
        pos[1] = y;

        setState(() {});
        update();
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
          title: const Text('Game Template'),
        ),
        body: engine!.getWidget(),
      ),
    );
  }

  @override
  update() {
    super.update();
  }
}

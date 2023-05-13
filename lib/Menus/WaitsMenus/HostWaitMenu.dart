import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '/Utils/GameManager.dart';

class HostWaitMenu extends StatefulWidget {
  final String message;
  const HostWaitMenu({super.key, required this.message});

  @override
  State<HostWaitMenu> createState() => _HostWaitMenuState();
}

class _HostWaitMenuState extends State<HostWaitMenu>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'And the winner is..',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              " " + GameManager.instance!.getLastWinner().toString() + " !",
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Text(widget.message),
            Text(
              'click next to choose the next game !',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Scores " + GameManager.instance!.scores.toString(),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!.sendPlayers();
                NavigationService.instance.navigateToReplacement('GAMES');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import 'GameMenu.dart';
import 'ConnPage.dart';
import '/Utils/GameMods.dart';
import '/Utils/GameManager.dart';

class WaitMenu extends StatefulWidget {
  const WaitMenu({super.key});

  @override
  State<WaitMenu> createState() => _WaitMenuState();
}

class _WaitMenuState extends State<WaitMenu> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Wait for the host to choose the next game !',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Text(
              "Score" + GameManager.instance!.scores.toString(),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                NavigationService.instance.navigateToReplacement('HOME');
              },
              child: const Text('Exit to home'),
            ),
          ],
        ),
      ),
    );
  }
}

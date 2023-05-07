import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '/Utils/GameManager.dart';

class GuestWaitMenu extends StatefulWidget {
  final String message;
  const GuestWaitMenu({super.key, required this.message});

  @override
  State<GuestWaitMenu> createState() => _GuestWaitMenuState();
}

class _GuestWaitMenuState extends State<GuestWaitMenu>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.message),
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

import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import '../../Utils/styles.dart';
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
      backgroundColor: Colors.amber.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(widget.message),
            Padding(padding:const EdgeInsets.all(10.0)),
            const Text(
              textAlign: TextAlign.center,
              'Wait for the host to choose the next game !',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(padding:const EdgeInsets.all(10.0)),
            Text(
              "Score" + GameManager.instance!.scores.toString(),
              textAlign: TextAlign.center,
            ),
            Padding(padding:const EdgeInsets.all(10.0)),
            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.red),
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

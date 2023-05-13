import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';

import '../Utils/AudioManager.dart';
import '../Utils/GameManager.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => SettingMenuState();
}

class SettingMenuState extends State<SettingsMenu> with WidgetsBindingObserver {
  double effectSliderValue = 0.0;
  double musicSliderValue = 0.0;
  final myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    AudioManager().getMusicVolume().then((value) => {musicSliderValue = value});
    AudioManager()
        .getEffectVolume()
        .then((value) => {print(effectSliderValue)});
    AudioManager.getInstance().playMusic("intro.mp3");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        //add a button to the home page :
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              NavigationService.instance.navigateToReplacement('HOME');
            },
          ),
        ],
        title: const Text('Settings Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the best P2P game app ever!',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            //la on met du padding
            const Padding(padding: EdgeInsets.all(100)),
            //et la un bouton de play
            Text('Effects volume'),
            Slider(
              value: effectSliderValue,
              max: 100,
              divisions: 5,
              label: effectSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  effectSliderValue = value;
                  AudioManager.getInstance().setEffectVolume(value);
                });
              },
            ),
            Text('Music volume'),
            Slider(
              value: musicSliderValue,
              max: 100,
              divisions: 5,
              label: musicSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  musicSliderValue = value;
                  AudioManager.getInstance().setMusicVolume(value);
                });
              },
            ),
            const Text(
              'Enter your name ',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            TextField(
              controller: myController,
            ),
            ElevatedButton(
                onPressed: () {
                  GameManager.instance!.playerName = myController.text;
                },
                child: Text('setName')),
          ],
        ),
      ),
    );
  }
}

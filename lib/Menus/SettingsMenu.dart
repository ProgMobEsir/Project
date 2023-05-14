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
  Color _selectedColor = Colors.white; // default color

  final List<Color> _colors = [    Colors.red,    Colors.blue,    Colors.green,    Colors.yellow,    Colors.purple,    Colors.black  ];


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
      body:  SingleChildScrollView(
    child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(20)),
            Text(
              'Customize you app !',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            //la on met du padding
            Padding(padding: EdgeInsets.all(20)),
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
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.grey,
            ),
            Padding(padding: EdgeInsets.all(20)),
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
                child: Text('Set your name')),
            Padding(padding: EdgeInsets.all(20)),
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.grey,
            ),
            Column(
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: _colors
                  .map((color) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                child: Container(
                  color: color,
                  child: color == _selectedColor
                      ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                      : null,
                ),
              ))
                  .toList(),
            ),
            ElevatedButton(
              onPressed: () {
                GameManager.instance!.playerColor = _selectedColor;
              },
              child: Text('set your color'),
            ),
            Padding(padding: EdgeInsets.all(20)),
          ],

        )

          ],
        ),
      ),),

    );
  }
}

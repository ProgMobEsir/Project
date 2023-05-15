import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Utils/AudioManager.dart';
import '../Utils/GameManager.dart';
import '../Utils/styles.dart';

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

  Future<void> _requestPermissions() async {
    final List<Permission> permissions = [
      Permission.locationWhenInUse,
      Permission.nearbyWifiDevices,
      Permission.storage,
    ];
    final Map<Permission, PermissionStatus> permissionStatuses = await permissions.request();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade100,
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
        child: Padding(padding: EdgeInsets.all(20),
          child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Customize you app',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 30,

                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(padding: EdgeInsets.all(20)),
            Text('Permissions'),
            ElevatedButton(onPressed: (){
              _requestPermissions();
            }, child: Text('Request Permissions')),
            Divider(
              height: 20,
              thickness: 2,
              color: Colors.grey,
            ),
            Padding(padding: EdgeInsets.all(20)),
            Text('Effects volume'),
            Slider(
              activeColor: Colors.blue.shade200,
              value: effectSliderValue,
              max: 1,
              divisions: 100,
              label: (effectSliderValue*100).round().toString(),
              onChanged: (double value) {
                setState(() {
                  effectSliderValue = value;
                  AudioManager.getInstance().setEffectVolume(value);

                });
              },
            ),
            Text('Music volume'),
            Slider(
              activeColor: Colors.red.shade200,
              value: musicSliderValue,
              max: 1,
              divisions: 100,
              label:( musicSliderValue*100).round().toString(),
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
              'Set your name !',
              //generate a line to add padding to the text
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(padding: EdgeInsets.all(2)),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
              controller: myController,
            ),

            ElevatedButton(
              style: Style.getBtnStyleROUNDED(Colors.deepOrangeAccent),
                onPressed: () {
                  GameManager.instance!.fileManager.setScoreForPlayer(myController.text,0);
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
              style: Style.getBtnStyleROUNDED(Colors.deepOrangeAccent),
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
      ),),),

    );
  }
}

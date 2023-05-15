import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/navigation/NavigationService.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Utils/GameManager.dart';
import '../Utils/styles.dart';

class LeaderboardMenu extends StatefulWidget {
  const LeaderboardMenu({super.key});
  @override
  State<LeaderboardMenu> createState() => LeaderboardMenuState();
}

class LeaderboardMenuState extends State<LeaderboardMenu> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    GameManager.instance!.fileManager.loadScoresToGameManager();

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
        backgroundColor:Colors.white.withOpacity(0.5),
        //add a button to the home page :
        actions: [
          IconButton(
            icon: const Icon(Icons.cancel),
            onPressed: () {
              NavigationService.instance.navigateToReplacement('HOME');
            },
          ),
        ],
        title: const Text('Leaderboard'),
      ),
      body:  SingleChildScrollView(
        child:Column(
            children:<Widget>[
Padding(padding: const EdgeInsets.all(10)),
              Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Padding(padding: const EdgeInsets.all(10)),
              Container(
                height: 200, // set a fixed or maximum height for the ListView.builder
                child: Scrollbar(
                  thickness: 10,
                  radius: Radius.circular(20),
                  child: ListView.builder(
                    itemCount: GameManager.instance!.scores.keys.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [

                            Text(GameManager.instance!.scores.keys.elementAt(index)),
                            Spacer(),
                            Text(GameManager.instance!.scores.values.elementAt(index).toString()),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(padding: const EdgeInsets.all(10)),
              ElevatedButton(
                  style: Style.getBtnStyleROUNDED(Colors.blueGrey),
                  onPressed: () async {await GameManager.instance!.fileManager.loadScoresToGameManager();print(GameManager.instance!.scores.keys.toList());setState(() {

                  });}, child: Text('Refresh')),
              Padding(padding: const EdgeInsets.all(10)),
              ElevatedButton(
                  style: Style.getBtnStyleROUNDED(Colors.red),
                  onPressed: () async {await GameManager.instance!.fileManager.clearScores();print(GameManager.instance!.scores.keys.toList());}, child: Text('Clear Scores'))

            ]

            ),
          ),

    );
  }
}

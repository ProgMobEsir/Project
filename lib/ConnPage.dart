import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'SuperSimon.dart';
import 'GameManager.dart';

class ConnPage extends StatefulWidget {
  const ConnPage({super.key});

  @override
  State<ConnPage> createState() => ConnPageState();
}

class ConnPageState extends State<ConnPage> with WidgetsBindingObserver {
  final TextEditingController msgText = TextEditingController();

  @override
  void initState() {
    if (GameManager.instance?.flutterP2pConnectionPlugin == null) {
      throw Exception('flutterP2pConnectionPlugin is null');
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //GameManager.instance?.init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    //_flutterP2pConnectionPlugin?.unregister();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //_flutterP2pConnectionPlugin?.unregister();
    } else if (state == AppLifecycleState.resumed) {
      //_flutterP2pConnectionPlugin?.register();
    }
  }

  void snack(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          msg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          //add a button to the home page :
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ],
          title: const Text('Connect or create a group'),
        ),
        //add padding to the left of this box

        body: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 20)),
                Text(
                    "IP: ${GameManager.instance!.wifiP2PInfo == null ? "null" : GameManager.instance!.wifiP2PInfo?.groupOwnerAddress}"),
                GameManager.instance!.wifiP2PInfo != null
                    ? Text(
                        "connected: ${GameManager.instance!.wifiP2PInfo?.isConnected}, isGroupOwner: ${GameManager.instance!.wifiP2PInfo?.isGroupOwner}, groupFormed: ${GameManager.instance!.wifiP2PInfo?.groupFormed}, groupOwnerAddress: ${GameManager.instance!.wifiP2PInfo?.groupOwnerAddress}, clients: ${GameManager.instance!.wifiP2PInfo?.clients}")
                    : const SizedBox.shrink(),
                const SizedBox(height: 10),
                Padding(padding: const EdgeInsets.only(top: 20)),
                const Text("avialable devices:"),
                Divider(),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: GameManager.instance!.peers.length,
                    itemBuilder: (context, index) => Center(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Center(
                              child: AlertDialog(
                                content: SizedBox(
                                  height: 200,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "name: ${GameManager.instance!.peers[index].deviceName}"),
                                      Text(
                                          "address: ${GameManager.instance!.peers[index].deviceAddress}"),
                                      Text(
                                          "isGroupOwner: ${GameManager.instance!.peers[index].isGroupOwner}"),
                                      Text(
                                          "isServiceDiscoveryCapable: ${GameManager.instance!.peers[index].isServiceDiscoveryCapable}"),
                                      Text(
                                          "primaryDeviceType: ${GameManager.instance!.peers[index].primaryDeviceType}"),
                                      Text(
                                          "secondaryDeviceType: ${GameManager.instance!.peers[index].secondaryDeviceType}"),
                                      Text(
                                          "status: ${GameManager.instance!.peers[index].status}"),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      bool? bo = await GameManager
                                          .instance?.flutterP2pConnectionPlugin
                                          .connect(GameManager.instance!
                                              .peers[index].deviceAddress);
                                      //on start le socker automatoque
                                      GameManager.instance!.startSocket();
                                      snack("connected: $bo");
                                    },
                                    child: const Text("connect"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              GameManager.instance!.peers[index].deviceName
                                  .toString()
                                  .characters
                                  .first
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 20)),
                Text("Games"),
                Divider(),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () async {
                    GameManager.instance!.sendMessage("START GAME 1 2 6");
                  },
                  child: const Text("START GAME"), //automatic in games
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SuperSimon(),
                      ),
                    );
                  },
                  child: const Text("Game Simon"),
                ),
                Padding(padding: const EdgeInsets.only(top: 20)),
                Text("Connection stuff"),
                Divider(),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                  ),
                  onPressed: () async {
                    bool? created = await GameManager
                        .instance?.flutterP2pConnectionPlugin
                        .createGroup(); // button

                    snack("created group: $created");
                  },
                  child: const Text("create game room"),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                  ),
                  onPressed: () async {
                    bool? removed = await GameManager
                        .instance?.flutterP2pConnectionPlugin
                        .removeGroup(); //3
                    snack("removed group: $removed");
                  },
                  child: const Text("Leave Group"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    var info = await GameManager
                        .instance?.flutterP2pConnectionPlugin
                        .groupInfo(); //button
                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: Dialog(
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "groupNetworkName: ${info?.groupNetworkName}"),
                                  Text("passPhrase: ${info?.passPhrase}"),
                                  Text("isGroupOwner: ${info?.isGroupOwner}"),
                                  Text("clients: ${info?.clients}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: const Text("get group info"),
                ),
                /*ElevatedButton(
              onPressed: () async {
                String? ip = await _flutterP2pConnectionPlugin.getIPAddress();
                snack("ip: $ip");
              },
              child: const Text("get ip"),
            ),*/
                ElevatedButton(
                  onPressed: () async {
                    bool? discovering = await GameManager
                        .instance?.flutterP2pConnectionPlugin
                        .discover(); // button 4
                    snack("discovering $discovering");
                  },
                  child: const Text("Search room"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool? stopped = await GameManager
                        .instance?.flutterP2pConnectionPlugin
                        .stopDiscovery();
                    snack("stopped discovering $stopped");
                  },
                  child: const Text("stop discovery"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    GameManager.instance!.startSocket();
                  },
                  child: const Text("open a socket"), // button 5
                ),
                ElevatedButton(
                  onPressed: () async {
                    GameManager.instance!.connectToSocket();
                  },
                  child: const Text("connect to socket"), // button 6
                ),
                ElevatedButton(
                  onPressed: () async {
                    GameManager.instance!.closeSocketConnection();
                  },
                  child: const Text("close socket"),
                ),
              ],
            ),
          ),
        ));
  }
}

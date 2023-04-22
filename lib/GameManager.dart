import 'dart:async';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'Reciever.dart';
import 'GameMods.dart';

class GameManager {
  GameMode gameMode = GameMode.Solo;
  List<DiscoveredPeers> peers = [];
  WifiP2PInfo? wifiP2PInfo;
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  FlutterP2pConnection _flutterP2pConnectionPlugin = FlutterP2pConnection();

  FlutterP2pConnection get flutterP2pConnectionPlugin =>
      _flutterP2pConnectionPlugin;

  static GameManager? _instance;
  String name = "gameManager";
  //table of all the subscribers
  List<Reciever> subscribers = [];

  static GameManager? get instance {
    if (_instance == null) {
      _instance = GameManager();
      _instance!.init();
    }
    return _instance;
  }

  void subscribe(game) {
    subscribers.add(game);
  }

  void unsubscribe(game) {
    subscribers.remove(game);
  }

  String getName() {
    return name;
  }

  void onRecieve(req) {
    print("Recieving something! string");

    for (var sub in subscribers) {
      print("sending to ${sub.getName()}");
      sub.onRecieve(req);
    }
  }

  void init() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo =
        _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      wifiP2PInfo = event;
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      peers = event;
    });

    //here try to switch on the location if not enable
    (await _flutterP2pConnectionPlugin.checkLocationEnabled())
        ? "enabled"
        : await _flutterP2pConnectionPlugin.enableLocationServices();

    (await _flutterP2pConnectionPlugin.checkWifiEnabled())
        ? "enabled"
        : await _flutterP2pConnectionPlugin.enableWifiServices();

    await _flutterP2pConnectionPlugin?.removeGroup();

    bool? discovering = await _flutterP2pConnectionPlugin!.discover();
  }

  Future startSocket() async {
    if (wifiP2PInfo != null) {
      bool started = await _flutterP2pConnectionPlugin!.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {},
        transferUpdate: (transfer) {
          if (transfer.completed) {}
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          //TODO : GOOD
          print("Recieving from socket");
          GameManager.instance!.onRecieve(req);
        },
      );
    }
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {},
        transferUpdate: (transfer) {
          // if (transfer.count == 0) transfer.cancelToken?.cancel();
          if (transfer.completed) {}
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          print("Recieving from socket");
          GameManager.instance!.onRecieve(req);
        },
      );
    }
  }

  Future closeSocketConnection() async {
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
  }

  Future sendMessage(String s) async {
    _flutterP2pConnectionPlugin.sendStringToSocket(s);
  }
}

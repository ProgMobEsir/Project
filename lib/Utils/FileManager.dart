
import 'dart:convert';
import 'dart:io';

import 'package:wifi_direct_json/Utils/GameManager.dart';
import 'package:path_provider/path_provider.dart';
class FileManager {
  var FILEPATH = "scores.json";
  var appDirPath = "";

  FileManager() {
    setDirectory(); // Call setDirectory() in the constructor
  }

  Future<void> setDirectory() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    appDirPath = appDir.path;
    print(appDirPath);
  }

  Future<void> clearScores() async{
    GameManager.instance!.scores = {};
    final file = File(appDirPath +"/" +FILEPATH);
    file.writeAsStringSync("{}");
  }

  Future<void> addScoreToHost(int score) async{
        setScoreForPlayer(GameManager.instance!.getMyID(),score);
  }

  Future<void> loadScoresToGameManager() async {
    if (appDirPath == "") {
      await setDirectory();
    }

    final file = File(appDirPath + "/" + FILEPATH);
    Map<String, dynamic> existingScores = file.existsSync()
        ? json.decode(file.readAsStringSync())
        : {}; // Read existing scores from the file, if any
    GameManager.instance!.scores = existingScores;
    print("scores loaded");
    print(GameManager.instance!.scores);
  }
  Future<void> writeScoresToFile() async {
    if(appDirPath == ""){
      await setDirectory();
    }

    final file = File(appDirPath +"/" +FILEPATH);
    Map existingScores = {};

    // Read existing scores from the file, if any
    if (file.existsSync()) {
      String fileContent = file.readAsStringSync();
      existingScores = json.decode(fileContent);
    }

    // Update the scores with new values
    GameManager.instance!.scores.forEach((player, score) {
      if (existingScores.containsKey(player)) {
        existingScores[player] = existingScores[player]! + score;

      } else {
        existingScores[player] = score;
      }
    });

    // Write the updated scores to the file
    String updatedScores = json.encode(existingScores);
    file.writeAsStringSync(updatedScores);
  }

  int getScoreForPlayer(String name) {
    final file = File(appDirPath +"/" +FILEPATH);
    Map<String, dynamic> existingScores = {};

    // Read existing scores from the file, if any
    if (file.existsSync()) {
      String fileContent = file.readAsStringSync();
      existingScores = json.decode(fileContent);
    }
    if (existingScores.containsKey(name)){
      return existingScores[name]!;
    }
    return 0;
  }

  Future<void> setScoreForPlayer(String name,int score) async{
    if(appDirPath == ""){
      await setDirectory();
    }
    final file = File(appDirPath +"/" +FILEPATH);
    Map<String, dynamic> existingScores = {};

    // Read existing scores from the file, if any
    if (file.existsSync()) {
      String fileContent = file.readAsStringSync();
      existingScores = json.decode(fileContent);
    }
    if (!existingScores.containsKey(name)){
      existingScores[name] = score;
    }
    else{
      existingScores[name] = existingScores[name]! + score;
    }
    String updatedScores = json.encode(existingScores);
    print(updatedScores);

    file.writeAsStringSync(updatedScores);
  }


}
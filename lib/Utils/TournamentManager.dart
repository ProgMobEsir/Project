import 'dart:math';

import 'package:wifi_direct_json/navigation/NavigationService.dart';

import 'GameManager.dart';
import 'Requests/JsonRequest.dart';

class TournamentManager {
  bool running = false;
  List<String> games = [];
  int currentGame = -1;
  String winner = "";
  void init(int nb) {
    print("start init the tournament");
    running = true;
    games.clear();
    //init random game list containing nb elements but not the same game twice
    var tmp = [];
    var random = new Random();
    while (tmp.length < nb) {
      var randomGame = random.nextInt(6);
      if (!tmp.contains(randomGame)) {
        print(randomGame);
        tmp.add(randomGame);
      }
    }
    for (int g in tmp){
      games.add(GameManager.instance!.gameList[g]);
    }
    NextGame();

  }

  void stopTournament(){
    running = false;
    currentGame = -1;

  }

  void NextGame(){
    currentGame +=1;
    if (currentGame >= games.length){
      onTournamentEnd();
      return;
    }
    print("next game : " + games[currentGame].split("_")[1]);
    GameManager.instance!
        .sendJsonRequest(new JsonRequest("", "GAME", games[currentGame].split("_")[1]));
    NavigationService.instance.navigateToReplacement(games[currentGame]);

  }

  void onTournamentEnd(){

    for (String player in GameManager.instance!.scores.keys){
      if (winner == ""){
        winner = player;
      }else{
        if (GameManager.instance!.scores[player] > GameManager.instance!.scores[winner]){
          winner = player;
        }
      }
    }
    stopTournament();
    GameManager.instance!
        .sendJsonRequest(new JsonRequest("", "SCREEN", "TOURNAMENT_END"));
    NavigationService.instance.navigateToReplacement('TOURNAMENT_END');
  }

}
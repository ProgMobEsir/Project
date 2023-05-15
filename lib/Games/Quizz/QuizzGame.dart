import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:wifi_direct_json/Utils/AudioManager.dart';
import 'package:wifi_direct_json/Utils/GameMods.dart';
import 'package:wifi_direct_json/Utils/Requests/QuestionRequest.dart';
import 'package:flutter/material.dart';
import 'package:wifi_direct_json/Utils/Requests/QuizzEndRequest.dart';
import '../../Utils/GameManager.dart';
import '../../Utils/Requests/JsonRequest.dart';
import '../../navigation/NavigationService.dart';
import '../GameState.dart';

enum Mode { write, guess, wait }

class QuizzGame extends StatefulWidget {
  const QuizzGame({super.key});

  @override
  State<QuizzGame> createState() => QuizzGameState();
}

class QuizzGameState extends GameState<QuizzGame> {
  String questionText = "";
  Map<String, dynamic> answers = {"a": "", "b": "", "c": "", "d": ""};
  int nbCorrect = 0;
  int currentIndex = 0;
  List<dynamic> questions = [];
  bool answered = false;
  var rightAnswer = "";
  bool otherHasFinished = false;
  int otherNbCorrect = 0;

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () {});
    if (GameManager.instance?.gameMode == GameMode.Solo) {
      loadQuestions();
    } else {
      if (GameManager.instance?.wifiP2PInfo?.isGroupOwner == true) {
        loadQuestions();
      }
    }
    super.initState();
  }

  loadQuestions() async {
    // Get a file reference
    String jsonString =
        await rootBundle.loadString('assets/gameData/Quizz/questions.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    print("Json de questions : " + jsonString);
    questions = jsonData["quiz"]["questions"];

    print("questions loaded");
    setNextQuestion();
    print("sending questions");

    send(new QuestionRequest(questions));

    print("game setup finished");
  }

  @override
  void onRecieve(JsonRequest req) {
    super.onRecieve(req);
    if (req.type == "questions") {
      QuestionRequest qreq = req.getQuestionRequest();

      questions = qreq.questions;
      setNextQuestion();
    } else if (req.type == "quizzend") {
      winner = req.getQuizzEndRequest().peer;
      QuizzEndRequest qreq = req.getQuizzEndRequest();
      otherNbCorrect = qreq.score;
      otherHasFinished = true;
      onEnd();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //return the widget with a text displaying the number
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {},
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          //add a button to the home page :
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                AudioManager.getInstance().stop();
                NavigationService.instance.navigateToReplacement("GAMES");
              },
            ),
          ],
          title: const Text('Simon Game'),
        ),
        body:
            //add four buttons numbered 1 to 4 :
            Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                questionText,
                style: const TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        onButtonPushed("a");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: getButtonColor("a"),
                    ),
                    child: Text(
                      answers["a"],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        onButtonPushed("c");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: getButtonColor("c"),
                    ),
                    child: Text(
                      answers["c"],
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      onButtonPushed("b");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: getButtonColor("b"),
                  ),
                  child: Text(
                    answers["b"],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      onButtonPushed("d");
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: getButtonColor("d"),
                  ),
                  child: Text(
                    answers["d"],
                  ),
                ),
              ]),
              if (answered)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      setNextQuestion();
                      answered = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  child: Text(
                    "Next question",
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void onButtonPushed(String button) {
    answered = true;
    if (button == rightAnswer) {
      nbCorrect++;
      AudioManager.getInstance().playEffect("powerup.mp3");
    }else{
      AudioManager.getInstance().playEffect("beep1.mp3");
    }
  }

  int getValidAnswerButton() {
    return 1;
  }

  void setNextQuestion() {
    if (currentIndex < questions.length) {
      var question = questions[currentIndex];
      questionText = question["question"];
      answers = question["options"];
      rightAnswer = question["answer"];
      currentIndex++;
      setState(() {});
    } else {
      send(new QuizzEndRequest(nbCorrect));
      onEnd();
    }
  }

  Color getButtonColor(String button) {
    if (answered) {
      if (button == rightAnswer) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }
    return Colors.blue;
  }

  onEnd() {
    if (GameManager.instance!.gameMode == GameMode.Solo) {
      onSoloWin();
    } else {
      if (GameManager.instance!.wifiP2PInfo!.isGroupOwner == true) {
        if (otherHasFinished) {
          if (nbCorrect > otherNbCorrect) {
            AudioManager.getInstance().playMusic("win.mp3");
            onWin();
          } else if (nbCorrect < otherNbCorrect) {
            AudioManager.getInstance().playMusic("loose.mp3");
            onLoose();
          } else {
            AudioManager.getInstance().playMusic("win.mp3");
            onTie();
          }
        }
      }
    }
  }

  onSoloWin() {
    winner = GameManager.instance!.getMyID();
    this.stop();
    GameManager.instance!.fileManager.addScoreToHost(nbCorrect);
    AudioManager.getInstance().playMusic("win.mp3");
    goToWaitMenu(true, "you guessed " + nbCorrect.toString() + " questions ! ");

  }

  onWin() {
    winner = GameManager.instance!.getMyID();
    this.stop();
    GameManager.instance!.fileManager.addScoreToHost(nbCorrect);
    AudioManager.getInstance().playMusic("win.mp3");
    dispatchOnEnd(false);
  }

  onTie() {
    this.stop();
    dispatchOnEnd(false);
  }

  onLoose() {
    winner = GameManager.instance!.getMyID();
    this.stop();
    dispatchOnEnd(true);
  }
}

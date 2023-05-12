import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:wifi_direct_json/Utils/Requests/QuestionRequest.dart';
import 'package:flutter/material.dart';
import '../../Utils/GameManager.dart';
import '../../Utils/Requests/JsonRequest.dart';
import '../../Utils/Requests/WinRequest.dart';
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
  List<String> answers = [];
  int nbCorrect = 0;
  int currentIndex = 0;
  List<dynamic> questions = [];
  bool answered  = false; 
  var rightAnswer = "";


  @override
  void initState()  {
    super.initState();
    loadQuestions();
  }
  loadQuestions() async {
    // Get a file reference
    String jsonString = await rootBundle.loadString('assets/gameData/Quizz/questions.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    print(jsonString);
    questions = jsonData["quiz"]["questions"];
  try {
    // Open the file
  } catch (e) {
    print('Error reading file: $e');
  }
  }

  @override
  void onRecieve(JsonRequest req) {
    super.onRecieve(req);
    if (req.type == "questions"){
      QuestionRequest qreq = req.getQuestionRequest();
      questions = qreq.questions["questions"];
    }

    if (req.type == "win") {
      wined = true;
      winner = req.peer;
      dispatchOnEnd(false);
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
                        onButtonPushed(1);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: getButtonColor(1),
                    ),
                    child: Text(
                      answers[0],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        onButtonPushed(3);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: getButtonColor(3),
                    ),
                    child: Text(
                      answers[1],
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  
                  onPressed: () {
                    setState(() {
                      onButtonPushed(2);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: getButtonColor(2),
                  ),
                  child: Text(
                    answers[2],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      onButtonPushed(4);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: getButtonColor(4),
                  ),
                  child: Text(
                    answers[3],
                  ),
                ),
              ]),
                if (answered ) ElevatedButton(
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


  void onButtonPushed(int button) {
    answered = true;
    if (button == getValidAnswerButton()){
      nbCorrect++;
    }
  }

  int getValidAnswerButton(){
    return 1;
  }

  void setNextQuestion(){

    if (currentIndex == questions.length){
      currentIndex++;
      print(questions.length);
      print(questions[0]);
      var question = questions[0];
      print(question);
      questionText = question["question"];
      answers = question["options"];
      rightAnswer = question["answer"];
    }

  }


  Color getButtonColor(int button) {
      return Colors.blue;
  }

  onSoloLoose() {
  
    this.stop();
    winner = "IA";
    goToWaitMenu(false, "stop");
  }

  onSoloWin() {

    winner = GameManager.instance!.getMyID();
    this.stop();
    goToWaitMenu(true,"stop");
  }

  onWin() {
    
    this.stop();
    dispatchOnEnd(false);
    send(new WinRequest(true));
  }

  onLoose() {
    this.stop();
    dispatchOnEnd(true);
    send(new WinRequest(false));
  }
}

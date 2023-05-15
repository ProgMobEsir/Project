import 'package:flutter/material.dart';

import '../navigation/NavigationService.dart';
import 'GameManager.dart';
import 'Requests/JsonRequest.dart';

class Style{


  static dynamic getBtnStyleROUNDED(Color c){
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(c),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0), // Set the desired border radius
        ),
      ),
    );;
  }

}


class GameCard extends StatelessWidget {
  const GameCard({Key? key, required this.gameName,required this.Title,required this.subTitle,required this.BgColor1,required this.BgColor2}) : super(key: key);
  final String gameName;
  final String Title;
  final String subTitle;
  final Color BgColor1;
  final Color BgColor2;
  @override
  Widget build(BuildContext context) {
    return
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Set the desired border radius
        ),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [BgColor1, BgColor2], // Set the desired gradient colors
                begin: Alignment.topLeft, // Set the desired gradient begin point
                end: Alignment.bottomRight, // Set the desired gradient end point
              ),
            ),


            child: InkWell(

              onTap: () {
                GameManager.instance!
                    .sendJsonRequest(new JsonRequest("", "GAME", gameName));

                NavigationService.instance
                    .navigateToReplacement("GAME_" + gameName);
              },
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Text(this.Title,
                        textAlign: TextAlign.center
                        ,style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,

                        )),
                    subtitle: Text(this.subTitle,
                        textAlign: TextAlign.center
                        ,style: TextStyle(
                          color: Colors.black,

                          fontSize: 18,
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      ElevatedButton(

                        child: const Text('Train'),
                        onPressed: () {/* ... */},
                        style : Style.getBtnStyleROUNDED(Colors.white.withOpacity(0.1)),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
          ),),
      );
  }
}


class DetailedCard extends StatelessWidget {
  const DetailedCard({Key? key, required this.MenuName,required this.Title,required this.subTitle,required this.BgColor1,required this.BgColor2}) : super(key: key);
  final String MenuName;
  final String Title;
  final String subTitle;
  final Color BgColor1;
  final Color BgColor2;
  @override
  Widget build(BuildContext context) {
    return
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Set the desired border radius
        ),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [BgColor1, BgColor2], // Set the desired gradient colors
                begin: Alignment.topLeft, // Set the desired gradient begin point
                end: Alignment.bottomRight, // Set the desired gradient end point
              ),
            ),

            child: InkWell(
              onTap: () {
                NavigationService.instance
                    .navigateToReplacement(MenuName);
              },
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                    child:Text(this.Title,
                        textAlign: TextAlign.center
                        ,style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,

                        )),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Text(this.subTitle,
                        textAlign: TextAlign.center
                        ,style: TextStyle(
                          color: Colors.black,

                          fontSize: 18,
                        )),
                  ),),
                ],
              ),
            ),
          ),
        ),
      );
  }
}
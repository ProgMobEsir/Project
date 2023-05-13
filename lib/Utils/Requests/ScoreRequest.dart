import 'dart:convert';

import 'JsonRequest.dart';

class ScoreRequest extends JsonRequest {
  Map<dynamic, dynamic> scores = {};
  ScoreRequest(Map<dynamic, dynamic> this.scores)
      : super('{"scores":${JsonEncoder().convert(scores)}}', "scores", "");

  ScoreRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    Map<dynamic, dynamic> s = jsonDecoded['scores'];
    print(s);
    scores = s;
  }
}

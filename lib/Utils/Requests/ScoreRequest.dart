import 'dart:convert';

import 'JsonRequest.dart';

class ScoreRequest extends JsonRequest {
  Map scores = {};
  ScoreRequest(this.scores) : super('{"scores":"$scores"}', "scores", "");

  ScoreRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    print("SCORES " + jsonDecoded);
    scores = jsonDecoded['scores'];
  }
}

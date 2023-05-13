import 'dart:convert';

import 'JsonRequest.dart';

class QuizzEndRequest extends JsonRequest {
  int score = 0;
  QuizzEndRequest(this.score) : super('{"score":"$score"}', "quizzend", "");

  QuizzEndRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    score = int.parse(jsonDecoded['score']);
  }
}

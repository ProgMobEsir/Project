import 'dart:convert';

import 'JsonRequest.dart';

class QuestionRequest extends JsonRequest {
  var questions = {};

  QuestionRequest(this.questions) : super('{"questions":"$questions"}', "questions", "");

  QuestionRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    questions = jsonDecoded['questions'];
  }
}

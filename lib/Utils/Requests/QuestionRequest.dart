import 'dart:convert';

import 'JsonRequest.dart';

class QuestionRequest extends JsonRequest {
  List<dynamic> questions = [];

  QuestionRequest(this.questions) : super("{}", "questions", "") {
    this.body = '{"questions":${JsonEncoder().convert(questions)}}';
  }

  QuestionRequest.FromString(String s) : super.FromString(s) {
    var jsonDecoded = JsonDecoder().convert(body);
    List<dynamic> q = jsonDecoded['questions'];
    print(q);
    questions = q;
  }
}

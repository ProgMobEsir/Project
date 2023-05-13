import 'dart:convert';

import 'JsonRequest.dart';

class DeafRequest extends JsonRequest {
  DeafRequest() : super('{}', "deaf", "");

  DeafRequest.FromString(String s) : super.FromString(s) {}
}

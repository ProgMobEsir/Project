import 'Requests/JsonRequest.dart';

class Reciever {
  bool subscribed = true;
  void onRecieve(JsonRequest req) {}
  String getName() {
    return "Reciever";
  }
}

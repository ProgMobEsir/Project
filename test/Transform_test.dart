// Import the test package and Counter class

import 'package:test/test.dart';
import 'package:wifi_direct_json/GameEngine/Vector2D.dart';
import 'package:wifi_direct_json/GameEngine/transform.dart';

void main() {
  test('zero transform is not 0', () {
    Transform t = new Transform.zero();
    expect(t.toString(), Transform(Vector2D(0,0), Vector2D(0,0),0).toString());
  });

  test('zero transform doesnt have the right values', () {
    Transform t = new Transform(Vector2D(58,0), Vector2D(25,10),5);
    expect(t.position.toString(), Vector2D(58, 0).toString());
  });

}

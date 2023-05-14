// Import the test package and Counter class

import 'package:test/test.dart';
import 'package:wifi_direct_json/GameEngine/Vector2D.dart';

void main() {
  test('Normalized null vector throw NaN error', () {
    final v = Vector2D(0, 0);

    var out = v.normalized;

    expect(out.toString(), Vector2D(0, 0).toString());
  });
  test('not getting the right values for simple instantiation', () {
    final v = Vector2D(100, 100);


    expect(v.toString(), Vector2D(100, 100).toString());
  });
  test('not the right value when multiplied by scalar', () {
    final v = Vector2D(5, 15);

    Vector2D out = v * 5;

    expect(out.toString(), Vector2D(25, 75).toString());
  });
  test('the up vector doesnt go up', () {
    final v = Vector2D.up();

    Vector2D out = v * 5;

    expect(out.toString(), Vector2D(0, -5).toString());
  });
}


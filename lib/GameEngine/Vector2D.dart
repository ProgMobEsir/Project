import 'dart:math' as math;

import 'package:flutter/material.dart';

class Vector2D {
  double x;
  double y;

  Vector2D(this.x, this.y);

  Vector2D operator +(Vector2D other) {
    return Vector2D(x + other.x, y + other.y);
  }

  Vector2D operator -(Vector2D other) {
    return Vector2D(x - other.x, y - other.y);
  }

  Vector2D operator *(double other) {
    return Vector2D(x * other, y * other);
  }

  Vector2D operator /(double other) {
    return Vector2D(x / other, y / other);
  }

  Vector2D operator -() {
    return Vector2D(-x, -y);
  }

  double get length => math.sqrt(x * x + y * y);

  double get lengthSquared => x * x + y * y;

  Vector2D get normalized {
    double len = length;
    if (len == 0.0) {
      return Vector2D(0.0, 0.0);
    }
    return Vector2D(x / len, y / len);
  }

  double dot(Vector2D other) {
    return x * other.x + y * other.y;
  }

  double cross(Vector2D other) {
    return x * other.y - y * other.x;
  }

  Vector2D rotate(double angle) {
    double cosA = math.cos(angle);
    double sinA = math.sin(angle);
    return Vector2D(x * cosA - y * sinA, x * sinA + y * cosA);
  }

  Vector2D lerp(Vector2D other, double t) {
    return Vector2D(x + (other.x - x) * t, y + (other.y - y) * t);
  }

  Vector2D copy() {
    return Vector2D(x, y);
  }

  @override
  String toString() {
    return 'Vector2D{x: $x, y: $y}';
  }

  Offset toOffset() {
    return Offset(x, y);
  }
}

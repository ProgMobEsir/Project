import 'dart:math' as math;

import 'package:flutter/material.dart';

class Vector2D {
  double x;
  double y;


  Vector2D(this.x, this.y);


  Vector2D.zero() : this(0.0, 0.0);

  Vector2D.fromVector2D(Vector2D other) : this(other.x, other.y);

  Vector2D.fromOffset(Offset offset) : this(offset.dx, offset.dy);

  Vector2D.fromSize(Size size) : this(size.width, size.height);

  Vector2D.fromDirection(double direction, double length) : this(math.cos(direction) * length, math.sin(direction) * length);

  Vector2D.fromPolar(double radians, double length) : this(math.cos(radians) * length, math.sin(radians) * length);

  Vector2D.fromAngle(double angle) : this(math.cos(angle), math.sin(angle));

  Vector2D.fromAngleDegrees(double angle) : this.fromAngle(angle * math.pi / 180.0);

  Vector2D.down() : this(0.0, 1.0);

  Vector2D.right() : this(1.0, 0.0);

  Vector2D.up() : this(0.0, -1.0);

  Vector2D.left() : this(-1.0, 0.0);


  Vector2D.random() : this((math.Random().nextDouble()*2) -1, (math.Random().nextDouble()*2) -1);

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

import 'package:wifi_direct_json/GameEngine/GameObject.dart';
import 'package:wifi_direct_json/GameEngine/shapes/Circle.dart';

class Bubble extends GameObject{
  double radius = 0;
  Bubble(double x, double y, double this.radius) : super(){

    this.transform.position.x = x;
    this.transform.position.y = y;
    renderer = new Circle(this, this.radius);

  }

  @override
  void update() {
  
  }
}
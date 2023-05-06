import '../GameObject.dart';
import 'RectCollider.dart';

class Collider{
  GameObject? parent;

  Collider(this.parent);
  
  bool isColliding(Collider other){
    return false;
  }

  bool isCollidingRectCollider(RectCollider other){
    return false;
  }

}
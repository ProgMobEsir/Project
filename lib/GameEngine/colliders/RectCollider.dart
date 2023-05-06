import '../GameObject.dart';
import 'collider.dart';
class RectCollider extends Collider{

  
RectCollider(parent) : super(parent);

@override
bool isCollidingRectCollider(RectCollider other) {

  if(parent!.transform.position.x + parent!.transform.scale.x > other.parent!.transform.position.x &&
  parent!.transform.position.x < other.parent!.transform.position.x + other.parent!.transform.scale.x &&
  parent!.transform.position.y + parent!.transform.scale.y > other.parent!.transform.position.y &&
  parent!.transform.position.y < other.parent!.transform.position.y + other.parent!.transform.scale.y){
    return true;
  }
  return false;
}

}
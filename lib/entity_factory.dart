import 'package:flutter_dynamic_web/page/da_entity.dart';
import 'package:flutter_dynamic_web/entity/add_new_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "OkEntity") {
      return OkEntity.fromJson(json) as T;
    } else if (T.toString() == "AddNewEntity") {
      return AddNewEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}
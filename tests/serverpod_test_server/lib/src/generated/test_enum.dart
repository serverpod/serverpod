/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

enum TestEnum with _i1.SerializableEntity {
  one,
  two,
  three;

  @override
  String get className => 'TestEnum';
  static TestEnum? fromJson(int index) {
    switch (index) {
      case 0:
        return one;
      case 1:
        return two;
      case 2:
        return three;
      default:
        return null;
    }
  }

  @override
  int toJson() => index;
}

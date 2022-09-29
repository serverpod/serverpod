/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_serialization/serverpod_serialization.dart';

enum TestEnum with SerializableEntity {
  one,
  two,
  three,
  ;

  static String get _className => 'TestEnum';

  @override
  String get className => _className;

  factory TestEnum.fromSerialization(Map<String, dynamic> serialization) {
    var data = SerializableEntity.unwrapSerializationDataForClassName(
        _className, serialization);
    switch (data['index']) {
      case 0:
        return TestEnum.one;
      case 1:
        return TestEnum.two;
      case 2:
        return TestEnum.three;
      default:
        throw Exception('Invalid $_className index $data[\'index\']');
    }
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'index': index,
    });
  }
}

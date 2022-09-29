/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ObjectWithEnum extends SerializableEntity {
  @override
  String get className => 'ObjectWithEnum';

  int? id;
  late TestEnum testEnum;
  TestEnum? nullableEnum;
  late List<TestEnum> enumList;
  late List<TestEnum?> nullableEnumList;

  ObjectWithEnum({
    this.id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
  });

  ObjectWithEnum.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    testEnum = TestEnum.fromSerialization(_data['testEnum']);
    nullableEnum = _data['nullableEnum'] != null
        ? TestEnum?.fromSerialization(_data['nullableEnum'])
        : null;
    enumList = _data['enumList']!
        .map<TestEnum>((a) => TestEnum.fromSerialization(a))
        ?.toList();
    nullableEnumList = _data['nullableEnumList']!
        .map<TestEnum?>(
            (a) => a != null ? TestEnum?.fromSerialization(a) : null)
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'testEnum': testEnum.serialize(),
      'nullableEnum': nullableEnum?.serialize(),
      'enumList': enumList.map((TestEnum a) => a.serialize()).toList(),
      'nullableEnumList':
          nullableEnumList.map((TestEnum? a) => a?.serialize()).toList(),
    });
  }
}

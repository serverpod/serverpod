/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class Types extends SerializableEntity {
  @override
  String get className => 'Types';

  int? id;
  int? anInt;
  bool? aBool;
  double? aDouble;
  DateTime? aDateTime;
  String? aString;

  Types({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
});

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt'];
    aBool = _data['aBool'];
    aDouble = _data['aDouble'];
    aDateTime = _data['aDateTime'] != null ? DateTime.tryParse(_data['aDateTime']) : null;
    aString = _data['aString'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
    });
  }
}


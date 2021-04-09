/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class Types extends SerializableEntity {
  String get className => 'Types';

  int? id;
  late int anInt;
  late bool aBool;
  late double aDouble;
  late DateTime aDateTime;
  late String aString;

  Types({
    this.id,
    required this.anInt,
    required this.aBool,
    required this.aDouble,
    required this.aDateTime,
    required this.aString,
});

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt']!;
    aBool = _data['aBool']!;
    aDouble = _data['aDouble']!;
    aDateTime = DateTime.tryParse(_data['aDateTime'])!;
    aString = _data['aString']!;
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime.toUtc().toIso8601String(),
      'aString': aString,
    });
  }
}


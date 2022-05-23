/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class Types extends SerializableEntity {
  @override
  String get className => 'Types';

  int? id;
  int? anInt;
  bool? aBool;
  double? aDouble;
  double? aDoubleWithDefaultValue;
  DateTime? aDateTime;
  String? aString;
  String? aStringWithDefaultValue;
  ByteData? aByteData;

  Types({
    this.id,
    this.anInt = 0,
    this.aBool,
    this.aDouble,
    this.aDoubleWithDefaultValue = 100,
    this.aDateTime,
    this.aString,
    this.aStringWithDefaultValue = 'Default Value',
    this.aByteData,
  });

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id']?.toInt();
    anInt = _data['anInt']?.toInt();
    aBool = _data['aBool'];
    aDouble = _data['aDouble']?.toDouble();
    aDoubleWithDefaultValue = _data['aDoubleWithDefaultValue']?.toDouble();
    aDateTime = _data['aDateTime'] != null
        ? DateTime.tryParse(_data['aDateTime'])
        : null;
    aString = _data['aString'];
    aStringWithDefaultValue = _data['aStringWithDefaultValue'];
    aByteData = _data['aByteData'] == null
        ? null
        : (_data['aByteData'] is String
            ? (_data['aByteData'] as String).base64DecodedByteData()
            : ByteData.view((_data['aByteData'] as Uint8List).buffer));
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDoubleWithDefaultValue': aDoubleWithDefaultValue,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
      'aStringWithDefaultValue': aStringWithDefaultValue,
      'aByteData': aByteData?.base64encodedString(),
    });
  }
}

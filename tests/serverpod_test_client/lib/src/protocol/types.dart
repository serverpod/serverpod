/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
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
  DateTime? aDateTime;
  String? aString;
  ByteData? aByteData;

  Types({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
});

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt'];
    aBool = _data['aBool'];
    aDouble = _data['aDouble'];
    aDateTime = _data['aDateTime'] != null ? DateTime.tryParse(_data['aDateTime']) : null;
    aString = _data['aString'];
    aByteData = _data['aByteData'] == null ? null : (_data['aByteData'] is String ? (_data['aByteData'] as String).base64DecodedByteData() : ByteData.view((_data['aByteData'] as Uint8List).buffer));
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
      'aByteData': aByteData?.base64encodedString(),
    });
  }
}


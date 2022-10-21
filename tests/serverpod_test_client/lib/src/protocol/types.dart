/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

class Types extends _i1.SerializableEntity {
  Types({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
  });

  factory Types.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Types(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      anInt: serializationManager
          .deserializeJson<int?>(jsonSerialization['anInt']),
      aBool: serializationManager
          .deserializeJson<bool?>(jsonSerialization['aBool']),
      aDouble: serializationManager
          .deserializeJson<double?>(jsonSerialization['aDouble']),
      aDateTime: serializationManager
          .deserializeJson<DateTime?>(jsonSerialization['aDateTime']),
      aString: serializationManager
          .deserializeJson<String?>(jsonSerialization['aString']),
      aByteData: serializationManager
          .deserializeJson<_i2.ByteData?>(jsonSerialization['aByteData']),
    );
  }

  int? id;

  int? anInt;

  bool? aBool;

  double? aDouble;

  DateTime? aDateTime;

  String? aString;

  _i2.ByteData? aByteData;

  @override
  String get className => 'Types';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime,
      'aString': aString,
      'aByteData': aByteData,
    };
  }
}

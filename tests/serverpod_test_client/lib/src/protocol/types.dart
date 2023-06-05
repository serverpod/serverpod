/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;

class _Undefined {}

class Types extends _i1.SerializableEntity {
  Types({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
  });

  factory Types.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Types(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      anInt: serializationManager.deserialize<int?>(jsonSerialization['anInt']),
      aBool:
          serializationManager.deserialize<bool?>(jsonSerialization['aBool']),
      aDouble: serializationManager
          .deserialize<double?>(jsonSerialization['aDouble']),
      aDateTime: serializationManager
          .deserialize<DateTime?>(jsonSerialization['aDateTime']),
      aString: serializationManager
          .deserialize<String?>(jsonSerialization['aString']),
      aByteData: serializationManager
          .deserialize<_i2.ByteData?>(jsonSerialization['aByteData']),
      aDuration: serializationManager
          .deserialize<Duration?>(jsonSerialization['aDuration']),
      aUuid: serializationManager
          .deserialize<_i1.UuidValue?>(jsonSerialization['aUuid']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  final int? anInt;

  final bool? aBool;

  final double? aDouble;

  final DateTime? aDateTime;

  final String? aString;

  final _i2.ByteData? aByteData;

  final Duration? aDuration;

  final _i1.UuidValue? aUuid;

  late Function({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
  }) copyWith = _copyWith;

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
      'aDuration': aDuration,
      'aUuid': aUuid,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is Types &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.anInt,
                  anInt,
                ) ||
                other.anInt == anInt) &&
            (identical(
                  other.aBool,
                  aBool,
                ) ||
                other.aBool == aBool) &&
            (identical(
                  other.aDouble,
                  aDouble,
                ) ||
                other.aDouble == aDouble) &&
            (identical(
                  other.aDateTime,
                  aDateTime,
                ) ||
                other.aDateTime == aDateTime) &&
            (identical(
                  other.aString,
                  aString,
                ) ||
                other.aString == aString) &&
            (identical(
                  other.aByteData,
                  aByteData,
                ) ||
                other.aByteData == aByteData) &&
            (identical(
                  other.aDuration,
                  aDuration,
                ) ||
                other.aDuration == aDuration) &&
            (identical(
                  other.aUuid,
                  aUuid,
                ) ||
                other.aUuid == aUuid));
  }

  @override
  int get hashCode => Object.hash(
        id,
        anInt,
        aBool,
        aDouble,
        aDateTime,
        aString,
        aByteData,
        aDuration,
        aUuid,
      );

  Types _copyWith({
    Object? id = _Undefined,
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
    Object? aByteData = _Undefined,
    Object? aDuration = _Undefined,
    Object? aUuid = _Undefined,
  }) {
    return Types(
      id: id == _Undefined ? this.id : (id as int?),
      anInt: anInt == _Undefined ? this.anInt : (anInt as int?),
      aBool: aBool == _Undefined ? this.aBool : (aBool as bool?),
      aDouble: aDouble == _Undefined ? this.aDouble : (aDouble as double?),
      aDateTime:
          aDateTime == _Undefined ? this.aDateTime : (aDateTime as DateTime?),
      aString: aString == _Undefined ? this.aString : (aString as String?),
      aByteData: aByteData == _Undefined
          ? this.aByteData
          : (aByteData as _i2.ByteData?),
      aDuration:
          aDuration == _Undefined ? this.aDuration : (aDuration as Duration?),
      aUuid: aUuid == _Undefined ? this.aUuid : (aUuid as _i1.UuidValue?),
    );
  }
}

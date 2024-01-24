/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;

abstract class Types extends _i1.SerializableEntity {
  Types._({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
    this.anEnum,
    this.aStringifiedEnum,
  });

  factory Types({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
    _i3.TestEnumStringified? aStringifiedEnum,
  }) = _TypesImpl;

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
      anEnum: serializationManager
          .deserialize<_i3.TestEnum?>(jsonSerialization['anEnum']),
      aStringifiedEnum:
          serializationManager.deserialize<_i3.TestEnumStringified?>(
              jsonSerialization['aStringifiedEnum']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? anInt;

  bool? aBool;

  double? aDouble;

  DateTime? aDateTime;

  String? aString;

  _i2.ByteData? aByteData;

  Duration? aDuration;

  _i1.UuidValue? aUuid;

  _i3.TestEnum? anEnum;

  _i3.TestEnumStringified? aStringifiedEnum;

  Types copyWith({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
    _i3.TestEnumStringified? aStringifiedEnum,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (anInt != null) 'anInt': anInt,
      if (aBool != null) 'aBool': aBool,
      if (aDouble != null) 'aDouble': aDouble,
      if (aDateTime != null) 'aDateTime': aDateTime?.toJson(),
      if (aString != null) 'aString': aString,
      if (aByteData != null) 'aByteData': aByteData?.toJson(),
      if (aDuration != null) 'aDuration': aDuration?.toJson(),
      if (aUuid != null) 'aUuid': aUuid?.toJson(),
      if (anEnum != null) 'anEnum': anEnum?.toJson(),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(),
    };
  }
}

class _Undefined {}

class _TypesImpl extends Types {
  _TypesImpl({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _i2.ByteData? aByteData,
    Duration? aDuration,
    _i1.UuidValue? aUuid,
    _i3.TestEnum? anEnum,
    _i3.TestEnumStringified? aStringifiedEnum,
  }) : super._(
          id: id,
          anInt: anInt,
          aBool: aBool,
          aDouble: aDouble,
          aDateTime: aDateTime,
          aString: aString,
          aByteData: aByteData,
          aDuration: aDuration,
          aUuid: aUuid,
          anEnum: anEnum,
          aStringifiedEnum: aStringifiedEnum,
        );

  @override
  Types copyWith({
    Object? id = _Undefined,
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
    Object? aByteData = _Undefined,
    Object? aDuration = _Undefined,
    Object? aUuid = _Undefined,
    Object? anEnum = _Undefined,
    Object? aStringifiedEnum = _Undefined,
  }) {
    return Types(
      id: id is int? ? id : this.id,
      anInt: anInt is int? ? anInt : this.anInt,
      aBool: aBool is bool? ? aBool : this.aBool,
      aDouble: aDouble is double? ? aDouble : this.aDouble,
      aDateTime: aDateTime is DateTime? ? aDateTime : this.aDateTime,
      aString: aString is String? ? aString : this.aString,
      aByteData:
          aByteData is _i2.ByteData? ? aByteData : this.aByteData?.clone(),
      aDuration: aDuration is Duration? ? aDuration : this.aDuration,
      aUuid: aUuid is _i1.UuidValue? ? aUuid : this.aUuid,
      anEnum: anEnum is _i3.TestEnum? ? anEnum : this.anEnum,
      aStringifiedEnum: aStringifiedEnum is _i3.TestEnumStringified?
          ? aStringifiedEnum
          : this.aStringifiedEnum,
    );
  }
}

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

abstract class TypesList extends _i1.SerializableEntity {
  TypesList._({
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
    this.anObject,
    this.aMap,
    this.aList,
  });

  factory TypesList({
    List<int>? anInt,
    List<bool>? aBool,
    List<double>? aDouble,
    List<DateTime>? aDateTime,
    List<String>? aString,
    List<_i2.ByteData>? aByteData,
    List<Duration>? aDuration,
    List<_i1.UuidValue>? aUuid,
    List<_i3.TestEnum>? anEnum,
    List<_i3.TestEnumStringified>? aStringifiedEnum,
    List<_i3.Types>? anObject,
    List<Map<String, _i3.Types>>? aMap,
    List<List<_i3.Types>>? aList,
  }) = _TypesListImpl;

  factory TypesList.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return TypesList(
      anInt: serializationManager
          .deserialize<List<int>?>(jsonSerialization['anInt']),
      aBool: serializationManager
          .deserialize<List<bool>?>(jsonSerialization['aBool']),
      aDouble: serializationManager
          .deserialize<List<double>?>(jsonSerialization['aDouble']),
      aDateTime: serializationManager
          .deserialize<List<DateTime>?>(jsonSerialization['aDateTime']),
      aString: serializationManager
          .deserialize<List<String>?>(jsonSerialization['aString']),
      aByteData: serializationManager
          .deserialize<List<_i2.ByteData>?>(jsonSerialization['aByteData']),
      aDuration: serializationManager
          .deserialize<List<Duration>?>(jsonSerialization['aDuration']),
      aUuid: serializationManager
          .deserialize<List<_i1.UuidValue>?>(jsonSerialization['aUuid']),
      anEnum: serializationManager
          .deserialize<List<_i3.TestEnum>?>(jsonSerialization['anEnum']),
      aStringifiedEnum:
          serializationManager.deserialize<List<_i3.TestEnumStringified>?>(
              jsonSerialization['aStringifiedEnum']),
      anObject: serializationManager
          .deserialize<List<_i3.Types>?>(jsonSerialization['anObject']),
      aMap: serializationManager.deserialize<List<Map<String, _i3.Types>>?>(
          jsonSerialization['aMap']),
      aList: serializationManager
          .deserialize<List<List<_i3.Types>>?>(jsonSerialization['aList']),
    );
  }

  List<int>? anInt;

  List<bool>? aBool;

  List<double>? aDouble;

  List<DateTime>? aDateTime;

  List<String>? aString;

  List<_i2.ByteData>? aByteData;

  List<Duration>? aDuration;

  List<_i1.UuidValue>? aUuid;

  List<_i3.TestEnum>? anEnum;

  List<_i3.TestEnumStringified>? aStringifiedEnum;

  List<_i3.Types>? anObject;

  List<Map<String, _i3.Types>>? aMap;

  List<List<_i3.Types>>? aList;

  TypesList copyWith({
    List<int>? anInt,
    List<bool>? aBool,
    List<double>? aDouble,
    List<DateTime>? aDateTime,
    List<String>? aString,
    List<_i2.ByteData>? aByteData,
    List<Duration>? aDuration,
    List<_i1.UuidValue>? aUuid,
    List<_i3.TestEnum>? anEnum,
    List<_i3.TestEnumStringified>? aStringifiedEnum,
    List<_i3.Types>? anObject,
    List<Map<String, _i3.Types>>? aMap,
    List<List<_i3.Types>>? aList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (anInt != null) 'anInt': anInt?.toJson(),
      if (aBool != null) 'aBool': aBool?.toJson(),
      if (aDouble != null) 'aDouble': aDouble?.toJson(),
      if (aDateTime != null)
        'aDateTime': aDateTime?.toJson(valueToJson: (v) => v.toJson()),
      if (aString != null) 'aString': aString?.toJson(),
      if (aByteData != null)
        'aByteData': aByteData?.toJson(valueToJson: (v) => v.toJson()),
      if (aDuration != null)
        'aDuration': aDuration?.toJson(valueToJson: (v) => v.toJson()),
      if (aUuid != null) 'aUuid': aUuid?.toJson(valueToJson: (v) => v.toJson()),
      if (anEnum != null)
        'anEnum': anEnum?.toJson(valueToJson: (v) => v.toJson()),
      if (aStringifiedEnum != null)
        'aStringifiedEnum':
            aStringifiedEnum?.toJson(valueToJson: (v) => v.toJson()),
      if (anObject != null)
        'anObject': anObject?.toJson(valueToJson: (v) => v.toJson()),
      if (aMap != null)
        'aMap': aMap?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
      if (aList != null)
        'aList': aList?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.toJson())),
    };
  }
}

class _Undefined {}

class _TypesListImpl extends TypesList {
  _TypesListImpl({
    List<int>? anInt,
    List<bool>? aBool,
    List<double>? aDouble,
    List<DateTime>? aDateTime,
    List<String>? aString,
    List<_i2.ByteData>? aByteData,
    List<Duration>? aDuration,
    List<_i1.UuidValue>? aUuid,
    List<_i3.TestEnum>? anEnum,
    List<_i3.TestEnumStringified>? aStringifiedEnum,
    List<_i3.Types>? anObject,
    List<Map<String, _i3.Types>>? aMap,
    List<List<_i3.Types>>? aList,
  }) : super._(
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
          anObject: anObject,
          aMap: aMap,
          aList: aList,
        );

  @override
  TypesList copyWith({
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
    Object? anObject = _Undefined,
    Object? aMap = _Undefined,
    Object? aList = _Undefined,
  }) {
    return TypesList(
      anInt: anInt is List<int>? ? anInt : this.anInt?.clone(),
      aBool: aBool is List<bool>? ? aBool : this.aBool?.clone(),
      aDouble: aDouble is List<double>? ? aDouble : this.aDouble?.clone(),
      aDateTime:
          aDateTime is List<DateTime>? ? aDateTime : this.aDateTime?.clone(),
      aString: aString is List<String>? ? aString : this.aString?.clone(),
      aByteData: aByteData is List<_i2.ByteData>?
          ? aByteData
          : this.aByteData?.clone(),
      aDuration:
          aDuration is List<Duration>? ? aDuration : this.aDuration?.clone(),
      aUuid: aUuid is List<_i1.UuidValue>? ? aUuid : this.aUuid?.clone(),
      anEnum: anEnum is List<_i3.TestEnum>? ? anEnum : this.anEnum?.clone(),
      aStringifiedEnum: aStringifiedEnum is List<_i3.TestEnumStringified>?
          ? aStringifiedEnum
          : this.aStringifiedEnum?.clone(),
      anObject:
          anObject is List<_i3.Types>? ? anObject : this.anObject?.clone(),
      aMap: aMap is List<Map<String, _i3.Types>>? ? aMap : this.aMap?.clone(),
      aList: aList is List<List<_i3.Types>>? ? aList : this.aList?.clone(),
    );
  }
}

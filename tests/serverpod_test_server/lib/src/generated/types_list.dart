/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'protocol.dart' as _i3;
import 'package:uuid/uuid_value.dart' as _i4;
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  factory TypesList.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesList(
      anInt: (jsonSerialization['anInt'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      aBool: (jsonSerialization['aBool'] as List<dynamic>?)
          ?.map((e) => e as bool)
          .toList(),
      aDouble: (jsonSerialization['aDouble'] as List<dynamic>?)
          ?.map((e) => e as double)
          .toList(),
      aDateTime: (jsonSerialization['aDateTime'] as List<dynamic>?)
          ?.map((e) => DateTime.parse((e as String)))
          .toList(),
      aString: (jsonSerialization['aString'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      aByteData: (jsonSerialization['aByteData'] as List<dynamic>?)
          ?.map((e) => (e != null && e is _i2.Uint8List
              ? _i2.ByteData.view(
                  e.buffer,
                  e.offsetInBytes,
                  e.lengthInBytes,
                )
              : (e as String?)?.base64DecodedByteData())!)
          .toList(),
      aDuration: (jsonSerialization['aDuration'] as List<dynamic>?)
          ?.map((e) => Duration(milliseconds: e))
          .toList(),
      aUuid: (jsonSerialization['aUuid'] as List<dynamic>?)
          ?.map((e) => _i4.UuidValue.fromString(e))
          .toList(),
      anEnum: (jsonSerialization['anEnum'] as List<dynamic>?)
          ?.map((e) => _i3.TestEnum.fromJson((e as int)))
          .toList(),
      aStringifiedEnum:
          (jsonSerialization['aStringifiedEnum'] as List<dynamic>?)
              ?.map((e) => _i3.TestEnumStringified.fromJson((e as String)))
              .toList(),
      anObject: (jsonSerialization['anObject'] as List<dynamic>?)
          ?.map((e) => _i3.Types.fromJson(e as Map<String, dynamic>))
          .toList(),
      aMap: (jsonSerialization['aMap'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>).fold<Map<String, _i3.Types>>(
              {},
              (t, e) => {
                    ...t,
                    e['k'] as String:
                        _i3.Types.fromJson(e['v'] as Map<String, dynamic>)
                  }))
          .toList(),
      aList: (jsonSerialization['aList'] as List<dynamic>?)
          ?.map((e) => (e as List<dynamic>)
              .map((e) => _i3.Types.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
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

  @override
  Map<String, dynamic> allToJson() {
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
        'anObject': anObject?.toJson(valueToJson: (v) => v.allToJson()),
      if (aMap != null)
        'aMap': aMap?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.allToJson())),
      if (aList != null)
        'aList': aList?.toJson(
            valueToJson: (v) => v.toJson(valueToJson: (v) => v.allToJson())),
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

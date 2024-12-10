/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'test_enum.dart' as _i3;
import 'test_enum_stringified.dart' as _i4;
import 'types.dart' as _i5;

abstract class TypesList
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
    List<_i4.TestEnumStringified>? aStringifiedEnum,
    List<_i5.Types>? anObject,
    List<Map<String, _i5.Types>>? aMap,
    List<List<_i5.Types>>? aList,
  }) = _TypesListImpl;

  factory TypesList.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesList(
      anInt:
          (jsonSerialization['anInt'] as List?)?.map((e) => e as int).toList(),
      aBool:
          (jsonSerialization['aBool'] as List?)?.map((e) => e as bool).toList(),
      aDouble: (jsonSerialization['aDouble'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      aDateTime: (jsonSerialization['aDateTime'] as List?)
          ?.map((e) => _i1.DateTimeJsonExtension.fromJson(e))
          .toList(),
      aString: (jsonSerialization['aString'] as List?)
          ?.map((e) => e as String)
          .toList(),
      aByteData: (jsonSerialization['aByteData'] as List?)
          ?.map((e) => _i1.ByteDataJsonExtension.fromJson(e))
          .toList(),
      aDuration: (jsonSerialization['aDuration'] as List?)
          ?.map((e) => _i1.DurationJsonExtension.fromJson(e))
          .toList(),
      aUuid: (jsonSerialization['aUuid'] as List?)
          ?.map((e) => _i1.UuidValueJsonExtension.fromJson(e))
          .toList(),
      anEnum: (jsonSerialization['anEnum'] as List?)
          ?.map((e) => _i3.TestEnum.fromJson((e as int)))
          .toList(),
      aStringifiedEnum: (jsonSerialization['aStringifiedEnum'] as List?)
          ?.map((e) => _i4.TestEnumStringified.fromJson((e as String)))
          .toList(),
      anObject: (jsonSerialization['anObject'] as List?)
          ?.map((e) => _i5.Types.fromJson((e as Map<String, dynamic>)))
          .toList(),
      aMap: (jsonSerialization['aMap'] as List?)
          ?.map((e) => (e as Map).map((k, v) => MapEntry(
                k as String,
                _i5.Types.fromJson((v as Map<String, dynamic>)),
              )))
          .toList(),
      aList: (jsonSerialization['aList'] as List?)
          ?.map((e) => (e as List)
              .map((e) => _i5.Types.fromJson((e as Map<String, dynamic>)))
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

  List<_i4.TestEnumStringified>? aStringifiedEnum;

  List<_i5.Types>? anObject;

  List<Map<String, _i5.Types>>? aMap;

  List<List<_i5.Types>>? aList;

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
    List<_i4.TestEnumStringified>? aStringifiedEnum,
    List<_i5.Types>? anObject,
    List<Map<String, _i5.Types>>? aMap,
    List<List<_i5.Types>>? aList,
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
  Map<String, dynamic> toJsonForProtocol() {
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
        'anObject': anObject?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (aMap != null)
        'aMap': aMap?.toJson(
            valueToJson: (v) =>
                v.toJson(valueToJson: (v) => v.toJsonForProtocol())),
      if (aList != null)
        'aList': aList?.toJson(
            valueToJson: (v) =>
                v.toJson(valueToJson: (v) => v.toJsonForProtocol())),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    List<_i4.TestEnumStringified>? aStringifiedEnum,
    List<_i5.Types>? anObject,
    List<Map<String, _i5.Types>>? aMap,
    List<List<_i5.Types>>? aList,
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
      anInt: anInt is List<int>? ? anInt : this.anInt?.map((e0) => e0).toList(),
      aBool:
          aBool is List<bool>? ? aBool : this.aBool?.map((e0) => e0).toList(),
      aDouble: aDouble is List<double>?
          ? aDouble
          : this.aDouble?.map((e0) => e0).toList(),
      aDateTime: aDateTime is List<DateTime>?
          ? aDateTime
          : this.aDateTime?.map((e0) => e0).toList(),
      aString: aString is List<String>?
          ? aString
          : this.aString?.map((e0) => e0).toList(),
      aByteData: aByteData is List<_i2.ByteData>?
          ? aByteData
          : this.aByteData?.map((e0) => e0.clone()).toList(),
      aDuration: aDuration is List<Duration>?
          ? aDuration
          : this.aDuration?.map((e0) => e0).toList(),
      aUuid: aUuid is List<_i1.UuidValue>?
          ? aUuid
          : this.aUuid?.map((e0) => e0).toList(),
      anEnum: anEnum is List<_i3.TestEnum>?
          ? anEnum
          : this.anEnum?.map((e0) => e0).toList(),
      aStringifiedEnum: aStringifiedEnum is List<_i4.TestEnumStringified>?
          ? aStringifiedEnum
          : this.aStringifiedEnum?.map((e0) => e0).toList(),
      anObject: anObject is List<_i5.Types>?
          ? anObject
          : this.anObject?.map((e0) => e0.copyWith()).toList(),
      aMap: aMap is List<Map<String, _i5.Types>>?
          ? aMap
          : this
              .aMap
              ?.map((e0) => e0.map((
                    key1,
                    value1,
                  ) =>
                      MapEntry(
                        key1,
                        value1.copyWith(),
                      )))
              .toList(),
      aList: aList is List<List<_i5.Types>>?
          ? aList
          : this
              .aList
              ?.map((e0) => e0.map((e1) => e1.copyWith()).toList())
              .toList(),
    );
  }
}

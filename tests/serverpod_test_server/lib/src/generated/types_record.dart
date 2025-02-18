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
import 'simple_data.dart' as _i5;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i6;

abstract class TypesRecord
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  TypesRecord._({
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
    this.aDuration,
    this.aUuid,
    this.aUri,
    this.aBigInt,
    this.anEnum,
    this.aStringifiedEnum,
    this.aList,
    this.aMap,
    this.aSet,
    this.aSimpleData,
  });

  factory TypesRecord({
    (int,)? anInt,
    (bool,)? aBool,
    (double,)? aDouble,
    (DateTime,)? aDateTime,
    (String,)? aString,
    (_i2.ByteData,)? aByteData,
    (Duration,)? aDuration,
    (_i1.UuidValue,)? aUuid,
    (Uri,)? aUri,
    (BigInt,)? aBigInt,
    (_i3.TestEnum,)? anEnum,
    (_i4.TestEnumStringified,)? aStringifiedEnum,
    (List<int>,)? aList,
    (Map<int, int>,)? aMap,
    (Set<int>,)? aSet,
    (_i5.SimpleData,)? aSimpleData,
  }) = _TypesRecordImpl;

  factory TypesRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return TypesRecord(
      anInt: jsonSerialization['anInt'] == null
          ? null
          : _i6.Protocol().deserialize<(int,)?>(
              (jsonSerialization['anInt'] as Map<String, dynamic>)),
      aBool: jsonSerialization['aBool'] == null
          ? null
          : _i6.Protocol().deserialize<(bool,)?>(
              (jsonSerialization['aBool'] as Map<String, dynamic>)),
      aDouble: jsonSerialization['aDouble'] == null
          ? null
          : _i6.Protocol().deserialize<(double,)?>(
              (jsonSerialization['aDouble'] as Map<String, dynamic>)),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _i6.Protocol().deserialize<(DateTime,)?>(
              (jsonSerialization['aDateTime'] as Map<String, dynamic>)),
      aString: jsonSerialization['aString'] == null
          ? null
          : _i6.Protocol().deserialize<(String,)?>(
              (jsonSerialization['aString'] as Map<String, dynamic>)),
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _i6.Protocol().deserialize<(_i2.ByteData,)?>(
              (jsonSerialization['aByteData'] as Map<String, dynamic>)),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _i6.Protocol().deserialize<(Duration,)?>(
              (jsonSerialization['aDuration'] as Map<String, dynamic>)),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _i6.Protocol().deserialize<(_i1.UuidValue,)?>(
              (jsonSerialization['aUuid'] as Map<String, dynamic>)),
      aUri: jsonSerialization['aUri'] == null
          ? null
          : _i6.Protocol().deserialize<(Uri,)?>(
              (jsonSerialization['aUri'] as Map<String, dynamic>)),
      aBigInt: jsonSerialization['aBigInt'] == null
          ? null
          : _i6.Protocol().deserialize<(BigInt,)?>(
              (jsonSerialization['aBigInt'] as Map<String, dynamic>)),
      anEnum: jsonSerialization['anEnum'] == null
          ? null
          : _i6.Protocol().deserialize<(_i3.TestEnum,)?>(
              (jsonSerialization['anEnum'] as Map<String, dynamic>)),
      aStringifiedEnum: jsonSerialization['aStringifiedEnum'] == null
          ? null
          : _i6.Protocol().deserialize<(_i4.TestEnumStringified,)?>(
              (jsonSerialization['aStringifiedEnum'] as Map<String, dynamic>)),
      aList: jsonSerialization['aList'] == null
          ? null
          : _i6.Protocol().deserialize<(List<int>,)?>(
              (jsonSerialization['aList'] as Map<String, dynamic>)),
      aMap: jsonSerialization['aMap'] == null
          ? null
          : _i6.Protocol().deserialize<(Map<int, int>,)?>(
              (jsonSerialization['aMap'] as Map<String, dynamic>)),
      aSet: jsonSerialization['aSet'] == null
          ? null
          : _i6.Protocol().deserialize<(Set<int>,)?>(
              (jsonSerialization['aSet'] as Map<String, dynamic>)),
      aSimpleData: jsonSerialization['aSimpleData'] == null
          ? null
          : _i6.Protocol().deserialize<(_i5.SimpleData,)?>(
              (jsonSerialization['aSimpleData'] as Map<String, dynamic>)),
    );
  }

  (int,)? anInt;

  (bool,)? aBool;

  (double,)? aDouble;

  (DateTime,)? aDateTime;

  (String,)? aString;

  (_i2.ByteData,)? aByteData;

  (Duration,)? aDuration;

  (_i1.UuidValue,)? aUuid;

  (Uri,)? aUri;

  (BigInt,)? aBigInt;

  (_i3.TestEnum,)? anEnum;

  (_i4.TestEnumStringified,)? aStringifiedEnum;

  (List<int>,)? aList;

  (Map<int, int>,)? aMap;

  (Set<int>,)? aSet;

  (_i5.SimpleData,)? aSimpleData;

  /// Returns a shallow copy of this [TypesRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TypesRecord copyWith({
    (int,)? anInt,
    (bool,)? aBool,
    (double,)? aDouble,
    (DateTime,)? aDateTime,
    (String,)? aString,
    (_i2.ByteData,)? aByteData,
    (Duration,)? aDuration,
    (_i1.UuidValue,)? aUuid,
    (Uri,)? aUri,
    (BigInt,)? aBigInt,
    (_i3.TestEnum,)? anEnum,
    (_i4.TestEnumStringified,)? aStringifiedEnum,
    (List<int>,)? aList,
    (Map<int, int>,)? aMap,
    (Set<int>,)? aSet,
    (_i5.SimpleData,)? aSimpleData,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (anInt != null) 'anInt': _i6.mapRecordToJson(anInt),
      if (aBool != null) 'aBool': _i6.mapRecordToJson(aBool),
      if (aDouble != null) 'aDouble': _i6.mapRecordToJson(aDouble),
      if (aDateTime != null) 'aDateTime': _i6.mapRecordToJson(aDateTime),
      if (aString != null) 'aString': _i6.mapRecordToJson(aString),
      if (aByteData != null) 'aByteData': _i6.mapRecordToJson(aByteData),
      if (aDuration != null) 'aDuration': _i6.mapRecordToJson(aDuration),
      if (aUuid != null) 'aUuid': _i6.mapRecordToJson(aUuid),
      if (aUri != null) 'aUri': _i6.mapRecordToJson(aUri),
      if (aBigInt != null) 'aBigInt': _i6.mapRecordToJson(aBigInt),
      if (anEnum != null) 'anEnum': _i6.mapRecordToJson(anEnum),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': _i6.mapRecordToJson(aStringifiedEnum),
      if (aList != null) 'aList': _i6.mapRecordToJson(aList),
      if (aMap != null) 'aMap': _i6.mapRecordToJson(aMap),
      if (aSet != null) 'aSet': _i6.mapRecordToJson(aSet),
      if (aSimpleData != null) 'aSimpleData': _i6.mapRecordToJson(aSimpleData),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (anInt != null) 'anInt': _i6.mapRecordToJson(anInt),
      if (aBool != null) 'aBool': _i6.mapRecordToJson(aBool),
      if (aDouble != null) 'aDouble': _i6.mapRecordToJson(aDouble),
      if (aDateTime != null) 'aDateTime': _i6.mapRecordToJson(aDateTime),
      if (aString != null) 'aString': _i6.mapRecordToJson(aString),
      if (aByteData != null) 'aByteData': _i6.mapRecordToJson(aByteData),
      if (aDuration != null) 'aDuration': _i6.mapRecordToJson(aDuration),
      if (aUuid != null) 'aUuid': _i6.mapRecordToJson(aUuid),
      if (aUri != null) 'aUri': _i6.mapRecordToJson(aUri),
      if (aBigInt != null) 'aBigInt': _i6.mapRecordToJson(aBigInt),
      if (anEnum != null) 'anEnum': _i6.mapRecordToJson(anEnum),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': _i6.mapRecordToJson(aStringifiedEnum),
      if (aList != null) 'aList': _i6.mapRecordToJson(aList),
      if (aMap != null) 'aMap': _i6.mapRecordToJson(aMap),
      if (aSet != null) 'aSet': _i6.mapRecordToJson(aSet),
      if (aSimpleData != null) 'aSimpleData': _i6.mapRecordToJson(aSimpleData),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TypesRecordImpl extends TypesRecord {
  _TypesRecordImpl({
    (int,)? anInt,
    (bool,)? aBool,
    (double,)? aDouble,
    (DateTime,)? aDateTime,
    (String,)? aString,
    (_i2.ByteData,)? aByteData,
    (Duration,)? aDuration,
    (_i1.UuidValue,)? aUuid,
    (Uri,)? aUri,
    (BigInt,)? aBigInt,
    (_i3.TestEnum,)? anEnum,
    (_i4.TestEnumStringified,)? aStringifiedEnum,
    (List<int>,)? aList,
    (Map<int, int>,)? aMap,
    (Set<int>,)? aSet,
    (_i5.SimpleData,)? aSimpleData,
  }) : super._(
          anInt: anInt,
          aBool: aBool,
          aDouble: aDouble,
          aDateTime: aDateTime,
          aString: aString,
          aByteData: aByteData,
          aDuration: aDuration,
          aUuid: aUuid,
          aUri: aUri,
          aBigInt: aBigInt,
          anEnum: anEnum,
          aStringifiedEnum: aStringifiedEnum,
          aList: aList,
          aMap: aMap,
          aSet: aSet,
          aSimpleData: aSimpleData,
        );

  /// Returns a shallow copy of this [TypesRecord]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TypesRecord copyWith({
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
    Object? aByteData = _Undefined,
    Object? aDuration = _Undefined,
    Object? aUuid = _Undefined,
    Object? aUri = _Undefined,
    Object? aBigInt = _Undefined,
    Object? anEnum = _Undefined,
    Object? aStringifiedEnum = _Undefined,
    Object? aList = _Undefined,
    Object? aMap = _Undefined,
    Object? aSet = _Undefined,
    Object? aSimpleData = _Undefined,
  }) {
    return TypesRecord(
      anInt: anInt is (int,)? ? anInt : this.anInt,
      aBool: aBool is (bool,)? ? aBool : this.aBool,
      aDouble: aDouble is (double,)? ? aDouble : this.aDouble,
      aDateTime: aDateTime is (DateTime,)? ? aDateTime : this.aDateTime,
      aString: aString is (String,)? ? aString : this.aString,
      aByteData: aByteData is (_i2.ByteData,)? ? aByteData : this.aByteData,
      aDuration: aDuration is (Duration,)? ? aDuration : this.aDuration,
      aUuid: aUuid is (_i1.UuidValue,)? ? aUuid : this.aUuid,
      aUri: aUri is (Uri,)? ? aUri : this.aUri,
      aBigInt: aBigInt is (BigInt,)? ? aBigInt : this.aBigInt,
      anEnum: anEnum is (_i3.TestEnum,)? ? anEnum : this.anEnum,
      aStringifiedEnum: aStringifiedEnum is (_i4.TestEnumStringified,)?
          ? aStringifiedEnum
          : this.aStringifiedEnum,
      aList: aList is (List<int>,)? ? aList : this.aList,
      aMap: aMap is (Map<int, int>,)? ? aMap : this.aMap,
      aSet: aSet is (Set<int>,)? ? aSet : this.aSet,
      aSimpleData:
          aSimpleData is (_i5.SimpleData,)? ? aSimpleData : this.aSimpleData,
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:typed_data' as _i2;
import 'test_enum.dart' as _i3;
import 'test_enum_stringified.dart' as _i4;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i5;

abstract class Types implements _i1.SerializableModel {
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
    this.aUri,
    this.aBigInt,
    this.aVector,
    this.aHalfVector,
    this.aSparseVector,
    this.aBit,
    this.anEnum,
    this.aStringifiedEnum,
    this.aList,
    this.aMap,
    this.aSet,
    this.aRecord,
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
    Uri? aUri,
    BigInt? aBigInt,
    _i1.Vector? aVector,
    _i1.HalfVector? aHalfVector,
    _i1.SparseVector? aSparseVector,
    _i1.Bit? aBit,
    _i3.TestEnum? anEnum,
    _i4.TestEnumStringified? aStringifiedEnum,
    List<int>? aList,
    Map<int, int>? aMap,
    Set<int>? aSet,
    (String, {Uri? optionalUri})? aRecord,
  }) = _TypesImpl;

  factory Types.fromJson(Map<String, dynamic> jsonSerialization) {
    return Types(
      id: jsonSerialization['id'] as int?,
      anInt: jsonSerialization['anInt'] as int?,
      aBool: jsonSerialization['aBool'] as bool?,
      aDouble: (jsonSerialization['aDouble'] as num?)?.toDouble(),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['aDateTime']),
      aString: jsonSerialization['aString'] as String?,
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _i1.ByteDataJsonExtension.fromJson(jsonSerialization['aByteData']),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _i1.DurationJsonExtension.fromJson(jsonSerialization['aDuration']),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['aUuid']),
      aUri: jsonSerialization['aUri'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(jsonSerialization['aUri']),
      aBigInt: jsonSerialization['aBigInt'] == null
          ? null
          : _i1.BigIntJsonExtension.fromJson(jsonSerialization['aBigInt']),
      aVector: jsonSerialization['aVector'] == null
          ? null
          : _i1.VectorJsonExtension.fromJson(jsonSerialization['aVector']),
      aHalfVector: jsonSerialization['aHalfVector'] == null
          ? null
          : _i1.HalfVectorJsonExtension.fromJson(
              jsonSerialization['aHalfVector']),
      aSparseVector: jsonSerialization['aSparseVector'] == null
          ? null
          : _i1.SparseVectorJsonExtension.fromJson(
              jsonSerialization['aSparseVector']),
      aBit: jsonSerialization['aBit'] == null
          ? null
          : _i1.BitJsonExtension.fromJson(jsonSerialization['aBit']),
      anEnum: jsonSerialization['anEnum'] == null
          ? null
          : _i3.TestEnum.fromJson((jsonSerialization['anEnum'] as int)),
      aStringifiedEnum: jsonSerialization['aStringifiedEnum'] == null
          ? null
          : _i4.TestEnumStringified.fromJson(
              (jsonSerialization['aStringifiedEnum'] as String)),
      aList:
          (jsonSerialization['aList'] as List?)?.map((e) => e as int).toList(),
      aMap: (jsonSerialization['aMap'] as List?)?.fold<Map<int, int>>(
          {}, (t, e) => {...t, e['k'] as int: e['v'] as int}),
      aSet: jsonSerialization['aSet'] == null
          ? null
          : _i1.SetJsonExtension.fromJson((jsonSerialization['aSet'] as List),
              itemFromJson: (e) => e as int),
      aRecord: jsonSerialization['aRecord'] == null
          ? null
          : _i5.Protocol().deserialize<(String, {Uri? optionalUri})?>(
              (jsonSerialization['aRecord'] as Map<String, dynamic>)),
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

  Uri? aUri;

  BigInt? aBigInt;

  _i1.Vector? aVector;

  _i1.HalfVector? aHalfVector;

  _i1.SparseVector? aSparseVector;

  _i1.Bit? aBit;

  _i3.TestEnum? anEnum;

  _i4.TestEnumStringified? aStringifiedEnum;

  List<int>? aList;

  Map<int, int>? aMap;

  Set<int>? aSet;

  (String, {Uri? optionalUri})? aRecord;

  /// Returns a shallow copy of this [Types]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
    Uri? aUri,
    BigInt? aBigInt,
    _i1.Vector? aVector,
    _i1.HalfVector? aHalfVector,
    _i1.SparseVector? aSparseVector,
    _i1.Bit? aBit,
    _i3.TestEnum? anEnum,
    _i4.TestEnumStringified? aStringifiedEnum,
    List<int>? aList,
    Map<int, int>? aMap,
    Set<int>? aSet,
    (String, {Uri? optionalUri})? aRecord,
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
      if (aUri != null) 'aUri': aUri?.toJson(),
      if (aBigInt != null) 'aBigInt': aBigInt?.toJson(),
      if (aVector != null) 'aVector': aVector?.toJson(),
      if (aHalfVector != null) 'aHalfVector': aHalfVector?.toJson(),
      if (aSparseVector != null) 'aSparseVector': aSparseVector?.toJson(),
      if (aBit != null) 'aBit': aBit?.toJson(),
      if (anEnum != null) 'anEnum': anEnum?.toJson(),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(),
      if (aList != null) 'aList': aList?.toJson(),
      if (aMap != null) 'aMap': aMap?.toJson(),
      if (aSet != null) 'aSet': aSet?.toJson(),
      if (aRecord != null) 'aRecord': _i5.mapRecordToJson(aRecord),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
    Uri? aUri,
    BigInt? aBigInt,
    _i1.Vector? aVector,
    _i1.HalfVector? aHalfVector,
    _i1.SparseVector? aSparseVector,
    _i1.Bit? aBit,
    _i3.TestEnum? anEnum,
    _i4.TestEnumStringified? aStringifiedEnum,
    List<int>? aList,
    Map<int, int>? aMap,
    Set<int>? aSet,
    (String, {Uri? optionalUri})? aRecord,
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
          aUri: aUri,
          aBigInt: aBigInt,
          aVector: aVector,
          aHalfVector: aHalfVector,
          aSparseVector: aSparseVector,
          aBit: aBit,
          anEnum: anEnum,
          aStringifiedEnum: aStringifiedEnum,
          aList: aList,
          aMap: aMap,
          aSet: aSet,
          aRecord: aRecord,
        );

  /// Returns a shallow copy of this [Types]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
    Object? aUri = _Undefined,
    Object? aBigInt = _Undefined,
    Object? aVector = _Undefined,
    Object? aHalfVector = _Undefined,
    Object? aSparseVector = _Undefined,
    Object? aBit = _Undefined,
    Object? anEnum = _Undefined,
    Object? aStringifiedEnum = _Undefined,
    Object? aList = _Undefined,
    Object? aMap = _Undefined,
    Object? aSet = _Undefined,
    Object? aRecord = _Undefined,
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
      aUri: aUri is Uri? ? aUri : this.aUri,
      aBigInt: aBigInt is BigInt? ? aBigInt : this.aBigInt,
      aVector: aVector is _i1.Vector? ? aVector : this.aVector?.clone(),
      aHalfVector: aHalfVector is _i1.HalfVector?
          ? aHalfVector
          : this.aHalfVector?.clone(),
      aSparseVector: aSparseVector is _i1.SparseVector?
          ? aSparseVector
          : this.aSparseVector?.clone(),
      aBit: aBit is _i1.Bit? ? aBit : this.aBit?.clone(),
      anEnum: anEnum is _i3.TestEnum? ? anEnum : this.anEnum,
      aStringifiedEnum: aStringifiedEnum is _i4.TestEnumStringified?
          ? aStringifiedEnum
          : this.aStringifiedEnum,
      aList: aList is List<int>? ? aList : this.aList?.map((e0) => e0).toList(),
      aMap: aMap is Map<int, int>?
          ? aMap
          : this.aMap?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      aSet: aSet is Set<int>? ? aSet : this.aSet?.map((e0) => e0).toSet(),
      aRecord: aRecord is (String, {Uri? optionalUri})?
          ? aRecord
          : this.aRecord == null
              ? null
              : (
                  this.aRecord!.$1,
                  optionalUri: this.aRecord!.optionalUri,
                ),
    );
  }
}

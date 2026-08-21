/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_stringified.dart' as _i7liykk2;

abstract class Types
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    this.aGeographyPoint,
    this.aGeographyLineString,
    this.aGeographyPolygon,
    this.aGeographyGeometryCollection,
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
    _idt.ByteData? aByteData,
    Duration? aDuration,
    _isc.UuidValue? aUuid,
    Uri? aUri,
    BigInt? aBigInt,
    _isc.Vector? aVector,
    _isc.HalfVector? aHalfVector,
    _isc.SparseVector? aSparseVector,
    _isc.Bit? aBit,
    _isc.GeographyPoint? aGeographyPoint,
    _isc.GeographyLineString? aGeographyLineString,
    _isc.GeographyPolygon? aGeographyPolygon,
    _isc.GeographyGeometryCollection? aGeographyGeometryCollection,
    _ionapfu9.TestEnum? anEnum,
    _i7liykk2.TestEnumStringified? aStringifiedEnum,
    List<int>? aList,
    Map<int, int>? aMap,
    Set<int>? aSet,
    (String, {Uri? optionalUri})? aRecord,
  }) = _TypesImpl;

  factory Types.fromJson(Map<String, dynamic> jsonSerialization) {
    return Types(
      id: jsonSerialization['id'] as int?,
      anInt: jsonSerialization['anInt'] as int?,
      aBool: jsonSerialization['aBool'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['aBool']),
      aDouble: (jsonSerialization['aDouble'] as num?)?.toDouble(),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['aDateTime']),
      aString: jsonSerialization['aString'] as String?,
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _isc.ByteDataJsonExtension.fromJson(jsonSerialization['aByteData']),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _isc.DurationJsonExtension.fromJson(jsonSerialization['aDuration']),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['aUuid']),
      aUri: jsonSerialization['aUri'] == null
          ? null
          : _isc.UriJsonExtension.fromJson(jsonSerialization['aUri']),
      aBigInt: jsonSerialization['aBigInt'] == null
          ? null
          : _isc.BigIntJsonExtension.fromJson(jsonSerialization['aBigInt']),
      aVector: jsonSerialization['aVector'] == null
          ? null
          : _isc.VectorJsonExtension.fromJson(jsonSerialization['aVector']),
      aHalfVector: jsonSerialization['aHalfVector'] == null
          ? null
          : _isc.HalfVectorJsonExtension.fromJson(
              jsonSerialization['aHalfVector'],
            ),
      aSparseVector: jsonSerialization['aSparseVector'] == null
          ? null
          : _isc.SparseVectorJsonExtension.fromJson(
              jsonSerialization['aSparseVector'],
            ),
      aBit: jsonSerialization['aBit'] == null
          ? null
          : _isc.BitJsonExtension.fromJson(jsonSerialization['aBit']),
      aGeographyPoint: jsonSerialization['aGeographyPoint'] == null
          ? null
          : _isc.GeographyPointJsonExtension.fromJson(
              jsonSerialization['aGeographyPoint'],
            ),
      aGeographyLineString: jsonSerialization['aGeographyLineString'] == null
          ? null
          : _isc.GeographyLineStringJsonExtension.fromJson(
              jsonSerialization['aGeographyLineString'],
            ),
      aGeographyPolygon: jsonSerialization['aGeographyPolygon'] == null
          ? null
          : _isc.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['aGeographyPolygon'],
            ),
      aGeographyGeometryCollection:
          jsonSerialization['aGeographyGeometryCollection'] == null
          ? null
          : _isc.GeographyGeometryCollectionJsonExtension.fromJson(
              jsonSerialization['aGeographyGeometryCollection'],
            ),
      anEnum: jsonSerialization['anEnum'] == null
          ? null
          : _ionapfu9.TestEnum.fromJson((jsonSerialization['anEnum'] as int)),
      aStringifiedEnum: jsonSerialization['aStringifiedEnum'] == null
          ? null
          : _i7liykk2.TestEnumStringified.fromJson(
              (jsonSerialization['aStringifiedEnum'] as String),
            ),
      aList: jsonSerialization['aList'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<int>>(
              jsonSerialization['aList'],
            ),
      aMap: jsonSerialization['aMap'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Map<int, int>>(
              jsonSerialization['aMap'],
            ),
      aSet: jsonSerialization['aSet'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Set<int>>(
              jsonSerialization['aSet'],
            ),
      aRecord: jsonSerialization['aRecord'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<(String, {Uri? optionalUri})?>(
              (jsonSerialization['aRecord'] as Map<String, dynamic>),
            ),
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

  _idt.ByteData? aByteData;

  Duration? aDuration;

  _isc.UuidValue? aUuid;

  Uri? aUri;

  BigInt? aBigInt;

  _isc.Vector? aVector;

  _isc.HalfVector? aHalfVector;

  _isc.SparseVector? aSparseVector;

  _isc.Bit? aBit;

  _isc.GeographyPoint? aGeographyPoint;

  _isc.GeographyLineString? aGeographyLineString;

  _isc.GeographyPolygon? aGeographyPolygon;

  _isc.GeographyGeometryCollection? aGeographyGeometryCollection;

  _ionapfu9.TestEnum? anEnum;

  _i7liykk2.TestEnumStringified? aStringifiedEnum;

  List<int>? aList;

  Map<int, int>? aMap;

  Set<int>? aSet;

  (String, {Uri? optionalUri})? aRecord;

  /// Returns a shallow copy of this [Types]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Types copyWith({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _idt.ByteData? aByteData,
    Duration? aDuration,
    _isc.UuidValue? aUuid,
    Uri? aUri,
    BigInt? aBigInt,
    _isc.Vector? aVector,
    _isc.HalfVector? aHalfVector,
    _isc.SparseVector? aSparseVector,
    _isc.Bit? aBit,
    _isc.GeographyPoint? aGeographyPoint,
    _isc.GeographyLineString? aGeographyLineString,
    _isc.GeographyPolygon? aGeographyPolygon,
    _isc.GeographyGeometryCollection? aGeographyGeometryCollection,
    _ionapfu9.TestEnum? anEnum,
    _i7liykk2.TestEnumStringified? aStringifiedEnum,
    List<int>? aList,
    Map<int, int>? aMap,
    Set<int>? aSet,
    (String, {Uri? optionalUri})? aRecord,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Types',
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
      if (aGeographyPoint != null) 'aGeographyPoint': aGeographyPoint?.toJson(),
      if (aGeographyLineString != null)
        'aGeographyLineString': aGeographyLineString?.toJson(),
      if (aGeographyPolygon != null)
        'aGeographyPolygon': aGeographyPolygon?.toJson(),
      if (aGeographyGeometryCollection != null)
        'aGeographyGeometryCollection': aGeographyGeometryCollection?.toJson(),
      if (anEnum != null) 'anEnum': anEnum?.toJson(),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(),
      if (aList != null) 'aList': aList?.toJson(),
      if (aMap != null) 'aMap': aMap?.toJson(),
      if (aSet != null) 'aSet': aSet?.toJson(),
      if (aRecord != null)
        'aRecord': _iza9lbb5.Protocol().mapRecordToJson(aRecord),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Types',
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
      if (aGeographyPoint != null) 'aGeographyPoint': aGeographyPoint?.toJson(),
      if (aGeographyLineString != null)
        'aGeographyLineString': aGeographyLineString?.toJson(),
      if (aGeographyPolygon != null)
        'aGeographyPolygon': aGeographyPolygon?.toJson(),
      if (aGeographyGeometryCollection != null)
        'aGeographyGeometryCollection': aGeographyGeometryCollection?.toJson(),
      if (anEnum != null) 'anEnum': anEnum?.toJson(),
      if (aStringifiedEnum != null)
        'aStringifiedEnum': aStringifiedEnum?.toJson(),
      if (aList != null) 'aList': aList?.toJson(),
      if (aMap != null) 'aMap': aMap?.toJson(),
      if (aSet != null) 'aSet': aSet?.toJson(),
      if (aRecord != null)
        'aRecord': _iza9lbb5.Protocol().mapRecordToJson(aRecord),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
    _idt.ByteData? aByteData,
    Duration? aDuration,
    _isc.UuidValue? aUuid,
    Uri? aUri,
    BigInt? aBigInt,
    _isc.Vector? aVector,
    _isc.HalfVector? aHalfVector,
    _isc.SparseVector? aSparseVector,
    _isc.Bit? aBit,
    _isc.GeographyPoint? aGeographyPoint,
    _isc.GeographyLineString? aGeographyLineString,
    _isc.GeographyPolygon? aGeographyPolygon,
    _isc.GeographyGeometryCollection? aGeographyGeometryCollection,
    _ionapfu9.TestEnum? anEnum,
    _i7liykk2.TestEnumStringified? aStringifiedEnum,
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
         aGeographyPoint: aGeographyPoint,
         aGeographyLineString: aGeographyLineString,
         aGeographyPolygon: aGeographyPolygon,
         aGeographyGeometryCollection: aGeographyGeometryCollection,
         anEnum: anEnum,
         aStringifiedEnum: aStringifiedEnum,
         aList: aList,
         aMap: aMap,
         aSet: aSet,
         aRecord: aRecord,
       );

  /// Returns a shallow copy of this [Types]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
    Object? aGeographyPoint = _Undefined,
    Object? aGeographyLineString = _Undefined,
    Object? aGeographyPolygon = _Undefined,
    Object? aGeographyGeometryCollection = _Undefined,
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
      aByteData: aByteData is _idt.ByteData?
          ? aByteData
          : this.aByteData?.clone(),
      aDuration: aDuration is Duration? ? aDuration : this.aDuration,
      aUuid: aUuid is _isc.UuidValue? ? aUuid : this.aUuid,
      aUri: aUri is Uri? ? aUri : this.aUri,
      aBigInt: aBigInt is BigInt? ? aBigInt : this.aBigInt,
      aVector: aVector is _isc.Vector? ? aVector : this.aVector?.clone(),
      aHalfVector: aHalfVector is _isc.HalfVector?
          ? aHalfVector
          : this.aHalfVector?.clone(),
      aSparseVector: aSparseVector is _isc.SparseVector?
          ? aSparseVector
          : this.aSparseVector?.clone(),
      aBit: aBit is _isc.Bit? ? aBit : this.aBit?.clone(),
      aGeographyPoint: aGeographyPoint is _isc.GeographyPoint?
          ? aGeographyPoint
          : this.aGeographyPoint,
      aGeographyLineString: aGeographyLineString is _isc.GeographyLineString?
          ? aGeographyLineString
          : this.aGeographyLineString,
      aGeographyPolygon: aGeographyPolygon is _isc.GeographyPolygon?
          ? aGeographyPolygon
          : this.aGeographyPolygon,
      aGeographyGeometryCollection:
          aGeographyGeometryCollection is _isc.GeographyGeometryCollection?
          ? aGeographyGeometryCollection
          : this.aGeographyGeometryCollection,
      anEnum: anEnum is _ionapfu9.TestEnum? ? anEnum : this.anEnum,
      aStringifiedEnum: aStringifiedEnum is _i7liykk2.TestEnumStringified?
          ? aStringifiedEnum
          : this.aStringifiedEnum,
      aList: aList is List<int>? ? aList : this.aList?.map((e0) => e0).toList(),
      aMap: aMap is Map<int, int>?
          ? aMap
          : this.aMap?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            ),
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

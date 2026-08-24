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
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_stringified.dart' as _i7liykk2;

abstract class Types
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
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
          : _i0ntutnq.Protocol().deserialize<List<int>>(
              jsonSerialization['aList'],
            ),
      aMap: jsonSerialization['aMap'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<Map<int, int>>(
              jsonSerialization['aMap'],
            ),
      aSet: jsonSerialization['aSet'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<Set<int>>(
              jsonSerialization['aSet'],
            ),
      aRecord: jsonSerialization['aRecord'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<(String, {Uri? optionalUri})?>(
              (jsonSerialization['aRecord'] as Map<String, dynamic>),
            ),
    );
  }

  static final t = TypesTable();

  static const db = TypesRepository._();

  @override
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

  @override
  _isd.Table<int?> get table => t;

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
        'aRecord': _i0ntutnq.Protocol().mapRecordToJson(aRecord),
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
        'aRecord': _i0ntutnq.Protocol().mapRecordToJson(aRecord),
    };
  }

  static TypesInclude include({_isd.SelectColumnsBuilder<TypesTable>? select}) {
    return TypesInclude.internal_(selectedColumns: select?.call(Types.t));
  }

  static TypesIncludeList includeList({
    _isd.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TypesTable>? orderBy,
    _isd.OrderByListBuilder<TypesTable>? orderByList,
    TypesInclude? include,
    _isd.SelectColumnsBuilder<TypesTable>? select,
  }) {
    return TypesIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      include: include,
      selectedColumns: select?.call(Types.t),
    );
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

class TypesUpdateTable extends _isd.UpdateTable<TypesTable> {
  TypesUpdateTable(super.table);

  _isd.ColumnValue<int, int> anInt(int? value) => _isd.ColumnValue(
    table.anInt,
    value,
  );

  _isd.ColumnValue<bool, bool> aBool(bool? value) => _isd.ColumnValue(
    table.aBool,
    value,
  );

  _isd.ColumnValue<double, double> aDouble(double? value) => _isd.ColumnValue(
    table.aDouble,
    value,
  );

  _isd.ColumnValue<DateTime, DateTime> aDateTime(DateTime? value) =>
      _isd.ColumnValue(
        table.aDateTime,
        value,
      );

  _isd.ColumnValue<String, String> aString(String? value) => _isd.ColumnValue(
    table.aString,
    value,
  );

  _isd.ColumnValue<_idt.ByteData, _idt.ByteData> aByteData(
    _idt.ByteData? value,
  ) => _isd.ColumnValue(
    table.aByteData,
    value,
  );

  _isd.ColumnValue<Duration, Duration> aDuration(Duration? value) =>
      _isd.ColumnValue(
        table.aDuration,
        value,
      );

  _isd.ColumnValue<_isc.UuidValue, _isc.UuidValue> aUuid(
    _isc.UuidValue? value,
  ) => _isd.ColumnValue(
    table.aUuid,
    value,
  );

  _isd.ColumnValue<Uri, Uri> aUri(Uri? value) => _isd.ColumnValue(
    table.aUri,
    value,
  );

  _isd.ColumnValue<BigInt, BigInt> aBigInt(BigInt? value) => _isd.ColumnValue(
    table.aBigInt,
    value,
  );

  _isd.ColumnValue<_isc.Vector, _isc.Vector> aVector(_isc.Vector? value) =>
      _isd.ColumnValue(
        table.aVector,
        value,
      );

  _isd.ColumnValue<_isc.HalfVector, _isc.HalfVector> aHalfVector(
    _isc.HalfVector? value,
  ) => _isd.ColumnValue(
    table.aHalfVector,
    value,
  );

  _isd.ColumnValue<_isc.SparseVector, _isc.SparseVector> aSparseVector(
    _isc.SparseVector? value,
  ) => _isd.ColumnValue(
    table.aSparseVector,
    value,
  );

  _isd.ColumnValue<_isc.Bit, _isc.Bit> aBit(_isc.Bit? value) =>
      _isd.ColumnValue(
        table.aBit,
        value,
      );

  _isd.ColumnValue<_isc.GeographyPoint, _isc.GeographyPoint> aGeographyPoint(
    _isc.GeographyPoint? value,
  ) => _isd.ColumnValue(
    table.aGeographyPoint,
    value,
  );

  _isd.ColumnValue<_isc.GeographyLineString, _isc.GeographyLineString>
  aGeographyLineString(_isc.GeographyLineString? value) => _isd.ColumnValue(
    table.aGeographyLineString,
    value,
  );

  _isd.ColumnValue<_isc.GeographyPolygon, _isc.GeographyPolygon>
  aGeographyPolygon(_isc.GeographyPolygon? value) => _isd.ColumnValue(
    table.aGeographyPolygon,
    value,
  );

  _isd.ColumnValue<
    _isc.GeographyGeometryCollection,
    _isc.GeographyGeometryCollection
  >
  aGeographyGeometryCollection(_isc.GeographyGeometryCollection? value) =>
      _isd.ColumnValue(
        table.aGeographyGeometryCollection,
        value,
      );

  _isd.ColumnValue<_ionapfu9.TestEnum, _ionapfu9.TestEnum> anEnum(
    _ionapfu9.TestEnum? value,
  ) => _isd.ColumnValue(
    table.anEnum,
    value,
  );

  _isd.ColumnValue<_i7liykk2.TestEnumStringified, _i7liykk2.TestEnumStringified>
  aStringifiedEnum(_i7liykk2.TestEnumStringified? value) => _isd.ColumnValue(
    table.aStringifiedEnum,
    value,
  );

  _isd.ColumnValue<List<int>, List<int>> aList(List<int>? value) =>
      _isd.ColumnValue(
        table.aList,
        value,
      );

  _isd.ColumnValue<Map<int, int>, Map<int, int>> aMap(Map<int, int>? value) =>
      _isd.ColumnValue(
        table.aMap,
        value,
      );

  _isd.ColumnValue<Set<int>, Set<int>> aSet(Set<int>? value) =>
      _isd.ColumnValue(
        table.aSet,
        value,
      );

  _isd.ColumnValue<(String, {Uri? optionalUri}), Map<String, dynamic>?> aRecord(
    (String, {Uri? optionalUri})? value,
  ) => _isd.ColumnValue(
    table.aRecord,
    _i0ntutnq.Protocol().mapRecordToJson(value),
  );
}

class TypesTable extends _isd.Table<int?> {
  TypesTable({super.tableRelation}) : super(tableName: 'types') {
    updateTable = TypesUpdateTable(this);
    anInt = _isd.ColumnInt(
      'anInt',
      this,
    );
    aBool = _isd.ColumnBool(
      'aBool',
      this,
    );
    aDouble = _isd.ColumnDouble(
      'aDouble',
      this,
    );
    aDateTime = _isd.ColumnDateTime(
      'aDateTime',
      this,
    );
    aString = _isd.ColumnString(
      'aString',
      this,
    );
    aByteData = _isd.ColumnByteData(
      'aByteData',
      this,
    );
    aDuration = _isd.ColumnDuration(
      'aDuration',
      this,
    );
    aUuid = _isd.ColumnUuid(
      'aUuid',
      this,
    );
    aUri = _isd.ColumnUri(
      'aUri',
      this,
    );
    aBigInt = _isd.ColumnBigInt(
      'aBigInt',
      this,
    );
    aVector = _isd.ColumnVector(
      'aVector',
      this,
      dimension: 3,
    );
    aHalfVector = _isd.ColumnHalfVector(
      'aHalfVector',
      this,
      dimension: 3,
    );
    aSparseVector = _isd.ColumnSparseVector(
      'aSparseVector',
      this,
      dimension: 3,
    );
    aBit = _isd.ColumnBit(
      'aBit',
      this,
      dimension: 3,
    );
    aGeographyPoint = _isd.ColumnGeographyPoint(
      'aGeographyPoint',
      this,
    );
    aGeographyLineString = _isd.ColumnGeographyLineString(
      'aGeographyLineString',
      this,
    );
    aGeographyPolygon = _isd.ColumnGeographyPolygon(
      'aGeographyPolygon',
      this,
    );
    aGeographyGeometryCollection = _isd.ColumnGeographyGeometryCollection(
      'aGeographyGeometryCollection',
      this,
    );
    anEnum = _isd.ColumnEnum(
      'anEnum',
      this,
      _isd.EnumSerialization.byIndex,
    );
    aStringifiedEnum = _isd.ColumnEnum(
      'aStringifiedEnum',
      this,
      _isd.EnumSerialization.byName,
    );
    aList = _isd.ColumnSerializable<List<int>>(
      'aList',
      this,
    );
    aMap = _isd.ColumnSerializable<Map<int, int>>(
      'aMap',
      this,
    );
    aSet = _isd.ColumnSerializable<Set<int>>(
      'aSet',
      this,
    );
    aRecord = _isd.ColumnSerializable<(String, {Uri? optionalUri})>(
      'aRecord',
      this,
    );
  }

  late final TypesUpdateTable updateTable;

  late final _isd.ColumnInt anInt;

  late final _isd.ColumnBool aBool;

  late final _isd.ColumnDouble aDouble;

  late final _isd.ColumnDateTime aDateTime;

  late final _isd.ColumnString aString;

  late final _isd.ColumnByteData aByteData;

  late final _isd.ColumnDuration aDuration;

  late final _isd.ColumnUuid aUuid;

  late final _isd.ColumnUri aUri;

  late final _isd.ColumnBigInt aBigInt;

  late final _isd.ColumnVector aVector;

  late final _isd.ColumnHalfVector aHalfVector;

  late final _isd.ColumnSparseVector aSparseVector;

  late final _isd.ColumnBit aBit;

  late final _isd.ColumnGeographyPoint aGeographyPoint;

  late final _isd.ColumnGeographyLineString aGeographyLineString;

  late final _isd.ColumnGeographyPolygon aGeographyPolygon;

  late final _isd.ColumnGeographyGeometryCollection
  aGeographyGeometryCollection;

  late final _isd.ColumnEnum<_ionapfu9.TestEnum> anEnum;

  late final _isd.ColumnEnum<_i7liykk2.TestEnumStringified> aStringifiedEnum;

  late final _isd.ColumnSerializable<List<int>> aList;

  late final _isd.ColumnSerializable<Map<int, int>> aMap;

  late final _isd.ColumnSerializable<Set<int>> aSet;

  late final _isd.ColumnSerializable<(String, {Uri? optionalUri})> aRecord;

  @override
  List<_isd.Column> get columns => [
    id,
    anInt,
    aBool,
    aDouble,
    aDateTime,
    aString,
    aByteData,
    aDuration,
    aUuid,
    aUri,
    aBigInt,
    aVector,
    aHalfVector,
    aSparseVector,
    aBit,
    aGeographyPoint,
    aGeographyLineString,
    aGeographyPolygon,
    aGeographyGeometryCollection,
    anEnum,
    aStringifiedEnum,
    aList,
    aMap,
    aSet,
    aRecord,
  ];
}

class TypesInclude extends _isd.IncludeObject {
  TypesInclude.internal_({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => Types.t;
}

class TypesIncludeList extends _isd.IncludeList {
  TypesIncludeList.internal_({
    _isd.WhereExpressionBuilder<TypesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Types.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Types.t;
}

class TypesRepository {
  const TypesRepository._();

  /// Returns a list of [Types]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Types>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TypesTable>? orderBy,
    _isd.OrderByListBuilder<TypesTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Types] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Types?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TypesTable>? where,
    int? offset,
    _isd.OrderByBuilder<TypesTable>? orderBy,
    _isd.OrderByListBuilder<TypesTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Types] by its [id] or null if no such row exists.
  Future<Types?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Types>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Types]s in the list and returns the inserted rows.
  ///
  /// The returned [Types]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Types>> insert(
    _isd.DatabaseSession session,
    List<Types> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Types>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Types] and returns the inserted row.
  ///
  /// The returned [Types] will have its `id` field set.
  Future<Types> insertRow(
    _isd.DatabaseSession session,
    Types row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Types>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Types]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Types]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Types>> upsert(
    _isd.DatabaseSession session,
    List<Types> rows, {
    required _isd.ColumnSelections<TypesTable> conflictColumns,
    _isd.ColumnSelections<TypesTable>? updateColumns,
    _isd.WhereExpressionBuilder<TypesTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Types>(
      rows,
      conflictColumns: conflictColumns(Types.t),
      updateColumns: updateColumns?.call(Types.t),
      updateWhere: updateWhere?.call(Types.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Types] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Types] will have its `id` field set.
  Future<Types?> upsertRow(
    _isd.DatabaseSession session,
    Types row, {
    required _isd.ColumnSelections<TypesTable> conflictColumns,
    _isd.ColumnSelections<TypesTable>? updateColumns,
    _isd.WhereExpressionBuilder<TypesTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Types>(
      row,
      conflictColumns: conflictColumns(Types.t),
      updateColumns: updateColumns?.call(Types.t),
      updateWhere: updateWhere?.call(Types.t),
      transaction: transaction,
    );
  }

  /// Updates all [Types]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Types>> update(
    _isd.DatabaseSession session,
    List<Types> rows, {
    _isd.ColumnSelections<TypesTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Types>(
      rows,
      columns: columns?.call(Types.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Types]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Types> updateRow(
    _isd.DatabaseSession session,
    Types row, {
    _isd.ColumnSelections<TypesTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Types>(
      row,
      columns: columns?.call(Types.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Types] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Types?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<TypesUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Types>(
      id,
      columnValues: columnValues(Types.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Types]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Types>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<TypesUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<TypesTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<TypesTable>? orderBy,
    _isd.OrderByListBuilder<TypesTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Types>(
      columnValues: columnValues(Types.t.updateTable),
      where: where(Types.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Types]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Types>> delete(
    _isd.DatabaseSession session,
    List<Types> rows, {
    _isd.OrderByBuilder<TypesTable>? orderBy,
    _isd.OrderByListBuilder<TypesTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Types>(
      rows,
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Types].
  Future<Types> deleteRow(
    _isd.DatabaseSession session,
    Types row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Types>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Types>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<TypesTable> where,
    _isd.OrderByBuilder<TypesTable>? orderBy,
    _isd.OrderByListBuilder<TypesTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Types>(
      where: where(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Types>(
      where: where?.call(Types.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Types] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<TypesTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Types>(
      where: where(Types.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

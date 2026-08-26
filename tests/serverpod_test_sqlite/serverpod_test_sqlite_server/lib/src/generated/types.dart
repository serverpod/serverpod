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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_stringified.dart' as _i7liykk2;

abstract class Types implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    _is.UuidValue? aUuid,
    Uri? aUri,
    BigInt? aBigInt,
    _is.Vector? aVector,
    _is.HalfVector? aHalfVector,
    _is.SparseVector? aSparseVector,
    _is.Bit? aBit,
    _is.GeographyPoint? aGeographyPoint,
    _is.GeographyLineString? aGeographyLineString,
    _is.GeographyPolygon? aGeographyPolygon,
    _is.GeographyGeometryCollection? aGeographyGeometryCollection,
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
          : _is.BoolJsonExtension.fromJson(jsonSerialization['aBool']),
      aDouble: (jsonSerialization['aDouble'] as num?)?.toDouble(),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['aDateTime']),
      aString: jsonSerialization['aString'] as String?,
      aByteData: jsonSerialization['aByteData'] == null
          ? null
          : _is.ByteDataJsonExtension.fromJson(jsonSerialization['aByteData']),
      aDuration: jsonSerialization['aDuration'] == null
          ? null
          : _is.DurationJsonExtension.fromJson(jsonSerialization['aDuration']),
      aUuid: jsonSerialization['aUuid'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['aUuid']),
      aUri: jsonSerialization['aUri'] == null
          ? null
          : _is.UriJsonExtension.fromJson(jsonSerialization['aUri']),
      aBigInt: jsonSerialization['aBigInt'] == null
          ? null
          : _is.BigIntJsonExtension.fromJson(jsonSerialization['aBigInt']),
      aVector: jsonSerialization['aVector'] == null
          ? null
          : _is.VectorJsonExtension.fromJson(jsonSerialization['aVector']),
      aHalfVector: jsonSerialization['aHalfVector'] == null
          ? null
          : _is.HalfVectorJsonExtension.fromJson(
              jsonSerialization['aHalfVector'],
            ),
      aSparseVector: jsonSerialization['aSparseVector'] == null
          ? null
          : _is.SparseVectorJsonExtension.fromJson(
              jsonSerialization['aSparseVector'],
            ),
      aBit: jsonSerialization['aBit'] == null
          ? null
          : _is.BitJsonExtension.fromJson(jsonSerialization['aBit']),
      aGeographyPoint: jsonSerialization['aGeographyPoint'] == null
          ? null
          : _is.GeographyPointJsonExtension.fromJson(
              jsonSerialization['aGeographyPoint'],
            ),
      aGeographyLineString: jsonSerialization['aGeographyLineString'] == null
          ? null
          : _is.GeographyLineStringJsonExtension.fromJson(
              jsonSerialization['aGeographyLineString'],
            ),
      aGeographyPolygon: jsonSerialization['aGeographyPolygon'] == null
          ? null
          : _is.GeographyPolygonJsonExtension.fromJson(
              jsonSerialization['aGeographyPolygon'],
            ),
      aGeographyGeometryCollection:
          jsonSerialization['aGeographyGeometryCollection'] == null
          ? null
          : _is.GeographyGeometryCollectionJsonExtension.fromJson(
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
          : _i08l111i.Protocol().deserialize<List<int>>(
              jsonSerialization['aList'],
            ),
      aMap: jsonSerialization['aMap'] == null
          ? null
          : _i08l111i.Protocol().deserialize<Map<int, int>>(
              jsonSerialization['aMap'],
            ),
      aSet: jsonSerialization['aSet'] == null
          ? null
          : _i08l111i.Protocol().deserialize<Set<int>>(
              jsonSerialization['aSet'],
            ),
      aRecord: jsonSerialization['aRecord'] == null
          ? null
          : _i08l111i.Protocol().deserialize<(String, {Uri? optionalUri})?>(
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

  _is.UuidValue? aUuid;

  Uri? aUri;

  BigInt? aBigInt;

  _is.Vector? aVector;

  _is.HalfVector? aHalfVector;

  _is.SparseVector? aSparseVector;

  _is.Bit? aBit;

  _is.GeographyPoint? aGeographyPoint;

  _is.GeographyLineString? aGeographyLineString;

  _is.GeographyPolygon? aGeographyPolygon;

  _is.GeographyGeometryCollection? aGeographyGeometryCollection;

  _ionapfu9.TestEnum? anEnum;

  _i7liykk2.TestEnumStringified? aStringifiedEnum;

  List<int>? aList;

  Map<int, int>? aMap;

  Set<int>? aSet;

  (String, {Uri? optionalUri})? aRecord;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Types]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Types copyWith({
    int? id,
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
    _idt.ByteData? aByteData,
    Duration? aDuration,
    _is.UuidValue? aUuid,
    Uri? aUri,
    BigInt? aBigInt,
    _is.Vector? aVector,
    _is.HalfVector? aHalfVector,
    _is.SparseVector? aSparseVector,
    _is.Bit? aBit,
    _is.GeographyPoint? aGeographyPoint,
    _is.GeographyLineString? aGeographyLineString,
    _is.GeographyPolygon? aGeographyPolygon,
    _is.GeographyGeometryCollection? aGeographyGeometryCollection,
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
        'aRecord': _i08l111i.Protocol().mapRecordToJson(aRecord),
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
        'aRecord': _i08l111i.Protocol().mapRecordToJson(aRecord),
    };
  }

  /// Builds a complete [TypesInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static TypesInclude include() {
    return TypesInclude._();
  }

  /// Builds a complete [TypesIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static TypesIncludeList includeList({
    _is.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    TypesInclude? include,
  }) {
    return TypesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [TypesJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static TypesJsonInclude includeJson({
    _is.SelectColumnsBuilder<TypesTable>? select,
  }) {
    return _TypesJsonInclude._(selectedColumns: select?.call(Types.t));
  }

  /// Builds a JSON-compatible [TypesJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static TypesJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    TypesJsonInclude? include,
    _is.SelectColumnsBuilder<TypesTable>? select,
  }) {
    return _TypesJsonIncludeList._(
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
    return _is.SerializationManager.encode(this);
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
    _is.UuidValue? aUuid,
    Uri? aUri,
    BigInt? aBigInt,
    _is.Vector? aVector,
    _is.HalfVector? aHalfVector,
    _is.SparseVector? aSparseVector,
    _is.Bit? aBit,
    _is.GeographyPoint? aGeographyPoint,
    _is.GeographyLineString? aGeographyLineString,
    _is.GeographyPolygon? aGeographyPolygon,
    _is.GeographyGeometryCollection? aGeographyGeometryCollection,
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
  @_is.useResult
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
      aUuid: aUuid is _is.UuidValue? ? aUuid : this.aUuid,
      aUri: aUri is Uri? ? aUri : this.aUri,
      aBigInt: aBigInt is BigInt? ? aBigInt : this.aBigInt,
      aVector: aVector is _is.Vector? ? aVector : this.aVector?.clone(),
      aHalfVector: aHalfVector is _is.HalfVector?
          ? aHalfVector
          : this.aHalfVector?.clone(),
      aSparseVector: aSparseVector is _is.SparseVector?
          ? aSparseVector
          : this.aSparseVector?.clone(),
      aBit: aBit is _is.Bit? ? aBit : this.aBit?.clone(),
      aGeographyPoint: aGeographyPoint is _is.GeographyPoint?
          ? aGeographyPoint
          : this.aGeographyPoint,
      aGeographyLineString: aGeographyLineString is _is.GeographyLineString?
          ? aGeographyLineString
          : this.aGeographyLineString,
      aGeographyPolygon: aGeographyPolygon is _is.GeographyPolygon?
          ? aGeographyPolygon
          : this.aGeographyPolygon,
      aGeographyGeometryCollection:
          aGeographyGeometryCollection is _is.GeographyGeometryCollection?
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

class TypesUpdateTable extends _is.UpdateTable<TypesTable> {
  TypesUpdateTable(super.table);

  _is.ColumnValue<int, int> anInt(int? value) => _is.ColumnValue(
    table.anInt,
    value,
  );

  _is.ColumnValue<bool, bool> aBool(bool? value) => _is.ColumnValue(
    table.aBool,
    value,
  );

  _is.ColumnValue<double, double> aDouble(double? value) => _is.ColumnValue(
    table.aDouble,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> aDateTime(DateTime? value) =>
      _is.ColumnValue(
        table.aDateTime,
        value,
      );

  _is.ColumnValue<String, String> aString(String? value) => _is.ColumnValue(
    table.aString,
    value,
  );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> aByteData(
    _idt.ByteData? value,
  ) => _is.ColumnValue(
    table.aByteData,
    value,
  );

  _is.ColumnValue<Duration, Duration> aDuration(Duration? value) =>
      _is.ColumnValue(
        table.aDuration,
        value,
      );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> aUuid(_is.UuidValue? value) =>
      _is.ColumnValue(
        table.aUuid,
        value,
      );

  _is.ColumnValue<Uri, Uri> aUri(Uri? value) => _is.ColumnValue(
    table.aUri,
    value,
  );

  _is.ColumnValue<BigInt, BigInt> aBigInt(BigInt? value) => _is.ColumnValue(
    table.aBigInt,
    value,
  );

  _is.ColumnValue<_is.Vector, _is.Vector> aVector(_is.Vector? value) =>
      _is.ColumnValue(
        table.aVector,
        value,
      );

  _is.ColumnValue<_is.HalfVector, _is.HalfVector> aHalfVector(
    _is.HalfVector? value,
  ) => _is.ColumnValue(
    table.aHalfVector,
    value,
  );

  _is.ColumnValue<_is.SparseVector, _is.SparseVector> aSparseVector(
    _is.SparseVector? value,
  ) => _is.ColumnValue(
    table.aSparseVector,
    value,
  );

  _is.ColumnValue<_is.Bit, _is.Bit> aBit(_is.Bit? value) => _is.ColumnValue(
    table.aBit,
    value,
  );

  _is.ColumnValue<_is.GeographyPoint, _is.GeographyPoint> aGeographyPoint(
    _is.GeographyPoint? value,
  ) => _is.ColumnValue(
    table.aGeographyPoint,
    value,
  );

  _is.ColumnValue<_is.GeographyLineString, _is.GeographyLineString>
  aGeographyLineString(_is.GeographyLineString? value) => _is.ColumnValue(
    table.aGeographyLineString,
    value,
  );

  _is.ColumnValue<_is.GeographyPolygon, _is.GeographyPolygon> aGeographyPolygon(
    _is.GeographyPolygon? value,
  ) => _is.ColumnValue(
    table.aGeographyPolygon,
    value,
  );

  _is.ColumnValue<
    _is.GeographyGeometryCollection,
    _is.GeographyGeometryCollection
  >
  aGeographyGeometryCollection(_is.GeographyGeometryCollection? value) =>
      _is.ColumnValue(
        table.aGeographyGeometryCollection,
        value,
      );

  _is.ColumnValue<_ionapfu9.TestEnum, _ionapfu9.TestEnum> anEnum(
    _ionapfu9.TestEnum? value,
  ) => _is.ColumnValue(
    table.anEnum,
    value,
  );

  _is.ColumnValue<_i7liykk2.TestEnumStringified, _i7liykk2.TestEnumStringified>
  aStringifiedEnum(_i7liykk2.TestEnumStringified? value) => _is.ColumnValue(
    table.aStringifiedEnum,
    value,
  );

  _is.ColumnValue<List<int>, List<int>> aList(List<int>? value) =>
      _is.ColumnValue(
        table.aList,
        value,
      );

  _is.ColumnValue<Map<int, int>, Map<int, int>> aMap(Map<int, int>? value) =>
      _is.ColumnValue(
        table.aMap,
        value,
      );

  _is.ColumnValue<Set<int>, Set<int>> aSet(Set<int>? value) => _is.ColumnValue(
    table.aSet,
    value,
  );

  _is.ColumnValue<(String, {Uri? optionalUri}), Map<String, dynamic>?> aRecord(
    (String, {Uri? optionalUri})? value,
  ) => _is.ColumnValue(
    table.aRecord,
    _i08l111i.Protocol().mapRecordToJson(value),
  );
}

class TypesTable extends _is.Table<int?> {
  TypesTable({super.tableRelation}) : super(tableName: 'types') {
    updateTable = TypesUpdateTable(this);
    anInt = _is.ColumnInt(
      'anInt',
      this,
    );
    aBool = _is.ColumnBool(
      'aBool',
      this,
    );
    aDouble = _is.ColumnDouble(
      'aDouble',
      this,
    );
    aDateTime = _is.ColumnDateTime(
      'aDateTime',
      this,
    );
    aString = _is.ColumnString(
      'aString',
      this,
    );
    aByteData = _is.ColumnByteData(
      'aByteData',
      this,
    );
    aDuration = _is.ColumnDuration(
      'aDuration',
      this,
    );
    aUuid = _is.ColumnUuid(
      'aUuid',
      this,
    );
    aUri = _is.ColumnUri(
      'aUri',
      this,
    );
    aBigInt = _is.ColumnBigInt(
      'aBigInt',
      this,
    );
    aVector = _is.ColumnVector(
      'aVector',
      this,
      dimension: 3,
    );
    aHalfVector = _is.ColumnHalfVector(
      'aHalfVector',
      this,
      dimension: 3,
    );
    aSparseVector = _is.ColumnSparseVector(
      'aSparseVector',
      this,
      dimension: 3,
    );
    aBit = _is.ColumnBit(
      'aBit',
      this,
      dimension: 3,
    );
    aGeographyPoint = _is.ColumnGeographyPoint(
      'aGeographyPoint',
      this,
    );
    aGeographyLineString = _is.ColumnGeographyLineString(
      'aGeographyLineString',
      this,
    );
    aGeographyPolygon = _is.ColumnGeographyPolygon(
      'aGeographyPolygon',
      this,
    );
    aGeographyGeometryCollection = _is.ColumnGeographyGeometryCollection(
      'aGeographyGeometryCollection',
      this,
    );
    anEnum = _is.ColumnEnum(
      'anEnum',
      this,
      _is.EnumSerialization.byIndex,
    );
    aStringifiedEnum = _is.ColumnEnum(
      'aStringifiedEnum',
      this,
      _is.EnumSerialization.byName,
    );
    aList = _is.ColumnSerializable<List<int>>(
      'aList',
      this,
    );
    aMap = _is.ColumnSerializable<Map<int, int>>(
      'aMap',
      this,
    );
    aSet = _is.ColumnSerializable<Set<int>>(
      'aSet',
      this,
    );
    aRecord = _is.ColumnSerializable<(String, {Uri? optionalUri})>(
      'aRecord',
      this,
    );
  }

  late final TypesUpdateTable updateTable;

  late final _is.ColumnInt anInt;

  late final _is.ColumnBool aBool;

  late final _is.ColumnDouble aDouble;

  late final _is.ColumnDateTime aDateTime;

  late final _is.ColumnString aString;

  late final _is.ColumnByteData aByteData;

  late final _is.ColumnDuration aDuration;

  late final _is.ColumnUuid aUuid;

  late final _is.ColumnUri aUri;

  late final _is.ColumnBigInt aBigInt;

  late final _is.ColumnVector aVector;

  late final _is.ColumnHalfVector aHalfVector;

  late final _is.ColumnSparseVector aSparseVector;

  late final _is.ColumnBit aBit;

  late final _is.ColumnGeographyPoint aGeographyPoint;

  late final _is.ColumnGeographyLineString aGeographyLineString;

  late final _is.ColumnGeographyPolygon aGeographyPolygon;

  late final _is.ColumnGeographyGeometryCollection aGeographyGeometryCollection;

  late final _is.ColumnEnum<_ionapfu9.TestEnum> anEnum;

  late final _is.ColumnEnum<_i7liykk2.TestEnumStringified> aStringifiedEnum;

  late final _is.ColumnSerializable<List<int>> aList;

  late final _is.ColumnSerializable<Map<int, int>> aMap;

  late final _is.ColumnSerializable<Set<int>> aSet;

  late final _is.ColumnSerializable<(String, {Uri? optionalUri})> aRecord;

  @override
  List<_is.Column> get columns => [
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

abstract interface class TypesJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class TypesJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class TypesInclude extends _is.IncludeObject
    implements TypesJsonInclude, _is.FullModelInclude {
  TypesInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Types.t;
}

final class TypesIncludeList extends _is.IncludeList
    implements TypesJsonIncludeList, _is.FullModelInclude {
  TypesIncludeList._({
    _is.WhereExpressionBuilder<TypesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    TypesInclude? super.include,
  }) {
    super.where = where?.call(Types.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Types.t;
}

final class _TypesJsonInclude extends _is.IncludeObject
    implements TypesJsonInclude {
  _TypesJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Types.t;
}

final class _TypesJsonIncludeList extends _is.IncludeList
    implements TypesJsonIncludeList {
  _TypesJsonIncludeList._({
    _is.WhereExpressionBuilder<TypesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    TypesJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Types.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Types.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TypesTable>? where,
    int? offset,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Types>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<TypesTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(Types.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TypesTable>? where,
    int? offset,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<TypesTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(Types.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<TypesTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Types>(
      id,
      transaction: transaction,
      select: select?.call(Types.t),
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
    _is.DatabaseSession session,
    List<Types> rows, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Types row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Types> rows, {
    required _is.ColumnSelections<TypesTable> conflictColumns,
    _is.ColumnSelections<TypesTable>? updateColumns,
    _is.WhereExpressionBuilder<TypesTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Types row, {
    required _is.ColumnSelections<TypesTable> conflictColumns,
    _is.ColumnSelections<TypesTable>? updateColumns,
    _is.WhereExpressionBuilder<TypesTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Types> rows, {
    _is.ColumnSelections<TypesTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Types row, {
    _is.ColumnSelections<TypesTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TypesUpdateTable> columnValues,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TypesUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TypesTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Types> rows, {
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Types row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TypesTable> where,
    _is.OrderByBuilder<TypesTable>? orderBy,
    _is.OrderByListBuilder<TypesTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Types>(
      where: where?.call(Types.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Types] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TypesTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Types>(
      where: where(Types.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

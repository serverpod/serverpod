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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i5;

abstract class Types implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = TypesTable();

  static const db = TypesRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static TypesInclude include() {
    return TypesInclude._();
  }

  static TypesIncludeList includeList({
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    TypesInclude? include,
  }) {
    return TypesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Types.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Types.t),
      include: include,
    );
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

class TypesTable extends _i1.Table<int?> {
  TypesTable({super.tableRelation}) : super(tableName: 'types') {
    anInt = _i1.ColumnInt(
      'anInt',
      this,
    );
    aBool = _i1.ColumnBool(
      'aBool',
      this,
    );
    aDouble = _i1.ColumnDouble(
      'aDouble',
      this,
    );
    aDateTime = _i1.ColumnDateTime(
      'aDateTime',
      this,
    );
    aString = _i1.ColumnString(
      'aString',
      this,
    );
    aByteData = _i1.ColumnByteData(
      'aByteData',
      this,
    );
    aDuration = _i1.ColumnDuration(
      'aDuration',
      this,
    );
    aUuid = _i1.ColumnUuid(
      'aUuid',
      this,
    );
    aUri = _i1.ColumnUri(
      'aUri',
      this,
    );
    aBigInt = _i1.ColumnBigInt(
      'aBigInt',
      this,
    );
    aVector = _i1.ColumnVector(
      'aVector',
      this,
      dimension: 3,
    );
    aHalfVector = _i1.ColumnHalfVector(
      'aHalfVector',
      this,
      dimension: 3,
    );
    aSparseVector = _i1.ColumnSparseVector(
      'aSparseVector',
      this,
      dimension: 3,
    );
    aBit = _i1.ColumnBit(
      'aBit',
      this,
      dimension: 3,
    );
    anEnum = _i1.ColumnEnum(
      'anEnum',
      this,
      _i1.EnumSerialization.byIndex,
    );
    aStringifiedEnum = _i1.ColumnEnum(
      'aStringifiedEnum',
      this,
      _i1.EnumSerialization.byName,
    );
    aList = _i1.ColumnSerializable(
      'aList',
      this,
    );
    aMap = _i1.ColumnSerializable(
      'aMap',
      this,
    );
    aSet = _i1.ColumnSerializable(
      'aSet',
      this,
    );
    aRecord = _i1.ColumnSerializable(
      'aRecord',
      this,
    );
  }

  late final _i1.ColumnInt anInt;

  late final _i1.ColumnBool aBool;

  late final _i1.ColumnDouble aDouble;

  late final _i1.ColumnDateTime aDateTime;

  late final _i1.ColumnString aString;

  late final _i1.ColumnByteData aByteData;

  late final _i1.ColumnDuration aDuration;

  late final _i1.ColumnUuid aUuid;

  late final _i1.ColumnUri aUri;

  late final _i1.ColumnBigInt aBigInt;

  late final _i1.ColumnVector aVector;

  late final _i1.ColumnHalfVector aHalfVector;

  late final _i1.ColumnSparseVector aSparseVector;

  late final _i1.ColumnBit aBit;

  late final _i1.ColumnEnum<_i3.TestEnum> anEnum;

  late final _i1.ColumnEnum<_i4.TestEnumStringified> aStringifiedEnum;

  late final _i1.ColumnSerializable aList;

  late final _i1.ColumnSerializable aMap;

  late final _i1.ColumnSerializable aSet;

  late final _i1.ColumnSerializable aRecord;

  @override
  List<_i1.Column> get columns => [
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
        anEnum,
        aStringifiedEnum,
        aList,
        aMap,
        aSet,
        aRecord,
      ];
}

class TypesInclude extends _i1.IncludeObject {
  TypesInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Types.t;
}

class TypesIncludeList extends _i1.IncludeList {
  TypesIncludeList._({
    _i1.WhereExpressionBuilder<TypesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Types.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Types.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? offset,
    _i1.OrderByBuilder<TypesTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TypesTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Types>(
      where: where?.call(Types.t),
      orderBy: orderBy?.call(Types.t),
      orderByList: orderByList?.call(Types.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Types] by its [id] or null if no such row exists.
  Future<Types?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Types>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Types]s in the list and returns the inserted rows.
  ///
  /// The returned [Types]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Types>> insert(
    _i1.Session session,
    List<Types> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Types>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Types] and returns the inserted row.
  ///
  /// The returned [Types] will have its `id` field set.
  Future<Types> insertRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Types>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Types]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Types>> update(
    _i1.Session session,
    List<Types> rows, {
    _i1.ColumnSelections<TypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Types>(
      rows,
      columns: columns?.call(Types.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Types]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Types> updateRow(
    _i1.Session session,
    Types row, {
    _i1.ColumnSelections<TypesTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Types>(
      row,
      columns: columns?.call(Types.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Types]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Types>> delete(
    _i1.Session session,
    List<Types> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Types>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Types].
  Future<Types> deleteRow(
    _i1.Session session,
    Types row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Types>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Types>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TypesTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Types>(
      where: where(Types.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TypesTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Types>(
      where: where?.call(Types.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

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
import 'package:serverpod/serverpod.dart' as _is;

abstract class ObjectWithHalfVector
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithHalfVector._({
    this.id,
    required this.halfVector,
    this.halfVectorNullable,
    required this.halfVectorIndexedHnsw,
    required this.halfVectorIndexedHnswWithParams,
    required this.halfVectorIndexedIvfflat,
    required this.halfVectorIndexedIvfflatWithParams,
  });

  factory ObjectWithHalfVector({
    int? id,
    required _is.HalfVector halfVector,
    _is.HalfVector? halfVectorNullable,
    required _is.HalfVector halfVectorIndexedHnsw,
    required _is.HalfVector halfVectorIndexedHnswWithParams,
    required _is.HalfVector halfVectorIndexedIvfflat,
    required _is.HalfVector halfVectorIndexedIvfflatWithParams,
  }) = _ObjectWithHalfVectorImpl;

  factory ObjectWithHalfVector.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithHalfVector(
      id: jsonSerialization['id'] as int?,
      halfVector: _is.HalfVectorJsonExtension.fromJson(
        jsonSerialization['halfVector'],
      ),
      halfVectorNullable: jsonSerialization['halfVectorNullable'] == null
          ? null
          : _is.HalfVectorJsonExtension.fromJson(
              jsonSerialization['halfVectorNullable'],
            ),
      halfVectorIndexedHnsw: _is.HalfVectorJsonExtension.fromJson(
        jsonSerialization['halfVectorIndexedHnsw'],
      ),
      halfVectorIndexedHnswWithParams: _is.HalfVectorJsonExtension.fromJson(
        jsonSerialization['halfVectorIndexedHnswWithParams'],
      ),
      halfVectorIndexedIvfflat: _is.HalfVectorJsonExtension.fromJson(
        jsonSerialization['halfVectorIndexedIvfflat'],
      ),
      halfVectorIndexedIvfflatWithParams: _is.HalfVectorJsonExtension.fromJson(
        jsonSerialization['halfVectorIndexedIvfflatWithParams'],
      ),
    );
  }

  static final t = ObjectWithHalfVectorTable();

  static const db = ObjectWithHalfVectorRepository._();

  @override
  int? id;

  _is.HalfVector halfVector;

  _is.HalfVector? halfVectorNullable;

  _is.HalfVector halfVectorIndexedHnsw;

  _is.HalfVector halfVectorIndexedHnswWithParams;

  _is.HalfVector halfVectorIndexedIvfflat;

  _is.HalfVector halfVectorIndexedIvfflatWithParams;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithHalfVector]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithHalfVector copyWith({
    int? id,
    _is.HalfVector? halfVector,
    _is.HalfVector? halfVectorNullable,
    _is.HalfVector? halfVectorIndexedHnsw,
    _is.HalfVector? halfVectorIndexedHnswWithParams,
    _is.HalfVector? halfVectorIndexedIvfflat,
    _is.HalfVector? halfVectorIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithHalfVector',
      if (id != null) 'id': id,
      'halfVector': halfVector.toJson(),
      if (halfVectorNullable != null)
        'halfVectorNullable': halfVectorNullable?.toJson(),
      'halfVectorIndexedHnsw': halfVectorIndexedHnsw.toJson(),
      'halfVectorIndexedHnswWithParams': halfVectorIndexedHnswWithParams
          .toJson(),
      'halfVectorIndexedIvfflat': halfVectorIndexedIvfflat.toJson(),
      'halfVectorIndexedIvfflatWithParams': halfVectorIndexedIvfflatWithParams
          .toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithHalfVector',
      if (id != null) 'id': id,
      'halfVector': halfVector.toJson(),
      if (halfVectorNullable != null)
        'halfVectorNullable': halfVectorNullable?.toJson(),
      'halfVectorIndexedHnsw': halfVectorIndexedHnsw.toJson(),
      'halfVectorIndexedHnswWithParams': halfVectorIndexedHnswWithParams
          .toJson(),
      'halfVectorIndexedIvfflat': halfVectorIndexedIvfflat.toJson(),
      'halfVectorIndexedIvfflatWithParams': halfVectorIndexedIvfflatWithParams
          .toJson(),
    };
  }

  /// Builds a complete [ObjectWithHalfVectorInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithHalfVectorInclude include() {
    return ObjectWithHalfVectorInclude._();
  }

  /// Builds a complete [ObjectWithHalfVectorIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithHalfVectorIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    ObjectWithHalfVectorInclude? include,
  }) {
    return ObjectWithHalfVectorIncludeList._(
      where: where?.call(ObjectWithHalfVector.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ObjectWithHalfVectorJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ObjectWithHalfVectorJsonInclude includeJson({
    _is.SelectColumnsBuilder<ObjectWithHalfVectorTable>? select,
  }) {
    return _ObjectWithHalfVectorJsonInclude._(
      selectedColumns: select?.call(ObjectWithHalfVector.t),
    );
  }

  /// Builds a JSON-compatible [ObjectWithHalfVectorJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ObjectWithHalfVectorJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    ObjectWithHalfVectorJsonInclude? include,
    _is.SelectColumnsBuilder<ObjectWithHalfVectorTable>? select,
  }) {
    return _ObjectWithHalfVectorJsonIncludeList._(
      where: where?.call(ObjectWithHalfVector.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      include: include,
      selectedColumns: select?.call(ObjectWithHalfVector.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithHalfVectorImpl extends ObjectWithHalfVector {
  _ObjectWithHalfVectorImpl({
    int? id,
    required _is.HalfVector halfVector,
    _is.HalfVector? halfVectorNullable,
    required _is.HalfVector halfVectorIndexedHnsw,
    required _is.HalfVector halfVectorIndexedHnswWithParams,
    required _is.HalfVector halfVectorIndexedIvfflat,
    required _is.HalfVector halfVectorIndexedIvfflatWithParams,
  }) : super._(
         id: id,
         halfVector: halfVector,
         halfVectorNullable: halfVectorNullable,
         halfVectorIndexedHnsw: halfVectorIndexedHnsw,
         halfVectorIndexedHnswWithParams: halfVectorIndexedHnswWithParams,
         halfVectorIndexedIvfflat: halfVectorIndexedIvfflat,
         halfVectorIndexedIvfflatWithParams: halfVectorIndexedIvfflatWithParams,
       );

  /// Returns a shallow copy of this [ObjectWithHalfVector]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithHalfVector copyWith({
    Object? id = _Undefined,
    _is.HalfVector? halfVector,
    Object? halfVectorNullable = _Undefined,
    _is.HalfVector? halfVectorIndexedHnsw,
    _is.HalfVector? halfVectorIndexedHnswWithParams,
    _is.HalfVector? halfVectorIndexedIvfflat,
    _is.HalfVector? halfVectorIndexedIvfflatWithParams,
  }) {
    return ObjectWithHalfVector(
      id: id is int? ? id : this.id,
      halfVector: halfVector ?? this.halfVector.clone(),
      halfVectorNullable: halfVectorNullable is _is.HalfVector?
          ? halfVectorNullable
          : this.halfVectorNullable?.clone(),
      halfVectorIndexedHnsw:
          halfVectorIndexedHnsw ?? this.halfVectorIndexedHnsw.clone(),
      halfVectorIndexedHnswWithParams:
          halfVectorIndexedHnswWithParams ??
          this.halfVectorIndexedHnswWithParams.clone(),
      halfVectorIndexedIvfflat:
          halfVectorIndexedIvfflat ?? this.halfVectorIndexedIvfflat.clone(),
      halfVectorIndexedIvfflatWithParams:
          halfVectorIndexedIvfflatWithParams ??
          this.halfVectorIndexedIvfflatWithParams.clone(),
    );
  }
}

class ObjectWithHalfVectorUpdateTable
    extends _is.UpdateTable<ObjectWithHalfVectorTable> {
  ObjectWithHalfVectorUpdateTable(super.table);

  _is.ColumnValue<_is.HalfVector, _is.HalfVector> halfVector(
    _is.HalfVector value,
  ) => _is.ColumnValue(
    table.halfVector,
    value,
  );

  _is.ColumnValue<_is.HalfVector, _is.HalfVector> halfVectorNullable(
    _is.HalfVector? value,
  ) => _is.ColumnValue(
    table.halfVectorNullable,
    value,
  );

  _is.ColumnValue<_is.HalfVector, _is.HalfVector> halfVectorIndexedHnsw(
    _is.HalfVector value,
  ) => _is.ColumnValue(
    table.halfVectorIndexedHnsw,
    value,
  );

  _is.ColumnValue<_is.HalfVector, _is.HalfVector>
  halfVectorIndexedHnswWithParams(_is.HalfVector value) => _is.ColumnValue(
    table.halfVectorIndexedHnswWithParams,
    value,
  );

  _is.ColumnValue<_is.HalfVector, _is.HalfVector> halfVectorIndexedIvfflat(
    _is.HalfVector value,
  ) => _is.ColumnValue(
    table.halfVectorIndexedIvfflat,
    value,
  );

  _is.ColumnValue<_is.HalfVector, _is.HalfVector>
  halfVectorIndexedIvfflatWithParams(_is.HalfVector value) => _is.ColumnValue(
    table.halfVectorIndexedIvfflatWithParams,
    value,
  );
}

class ObjectWithHalfVectorTable extends _is.Table<int?> {
  ObjectWithHalfVectorTable({super.tableRelation})
    : super(tableName: 'object_with_half_vector') {
    updateTable = ObjectWithHalfVectorUpdateTable(this);
    halfVector = _is.ColumnHalfVector(
      'halfVector',
      this,
      dimension: 512,
    );
    halfVectorNullable = _is.ColumnHalfVector(
      'halfVectorNullable',
      this,
      dimension: 512,
    );
    halfVectorIndexedHnsw = _is.ColumnHalfVector(
      'halfVectorIndexedHnsw',
      this,
      dimension: 512,
    );
    halfVectorIndexedHnswWithParams = _is.ColumnHalfVector(
      'halfVectorIndexedHnswWithParams',
      this,
      dimension: 512,
    );
    halfVectorIndexedIvfflat = _is.ColumnHalfVector(
      'halfVectorIndexedIvfflat',
      this,
      dimension: 512,
    );
    halfVectorIndexedIvfflatWithParams = _is.ColumnHalfVector(
      'halfVectorIndexedIvfflatWithParams',
      this,
      dimension: 512,
    );
  }

  late final ObjectWithHalfVectorUpdateTable updateTable;

  late final _is.ColumnHalfVector halfVector;

  late final _is.ColumnHalfVector halfVectorNullable;

  late final _is.ColumnHalfVector halfVectorIndexedHnsw;

  late final _is.ColumnHalfVector halfVectorIndexedHnswWithParams;

  late final _is.ColumnHalfVector halfVectorIndexedIvfflat;

  late final _is.ColumnHalfVector halfVectorIndexedIvfflatWithParams;

  @override
  List<_is.Column> get columns => [
    id,
    halfVector,
    halfVectorNullable,
    halfVectorIndexedHnsw,
    halfVectorIndexedHnswWithParams,
    halfVectorIndexedIvfflat,
    halfVectorIndexedIvfflatWithParams,
  ];
}

abstract interface class ObjectWithHalfVectorJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ObjectWithHalfVectorJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ObjectWithHalfVectorInclude extends _is.IncludeObject
    implements ObjectWithHalfVectorJsonInclude, _is.FullModelInclude {
  ObjectWithHalfVectorInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithHalfVector.t;
}

final class ObjectWithHalfVectorIncludeList extends _is.IncludeList
    implements ObjectWithHalfVectorJsonIncludeList, _is.FullModelInclude {
  ObjectWithHalfVectorIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithHalfVectorInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithHalfVector.t;
}

final class _ObjectWithHalfVectorJsonInclude extends _is.IncludeObject
    implements ObjectWithHalfVectorJsonInclude {
  _ObjectWithHalfVectorJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithHalfVector.t;
}

final class _ObjectWithHalfVectorJsonIncludeList extends _is.IncludeList
    implements ObjectWithHalfVectorJsonIncludeList {
  _ObjectWithHalfVectorJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithHalfVectorJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithHalfVector.t;
}

class ObjectWithHalfVectorRepository {
  const ObjectWithHalfVectorRepository._();

  /// Returns a list of [ObjectWithHalfVector]s matching the given query parameters.
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
  Future<List<ObjectWithHalfVector>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithHalfVector] matching the given query parameters.
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
  Future<ObjectWithHalfVector?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithHalfVector] by its [id] or null if no such row exists.
  Future<ObjectWithHalfVector?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithHalfVector>(
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
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithHalfVectorTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithHalfVector.t),
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
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithHalfVectorTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithHalfVector.t),
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
    _is.SelectColumnsBuilder<ObjectWithHalfVectorTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ObjectWithHalfVector>(
      id,
      transaction: transaction,
      select: select?.call(ObjectWithHalfVector.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithHalfVector]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithHalfVector]s will have their `id` fields set.
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
  Future<List<ObjectWithHalfVector>> insert(
    _is.DatabaseSession session,
    List<ObjectWithHalfVector> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithHalfVector>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithHalfVector] and returns the inserted row.
  ///
  /// The returned [ObjectWithHalfVector] will have its `id` field set.
  Future<ObjectWithHalfVector> insertRow(
    _is.DatabaseSession session,
    ObjectWithHalfVector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithHalfVector>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithHalfVector]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithHalfVector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithHalfVector>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithHalfVector> rows, {
    required _is.ColumnSelections<ObjectWithHalfVectorTable> conflictColumns,
    _is.ColumnSelections<ObjectWithHalfVectorTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithHalfVector>(
      rows,
      conflictColumns: conflictColumns(ObjectWithHalfVector.t),
      updateColumns: updateColumns?.call(ObjectWithHalfVector.t),
      updateWhere: updateWhere?.call(ObjectWithHalfVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithHalfVector] and returns the resulting row.
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
  /// The returned [ObjectWithHalfVector] will have its `id` field set.
  Future<ObjectWithHalfVector?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithHalfVector row, {
    required _is.ColumnSelections<ObjectWithHalfVectorTable> conflictColumns,
    _is.ColumnSelections<ObjectWithHalfVectorTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithHalfVector>(
      row,
      conflictColumns: conflictColumns(ObjectWithHalfVector.t),
      updateColumns: updateColumns?.call(ObjectWithHalfVector.t),
      updateWhere: updateWhere?.call(ObjectWithHalfVector.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithHalfVector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithHalfVector>> update(
    _is.DatabaseSession session,
    List<ObjectWithHalfVector> rows, {
    _is.ColumnSelections<ObjectWithHalfVectorTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithHalfVector>(
      rows,
      columns: columns?.call(ObjectWithHalfVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithHalfVector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithHalfVector> updateRow(
    _is.DatabaseSession session,
    ObjectWithHalfVector row, {
    _is.ColumnSelections<ObjectWithHalfVectorTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithHalfVector>(
      row,
      columns: columns?.call(ObjectWithHalfVector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithHalfVector] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithHalfVector?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithHalfVectorUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithHalfVector>(
      id,
      columnValues: columnValues(ObjectWithHalfVector.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithHalfVector]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithHalfVector>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithHalfVectorUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithHalfVectorTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithHalfVector>(
      columnValues: columnValues(ObjectWithHalfVector.t.updateTable),
      where: where(ObjectWithHalfVector.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithHalfVector]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithHalfVector>> delete(
    _is.DatabaseSession session,
    List<ObjectWithHalfVector> rows, {
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithHalfVector>(
      rows,
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithHalfVector].
  Future<ObjectWithHalfVector> deleteRow(
    _is.DatabaseSession session,
    ObjectWithHalfVector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithHalfVector>(
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
  Future<List<ObjectWithHalfVector>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithHalfVectorTable> where,
    _is.OrderByBuilder<ObjectWithHalfVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithHalfVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithHalfVector>(
      where: where(ObjectWithHalfVector.t),
      orderBy: orderBy?.call(ObjectWithHalfVector.t),
      orderByList: orderByList?.call(ObjectWithHalfVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithHalfVectorTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithHalfVector>(
      where: where?.call(ObjectWithHalfVector.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithHalfVector] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithHalfVectorTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithHalfVector>(
      where: where(ObjectWithHalfVector.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

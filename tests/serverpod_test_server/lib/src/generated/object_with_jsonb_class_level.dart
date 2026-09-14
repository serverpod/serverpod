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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;

abstract class ObjectWithJsonbClassLevel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithJsonbClassLevel._({
    this.id,
    required this.implicitJsonb,
    required this.explicitJsonb,
    required this.json,
  });

  factory ObjectWithJsonbClassLevel({
    int? id,
    required List<String> implicitJsonb,
    required List<String> explicitJsonb,
    required List<String> json,
  }) = _ObjectWithJsonbClassLevelImpl;

  factory ObjectWithJsonbClassLevel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithJsonbClassLevel(
      id: jsonSerialization['id'] as int?,
      implicitJsonb: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['implicitJsonb'],
      ),
      explicitJsonb: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['explicitJsonb'],
      ),
      json: _igqrxdcj.Protocol().deserialize<List<String>>(
        jsonSerialization['json'],
      ),
    );
  }

  static final t = ObjectWithJsonbClassLevelTable();

  static const db = ObjectWithJsonbClassLevelRepository._();

  @override
  int? id;

  List<String> implicitJsonb;

  List<String> explicitJsonb;

  List<String> json;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithJsonbClassLevel copyWith({
    int? id,
    List<String>? implicitJsonb,
    List<String>? explicitJsonb,
    List<String>? json,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithJsonbClassLevel',
      if (id != null) 'id': id,
      'implicitJsonb': implicitJsonb.toJson(),
      'explicitJsonb': explicitJsonb.toJson(),
      'json': json.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithJsonbClassLevel',
      if (id != null) 'id': id,
      'implicitJsonb': implicitJsonb.toJson(),
      'explicitJsonb': explicitJsonb.toJson(),
      'json': json.toJson(),
    };
  }

  /// Builds a complete [ObjectWithJsonbClassLevelInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithJsonbClassLevelInclude include() {
    return ObjectWithJsonbClassLevelInclude._();
  }

  /// Builds a complete [ObjectWithJsonbClassLevelIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ObjectWithJsonbClassLevelIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    ObjectWithJsonbClassLevelInclude? include,
  }) {
    return ObjectWithJsonbClassLevelIncludeList._(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ObjectWithJsonbClassLevelJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ObjectWithJsonbClassLevelJsonInclude includeJson({
    _is.SelectColumnsBuilder<ObjectWithJsonbClassLevelTable>? select,
  }) {
    return _ObjectWithJsonbClassLevelJsonInclude._(
      selectedColumns: select?.call(ObjectWithJsonbClassLevel.t),
    );
  }

  /// Builds a JSON-compatible [ObjectWithJsonbClassLevelJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ObjectWithJsonbClassLevelJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    ObjectWithJsonbClassLevelJsonInclude? include,
    _is.SelectColumnsBuilder<ObjectWithJsonbClassLevelTable>? select,
  }) {
    return _ObjectWithJsonbClassLevelJsonIncludeList._(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      include: include,
      selectedColumns: select?.call(ObjectWithJsonbClassLevel.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithJsonbClassLevelImpl extends ObjectWithJsonbClassLevel {
  _ObjectWithJsonbClassLevelImpl({
    int? id,
    required List<String> implicitJsonb,
    required List<String> explicitJsonb,
    required List<String> json,
  }) : super._(
         id: id,
         implicitJsonb: implicitJsonb,
         explicitJsonb: explicitJsonb,
         json: json,
       );

  /// Returns a shallow copy of this [ObjectWithJsonbClassLevel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithJsonbClassLevel copyWith({
    Object? id = _Undefined,
    List<String>? implicitJsonb,
    List<String>? explicitJsonb,
    List<String>? json,
  }) {
    return ObjectWithJsonbClassLevel(
      id: id is int? ? id : this.id,
      implicitJsonb:
          implicitJsonb ?? this.implicitJsonb.map((e0) => e0).toList(),
      explicitJsonb:
          explicitJsonb ?? this.explicitJsonb.map((e0) => e0).toList(),
      json: json ?? this.json.map((e0) => e0).toList(),
    );
  }
}

class ObjectWithJsonbClassLevelUpdateTable
    extends _is.UpdateTable<ObjectWithJsonbClassLevelTable> {
  ObjectWithJsonbClassLevelUpdateTable(super.table);

  _is.ColumnValue<List<String>, List<String>> implicitJsonb(
    List<String> value,
  ) => _is.ColumnValue(
    table.implicitJsonb,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> explicitJsonb(
    List<String> value,
  ) => _is.ColumnValue(
    table.explicitJsonb,
    value,
  );

  _is.ColumnValue<List<String>, List<String>> json(List<String> value) =>
      _is.ColumnValue(
        table.json,
        value,
      );
}

class ObjectWithJsonbClassLevelTable extends _is.Table<int?> {
  ObjectWithJsonbClassLevelTable({super.tableRelation})
    : super(tableName: 'object_with_jsonb_class_level') {
    updateTable = ObjectWithJsonbClassLevelUpdateTable(this);
    implicitJsonb = _is.ColumnStructured<List<String>>(
      'implicitJsonb',
      this,
    );
    explicitJsonb = _is.ColumnStructured<List<String>>(
      'explicitJsonb',
      this,
    );
    json = _is.ColumnSerializable<List<String>>(
      'json',
      this,
    );
  }

  late final ObjectWithJsonbClassLevelUpdateTable updateTable;

  late final _is.ColumnStructured<List<String>> implicitJsonb;

  late final _is.ColumnStructured<List<String>> explicitJsonb;

  late final _is.ColumnSerializable<List<String>> json;

  @override
  List<_is.Column> get columns => [
    id,
    implicitJsonb,
    explicitJsonb,
    json,
  ];
}

abstract interface class ObjectWithJsonbClassLevelJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ObjectWithJsonbClassLevelJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ObjectWithJsonbClassLevelInclude extends _is.IncludeObject
    implements ObjectWithJsonbClassLevelJsonInclude, _is.FullModelInclude {
  ObjectWithJsonbClassLevelInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithJsonbClassLevel.t;
}

final class ObjectWithJsonbClassLevelIncludeList extends _is.IncludeList
    implements ObjectWithJsonbClassLevelJsonIncludeList, _is.FullModelInclude {
  ObjectWithJsonbClassLevelIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithJsonbClassLevelInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithJsonbClassLevel.t;
}

final class _ObjectWithJsonbClassLevelJsonInclude extends _is.IncludeObject
    implements ObjectWithJsonbClassLevelJsonInclude {
  _ObjectWithJsonbClassLevelJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithJsonbClassLevel.t;
}

final class _ObjectWithJsonbClassLevelJsonIncludeList extends _is.IncludeList
    implements ObjectWithJsonbClassLevelJsonIncludeList {
  _ObjectWithJsonbClassLevelJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ObjectWithJsonbClassLevelJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithJsonbClassLevel.t;
}

class ObjectWithJsonbClassLevelRepository {
  const ObjectWithJsonbClassLevelRepository._();

  /// Returns a list of [ObjectWithJsonbClassLevel]s matching the given query parameters.
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
  Future<List<ObjectWithJsonbClassLevel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithJsonbClassLevel] matching the given query parameters.
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
  Future<ObjectWithJsonbClassLevel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithJsonbClassLevel] by its [id] or null if no such row exists.
  Future<ObjectWithJsonbClassLevel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithJsonbClassLevel>(
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
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithJsonbClassLevelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithJsonbClassLevel.t),
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
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithJsonbClassLevelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithJsonbClassLevel.t),
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
    _is.SelectColumnsBuilder<ObjectWithJsonbClassLevelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ObjectWithJsonbClassLevel>(
      id,
      transaction: transaction,
      select: select?.call(ObjectWithJsonbClassLevel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithJsonbClassLevel]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithJsonbClassLevel]s will have their `id` fields set.
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
  Future<List<ObjectWithJsonbClassLevel>> insert(
    _is.DatabaseSession session,
    List<ObjectWithJsonbClassLevel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithJsonbClassLevel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithJsonbClassLevel] and returns the inserted row.
  ///
  /// The returned [ObjectWithJsonbClassLevel] will have its `id` field set.
  Future<ObjectWithJsonbClassLevel> insertRow(
    _is.DatabaseSession session,
    ObjectWithJsonbClassLevel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithJsonbClassLevel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithJsonbClassLevel]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithJsonbClassLevel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithJsonbClassLevel>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithJsonbClassLevel> rows, {
    required _is.ColumnSelections<ObjectWithJsonbClassLevelTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithJsonbClassLevelTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithJsonbClassLevel>(
      rows,
      conflictColumns: conflictColumns(ObjectWithJsonbClassLevel.t),
      updateColumns: updateColumns?.call(ObjectWithJsonbClassLevel.t),
      updateWhere: updateWhere?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithJsonbClassLevel] and returns the resulting row.
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
  /// The returned [ObjectWithJsonbClassLevel] will have its `id` field set.
  Future<ObjectWithJsonbClassLevel?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithJsonbClassLevel row, {
    required _is.ColumnSelections<ObjectWithJsonbClassLevelTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithJsonbClassLevelTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithJsonbClassLevel>(
      row,
      conflictColumns: conflictColumns(ObjectWithJsonbClassLevel.t),
      updateColumns: updateColumns?.call(ObjectWithJsonbClassLevel.t),
      updateWhere: updateWhere?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonbClassLevel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithJsonbClassLevel>> update(
    _is.DatabaseSession session,
    List<ObjectWithJsonbClassLevel> rows, {
    _is.ColumnSelections<ObjectWithJsonbClassLevelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithJsonbClassLevel>(
      rows,
      columns: columns?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithJsonbClassLevel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithJsonbClassLevel> updateRow(
    _is.DatabaseSession session,
    ObjectWithJsonbClassLevel row, {
    _is.ColumnSelections<ObjectWithJsonbClassLevelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithJsonbClassLevel>(
      row,
      columns: columns?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithJsonbClassLevel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithJsonbClassLevel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithJsonbClassLevelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithJsonbClassLevel>(
      id,
      columnValues: columnValues(ObjectWithJsonbClassLevel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithJsonbClassLevel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithJsonbClassLevel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithJsonbClassLevelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithJsonbClassLevel>(
      columnValues: columnValues(ObjectWithJsonbClassLevel.t.updateTable),
      where: where(ObjectWithJsonbClassLevel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithJsonbClassLevel]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithJsonbClassLevel>> delete(
    _is.DatabaseSession session,
    List<ObjectWithJsonbClassLevel> rows, {
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithJsonbClassLevel>(
      rows,
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithJsonbClassLevel].
  Future<ObjectWithJsonbClassLevel> deleteRow(
    _is.DatabaseSession session,
    ObjectWithJsonbClassLevel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithJsonbClassLevel>(
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
  Future<List<ObjectWithJsonbClassLevel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable> where,
    _is.OrderByBuilder<ObjectWithJsonbClassLevelTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithJsonbClassLevelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithJsonbClassLevel>(
      where: where(ObjectWithJsonbClassLevel.t),
      orderBy: orderBy?.call(ObjectWithJsonbClassLevel.t),
      orderByList: orderByList?.call(ObjectWithJsonbClassLevel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithJsonbClassLevel>(
      where: where?.call(ObjectWithJsonbClassLevel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithJsonbClassLevel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithJsonbClassLevelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithJsonbClassLevel>(
      where: where(ObjectWithJsonbClassLevel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

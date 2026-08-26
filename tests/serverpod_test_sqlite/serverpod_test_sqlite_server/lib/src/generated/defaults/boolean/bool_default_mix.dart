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

abstract class BoolDefaultMix
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BoolDefaultMix._({
    this.id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) : boolDefaultAndDefaultModel = boolDefaultAndDefaultModel ?? false,
       boolDefaultAndDefaultPersist = boolDefaultAndDefaultPersist ?? true,
       boolDefaultModelAndDefaultPersist =
           boolDefaultModelAndDefaultPersist ?? true;

  factory BoolDefaultMix({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) = _BoolDefaultMixImpl;

  factory BoolDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefaultMix(
      id: jsonSerialization['id'] as int?,
      boolDefaultAndDefaultModel:
          jsonSerialization['boolDefaultAndDefaultModel'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['boolDefaultAndDefaultModel'],
            ),
      boolDefaultAndDefaultPersist:
          jsonSerialization['boolDefaultAndDefaultPersist'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['boolDefaultAndDefaultPersist'],
            ),
      boolDefaultModelAndDefaultPersist:
          jsonSerialization['boolDefaultModelAndDefaultPersist'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['boolDefaultModelAndDefaultPersist'],
            ),
    );
  }

  static final t = BoolDefaultMixTable();

  static const db = BoolDefaultMixRepository._();

  @override
  int? id;

  bool boolDefaultAndDefaultModel;

  bool boolDefaultAndDefaultPersist;

  bool boolDefaultModelAndDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BoolDefaultMix copyWith({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoolDefaultMix',
      if (id != null) 'id': id,
      'boolDefaultAndDefaultModel': boolDefaultAndDefaultModel,
      'boolDefaultAndDefaultPersist': boolDefaultAndDefaultPersist,
      'boolDefaultModelAndDefaultPersist': boolDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BoolDefaultMix',
      if (id != null) 'id': id,
      'boolDefaultAndDefaultModel': boolDefaultAndDefaultModel,
      'boolDefaultAndDefaultPersist': boolDefaultAndDefaultPersist,
      'boolDefaultModelAndDefaultPersist': boolDefaultModelAndDefaultPersist,
    };
  }

  /// Builds a complete [BoolDefaultMixInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static BoolDefaultMixInclude include() {
    return BoolDefaultMixInclude._();
  }

  /// Builds a complete [BoolDefaultMixIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static BoolDefaultMixIncludeList includeList({
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    BoolDefaultMixInclude? include,
  }) {
    return BoolDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [BoolDefaultMixJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static BoolDefaultMixJsonInclude includeJson({
    _is.SelectColumnsBuilder<BoolDefaultMixTable>? select,
  }) {
    return _BoolDefaultMixJsonInclude._(
      selectedColumns: select?.call(BoolDefaultMix.t),
    );
  }

  /// Builds a JSON-compatible [BoolDefaultMixJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static BoolDefaultMixJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    BoolDefaultMixJsonInclude? include,
    _is.SelectColumnsBuilder<BoolDefaultMixTable>? select,
  }) {
    return _BoolDefaultMixJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      include: include,
      selectedColumns: select?.call(BoolDefaultMix.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultMixImpl extends BoolDefaultMix {
  _BoolDefaultMixImpl({
    int? id,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         boolDefaultAndDefaultModel: boolDefaultAndDefaultModel,
         boolDefaultAndDefaultPersist: boolDefaultAndDefaultPersist,
         boolDefaultModelAndDefaultPersist: boolDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [BoolDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BoolDefaultMix copyWith({
    Object? id = _Undefined,
    bool? boolDefaultAndDefaultModel,
    bool? boolDefaultAndDefaultPersist,
    bool? boolDefaultModelAndDefaultPersist,
  }) {
    return BoolDefaultMix(
      id: id is int? ? id : this.id,
      boolDefaultAndDefaultModel:
          boolDefaultAndDefaultModel ?? this.boolDefaultAndDefaultModel,
      boolDefaultAndDefaultPersist:
          boolDefaultAndDefaultPersist ?? this.boolDefaultAndDefaultPersist,
      boolDefaultModelAndDefaultPersist:
          boolDefaultModelAndDefaultPersist ??
          this.boolDefaultModelAndDefaultPersist,
    );
  }
}

class BoolDefaultMixUpdateTable extends _is.UpdateTable<BoolDefaultMixTable> {
  BoolDefaultMixUpdateTable(super.table);

  _is.ColumnValue<bool, bool> boolDefaultAndDefaultModel(bool value) =>
      _is.ColumnValue(
        table.boolDefaultAndDefaultModel,
        value,
      );

  _is.ColumnValue<bool, bool> boolDefaultAndDefaultPersist(bool value) =>
      _is.ColumnValue(
        table.boolDefaultAndDefaultPersist,
        value,
      );

  _is.ColumnValue<bool, bool> boolDefaultModelAndDefaultPersist(bool value) =>
      _is.ColumnValue(
        table.boolDefaultModelAndDefaultPersist,
        value,
      );
}

class BoolDefaultMixTable extends _is.Table<int?> {
  BoolDefaultMixTable({super.tableRelation})
    : super(tableName: 'bool_default_mix') {
    updateTable = BoolDefaultMixUpdateTable(this);
    boolDefaultAndDefaultModel = _is.ColumnBool(
      'boolDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    boolDefaultAndDefaultPersist = _is.ColumnBool(
      'boolDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    boolDefaultModelAndDefaultPersist = _is.ColumnBool(
      'boolDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final BoolDefaultMixUpdateTable updateTable;

  late final _is.ColumnBool boolDefaultAndDefaultModel;

  late final _is.ColumnBool boolDefaultAndDefaultPersist;

  late final _is.ColumnBool boolDefaultModelAndDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    boolDefaultAndDefaultModel,
    boolDefaultAndDefaultPersist,
    boolDefaultModelAndDefaultPersist,
  ];
}

abstract interface class BoolDefaultMixJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class BoolDefaultMixJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class BoolDefaultMixInclude extends _is.IncludeObject
    implements BoolDefaultMixJsonInclude, _is.FullModelInclude {
  BoolDefaultMixInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BoolDefaultMix.t;
}

final class BoolDefaultMixIncludeList extends _is.IncludeList
    implements BoolDefaultMixJsonIncludeList, _is.FullModelInclude {
  BoolDefaultMixIncludeList._({
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    BoolDefaultMixInclude? super.include,
  }) {
    super.where = where?.call(BoolDefaultMix.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BoolDefaultMix.t;
}

final class _BoolDefaultMixJsonInclude extends _is.IncludeObject
    implements BoolDefaultMixJsonInclude {
  _BoolDefaultMixJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BoolDefaultMix.t;
}

final class _BoolDefaultMixJsonIncludeList extends _is.IncludeList
    implements BoolDefaultMixJsonIncludeList {
  _BoolDefaultMixJsonIncludeList._({
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    BoolDefaultMixJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(BoolDefaultMix.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BoolDefaultMix.t;
}

class BoolDefaultMixRepository {
  const BoolDefaultMixRepository._();

  /// Returns a list of [BoolDefaultMix]s matching the given query parameters.
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
  Future<List<BoolDefaultMix>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BoolDefaultMix] matching the given query parameters.
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
  Future<BoolDefaultMix?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BoolDefaultMix] by its [id] or null if no such row exists.
  Future<BoolDefaultMix?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BoolDefaultMix>(
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
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BoolDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(BoolDefaultMix.t),
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
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BoolDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(BoolDefaultMix.t),
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
    _is.SelectColumnsBuilder<BoolDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<BoolDefaultMix>(
      id,
      transaction: transaction,
      select: select?.call(BoolDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BoolDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [BoolDefaultMix]s will have their `id` fields set.
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
  Future<List<BoolDefaultMix>> insert(
    _is.DatabaseSession session,
    List<BoolDefaultMix> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BoolDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BoolDefaultMix] and returns the inserted row.
  ///
  /// The returned [BoolDefaultMix] will have its `id` field set.
  Future<BoolDefaultMix> insertRow(
    _is.DatabaseSession session,
    BoolDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoolDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BoolDefaultMix]s in the list and returns the resulting rows.
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
  /// The returned [BoolDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BoolDefaultMix>> upsert(
    _is.DatabaseSession session,
    List<BoolDefaultMix> rows, {
    required _is.ColumnSelections<BoolDefaultMixTable> conflictColumns,
    _is.ColumnSelections<BoolDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BoolDefaultMix>(
      rows,
      conflictColumns: conflictColumns(BoolDefaultMix.t),
      updateColumns: updateColumns?.call(BoolDefaultMix.t),
      updateWhere: updateWhere?.call(BoolDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BoolDefaultMix] and returns the resulting row.
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
  /// The returned [BoolDefaultMix] will have its `id` field set.
  Future<BoolDefaultMix?> upsertRow(
    _is.DatabaseSession session,
    BoolDefaultMix row, {
    required _is.ColumnSelections<BoolDefaultMixTable> conflictColumns,
    _is.ColumnSelections<BoolDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BoolDefaultMix>(
      row,
      conflictColumns: conflictColumns(BoolDefaultMix.t),
      updateColumns: updateColumns?.call(BoolDefaultMix.t),
      updateWhere: updateWhere?.call(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates all [BoolDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BoolDefaultMix>> update(
    _is.DatabaseSession session,
    List<BoolDefaultMix> rows, {
    _is.ColumnSelections<BoolDefaultMixTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BoolDefaultMix>(
      rows,
      columns: columns?.call(BoolDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BoolDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoolDefaultMix> updateRow(
    _is.DatabaseSession session,
    BoolDefaultMix row, {
    _is.ColumnSelections<BoolDefaultMixTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoolDefaultMix>(
      row,
      columns: columns?.call(BoolDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoolDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BoolDefaultMix?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BoolDefaultMixUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BoolDefaultMix>(
      id,
      columnValues: columnValues(BoolDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BoolDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BoolDefaultMix>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BoolDefaultMixUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BoolDefaultMixTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BoolDefaultMix>(
      columnValues: columnValues(BoolDefaultMix.t.updateTable),
      where: where(BoolDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BoolDefaultMix]s in the list and returns the deleted rows.
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
  Future<List<BoolDefaultMix>> delete(
    _is.DatabaseSession session,
    List<BoolDefaultMix> rows, {
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BoolDefaultMix>(
      rows,
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BoolDefaultMix].
  Future<BoolDefaultMix> deleteRow(
    _is.DatabaseSession session,
    BoolDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoolDefaultMix>(
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
  Future<List<BoolDefaultMix>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BoolDefaultMixTable> where,
    _is.OrderByBuilder<BoolDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BoolDefaultMix>(
      where: where(BoolDefaultMix.t),
      orderBy: orderBy?.call(BoolDefaultMix.t),
      orderByList: orderByList?.call(BoolDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultMixTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BoolDefaultMix>(
      where: where?.call(BoolDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BoolDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BoolDefaultMixTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BoolDefaultMix>(
      where: where(BoolDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class IntDefaultMix
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  IntDefaultMix._({
    this.id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) : intDefaultAndDefaultModel = intDefaultAndDefaultModel ?? 20,
       intDefaultAndDefaultPersist = intDefaultAndDefaultPersist ?? 10,
       intDefaultModelAndDefaultPersist =
           intDefaultModelAndDefaultPersist ?? 10;

  factory IntDefaultMix({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) = _IntDefaultMixImpl;

  factory IntDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultMix(
      id: jsonSerialization['id'] as int?,
      intDefaultAndDefaultModel:
          jsonSerialization['intDefaultAndDefaultModel'] as int?,
      intDefaultAndDefaultPersist:
          jsonSerialization['intDefaultAndDefaultPersist'] as int?,
      intDefaultModelAndDefaultPersist:
          jsonSerialization['intDefaultModelAndDefaultPersist'] as int?,
    );
  }

  static final t = IntDefaultMixTable();

  static const db = IntDefaultMixRepository._();

  @override
  int? id;

  int intDefaultAndDefaultModel;

  int intDefaultAndDefaultPersist;

  int intDefaultModelAndDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [IntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IntDefaultMix copyWith({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IntDefaultMix',
      if (id != null) 'id': id,
      'intDefaultAndDefaultModel': intDefaultAndDefaultModel,
      'intDefaultAndDefaultPersist': intDefaultAndDefaultPersist,
      'intDefaultModelAndDefaultPersist': intDefaultModelAndDefaultPersist,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IntDefaultMix',
      if (id != null) 'id': id,
      'intDefaultAndDefaultModel': intDefaultAndDefaultModel,
      'intDefaultAndDefaultPersist': intDefaultAndDefaultPersist,
      'intDefaultModelAndDefaultPersist': intDefaultModelAndDefaultPersist,
    };
  }

  /// Builds a complete [IntDefaultMixInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static IntDefaultMixInclude include() {
    return IntDefaultMixInclude._();
  }

  /// Builds a complete [IntDefaultMixIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static IntDefaultMixIncludeList includeList({
    _is.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    IntDefaultMixInclude? include,
  }) {
    return IntDefaultMixIncludeList._(
      where: where?.call(IntDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [IntDefaultMixJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static IntDefaultMixJsonInclude includeJson({
    _is.SelectColumnsBuilder<IntDefaultMixTable>? select,
  }) {
    return _IntDefaultMixJsonInclude._(
      selectedColumns: select?.call(IntDefaultMix.t),
    );
  }

  /// Builds a JSON-compatible [IntDefaultMixJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static IntDefaultMixJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    IntDefaultMixJsonInclude? include,
    _is.SelectColumnsBuilder<IntDefaultMixTable>? select,
  }) {
    return _IntDefaultMixJsonIncludeList._(
      where: where?.call(IntDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      include: include,
      selectedColumns: select?.call(IntDefaultMix.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultMixImpl extends IntDefaultMix {
  _IntDefaultMixImpl({
    int? id,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         intDefaultAndDefaultModel: intDefaultAndDefaultModel,
         intDefaultAndDefaultPersist: intDefaultAndDefaultPersist,
         intDefaultModelAndDefaultPersist: intDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [IntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IntDefaultMix copyWith({
    Object? id = _Undefined,
    int? intDefaultAndDefaultModel,
    int? intDefaultAndDefaultPersist,
    int? intDefaultModelAndDefaultPersist,
  }) {
    return IntDefaultMix(
      id: id is int? ? id : this.id,
      intDefaultAndDefaultModel:
          intDefaultAndDefaultModel ?? this.intDefaultAndDefaultModel,
      intDefaultAndDefaultPersist:
          intDefaultAndDefaultPersist ?? this.intDefaultAndDefaultPersist,
      intDefaultModelAndDefaultPersist:
          intDefaultModelAndDefaultPersist ??
          this.intDefaultModelAndDefaultPersist,
    );
  }
}

class IntDefaultMixUpdateTable extends _is.UpdateTable<IntDefaultMixTable> {
  IntDefaultMixUpdateTable(super.table);

  _is.ColumnValue<int, int> intDefaultAndDefaultModel(int value) =>
      _is.ColumnValue(
        table.intDefaultAndDefaultModel,
        value,
      );

  _is.ColumnValue<int, int> intDefaultAndDefaultPersist(int value) =>
      _is.ColumnValue(
        table.intDefaultAndDefaultPersist,
        value,
      );

  _is.ColumnValue<int, int> intDefaultModelAndDefaultPersist(int value) =>
      _is.ColumnValue(
        table.intDefaultModelAndDefaultPersist,
        value,
      );
}

class IntDefaultMixTable extends _is.Table<int?> {
  IntDefaultMixTable({super.tableRelation})
    : super(tableName: 'int_default_mix') {
    updateTable = IntDefaultMixUpdateTable(this);
    intDefaultAndDefaultModel = _is.ColumnInt(
      'intDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    intDefaultAndDefaultPersist = _is.ColumnInt(
      'intDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    intDefaultModelAndDefaultPersist = _is.ColumnInt(
      'intDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final IntDefaultMixUpdateTable updateTable;

  late final _is.ColumnInt intDefaultAndDefaultModel;

  late final _is.ColumnInt intDefaultAndDefaultPersist;

  late final _is.ColumnInt intDefaultModelAndDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    intDefaultAndDefaultModel,
    intDefaultAndDefaultPersist,
    intDefaultModelAndDefaultPersist,
  ];
}

abstract interface class IntDefaultMixJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class IntDefaultMixJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class IntDefaultMixInclude extends _is.IncludeObject
    implements IntDefaultMixJsonInclude, _is.FullModelInclude {
  IntDefaultMixInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IntDefaultMix.t;
}

final class IntDefaultMixIncludeList extends _is.IncludeList
    implements IntDefaultMixJsonIncludeList, _is.FullModelInclude {
  IntDefaultMixIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    IntDefaultMixInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IntDefaultMix.t;
}

final class _IntDefaultMixJsonInclude extends _is.IncludeObject
    implements IntDefaultMixJsonInclude {
  _IntDefaultMixJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IntDefaultMix.t;
}

final class _IntDefaultMixJsonIncludeList extends _is.IncludeList
    implements IntDefaultMixJsonIncludeList {
  _IntDefaultMixJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    IntDefaultMixJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IntDefaultMix.t;
}

class IntDefaultMixRepository {
  const IntDefaultMixRepository._();

  /// Returns a list of [IntDefaultMix]s matching the given query parameters.
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
  Future<List<IntDefaultMix>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IntDefaultMix] matching the given query parameters.
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
  Future<IntDefaultMix?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IntDefaultMix] by its [id] or null if no such row exists.
  Future<IntDefaultMix?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IntDefaultMix>(
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
    _is.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<IntDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(IntDefaultMix.t),
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
    _is.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<IntDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(IntDefaultMix.t),
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
    _is.SelectColumnsBuilder<IntDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<IntDefaultMix>(
      id,
      transaction: transaction,
      select: select?.call(IntDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IntDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [IntDefaultMix]s will have their `id` fields set.
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
  Future<List<IntDefaultMix>> insert(
    _is.DatabaseSession session,
    List<IntDefaultMix> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IntDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IntDefaultMix] and returns the inserted row.
  ///
  /// The returned [IntDefaultMix] will have its `id` field set.
  Future<IntDefaultMix> insertRow(
    _is.DatabaseSession session,
    IntDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IntDefaultMix]s in the list and returns the resulting rows.
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
  /// The returned [IntDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultMix>> upsert(
    _is.DatabaseSession session,
    List<IntDefaultMix> rows, {
    required _is.ColumnSelections<IntDefaultMixTable> conflictColumns,
    _is.ColumnSelections<IntDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<IntDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IntDefaultMix>(
      rows,
      conflictColumns: conflictColumns(IntDefaultMix.t),
      updateColumns: updateColumns?.call(IntDefaultMix.t),
      updateWhere: updateWhere?.call(IntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IntDefaultMix] and returns the resulting row.
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
  /// The returned [IntDefaultMix] will have its `id` field set.
  Future<IntDefaultMix?> upsertRow(
    _is.DatabaseSession session,
    IntDefaultMix row, {
    required _is.ColumnSelections<IntDefaultMixTable> conflictColumns,
    _is.ColumnSelections<IntDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<IntDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IntDefaultMix>(
      row,
      conflictColumns: conflictColumns(IntDefaultMix.t),
      updateColumns: updateColumns?.call(IntDefaultMix.t),
      updateWhere: updateWhere?.call(IntDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates all [IntDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultMix>> update(
    _is.DatabaseSession session,
    List<IntDefaultMix> rows, {
    _is.ColumnSelections<IntDefaultMixTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IntDefaultMix>(
      rows,
      columns: columns?.call(IntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IntDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IntDefaultMix> updateRow(
    _is.DatabaseSession session,
    IntDefaultMix row, {
    _is.ColumnSelections<IntDefaultMixTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntDefaultMix>(
      row,
      columns: columns?.call(IntDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IntDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IntDefaultMix?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IntDefaultMixUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IntDefaultMix>(
      id,
      columnValues: columnValues(IntDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IntDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultMix>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IntDefaultMixUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<IntDefaultMixTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IntDefaultMix>(
      columnValues: columnValues(IntDefaultMix.t.updateTable),
      where: where(IntDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IntDefaultMix]s in the list and returns the deleted rows.
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
  Future<List<IntDefaultMix>> delete(
    _is.DatabaseSession session,
    List<IntDefaultMix> rows, {
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IntDefaultMix>(
      rows,
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IntDefaultMix].
  Future<IntDefaultMix> deleteRow(
    _is.DatabaseSession session,
    IntDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntDefaultMix>(
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
  Future<List<IntDefaultMix>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IntDefaultMixTable> where,
    _is.OrderByBuilder<IntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IntDefaultMix>(
      where: where(IntDefaultMix.t),
      orderBy: orderBy?.call(IntDefaultMix.t),
      orderByList: orderByList?.call(IntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultMixTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IntDefaultMix>(
      where: where?.call(IntDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IntDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IntDefaultMixTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IntDefaultMix>(
      where: where(IntDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

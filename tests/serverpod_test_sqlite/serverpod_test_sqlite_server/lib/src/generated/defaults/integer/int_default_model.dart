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

abstract class IntDefaultModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  IntDefaultModel._({
    this.id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) : intDefaultModel = intDefaultModel ?? 10,
       intDefaultModelNull = intDefaultModelNull ?? 20;

  factory IntDefaultModel({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) = _IntDefaultModelImpl;

  factory IntDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultModel(
      id: jsonSerialization['id'] as int?,
      intDefaultModel: jsonSerialization['intDefaultModel'] as int?,
      intDefaultModelNull: jsonSerialization['intDefaultModelNull'] as int?,
    );
  }

  static final t = IntDefaultModelTable();

  static const db = IntDefaultModelRepository._();

  @override
  int? id;

  int intDefaultModel;

  int intDefaultModelNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [IntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IntDefaultModel copyWith({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IntDefaultModel',
      if (id != null) 'id': id,
      'intDefaultModel': intDefaultModel,
      'intDefaultModelNull': intDefaultModelNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IntDefaultModel',
      if (id != null) 'id': id,
      'intDefaultModel': intDefaultModel,
      'intDefaultModelNull': intDefaultModelNull,
    };
  }

  /// Builds a complete [IntDefaultModelInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static IntDefaultModelInclude include() {
    return IntDefaultModelInclude._();
  }

  /// Builds a complete [IntDefaultModelIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static IntDefaultModelIncludeList includeList({
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    IntDefaultModelInclude? include,
  }) {
    return IntDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [IntDefaultModelJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static IntDefaultModelJsonInclude includeJson({
    _is.SelectColumnsBuilder<IntDefaultModelTable>? select,
  }) {
    return _IntDefaultModelJsonInclude._(
      selectedColumns: select?.call(IntDefaultModel.t),
    );
  }

  /// Builds a JSON-compatible [IntDefaultModelJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static IntDefaultModelJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    IntDefaultModelJsonInclude? include,
    _is.SelectColumnsBuilder<IntDefaultModelTable>? select,
  }) {
    return _IntDefaultModelJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      include: include,
      selectedColumns: select?.call(IntDefaultModel.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultModelImpl extends IntDefaultModel {
  _IntDefaultModelImpl({
    int? id,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) : super._(
         id: id,
         intDefaultModel: intDefaultModel,
         intDefaultModelNull: intDefaultModelNull,
       );

  /// Returns a shallow copy of this [IntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IntDefaultModel copyWith({
    Object? id = _Undefined,
    int? intDefaultModel,
    int? intDefaultModelNull,
  }) {
    return IntDefaultModel(
      id: id is int? ? id : this.id,
      intDefaultModel: intDefaultModel ?? this.intDefaultModel,
      intDefaultModelNull: intDefaultModelNull ?? this.intDefaultModelNull,
    );
  }
}

class IntDefaultModelUpdateTable extends _is.UpdateTable<IntDefaultModelTable> {
  IntDefaultModelUpdateTable(super.table);

  _is.ColumnValue<int, int> intDefaultModel(int value) => _is.ColumnValue(
    table.intDefaultModel,
    value,
  );

  _is.ColumnValue<int, int> intDefaultModelNull(int value) => _is.ColumnValue(
    table.intDefaultModelNull,
    value,
  );
}

class IntDefaultModelTable extends _is.Table<int?> {
  IntDefaultModelTable({super.tableRelation})
    : super(tableName: 'int_default_model') {
    updateTable = IntDefaultModelUpdateTable(this);
    intDefaultModel = _is.ColumnInt(
      'intDefaultModel',
      this,
    );
    intDefaultModelNull = _is.ColumnInt(
      'intDefaultModelNull',
      this,
    );
  }

  late final IntDefaultModelUpdateTable updateTable;

  late final _is.ColumnInt intDefaultModel;

  late final _is.ColumnInt intDefaultModelNull;

  @override
  List<_is.Column> get columns => [
    id,
    intDefaultModel,
    intDefaultModelNull,
  ];
}

abstract interface class IntDefaultModelJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class IntDefaultModelJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class IntDefaultModelInclude extends _is.IncludeObject
    implements IntDefaultModelJsonInclude, _is.FullModelInclude {
  IntDefaultModelInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IntDefaultModel.t;
}

final class IntDefaultModelIncludeList extends _is.IncludeList
    implements IntDefaultModelJsonIncludeList, _is.FullModelInclude {
  IntDefaultModelIncludeList._({
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    IntDefaultModelInclude? super.include,
  }) {
    super.where = where?.call(IntDefaultModel.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IntDefaultModel.t;
}

final class _IntDefaultModelJsonInclude extends _is.IncludeObject
    implements IntDefaultModelJsonInclude {
  _IntDefaultModelJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => IntDefaultModel.t;
}

final class _IntDefaultModelJsonIncludeList extends _is.IncludeList
    implements IntDefaultModelJsonIncludeList {
  _IntDefaultModelJsonIncludeList._({
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    IntDefaultModelJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(IntDefaultModel.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => IntDefaultModel.t;
}

class IntDefaultModelRepository {
  const IntDefaultModelRepository._();

  /// Returns a list of [IntDefaultModel]s matching the given query parameters.
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
  Future<List<IntDefaultModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [IntDefaultModel] matching the given query parameters.
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
  Future<IntDefaultModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [IntDefaultModel] by its [id] or null if no such row exists.
  Future<IntDefaultModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<IntDefaultModel>(
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
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<IntDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(IntDefaultModel.t),
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
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<IntDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(IntDefaultModel.t),
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
    _is.SelectColumnsBuilder<IntDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<IntDefaultModel>(
      id,
      transaction: transaction,
      select: select?.call(IntDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [IntDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [IntDefaultModel]s will have their `id` fields set.
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
  Future<List<IntDefaultModel>> insert(
    _is.DatabaseSession session,
    List<IntDefaultModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<IntDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [IntDefaultModel] and returns the inserted row.
  ///
  /// The returned [IntDefaultModel] will have its `id` field set.
  Future<IntDefaultModel> insertRow(
    _is.DatabaseSession session,
    IntDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<IntDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [IntDefaultModel]s in the list and returns the resulting rows.
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
  /// The returned [IntDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultModel>> upsert(
    _is.DatabaseSession session,
    List<IntDefaultModel> rows, {
    required _is.ColumnSelections<IntDefaultModelTable> conflictColumns,
    _is.ColumnSelections<IntDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<IntDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<IntDefaultModel>(
      rows,
      conflictColumns: conflictColumns(IntDefaultModel.t),
      updateColumns: updateColumns?.call(IntDefaultModel.t),
      updateWhere: updateWhere?.call(IntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [IntDefaultModel] and returns the resulting row.
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
  /// The returned [IntDefaultModel] will have its `id` field set.
  Future<IntDefaultModel?> upsertRow(
    _is.DatabaseSession session,
    IntDefaultModel row, {
    required _is.ColumnSelections<IntDefaultModelTable> conflictColumns,
    _is.ColumnSelections<IntDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<IntDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<IntDefaultModel>(
      row,
      conflictColumns: conflictColumns(IntDefaultModel.t),
      updateColumns: updateColumns?.call(IntDefaultModel.t),
      updateWhere: updateWhere?.call(IntDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [IntDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultModel>> update(
    _is.DatabaseSession session,
    List<IntDefaultModel> rows, {
    _is.ColumnSelections<IntDefaultModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<IntDefaultModel>(
      rows,
      columns: columns?.call(IntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [IntDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<IntDefaultModel> updateRow(
    _is.DatabaseSession session,
    IntDefaultModel row, {
    _is.ColumnSelections<IntDefaultModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<IntDefaultModel>(
      row,
      columns: columns?.call(IntDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [IntDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<IntDefaultModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<IntDefaultModelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<IntDefaultModel>(
      id,
      columnValues: columnValues(IntDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [IntDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<IntDefaultModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<IntDefaultModelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<IntDefaultModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<IntDefaultModel>(
      columnValues: columnValues(IntDefaultModel.t.updateTable),
      where: where(IntDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [IntDefaultModel]s in the list and returns the deleted rows.
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
  Future<List<IntDefaultModel>> delete(
    _is.DatabaseSession session,
    List<IntDefaultModel> rows, {
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<IntDefaultModel>(
      rows,
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [IntDefaultModel].
  Future<IntDefaultModel> deleteRow(
    _is.DatabaseSession session,
    IntDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<IntDefaultModel>(
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
  Future<List<IntDefaultModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IntDefaultModelTable> where,
    _is.OrderByBuilder<IntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<IntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<IntDefaultModel>(
      where: where(IntDefaultModel.t),
      orderBy: orderBy?.call(IntDefaultModel.t),
      orderByList: orderByList?.call(IntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<IntDefaultModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<IntDefaultModel>(
      where: where?.call(IntDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [IntDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<IntDefaultModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<IntDefaultModel>(
      where: where(IntDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

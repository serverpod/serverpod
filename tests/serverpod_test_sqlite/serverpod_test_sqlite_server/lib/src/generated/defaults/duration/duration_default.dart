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

abstract class DurationDefault
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DurationDefault._({
    this.id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  }) : durationDefault =
           durationDefault ??
           const Duration(
             days: 1,
             hours: 2,
             minutes: 10,
             seconds: 30,
             milliseconds: 100,
           ),
       durationDefaultNull =
           durationDefaultNull ??
           const Duration(
             days: 2,
             hours: 1,
             minutes: 20,
             seconds: 40,
             milliseconds: 100,
           );

  factory DurationDefault({
    int? id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  }) = _DurationDefaultImpl;

  factory DurationDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DurationDefault(
      id: jsonSerialization['id'] as int?,
      durationDefault: jsonSerialization['durationDefault'] == null
          ? null
          : _is.DurationJsonExtension.fromJson(
              jsonSerialization['durationDefault'],
            ),
      durationDefaultNull: jsonSerialization['durationDefaultNull'] == null
          ? null
          : _is.DurationJsonExtension.fromJson(
              jsonSerialization['durationDefaultNull'],
            ),
    );
  }

  static final t = DurationDefaultTable();

  static const db = DurationDefaultRepository._();

  @override
  int? id;

  Duration durationDefault;

  Duration? durationDefaultNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DurationDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DurationDefault copyWith({
    int? id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DurationDefault',
      if (id != null) 'id': id,
      'durationDefault': durationDefault.toJson(),
      if (durationDefaultNull != null)
        'durationDefaultNull': durationDefaultNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DurationDefault',
      if (id != null) 'id': id,
      'durationDefault': durationDefault.toJson(),
      if (durationDefaultNull != null)
        'durationDefaultNull': durationDefaultNull?.toJson(),
    };
  }

  static DurationDefaultInclude include({
    _is.SelectColumnsBuilder<DurationDefaultTable>? select,
  }) {
    return DurationDefaultInclude._(
      selectedColumns: select?.call(DurationDefault.t),
    );
  }

  static DurationDefaultIncludeList includeList({
    _is.WhereExpressionBuilder<DurationDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    DurationDefaultInclude? include,
    _is.SelectColumnsBuilder<DurationDefaultTable>? select,
  }) {
    return DurationDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      include: include,
      selectedColumns: select?.call(DurationDefault.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DurationDefaultImpl extends DurationDefault {
  _DurationDefaultImpl({
    int? id,
    Duration? durationDefault,
    Duration? durationDefaultNull,
  }) : super._(
         id: id,
         durationDefault: durationDefault,
         durationDefaultNull: durationDefaultNull,
       );

  /// Returns a shallow copy of this [DurationDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DurationDefault copyWith({
    Object? id = _Undefined,
    Duration? durationDefault,
    Object? durationDefaultNull = _Undefined,
  }) {
    return DurationDefault(
      id: id is int? ? id : this.id,
      durationDefault: durationDefault ?? this.durationDefault,
      durationDefaultNull: durationDefaultNull is Duration?
          ? durationDefaultNull
          : this.durationDefaultNull,
    );
  }
}

class DurationDefaultUpdateTable extends _is.UpdateTable<DurationDefaultTable> {
  DurationDefaultUpdateTable(super.table);

  _is.ColumnValue<Duration, Duration> durationDefault(Duration value) =>
      _is.ColumnValue(
        table.durationDefault,
        value,
      );

  _is.ColumnValue<Duration, Duration> durationDefaultNull(Duration? value) =>
      _is.ColumnValue(
        table.durationDefaultNull,
        value,
      );
}

class DurationDefaultTable extends _is.Table<int?> {
  DurationDefaultTable({super.tableRelation})
    : super(tableName: 'duration_default') {
    updateTable = DurationDefaultUpdateTable(this);
    durationDefault = _is.ColumnDuration(
      'durationDefault',
      this,
      hasDefault: true,
    );
    durationDefaultNull = _is.ColumnDuration(
      'durationDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final DurationDefaultUpdateTable updateTable;

  late final _is.ColumnDuration durationDefault;

  late final _is.ColumnDuration durationDefaultNull;

  @override
  List<_is.Column> get columns => [
    id,
    durationDefault,
    durationDefaultNull,
  ];
}

class DurationDefaultInclude extends _is.IncludeObject {
  DurationDefaultInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DurationDefault.t;
}

class DurationDefaultIncludeList extends _is.IncludeList {
  DurationDefaultIncludeList._({
    _is.WhereExpressionBuilder<DurationDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(DurationDefault.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DurationDefault.t;
}

class DurationDefaultRepository {
  const DurationDefaultRepository._();

  /// Returns a list of [DurationDefault]s matching the given query parameters.
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
  Future<List<DurationDefault>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DurationDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DurationDefault>(
      where: where?.call(DurationDefault.t),
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DurationDefault] matching the given query parameters.
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
  Future<DurationDefault?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DurationDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DurationDefault>(
      where: where?.call(DurationDefault.t),
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DurationDefault] by its [id] or null if no such row exists.
  Future<DurationDefault?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DurationDefault>(
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
    _is.WhereExpressionBuilder<DurationDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DurationDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<DurationDefault>(
      where: where?.call(DurationDefault.t),
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(DurationDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
    _is.WhereExpressionBuilder<DurationDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DurationDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<DurationDefault>(
      where: where?.call(DurationDefault.t),
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(DurationDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DurationDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<DurationDefault>(
      id,
      transaction: transaction,
      select: select?.call(DurationDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DurationDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [DurationDefault]s will have their `id` fields set.
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
  Future<List<DurationDefault>> insert(
    _is.DatabaseSession session,
    List<DurationDefault> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DurationDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DurationDefault] and returns the inserted row.
  ///
  /// The returned [DurationDefault] will have its `id` field set.
  Future<DurationDefault> insertRow(
    _is.DatabaseSession session,
    DurationDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DurationDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DurationDefault]s in the list and returns the resulting rows.
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
  /// The returned [DurationDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DurationDefault>> upsert(
    _is.DatabaseSession session,
    List<DurationDefault> rows, {
    required _is.ColumnSelections<DurationDefaultTable> conflictColumns,
    _is.ColumnSelections<DurationDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<DurationDefaultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DurationDefault>(
      rows,
      conflictColumns: conflictColumns(DurationDefault.t),
      updateColumns: updateColumns?.call(DurationDefault.t),
      updateWhere: updateWhere?.call(DurationDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DurationDefault] and returns the resulting row.
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
  /// The returned [DurationDefault] will have its `id` field set.
  Future<DurationDefault?> upsertRow(
    _is.DatabaseSession session,
    DurationDefault row, {
    required _is.ColumnSelections<DurationDefaultTable> conflictColumns,
    _is.ColumnSelections<DurationDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<DurationDefaultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DurationDefault>(
      row,
      conflictColumns: conflictColumns(DurationDefault.t),
      updateColumns: updateColumns?.call(DurationDefault.t),
      updateWhere: updateWhere?.call(DurationDefault.t),
      transaction: transaction,
    );
  }

  /// Updates all [DurationDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DurationDefault>> update(
    _is.DatabaseSession session,
    List<DurationDefault> rows, {
    _is.ColumnSelections<DurationDefaultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DurationDefault>(
      rows,
      columns: columns?.call(DurationDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DurationDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DurationDefault> updateRow(
    _is.DatabaseSession session,
    DurationDefault row, {
    _is.ColumnSelections<DurationDefaultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DurationDefault>(
      row,
      columns: columns?.call(DurationDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DurationDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DurationDefault?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DurationDefaultUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DurationDefault>(
      id,
      columnValues: columnValues(DurationDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DurationDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DurationDefault>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DurationDefaultUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DurationDefaultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DurationDefault>(
      columnValues: columnValues(DurationDefault.t.updateTable),
      where: where(DurationDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DurationDefault]s in the list and returns the deleted rows.
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
  Future<List<DurationDefault>> delete(
    _is.DatabaseSession session,
    List<DurationDefault> rows, {
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DurationDefault>(
      rows,
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DurationDefault].
  Future<DurationDefault> deleteRow(
    _is.DatabaseSession session,
    DurationDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DurationDefault>(
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
  Future<List<DurationDefault>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DurationDefaultTable> where,
    _is.OrderByBuilder<DurationDefaultTable>? orderBy,
    _is.OrderByListBuilder<DurationDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DurationDefault>(
      where: where(DurationDefault.t),
      orderBy: orderBy?.call(DurationDefault.t),
      orderByList: orderByList?.call(DurationDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DurationDefaultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DurationDefault>(
      where: where?.call(DurationDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DurationDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DurationDefaultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DurationDefault>(
      where: where(DurationDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class ObjectWithDuration
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithDuration._({
    this.id,
    required this.duration,
  });

  factory ObjectWithDuration({
    int? id,
    required Duration duration,
  }) = _ObjectWithDurationImpl;

  factory ObjectWithDuration.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithDuration(
      id: jsonSerialization['id'] as int?,
      duration: _is.DurationJsonExtension.fromJson(
        jsonSerialization['duration'],
      ),
    );
  }

  static final t = ObjectWithDurationTable();

  static const db = ObjectWithDurationRepository._();

  @override
  int? id;

  Duration duration;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithDuration]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithDuration copyWith({
    int? id,
    Duration? duration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithDuration',
      if (id != null) 'id': id,
      'duration': duration.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithDuration',
      if (id != null) 'id': id,
      'duration': duration.toJson(),
    };
  }

  static ObjectWithDurationInclude include({
    _is.SelectColumnsBuilder<ObjectWithDurationTable>? select,
  }) {
    return ObjectWithDurationInclude._(
      selectedColumns: select?.call(ObjectWithDuration.t),
    );
  }

  static ObjectWithDurationIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    ObjectWithDurationInclude? include,
    _is.SelectColumnsBuilder<ObjectWithDurationTable>? select,
  }) {
    return ObjectWithDurationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      include: include,
      selectedColumns: select?.call(ObjectWithDuration.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithDurationImpl extends ObjectWithDuration {
  _ObjectWithDurationImpl({
    int? id,
    required Duration duration,
  }) : super._(
         id: id,
         duration: duration,
       );

  /// Returns a shallow copy of this [ObjectWithDuration]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithDuration copyWith({
    Object? id = _Undefined,
    Duration? duration,
  }) {
    return ObjectWithDuration(
      id: id is int? ? id : this.id,
      duration: duration ?? this.duration,
    );
  }
}

class ObjectWithDurationUpdateTable
    extends _is.UpdateTable<ObjectWithDurationTable> {
  ObjectWithDurationUpdateTable(super.table);

  _is.ColumnValue<Duration, Duration> duration(Duration value) =>
      _is.ColumnValue(
        table.duration,
        value,
      );
}

class ObjectWithDurationTable extends _is.Table<int?> {
  ObjectWithDurationTable({super.tableRelation})
    : super(tableName: 'object_with_duration') {
    updateTable = ObjectWithDurationUpdateTable(this);
    duration = _is.ColumnDuration(
      'duration',
      this,
    );
  }

  late final ObjectWithDurationUpdateTable updateTable;

  late final _is.ColumnDuration duration;

  @override
  List<_is.Column> get columns => [
    id,
    duration,
  ];
}

class ObjectWithDurationInclude extends _is.IncludeObject {
  ObjectWithDurationInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithDuration.t;
}

class ObjectWithDurationIncludeList extends _is.IncludeList {
  ObjectWithDurationIncludeList._({
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithDuration.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithDuration.t;
}

class ObjectWithDurationRepository {
  const ObjectWithDurationRepository._();

  /// Returns a list of [ObjectWithDuration]s matching the given query parameters.
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
  Future<List<ObjectWithDuration>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithDuration] matching the given query parameters.
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
  Future<ObjectWithDuration?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithDuration] by its [id] or null if no such row exists.
  Future<ObjectWithDuration?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithDuration>(
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
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithDurationTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithDuration.t),
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
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithDurationTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithDuration.t),
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
    _is.SelectColumnsBuilder<ObjectWithDurationTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ObjectWithDuration>(
      id,
      transaction: transaction,
      select: select?.call(ObjectWithDuration.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithDuration]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithDuration]s will have their `id` fields set.
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
  Future<List<ObjectWithDuration>> insert(
    _is.DatabaseSession session,
    List<ObjectWithDuration> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithDuration>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithDuration] and returns the inserted row.
  ///
  /// The returned [ObjectWithDuration] will have its `id` field set.
  Future<ObjectWithDuration> insertRow(
    _is.DatabaseSession session,
    ObjectWithDuration row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithDuration>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithDuration]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithDuration]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithDuration>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithDuration> rows, {
    required _is.ColumnSelections<ObjectWithDurationTable> conflictColumns,
    _is.ColumnSelections<ObjectWithDurationTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithDuration>(
      rows,
      conflictColumns: conflictColumns(ObjectWithDuration.t),
      updateColumns: updateColumns?.call(ObjectWithDuration.t),
      updateWhere: updateWhere?.call(ObjectWithDuration.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithDuration] and returns the resulting row.
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
  /// The returned [ObjectWithDuration] will have its `id` field set.
  Future<ObjectWithDuration?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithDuration row, {
    required _is.ColumnSelections<ObjectWithDurationTable> conflictColumns,
    _is.ColumnSelections<ObjectWithDurationTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithDuration>(
      row,
      conflictColumns: conflictColumns(ObjectWithDuration.t),
      updateColumns: updateColumns?.call(ObjectWithDuration.t),
      updateWhere: updateWhere?.call(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithDuration]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithDuration>> update(
    _is.DatabaseSession session,
    List<ObjectWithDuration> rows, {
    _is.ColumnSelections<ObjectWithDurationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithDuration>(
      rows,
      columns: columns?.call(ObjectWithDuration.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithDuration]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithDuration> updateRow(
    _is.DatabaseSession session,
    ObjectWithDuration row, {
    _is.ColumnSelections<ObjectWithDurationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithDuration>(
      row,
      columns: columns?.call(ObjectWithDuration.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithDuration] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithDuration?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithDurationUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithDuration>(
      id,
      columnValues: columnValues(ObjectWithDuration.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithDuration]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithDuration>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithDurationUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithDurationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithDuration>(
      columnValues: columnValues(ObjectWithDuration.t.updateTable),
      where: where(ObjectWithDuration.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithDuration]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithDuration>> delete(
    _is.DatabaseSession session,
    List<ObjectWithDuration> rows, {
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithDuration>(
      rows,
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithDuration].
  Future<ObjectWithDuration> deleteRow(
    _is.DatabaseSession session,
    ObjectWithDuration row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithDuration>(
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
  Future<List<ObjectWithDuration>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithDurationTable> where,
    _is.OrderByBuilder<ObjectWithDurationTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithDurationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithDuration>(
      where: where(ObjectWithDuration.t),
      orderBy: orderBy?.call(ObjectWithDuration.t),
      orderByList: orderByList?.call(ObjectWithDuration.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithDurationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithDuration>(
      where: where?.call(ObjectWithDuration.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithDuration] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithDurationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithDuration>(
      where: where(ObjectWithDuration.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

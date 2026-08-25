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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;

/// Just some simple data.
abstract class SimpleDateTime
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  SimpleDateTime._({
    this.id,
    required this.dateTime,
  });

  factory SimpleDateTime({
    int? id,
    required DateTime dateTime,
  }) = _SimpleDateTimeImpl;

  factory SimpleDateTime.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDateTime(
      id: jsonSerialization['id'] as int?,
      dateTime: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['dateTime'],
      ),
    );
  }

  static final t = SimpleDateTimeTable();

  static const db = SimpleDateTimeRepository._();

  @override
  int? id;

  /// The only field of [SimpleDateTime]
  DateTime dateTime;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [SimpleDateTime]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SimpleDateTime copyWith({
    int? id,
    DateTime? dateTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SimpleDateTime',
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SimpleDateTime',
      if (id != null) 'id': id,
      'dateTime': dateTime.toJson(),
    };
  }

  static SimpleDateTimeInclude include({
    _isd.SelectColumnsBuilder<SimpleDateTimeTable>? select,
  }) {
    return SimpleDateTimeInclude._(
      selectedColumns: select?.call(SimpleDateTime.t),
    );
  }

  static SimpleDateTimeIncludeList includeList({
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    SimpleDateTimeInclude? include,
    _isd.SelectColumnsBuilder<SimpleDateTimeTable>? select,
  }) {
    return SimpleDateTimeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      include: include,
      selectedColumns: select?.call(SimpleDateTime.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SimpleDateTimeImpl extends SimpleDateTime {
  _SimpleDateTimeImpl({
    int? id,
    required DateTime dateTime,
  }) : super._(
         id: id,
         dateTime: dateTime,
       );

  /// Returns a shallow copy of this [SimpleDateTime]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SimpleDateTime copyWith({
    Object? id = _Undefined,
    DateTime? dateTime,
  }) {
    return SimpleDateTime(
      id: id is int? ? id : this.id,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}

class SimpleDateTimeUpdateTable extends _isd.UpdateTable<SimpleDateTimeTable> {
  SimpleDateTimeUpdateTable(super.table);

  _isd.ColumnValue<DateTime, DateTime> dateTime(DateTime value) =>
      _isd.ColumnValue(
        table.dateTime,
        value,
      );
}

class SimpleDateTimeTable extends _isd.Table<int?> {
  SimpleDateTimeTable({super.tableRelation})
    : super(tableName: 'simple_date_time') {
    updateTable = SimpleDateTimeUpdateTable(this);
    dateTime = _isd.ColumnDateTime(
      'dateTime',
      this,
    );
  }

  late final SimpleDateTimeUpdateTable updateTable;

  /// The only field of [SimpleDateTime]
  late final _isd.ColumnDateTime dateTime;

  @override
  List<_isd.Column> get columns => [
    id,
    dateTime,
  ];
}

class SimpleDateTimeInclude extends _isd.IncludeObject {
  SimpleDateTimeInclude._({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => SimpleDateTime.t;
}

class SimpleDateTimeIncludeList extends _isd.IncludeList {
  SimpleDateTimeIncludeList._({
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(SimpleDateTime.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => SimpleDateTime.t;
}

class SimpleDateTimeRepository {
  const SimpleDateTimeRepository._();

  /// Returns a list of [SimpleDateTime]s matching the given query parameters.
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
  Future<List<SimpleDateTime>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SimpleDateTime] matching the given query parameters.
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
  Future<SimpleDateTime?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? offset,
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SimpleDateTime] by its [id] or null if no such row exists.
  Future<SimpleDateTime?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SimpleDateTime>(
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SimpleDateTimeTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(SimpleDateTime.t),
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? offset,
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SimpleDateTimeTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(SimpleDateTime.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<SimpleDateTimeTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<SimpleDateTime>(
      id,
      transaction: transaction,
      select: select?.call(SimpleDateTime.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SimpleDateTime]s in the list and returns the inserted rows.
  ///
  /// The returned [SimpleDateTime]s will have their `id` fields set.
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
  Future<List<SimpleDateTime>> insert(
    _isd.DatabaseSession session,
    List<SimpleDateTime> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SimpleDateTime>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SimpleDateTime] and returns the inserted row.
  ///
  /// The returned [SimpleDateTime] will have its `id` field set.
  Future<SimpleDateTime> insertRow(
    _isd.DatabaseSession session,
    SimpleDateTime row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<SimpleDateTime>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SimpleDateTime]s in the list and returns the resulting rows.
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
  /// The returned [SimpleDateTime]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SimpleDateTime>> upsert(
    _isd.DatabaseSession session,
    List<SimpleDateTime> rows, {
    required _isd.ColumnSelections<SimpleDateTimeTable> conflictColumns,
    _isd.ColumnSelections<SimpleDateTimeTable>? updateColumns,
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SimpleDateTime>(
      rows,
      conflictColumns: conflictColumns(SimpleDateTime.t),
      updateColumns: updateColumns?.call(SimpleDateTime.t),
      updateWhere: updateWhere?.call(SimpleDateTime.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SimpleDateTime] and returns the resulting row.
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
  /// The returned [SimpleDateTime] will have its `id` field set.
  Future<SimpleDateTime?> upsertRow(
    _isd.DatabaseSession session,
    SimpleDateTime row, {
    required _isd.ColumnSelections<SimpleDateTimeTable> conflictColumns,
    _isd.ColumnSelections<SimpleDateTimeTable>? updateColumns,
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SimpleDateTime>(
      row,
      conflictColumns: conflictColumns(SimpleDateTime.t),
      updateColumns: updateColumns?.call(SimpleDateTime.t),
      updateWhere: updateWhere?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  /// Updates all [SimpleDateTime]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SimpleDateTime>> update(
    _isd.DatabaseSession session,
    List<SimpleDateTime> rows, {
    _isd.ColumnSelections<SimpleDateTimeTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SimpleDateTime>(
      rows,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SimpleDateTime]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SimpleDateTime> updateRow(
    _isd.DatabaseSession session,
    SimpleDateTime row, {
    _isd.ColumnSelections<SimpleDateTimeTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<SimpleDateTime>(
      row,
      columns: columns?.call(SimpleDateTime.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SimpleDateTime] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SimpleDateTime?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<SimpleDateTimeUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<SimpleDateTime>(
      id,
      columnValues: columnValues(SimpleDateTime.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SimpleDateTime]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SimpleDateTime>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<SimpleDateTimeUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<SimpleDateTimeTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SimpleDateTime>(
      columnValues: columnValues(SimpleDateTime.t.updateTable),
      where: where(SimpleDateTime.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SimpleDateTime]s in the list and returns the deleted rows.
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
  Future<List<SimpleDateTime>> delete(
    _isd.DatabaseSession session,
    List<SimpleDateTime> rows, {
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SimpleDateTime>(
      rows,
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SimpleDateTime].
  Future<SimpleDateTime> deleteRow(
    _isd.DatabaseSession session,
    SimpleDateTime row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SimpleDateTime>(
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
  Future<List<SimpleDateTime>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SimpleDateTimeTable> where,
    _isd.OrderByBuilder<SimpleDateTimeTable>? orderBy,
    _isd.OrderByListBuilder<SimpleDateTimeTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SimpleDateTime>(
      where: where(SimpleDateTime.t),
      orderBy: orderBy?.call(SimpleDateTime.t),
      orderByList: orderByList?.call(SimpleDateTime.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<SimpleDateTimeTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<SimpleDateTime>(
      where: where?.call(SimpleDateTime.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SimpleDateTime] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<SimpleDateTimeTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SimpleDateTime>(
      where: where(SimpleDateTime.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

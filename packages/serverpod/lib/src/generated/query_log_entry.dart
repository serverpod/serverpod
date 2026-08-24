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

/// A log entry for a database query.
abstract class QueryLogEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  QueryLogEntry._({
    this.id,
    required this.serverId,
    required this.sessionLogId,
    this.messageId,
    required this.query,
    required this.duration,
    this.numRows,
    this.error,
    this.stackTrace,
    required this.slow,
    required this.order,
  });

  factory QueryLogEntry({
    int? id,
    required String serverId,
    required int sessionLogId,
    int? messageId,
    required String query,
    required double duration,
    int? numRows,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) = _QueryLogEntryImpl;

  factory QueryLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueryLogEntry(
      id: jsonSerialization['id'] as int?,
      serverId: jsonSerialization['serverId'] as String,
      sessionLogId: jsonSerialization['sessionLogId'] as int,
      messageId: jsonSerialization['messageId'] as int?,
      query: jsonSerialization['query'] as String,
      duration: (jsonSerialization['duration'] as num).toDouble(),
      numRows: jsonSerialization['numRows'] as int?,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      slow: _is.BoolJsonExtension.fromJson(jsonSerialization['slow']),
      order: jsonSerialization['order'] as int,
    );
  }

  static final t = QueryLogEntryTable();

  static const db = QueryLogEntryRepository._();

  @override
  int? id;

  /// The id of the server that handled the query.
  String serverId;

  /// Id of the session this entry is associated with.
  int sessionLogId;

  /// The id of the message this entry is associated with, if the query was
  /// executed in a streaming session.
  int? messageId;

  /// The query that was executed.
  String query;

  /// The time it took to execute the query, in seconds.
  double duration;

  /// Number of rows returned by this query. This can be null if the number is
  /// not relevant.
  int? numRows;

  /// Set if an exception was thrown during the execution of this query.
  String? error;

  /// The stack trace of this query.
  String? stackTrace;

  /// True if the execution of this query was considered slow.
  bool slow;

  /// used for sorting the query log.
  int order;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [QueryLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  QueryLogEntry copyWith({
    int? id,
    String? serverId,
    int? sessionLogId,
    int? messageId,
    String? query,
    double? duration,
    int? numRows,
    String? error,
    String? stackTrace,
    bool? slow,
    int? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.QueryLogEntry',
      if (id != null) 'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      if (messageId != null) 'messageId': messageId,
      'query': query,
      'duration': duration,
      if (numRows != null) 'numRows': numRows,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.QueryLogEntry',
      if (id != null) 'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      if (messageId != null) 'messageId': messageId,
      'query': query,
      'duration': duration,
      if (numRows != null) 'numRows': numRows,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  static QueryLogEntryInclude include({
    _is.SelectColumnsBuilder<QueryLogEntryTable>? select,
  }) {
    return QueryLogEntryInclude.internal_(
      selectedColumns: select?.call(QueryLogEntry.t),
    );
  }

  static QueryLogEntryIncludeList includeList({
    _is.WhereExpressionBuilder<QueryLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueryLogEntryTable>? orderBy,
    _is.OrderByListBuilder<QueryLogEntryTable>? orderByList,
    QueryLogEntryInclude? include,
    _is.SelectColumnsBuilder<QueryLogEntryTable>? select,
  }) {
    return QueryLogEntryIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueryLogEntry.t),
      orderByList: orderByList?.call(QueryLogEntry.t),
      include: include,
      selectedColumns: select?.call(QueryLogEntry.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QueryLogEntryImpl extends QueryLogEntry {
  _QueryLogEntryImpl({
    int? id,
    required String serverId,
    required int sessionLogId,
    int? messageId,
    required String query,
    required double duration,
    int? numRows,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) : super._(
         id: id,
         serverId: serverId,
         sessionLogId: sessionLogId,
         messageId: messageId,
         query: query,
         duration: duration,
         numRows: numRows,
         error: error,
         stackTrace: stackTrace,
         slow: slow,
         order: order,
       );

  /// Returns a shallow copy of this [QueryLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  QueryLogEntry copyWith({
    Object? id = _Undefined,
    String? serverId,
    int? sessionLogId,
    Object? messageId = _Undefined,
    String? query,
    double? duration,
    Object? numRows = _Undefined,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    bool? slow,
    int? order,
  }) {
    return QueryLogEntry(
      id: id is int? ? id : this.id,
      serverId: serverId ?? this.serverId,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      messageId: messageId is int? ? messageId : this.messageId,
      query: query ?? this.query,
      duration: duration ?? this.duration,
      numRows: numRows is int? ? numRows : this.numRows,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      slow: slow ?? this.slow,
      order: order ?? this.order,
    );
  }
}

class QueryLogEntryUpdateTable extends _is.UpdateTable<QueryLogEntryTable> {
  QueryLogEntryUpdateTable(super.table);

  _is.ColumnValue<String, String> serverId(String value) => _is.ColumnValue(
    table.serverId,
    value,
  );

  _is.ColumnValue<int, int> sessionLogId(int value) => _is.ColumnValue(
    table.sessionLogId,
    value,
  );

  _is.ColumnValue<int, int> messageId(int? value) => _is.ColumnValue(
    table.messageId,
    value,
  );

  _is.ColumnValue<String, String> query(String value) => _is.ColumnValue(
    table.query,
    value,
  );

  _is.ColumnValue<double, double> duration(double value) => _is.ColumnValue(
    table.duration,
    value,
  );

  _is.ColumnValue<int, int> numRows(int? value) => _is.ColumnValue(
    table.numRows,
    value,
  );

  _is.ColumnValue<String, String> error(String? value) => _is.ColumnValue(
    table.error,
    value,
  );

  _is.ColumnValue<String, String> stackTrace(String? value) => _is.ColumnValue(
    table.stackTrace,
    value,
  );

  _is.ColumnValue<bool, bool> slow(bool value) => _is.ColumnValue(
    table.slow,
    value,
  );

  _is.ColumnValue<int, int> order(int value) => _is.ColumnValue(
    table.order,
    value,
  );
}

class QueryLogEntryTable extends _is.Table<int?> {
  QueryLogEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_query_log') {
    updateTable = QueryLogEntryUpdateTable(this);
    serverId = _is.ColumnString(
      'serverId',
      this,
    );
    sessionLogId = _is.ColumnInt(
      'sessionLogId',
      this,
    );
    messageId = _is.ColumnInt(
      'messageId',
      this,
    );
    query = _is.ColumnString(
      'query',
      this,
    );
    duration = _is.ColumnDouble(
      'duration',
      this,
    );
    numRows = _is.ColumnInt(
      'numRows',
      this,
    );
    error = _is.ColumnString(
      'error',
      this,
    );
    stackTrace = _is.ColumnString(
      'stackTrace',
      this,
    );
    slow = _is.ColumnBool(
      'slow',
      this,
    );
    order = _is.ColumnInt(
      'order',
      this,
    );
  }

  late final QueryLogEntryUpdateTable updateTable;

  /// The id of the server that handled the query.
  late final _is.ColumnString serverId;

  /// Id of the session this entry is associated with.
  late final _is.ColumnInt sessionLogId;

  /// The id of the message this entry is associated with, if the query was
  /// executed in a streaming session.
  late final _is.ColumnInt messageId;

  /// The query that was executed.
  late final _is.ColumnString query;

  /// The time it took to execute the query, in seconds.
  late final _is.ColumnDouble duration;

  /// Number of rows returned by this query. This can be null if the number is
  /// not relevant.
  late final _is.ColumnInt numRows;

  /// Set if an exception was thrown during the execution of this query.
  late final _is.ColumnString error;

  /// The stack trace of this query.
  late final _is.ColumnString stackTrace;

  /// True if the execution of this query was considered slow.
  late final _is.ColumnBool slow;

  /// used for sorting the query log.
  late final _is.ColumnInt order;

  @override
  List<_is.Column> get columns => [
    id,
    serverId,
    sessionLogId,
    messageId,
    query,
    duration,
    numRows,
    error,
    stackTrace,
    slow,
    order,
  ];
}

class QueryLogEntryInclude extends _is.IncludeObject {
  QueryLogEntryInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => QueryLogEntry.t;
}

class QueryLogEntryIncludeList extends _is.IncludeList {
  QueryLogEntryIncludeList.internal_({
    _is.WhereExpressionBuilder<QueryLogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(QueryLogEntry.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => QueryLogEntry.t;
}

class QueryLogEntryRepository {
  const QueryLogEntryRepository._();

  /// Returns a list of [QueryLogEntry]s matching the given query parameters.
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
  Future<List<QueryLogEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueryLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueryLogEntryTable>? orderBy,
    _is.OrderByListBuilder<QueryLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<QueryLogEntry>(
      where: where?.call(QueryLogEntry.t),
      orderBy: orderBy?.call(QueryLogEntry.t),
      orderByList: orderByList?.call(QueryLogEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [QueryLogEntry] matching the given query parameters.
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
  Future<QueryLogEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueryLogEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<QueryLogEntryTable>? orderBy,
    _is.OrderByListBuilder<QueryLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<QueryLogEntry>(
      where: where?.call(QueryLogEntry.t),
      orderBy: orderBy?.call(QueryLogEntry.t),
      orderByList: orderByList?.call(QueryLogEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [QueryLogEntry] by its [id] or null if no such row exists.
  Future<QueryLogEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<QueryLogEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [QueryLogEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [QueryLogEntry]s will have their `id` fields set.
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
  Future<List<QueryLogEntry>> insert(
    _is.DatabaseSession session,
    List<QueryLogEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<QueryLogEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [QueryLogEntry] and returns the inserted row.
  ///
  /// The returned [QueryLogEntry] will have its `id` field set.
  Future<QueryLogEntry> insertRow(
    _is.DatabaseSession session,
    QueryLogEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<QueryLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [QueryLogEntry]s in the list and returns the resulting rows.
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
  /// The returned [QueryLogEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueryLogEntry>> upsert(
    _is.DatabaseSession session,
    List<QueryLogEntry> rows, {
    required _is.ColumnSelections<QueryLogEntryTable> conflictColumns,
    _is.ColumnSelections<QueryLogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<QueryLogEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<QueryLogEntry>(
      rows,
      conflictColumns: conflictColumns(QueryLogEntry.t),
      updateColumns: updateColumns?.call(QueryLogEntry.t),
      updateWhere: updateWhere?.call(QueryLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [QueryLogEntry] and returns the resulting row.
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
  /// The returned [QueryLogEntry] will have its `id` field set.
  Future<QueryLogEntry?> upsertRow(
    _is.DatabaseSession session,
    QueryLogEntry row, {
    required _is.ColumnSelections<QueryLogEntryTable> conflictColumns,
    _is.ColumnSelections<QueryLogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<QueryLogEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<QueryLogEntry>(
      row,
      conflictColumns: conflictColumns(QueryLogEntry.t),
      updateColumns: updateColumns?.call(QueryLogEntry.t),
      updateWhere: updateWhere?.call(QueryLogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [QueryLogEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueryLogEntry>> update(
    _is.DatabaseSession session,
    List<QueryLogEntry> rows, {
    _is.ColumnSelections<QueryLogEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<QueryLogEntry>(
      rows,
      columns: columns?.call(QueryLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [QueryLogEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<QueryLogEntry> updateRow(
    _is.DatabaseSession session,
    QueryLogEntry row, {
    _is.ColumnSelections<QueryLogEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<QueryLogEntry>(
      row,
      columns: columns?.call(QueryLogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [QueryLogEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<QueryLogEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<QueryLogEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<QueryLogEntry>(
      id,
      columnValues: columnValues(QueryLogEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [QueryLogEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<QueryLogEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<QueryLogEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<QueryLogEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<QueryLogEntryTable>? orderBy,
    _is.OrderByListBuilder<QueryLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<QueryLogEntry>(
      columnValues: columnValues(QueryLogEntry.t.updateTable),
      where: where(QueryLogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(QueryLogEntry.t),
      orderByList: orderByList?.call(QueryLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [QueryLogEntry]s in the list and returns the deleted rows.
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
  Future<List<QueryLogEntry>> delete(
    _is.DatabaseSession session,
    List<QueryLogEntry> rows, {
    _is.OrderByBuilder<QueryLogEntryTable>? orderBy,
    _is.OrderByListBuilder<QueryLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<QueryLogEntry>(
      rows,
      orderBy: orderBy?.call(QueryLogEntry.t),
      orderByList: orderByList?.call(QueryLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [QueryLogEntry].
  Future<QueryLogEntry> deleteRow(
    _is.DatabaseSession session,
    QueryLogEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<QueryLogEntry>(
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
  Future<List<QueryLogEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QueryLogEntryTable> where,
    _is.OrderByBuilder<QueryLogEntryTable>? orderBy,
    _is.OrderByListBuilder<QueryLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<QueryLogEntry>(
      where: where(QueryLogEntry.t),
      orderBy: orderBy?.call(QueryLogEntry.t),
      orderByList: orderByList?.call(QueryLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<QueryLogEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<QueryLogEntry>(
      where: where?.call(QueryLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [QueryLogEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<QueryLogEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<QueryLogEntry>(
      where: where(QueryLogEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

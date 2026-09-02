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
import 'log_level.dart' as _iavjjqw5;

/// Bindings to a log entry in the database.
abstract class LogEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LogEntry._({
    this.id,
    required this.sessionLogId,
    this.messageId,
    this.reference,
    required this.serverId,
    required this.time,
    required this.logLevel,
    required this.message,
    this.error,
    this.stackTrace,
    required this.order,
  });

  factory LogEntry({
    int? id,
    required int sessionLogId,
    int? messageId,
    String? reference,
    required String serverId,
    required DateTime time,
    required _iavjjqw5.LogLevel logLevel,
    required String message,
    String? error,
    String? stackTrace,
    required int order,
  }) = _LogEntryImpl;

  factory LogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LogEntry(
      id: jsonSerialization['id'] as int?,
      sessionLogId: jsonSerialization['sessionLogId'] as int,
      messageId: jsonSerialization['messageId'] as int?,
      reference: jsonSerialization['reference'] as String?,
      serverId: jsonSerialization['serverId'] as String,
      time: _is.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      logLevel: _iavjjqw5.LogLevel.fromJson(
        (jsonSerialization['logLevel'] as int),
      ),
      message: jsonSerialization['message'] as String,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      order: jsonSerialization['order'] as int,
    );
  }

  static final t = LogEntryTable();

  static const db = LogEntryRepository._();

  @override
  int? id;

  /// The id of the session this log entry is associated with.
  int sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  int? messageId;

  /// Currently unused.
  String? reference;

  /// The id of the server which created this log entry.
  String serverId;

  /// Timestamp of this log entry.
  DateTime time;

  /// The log level of this entry.
  _iavjjqw5.LogLevel logLevel;

  /// The logging message.
  String message;

  /// Optional error associated with this log entry.
  String? error;

  /// Optional stack trace associated with this log entry.
  String? stackTrace;

  /// The order of this log entry, used for sorting.
  int order;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LogEntry copyWith({
    int? id,
    int? sessionLogId,
    int? messageId,
    String? reference,
    String? serverId,
    DateTime? time,
    _iavjjqw5.LogLevel? logLevel,
    String? message,
    String? error,
    String? stackTrace,
    int? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.LogEntry',
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      if (messageId != null) 'messageId': messageId,
      if (reference != null) 'reference': reference,
      'serverId': serverId,
      'time': time.toJson(),
      'logLevel': logLevel.toJson(),
      'message': message,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'order': order,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.LogEntry',
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      if (messageId != null) 'messageId': messageId,
      if (reference != null) 'reference': reference,
      'serverId': serverId,
      'time': time.toJson(),
      'logLevel': logLevel.toJson(),
      'message': message,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'order': order,
    };
  }

  static LogEntryInclude include() {
    return LogEntryInclude._();
  }

  static LogEntryIncludeList includeList({
    _is.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LogEntryTable>? orderBy,
    _is.OrderByListBuilder<LogEntryTable>? orderByList,
    LogEntryInclude? include,
  }) {
    return LogEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LogEntryImpl extends LogEntry {
  _LogEntryImpl({
    int? id,
    required int sessionLogId,
    int? messageId,
    String? reference,
    required String serverId,
    required DateTime time,
    required _iavjjqw5.LogLevel logLevel,
    required String message,
    String? error,
    String? stackTrace,
    required int order,
  }) : super._(
         id: id,
         sessionLogId: sessionLogId,
         messageId: messageId,
         reference: reference,
         serverId: serverId,
         time: time,
         logLevel: logLevel,
         message: message,
         error: error,
         stackTrace: stackTrace,
         order: order,
       );

  /// Returns a shallow copy of this [LogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LogEntry copyWith({
    Object? id = _Undefined,
    int? sessionLogId,
    Object? messageId = _Undefined,
    Object? reference = _Undefined,
    String? serverId,
    DateTime? time,
    _iavjjqw5.LogLevel? logLevel,
    String? message,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    int? order,
  }) {
    return LogEntry(
      id: id is int? ? id : this.id,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      messageId: messageId is int? ? messageId : this.messageId,
      reference: reference is String? ? reference : this.reference,
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      logLevel: logLevel ?? this.logLevel,
      message: message ?? this.message,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      order: order ?? this.order,
    );
  }
}

class LogEntryUpdateTable extends _is.UpdateTable<LogEntryTable> {
  LogEntryUpdateTable(super.table);

  _is.ColumnValue<int, int> sessionLogId(int value) => _is.ColumnValue(
    table.sessionLogId,
    value,
  );

  _is.ColumnValue<int, int> messageId(int? value) => _is.ColumnValue(
    table.messageId,
    value,
  );

  _is.ColumnValue<String, String> reference(String? value) => _is.ColumnValue(
    table.reference,
    value,
  );

  _is.ColumnValue<String, String> serverId(String value) => _is.ColumnValue(
    table.serverId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> time(DateTime value) => _is.ColumnValue(
    table.time,
    value,
  );

  _is.ColumnValue<_iavjjqw5.LogLevel, _iavjjqw5.LogLevel> logLevel(
    _iavjjqw5.LogLevel value,
  ) => _is.ColumnValue(
    table.logLevel,
    value,
  );

  _is.ColumnValue<String, String> message(String value) => _is.ColumnValue(
    table.message,
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

  _is.ColumnValue<int, int> order(int value) => _is.ColumnValue(
    table.order,
    value,
  );
}

class LogEntryTable extends _is.Table<int?> {
  LogEntryTable({super.tableRelation}) : super(tableName: 'serverpod_log') {
    updateTable = LogEntryUpdateTable(this);
    sessionLogId = _is.ColumnInt(
      'sessionLogId',
      this,
    );
    messageId = _is.ColumnInt(
      'messageId',
      this,
    );
    reference = _is.ColumnString(
      'reference',
      this,
    );
    serverId = _is.ColumnString(
      'serverId',
      this,
    );
    time = _is.ColumnDateTime(
      'time',
      this,
    );
    logLevel = _is.ColumnEnum(
      'logLevel',
      this,
      _is.EnumSerialization.byIndex,
    );
    message = _is.ColumnString(
      'message',
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
    order = _is.ColumnInt(
      'order',
      this,
    );
  }

  late final LogEntryUpdateTable updateTable;

  /// The id of the session this log entry is associated with.
  late final _is.ColumnInt sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  late final _is.ColumnInt messageId;

  /// Currently unused.
  late final _is.ColumnString reference;

  /// The id of the server which created this log entry.
  late final _is.ColumnString serverId;

  /// Timestamp of this log entry.
  late final _is.ColumnDateTime time;

  /// The log level of this entry.
  late final _is.ColumnEnum<_iavjjqw5.LogLevel> logLevel;

  /// The logging message.
  late final _is.ColumnString message;

  /// Optional error associated with this log entry.
  late final _is.ColumnString error;

  /// Optional stack trace associated with this log entry.
  late final _is.ColumnString stackTrace;

  /// The order of this log entry, used for sorting.
  late final _is.ColumnInt order;

  @override
  List<_is.Column> get columns => [
    id,
    sessionLogId,
    messageId,
    reference,
    serverId,
    time,
    logLevel,
    message,
    error,
    stackTrace,
    order,
  ];
}

class LogEntryInclude extends _is.IncludeObject {
  LogEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LogEntry.t;
}

class LogEntryIncludeList extends _is.IncludeList {
  LogEntryIncludeList._({
    _is.WhereExpressionBuilder<LogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LogEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LogEntry.t;
}

class LogEntryRepository {
  const LogEntryRepository._();

  /// Returns a list of [LogEntry]s matching the given query parameters.
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
  Future<List<LogEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LogEntryTable>? orderBy,
    _is.OrderByListBuilder<LogEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LogEntry>(
      where: where?.call(LogEntry.t),
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LogEntry] matching the given query parameters.
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
  Future<LogEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LogEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<LogEntryTable>? orderBy,
    _is.OrderByListBuilder<LogEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LogEntry>(
      where: where?.call(LogEntry.t),
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LogEntry] by its [id] or null if no such row exists.
  Future<LogEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LogEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LogEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [LogEntry]s will have their `id` fields set.
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
  Future<List<LogEntry>> insert(
    _is.DatabaseSession session,
    List<LogEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LogEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LogEntry] and returns the inserted row.
  ///
  /// The returned [LogEntry] will have its `id` field set.
  Future<LogEntry> insertRow(
    _is.DatabaseSession session,
    LogEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LogEntry]s in the list and returns the resulting rows.
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
  /// The returned [LogEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LogEntry>> upsert(
    _is.DatabaseSession session,
    List<LogEntry> rows, {
    required _is.ColumnSelections<LogEntryTable> conflictColumns,
    _is.ColumnSelections<LogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<LogEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LogEntry>(
      rows,
      conflictColumns: conflictColumns(LogEntry.t),
      updateColumns: updateColumns?.call(LogEntry.t),
      updateWhere: updateWhere?.call(LogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LogEntry] and returns the resulting row.
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
  /// The returned [LogEntry] will have its `id` field set.
  Future<LogEntry?> upsertRow(
    _is.DatabaseSession session,
    LogEntry row, {
    required _is.ColumnSelections<LogEntryTable> conflictColumns,
    _is.ColumnSelections<LogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<LogEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LogEntry>(
      row,
      conflictColumns: conflictColumns(LogEntry.t),
      updateColumns: updateColumns?.call(LogEntry.t),
      updateWhere: updateWhere?.call(LogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [LogEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LogEntry>> update(
    _is.DatabaseSession session,
    List<LogEntry> rows, {
    _is.ColumnSelections<LogEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LogEntry>(
      rows,
      columns: columns?.call(LogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LogEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LogEntry> updateRow(
    _is.DatabaseSession session,
    LogEntry row, {
    _is.ColumnSelections<LogEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LogEntry>(
      row,
      columns: columns?.call(LogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LogEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LogEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LogEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LogEntry>(
      id,
      columnValues: columnValues(LogEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LogEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LogEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LogEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<LogEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LogEntryTable>? orderBy,
    _is.OrderByListBuilder<LogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LogEntry>(
      columnValues: columnValues(LogEntry.t.updateTable),
      where: where(LogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LogEntry]s in the list and returns the deleted rows.
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
  Future<List<LogEntry>> delete(
    _is.DatabaseSession session,
    List<LogEntry> rows, {
    _is.OrderByBuilder<LogEntryTable>? orderBy,
    _is.OrderByListBuilder<LogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LogEntry>(
      rows,
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LogEntry].
  Future<LogEntry> deleteRow(
    _is.DatabaseSession session,
    LogEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LogEntry>(
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
  Future<List<LogEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LogEntryTable> where,
    _is.OrderByBuilder<LogEntryTable>? orderBy,
    _is.OrderByListBuilder<LogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LogEntry>(
      where: where(LogEntry.t),
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LogEntry>(
      where: where?.call(LogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LogEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LogEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LogEntry>(
      where: where(LogEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

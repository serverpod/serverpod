/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Log entry for a session.
abstract class SessionLogEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SessionLogEntry._({
    this.id,
    required this.serverId,
    required this.time,
    this.module,
    this.endpoint,
    this.method,
    this.duration,
    this.numQueries,
    this.slow,
    this.error,
    this.stackTrace,
    this.authenticatedUserId,
    this.isOpen,
    required this.touched,
  });

  factory SessionLogEntry({
    int? id,
    required String serverId,
    required DateTime time,
    String? module,
    String? endpoint,
    String? method,
    double? duration,
    int? numQueries,
    bool? slow,
    String? error,
    String? stackTrace,
    int? authenticatedUserId,
    bool? isOpen,
    required DateTime touched,
  }) = _SessionLogEntryImpl;

  factory SessionLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogEntry(
      id: jsonSerialization['id'] as int?,
      serverId: jsonSerialization['serverId'] as String,
      time: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      module: jsonSerialization['module'] as String?,
      endpoint: jsonSerialization['endpoint'] as String?,
      method: jsonSerialization['method'] as String?,
      duration: (jsonSerialization['duration'] as num?)?.toDouble(),
      numQueries: jsonSerialization['numQueries'] as int?,
      slow: jsonSerialization['slow'] as bool?,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      authenticatedUserId: jsonSerialization['authenticatedUserId'] as int?,
      isOpen: jsonSerialization['isOpen'] as bool?,
      touched: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['touched']),
    );
  }

  static final t = SessionLogEntryTable();

  static const db = SessionLogEntryRepository._();

  @override
  int? id;

  /// The id of the server that handled this session.
  String serverId;

  /// The starting time of this session.
  DateTime time;

  /// The module this session is associated with, if any.
  String? module;

  /// The endpoint this session is associated with, if any.
  String? endpoint;

  /// The method this session is associated with, if any.
  String? method;

  /// The running time of this session. May be null if the session is still
  /// active.
  double? duration;

  /// The number of queries performed during this session.
  int? numQueries;

  /// True if this session was slow to complete.
  bool? slow;

  /// If the session ends with an exception, the error field will be set.
  String? error;

  /// If the session ends with an exception, a stack trace will be set.
  String? stackTrace;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  int? authenticatedUserId;

  /// True if the session is still open.
  bool? isOpen;

  /// Timestamp of the last time this record was modified.
  DateTime touched;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SessionLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionLogEntry copyWith({
    int? id,
    String? serverId,
    DateTime? time,
    String? module,
    String? endpoint,
    String? method,
    double? duration,
    int? numQueries,
    bool? slow,
    String? error,
    String? stackTrace,
    int? authenticatedUserId,
    bool? isOpen,
    DateTime? touched,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'serverId': serverId,
      'time': time.toJson(),
      if (module != null) 'module': module,
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
      if (duration != null) 'duration': duration,
      if (numQueries != null) 'numQueries': numQueries,
      if (slow != null) 'slow': slow,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      if (authenticatedUserId != null)
        'authenticatedUserId': authenticatedUserId,
      if (isOpen != null) 'isOpen': isOpen,
      'touched': touched.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'serverId': serverId,
      'time': time.toJson(),
      if (module != null) 'module': module,
      if (endpoint != null) 'endpoint': endpoint,
      if (method != null) 'method': method,
      if (duration != null) 'duration': duration,
      if (numQueries != null) 'numQueries': numQueries,
      if (slow != null) 'slow': slow,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      if (authenticatedUserId != null)
        'authenticatedUserId': authenticatedUserId,
      if (isOpen != null) 'isOpen': isOpen,
      'touched': touched.toJson(),
    };
  }

  static SessionLogEntryInclude include() {
    return SessionLogEntryInclude._();
  }

  static SessionLogEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    SessionLogEntryInclude? include,
  }) {
    return SessionLogEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SessionLogEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SessionLogEntryImpl extends SessionLogEntry {
  _SessionLogEntryImpl({
    int? id,
    required String serverId,
    required DateTime time,
    String? module,
    String? endpoint,
    String? method,
    double? duration,
    int? numQueries,
    bool? slow,
    String? error,
    String? stackTrace,
    int? authenticatedUserId,
    bool? isOpen,
    required DateTime touched,
  }) : super._(
          id: id,
          serverId: serverId,
          time: time,
          module: module,
          endpoint: endpoint,
          method: method,
          duration: duration,
          numQueries: numQueries,
          slow: slow,
          error: error,
          stackTrace: stackTrace,
          authenticatedUserId: authenticatedUserId,
          isOpen: isOpen,
          touched: touched,
        );

  /// Returns a shallow copy of this [SessionLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SessionLogEntry copyWith({
    Object? id = _Undefined,
    String? serverId,
    DateTime? time,
    Object? module = _Undefined,
    Object? endpoint = _Undefined,
    Object? method = _Undefined,
    Object? duration = _Undefined,
    Object? numQueries = _Undefined,
    Object? slow = _Undefined,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    Object? authenticatedUserId = _Undefined,
    Object? isOpen = _Undefined,
    DateTime? touched,
  }) {
    return SessionLogEntry(
      id: id is int? ? id : this.id,
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      module: module is String? ? module : this.module,
      endpoint: endpoint is String? ? endpoint : this.endpoint,
      method: method is String? ? method : this.method,
      duration: duration is double? ? duration : this.duration,
      numQueries: numQueries is int? ? numQueries : this.numQueries,
      slow: slow is bool? ? slow : this.slow,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      authenticatedUserId: authenticatedUserId is int?
          ? authenticatedUserId
          : this.authenticatedUserId,
      isOpen: isOpen is bool? ? isOpen : this.isOpen,
      touched: touched ?? this.touched,
    );
  }
}

class SessionLogEntryTable extends _i1.Table<int?> {
  SessionLogEntryTable({super.tableRelation})
      : super(tableName: 'serverpod_session_log') {
    serverId = _i1.ColumnString(
      'serverId',
      this,
    );
    time = _i1.ColumnDateTime(
      'time',
      this,
    );
    module = _i1.ColumnString(
      'module',
      this,
    );
    endpoint = _i1.ColumnString(
      'endpoint',
      this,
    );
    method = _i1.ColumnString(
      'method',
      this,
    );
    duration = _i1.ColumnDouble(
      'duration',
      this,
    );
    numQueries = _i1.ColumnInt(
      'numQueries',
      this,
    );
    slow = _i1.ColumnBool(
      'slow',
      this,
    );
    error = _i1.ColumnString(
      'error',
      this,
    );
    stackTrace = _i1.ColumnString(
      'stackTrace',
      this,
    );
    authenticatedUserId = _i1.ColumnInt(
      'authenticatedUserId',
      this,
    );
    isOpen = _i1.ColumnBool(
      'isOpen',
      this,
    );
    touched = _i1.ColumnDateTime(
      'touched',
      this,
    );
  }

  /// The id of the server that handled this session.
  late final _i1.ColumnString serverId;

  /// The starting time of this session.
  late final _i1.ColumnDateTime time;

  /// The module this session is associated with, if any.
  late final _i1.ColumnString module;

  /// The endpoint this session is associated with, if any.
  late final _i1.ColumnString endpoint;

  /// The method this session is associated with, if any.
  late final _i1.ColumnString method;

  /// The running time of this session. May be null if the session is still
  /// active.
  late final _i1.ColumnDouble duration;

  /// The number of queries performed during this session.
  late final _i1.ColumnInt numQueries;

  /// True if this session was slow to complete.
  late final _i1.ColumnBool slow;

  /// If the session ends with an exception, the error field will be set.
  late final _i1.ColumnString error;

  /// If the session ends with an exception, a stack trace will be set.
  late final _i1.ColumnString stackTrace;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  late final _i1.ColumnInt authenticatedUserId;

  /// True if the session is still open.
  late final _i1.ColumnBool isOpen;

  /// Timestamp of the last time this record was modified.
  late final _i1.ColumnDateTime touched;

  @override
  List<_i1.Column> get columns => [
        id,
        serverId,
        time,
        module,
        endpoint,
        method,
        duration,
        numQueries,
        slow,
        error,
        stackTrace,
        authenticatedUserId,
        isOpen,
        touched,
      ];
}

class SessionLogEntryInclude extends _i1.IncludeObject {
  SessionLogEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SessionLogEntry.t;
}

class SessionLogEntryIncludeList extends _i1.IncludeList {
  SessionLogEntryIncludeList._({
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SessionLogEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SessionLogEntry.t;
}

class SessionLogEntryRepository {
  const SessionLogEntryRepository._();

  /// Returns a list of [SessionLogEntry]s matching the given query parameters.
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
  Future<List<SessionLogEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SessionLogEntry] matching the given query parameters.
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
  Future<SessionLogEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SessionLogEntry] by its [id] or null if no such row exists.
  Future<SessionLogEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SessionLogEntry>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SessionLogEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [SessionLogEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SessionLogEntry>> insert(
    _i1.Session session,
    List<SessionLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SessionLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SessionLogEntry] and returns the inserted row.
  ///
  /// The returned [SessionLogEntry] will have its `id` field set.
  Future<SessionLogEntry> insertRow(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SessionLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SessionLogEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SessionLogEntry>> update(
    _i1.Session session,
    List<SessionLogEntry> rows, {
    _i1.ColumnSelections<SessionLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SessionLogEntry>(
      rows,
      columns: columns?.call(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SessionLogEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SessionLogEntry> updateRow(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.ColumnSelections<SessionLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SessionLogEntry>(
      row,
      columns: columns?.call(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  /// Deletes all [SessionLogEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SessionLogEntry>> delete(
    _i1.Session session,
    List<SessionLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SessionLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SessionLogEntry].
  Future<SessionLogEntry> deleteRow(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SessionLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SessionLogEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SessionLogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

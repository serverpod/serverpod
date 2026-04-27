/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'log_entry.dart' as _i2;
import 'query_log_entry.dart' as _i3;
import 'message_log_entry.dart' as _i4;
import 'package:serverpod/src/generated/protocol.dart' as _i5;

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
    this.userId,
    this.isOpen,
    required this.touched,
    this.logs,
    this.queries,
    this.messages,
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
    String? userId,
    bool? isOpen,
    required DateTime touched,
    List<_i2.LogEntry>? logs,
    List<_i3.QueryLogEntry>? queries,
    List<_i4.MessageLogEntry>? messages,
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
      slow: jsonSerialization['slow'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['slow']),
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      authenticatedUserId: jsonSerialization['authenticatedUserId'] as int?,
      userId: jsonSerialization['userId'] as String?,
      isOpen: jsonSerialization['isOpen'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
      touched: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['touched']),
      logs: jsonSerialization['logs'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i2.LogEntry>>(
              jsonSerialization['logs'],
            ),
      queries: jsonSerialization['queries'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i3.QueryLogEntry>>(
              jsonSerialization['queries'],
            ),
      messages: jsonSerialization['messages'] == null
          ? null
          : _i5.Protocol().deserialize<List<_i4.MessageLogEntry>>(
              jsonSerialization['messages'],
            ),
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

  /// The running time of this session, in seconds. May be null if the session
  /// is still active.
  double? duration;

  /// The number of queries performed during this session.
  int? numQueries;

  /// True if this session was slow to complete.
  bool? slow;

  /// If the session ends with an exception, the error field will be set.
  String? error;

  /// If the session ends with an exception, a stack trace will be set.
  String? stackTrace;

  /// Deprecated. Use userId instead.
  int? authenticatedUserId;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  String? userId;

  /// True if the session is still open.
  bool? isOpen;

  /// Timestamp of the last time this record was modified.
  DateTime touched;

  /// Application log lines for this session.
  List<_i2.LogEntry>? logs;

  /// Query log lines for this session.
  List<_i3.QueryLogEntry>? queries;

  /// Streaming message log lines for this session.
  List<_i4.MessageLogEntry>? messages;

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
    String? userId,
    bool? isOpen,
    DateTime? touched,
    List<_i2.LogEntry>? logs,
    List<_i3.QueryLogEntry>? queries,
    List<_i4.MessageLogEntry>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.SessionLogEntry',
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
      if (userId != null) 'userId': userId,
      if (isOpen != null) 'isOpen': isOpen,
      'touched': touched.toJson(),
      if (logs != null) 'logs': logs?.toJson(valueToJson: (v) => v.toJson()),
      if (queries != null)
        'queries': queries?.toJson(valueToJson: (v) => v.toJson()),
      if (messages != null)
        'messages': messages?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.SessionLogEntry',
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
      if (userId != null) 'userId': userId,
      if (isOpen != null) 'isOpen': isOpen,
      'touched': touched.toJson(),
      if (logs != null)
        'logs': logs?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (queries != null)
        'queries': queries?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (messages != null)
        'messages': messages?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static SessionLogEntryInclude include({
    _i2.LogEntryIncludeList? logs,
    _i3.QueryLogEntryIncludeList? queries,
    _i4.MessageLogEntryIncludeList? messages,
  }) {
    return SessionLogEntryInclude._(
      logs: logs,
      queries: queries,
      messages: messages,
    );
  }

  static SessionLogEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    SessionLogEntryInclude? include,
  }) {
    return SessionLogEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
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
    String? userId,
    bool? isOpen,
    required DateTime touched,
    List<_i2.LogEntry>? logs,
    List<_i3.QueryLogEntry>? queries,
    List<_i4.MessageLogEntry>? messages,
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
         userId: userId,
         isOpen: isOpen,
         touched: touched,
         logs: logs,
         queries: queries,
         messages: messages,
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
    Object? userId = _Undefined,
    Object? isOpen = _Undefined,
    DateTime? touched,
    Object? logs = _Undefined,
    Object? queries = _Undefined,
    Object? messages = _Undefined,
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
      userId: userId is String? ? userId : this.userId,
      isOpen: isOpen is bool? ? isOpen : this.isOpen,
      touched: touched ?? this.touched,
      logs: logs is List<_i2.LogEntry>?
          ? logs
          : this.logs?.map((e0) => e0.copyWith()).toList(),
      queries: queries is List<_i3.QueryLogEntry>?
          ? queries
          : this.queries?.map((e0) => e0.copyWith()).toList(),
      messages: messages is List<_i4.MessageLogEntry>?
          ? messages
          : this.messages?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class SessionLogEntryUpdateTable extends _i1.UpdateTable<SessionLogEntryTable> {
  SessionLogEntryUpdateTable(super.table);

  _i1.ColumnValue<String, String> serverId(String value) => _i1.ColumnValue(
    table.serverId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> time(DateTime value) => _i1.ColumnValue(
    table.time,
    value,
  );

  _i1.ColumnValue<String, String> module(String? value) => _i1.ColumnValue(
    table.module,
    value,
  );

  _i1.ColumnValue<String, String> endpoint(String? value) => _i1.ColumnValue(
    table.endpoint,
    value,
  );

  _i1.ColumnValue<String, String> method(String? value) => _i1.ColumnValue(
    table.method,
    value,
  );

  _i1.ColumnValue<double, double> duration(double? value) => _i1.ColumnValue(
    table.duration,
    value,
  );

  _i1.ColumnValue<int, int> numQueries(int? value) => _i1.ColumnValue(
    table.numQueries,
    value,
  );

  _i1.ColumnValue<bool, bool> slow(bool? value) => _i1.ColumnValue(
    table.slow,
    value,
  );

  _i1.ColumnValue<String, String> error(String? value) => _i1.ColumnValue(
    table.error,
    value,
  );

  _i1.ColumnValue<String, String> stackTrace(String? value) => _i1.ColumnValue(
    table.stackTrace,
    value,
  );

  _i1.ColumnValue<int, int> authenticatedUserId(int? value) => _i1.ColumnValue(
    table.authenticatedUserId,
    value,
  );

  _i1.ColumnValue<String, String> userId(String? value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<bool, bool> isOpen(bool? value) => _i1.ColumnValue(
    table.isOpen,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> touched(DateTime value) =>
      _i1.ColumnValue(
        table.touched,
        value,
      );
}

class SessionLogEntryTable extends _i1.Table<int?> {
  SessionLogEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_session_log') {
    updateTable = SessionLogEntryUpdateTable(this);
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
    userId = _i1.ColumnString(
      'userId',
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

  late final SessionLogEntryUpdateTable updateTable;

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

  /// The running time of this session, in seconds. May be null if the session
  /// is still active.
  late final _i1.ColumnDouble duration;

  /// The number of queries performed during this session.
  late final _i1.ColumnInt numQueries;

  /// True if this session was slow to complete.
  late final _i1.ColumnBool slow;

  /// If the session ends with an exception, the error field will be set.
  late final _i1.ColumnString error;

  /// If the session ends with an exception, a stack trace will be set.
  late final _i1.ColumnString stackTrace;

  /// Deprecated. Use userId instead.
  late final _i1.ColumnInt authenticatedUserId;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  late final _i1.ColumnString userId;

  /// True if the session is still open.
  late final _i1.ColumnBool isOpen;

  /// Timestamp of the last time this record was modified.
  late final _i1.ColumnDateTime touched;

  /// Application log lines for this session.
  _i2.LogEntryTable? ___logs;

  /// Application log lines for this session.
  _i1.ManyRelation<_i2.LogEntryTable>? _logs;

  /// Query log lines for this session.
  _i3.QueryLogEntryTable? ___queries;

  /// Query log lines for this session.
  _i1.ManyRelation<_i3.QueryLogEntryTable>? _queries;

  /// Streaming message log lines for this session.
  _i4.MessageLogEntryTable? ___messages;

  /// Streaming message log lines for this session.
  _i1.ManyRelation<_i4.MessageLogEntryTable>? _messages;

  _i2.LogEntryTable get __logs {
    if (___logs != null) return ___logs!;
    ___logs = _i1.createRelationTable(
      relationFieldName: '__logs',
      field: SessionLogEntry.t.id,
      foreignField: _i2.LogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.LogEntryTable(tableRelation: foreignTableRelation),
    );
    return ___logs!;
  }

  _i3.QueryLogEntryTable get __queries {
    if (___queries != null) return ___queries!;
    ___queries = _i1.createRelationTable(
      relationFieldName: '__queries',
      field: SessionLogEntry.t.id,
      foreignField: _i3.QueryLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.QueryLogEntryTable(tableRelation: foreignTableRelation),
    );
    return ___queries!;
  }

  _i4.MessageLogEntryTable get __messages {
    if (___messages != null) return ___messages!;
    ___messages = _i1.createRelationTable(
      relationFieldName: '__messages',
      field: SessionLogEntry.t.id,
      foreignField: _i4.MessageLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.MessageLogEntryTable(tableRelation: foreignTableRelation),
    );
    return ___messages!;
  }

  _i1.ManyRelation<_i2.LogEntryTable> get logs {
    if (_logs != null) return _logs!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'logs',
      field: SessionLogEntry.t.id,
      foreignField: _i2.LogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.LogEntryTable(tableRelation: foreignTableRelation),
    );
    _logs = _i1.ManyRelation<_i2.LogEntryTable>(
      tableWithRelations: relationTable,
      table: _i2.LogEntryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _logs!;
  }

  _i1.ManyRelation<_i3.QueryLogEntryTable> get queries {
    if (_queries != null) return _queries!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'queries',
      field: SessionLogEntry.t.id,
      foreignField: _i3.QueryLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.QueryLogEntryTable(tableRelation: foreignTableRelation),
    );
    _queries = _i1.ManyRelation<_i3.QueryLogEntryTable>(
      tableWithRelations: relationTable,
      table: _i3.QueryLogEntryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _queries!;
  }

  _i1.ManyRelation<_i4.MessageLogEntryTable> get messages {
    if (_messages != null) return _messages!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'messages',
      field: SessionLogEntry.t.id,
      foreignField: _i4.MessageLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.MessageLogEntryTable(tableRelation: foreignTableRelation),
    );
    _messages = _i1.ManyRelation<_i4.MessageLogEntryTable>(
      tableWithRelations: relationTable,
      table: _i4.MessageLogEntryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _messages!;
  }

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
    userId,
    isOpen,
    touched,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'logs') {
      return __logs;
    }
    if (relationField == 'queries') {
      return __queries;
    }
    if (relationField == 'messages') {
      return __messages;
    }
    return null;
  }
}

class SessionLogEntryInclude extends _i1.IncludeObject {
  SessionLogEntryInclude._({
    _i2.LogEntryIncludeList? logs,
    _i3.QueryLogEntryIncludeList? queries,
    _i4.MessageLogEntryIncludeList? messages,
  }) {
    _logs = logs;
    _queries = queries;
    _messages = messages;
  }

  _i2.LogEntryIncludeList? _logs;

  _i3.QueryLogEntryIncludeList? _queries;

  _i4.MessageLogEntryIncludeList? _messages;

  @override
  Map<String, _i1.Include?> get includes => {
    'logs': _logs,
    'queries': _queries,
    'messages': _messages,
  };

  @override
  _i1.Table<int?> get table => SessionLogEntry.t;
}

class SessionLogEntryIncludeList extends _i1.IncludeList {
  SessionLogEntryIncludeList._({
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
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

  final attach = const SessionLogEntryAttachRepository._();

  final attachRow = const SessionLogEntryAttachRowRepository._();

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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
    SessionLogEntryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
    SessionLogEntryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SessionLogEntry] by its [id] or null if no such row exists.
  Future<SessionLogEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    SessionLogEntryInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SessionLogEntry>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SessionLogEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [SessionLogEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SessionLogEntry>> insert(
    _i1.DatabaseSession session,
    List<SessionLogEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SessionLogEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SessionLogEntry] and returns the inserted row.
  ///
  /// The returned [SessionLogEntry] will have its `id` field set.
  Future<SessionLogEntry> insertRow(
    _i1.DatabaseSession session,
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
    _i1.DatabaseSession session,
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
    _i1.DatabaseSession session,
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

  /// Updates a single [SessionLogEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SessionLogEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<SessionLogEntryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SessionLogEntry>(
      id,
      columnValues: columnValues(SessionLogEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SessionLogEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SessionLogEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<SessionLogEntryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SessionLogEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SessionLogEntry>(
      columnValues: columnValues(SessionLogEntry.t.updateTable),
      where: where(SessionLogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SessionLogEntry]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SessionLogEntry>> delete(
    _i1.DatabaseSession session,
    List<SessionLogEntry> rows, {
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SessionLogEntry>(
      rows,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [SessionLogEntry].
  Future<SessionLogEntry> deleteRow(
    _i1.DatabaseSession session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SessionLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<SessionLogEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SessionLogEntryTable> where,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
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

  /// Acquires row-level locks on [SessionLogEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<SessionLogEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class SessionLogEntryAttachRepository {
  const SessionLogEntryAttachRepository._();

  /// Creates a relation between this [SessionLogEntry] and the given [LogEntry]s
  /// by setting each [LogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> logs(
    _i1.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    List<_i2.LogEntry> logEntry, {
    _i1.Transaction? transaction,
  }) async {
    if (logEntry.any((e) => e.id == null)) {
      throw ArgumentError.notNull('logEntry.id');
    }
    if (sessionLogEntry.id == null) {
      throw ArgumentError.notNull('sessionLogEntry.id');
    }

    var $logEntry = logEntry
        .map((e) => e.copyWith(sessionLogId: sessionLogEntry.id))
        .toList();
    await session.db.update<_i2.LogEntry>(
      $logEntry,
      columns: [_i2.LogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [QueryLogEntry]s
  /// by setting each [QueryLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> queries(
    _i1.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    List<_i3.QueryLogEntry> queryLogEntry, {
    _i1.Transaction? transaction,
  }) async {
    if (queryLogEntry.any((e) => e.id == null)) {
      throw ArgumentError.notNull('queryLogEntry.id');
    }
    if (sessionLogEntry.id == null) {
      throw ArgumentError.notNull('sessionLogEntry.id');
    }

    var $queryLogEntry = queryLogEntry
        .map((e) => e.copyWith(sessionLogId: sessionLogEntry.id))
        .toList();
    await session.db.update<_i3.QueryLogEntry>(
      $queryLogEntry,
      columns: [_i3.QueryLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [MessageLogEntry]s
  /// by setting each [MessageLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> messages(
    _i1.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    List<_i4.MessageLogEntry> messageLogEntry, {
    _i1.Transaction? transaction,
  }) async {
    if (messageLogEntry.any((e) => e.id == null)) {
      throw ArgumentError.notNull('messageLogEntry.id');
    }
    if (sessionLogEntry.id == null) {
      throw ArgumentError.notNull('sessionLogEntry.id');
    }

    var $messageLogEntry = messageLogEntry
        .map((e) => e.copyWith(sessionLogId: sessionLogEntry.id))
        .toList();
    await session.db.update<_i4.MessageLogEntry>(
      $messageLogEntry,
      columns: [_i4.MessageLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }
}

class SessionLogEntryAttachRowRepository {
  const SessionLogEntryAttachRowRepository._();

  /// Creates a relation between this [SessionLogEntry] and the given [LogEntry]
  /// by setting the [LogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> logs(
    _i1.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    _i2.LogEntry logEntry, {
    _i1.Transaction? transaction,
  }) async {
    if (logEntry.id == null) {
      throw ArgumentError.notNull('logEntry.id');
    }
    if (sessionLogEntry.id == null) {
      throw ArgumentError.notNull('sessionLogEntry.id');
    }

    var $logEntry = logEntry.copyWith(sessionLogId: sessionLogEntry.id);
    await session.db.updateRow<_i2.LogEntry>(
      $logEntry,
      columns: [_i2.LogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [QueryLogEntry]
  /// by setting the [QueryLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> queries(
    _i1.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    _i3.QueryLogEntry queryLogEntry, {
    _i1.Transaction? transaction,
  }) async {
    if (queryLogEntry.id == null) {
      throw ArgumentError.notNull('queryLogEntry.id');
    }
    if (sessionLogEntry.id == null) {
      throw ArgumentError.notNull('sessionLogEntry.id');
    }

    var $queryLogEntry = queryLogEntry.copyWith(
      sessionLogId: sessionLogEntry.id,
    );
    await session.db.updateRow<_i3.QueryLogEntry>(
      $queryLogEntry,
      columns: [_i3.QueryLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [MessageLogEntry]
  /// by setting the [MessageLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> messages(
    _i1.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    _i4.MessageLogEntry messageLogEntry, {
    _i1.Transaction? transaction,
  }) async {
    if (messageLogEntry.id == null) {
      throw ArgumentError.notNull('messageLogEntry.id');
    }
    if (sessionLogEntry.id == null) {
      throw ArgumentError.notNull('sessionLogEntry.id');
    }

    var $messageLogEntry = messageLogEntry.copyWith(
      sessionLogId: sessionLogEntry.id,
    );
    await session.db.updateRow<_i4.MessageLogEntry>(
      $messageLogEntry,
      columns: [_i4.MessageLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }
}

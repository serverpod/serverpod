/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;
import 'log_entry.dart' as _iv7ld46g;
import 'message_log_entry.dart' as _iky1nb92;
import 'query_log_entry.dart' as _inqjskye;

/// Log entry for a session.
abstract class SessionLogEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    List<_iv7ld46g.LogEntry>? logs,
    List<_inqjskye.QueryLogEntry>? queries,
    List<_iky1nb92.MessageLogEntry>? messages,
  }) = _SessionLogEntryImpl;

  factory SessionLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogEntry(
      id: jsonSerialization['id'] as int?,
      serverId: jsonSerialization['serverId'] as String,
      time: _is.DateTimeJsonExtension.fromJson(jsonSerialization['time']),
      module: jsonSerialization['module'] as String?,
      endpoint: jsonSerialization['endpoint'] as String?,
      method: jsonSerialization['method'] as String?,
      duration: (jsonSerialization['duration'] as num?)?.toDouble(),
      numQueries: jsonSerialization['numQueries'] as int?,
      slow: jsonSerialization['slow'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['slow']),
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      authenticatedUserId: jsonSerialization['authenticatedUserId'] as int?,
      userId: jsonSerialization['userId'] as String?,
      isOpen: jsonSerialization['isOpen'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
      touched: _is.DateTimeJsonExtension.fromJson(jsonSerialization['touched']),
      logs: jsonSerialization['logs'] == null
          ? null
          : _ic00rqxb.Protocol().deserialize<List<_iv7ld46g.LogEntry>>(
              jsonSerialization['logs'],
            ),
      queries: jsonSerialization['queries'] == null
          ? null
          : _ic00rqxb.Protocol().deserialize<List<_inqjskye.QueryLogEntry>>(
              jsonSerialization['queries'],
            ),
      messages: jsonSerialization['messages'] == null
          ? null
          : _ic00rqxb.Protocol().deserialize<List<_iky1nb92.MessageLogEntry>>(
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
  List<_iv7ld46g.LogEntry>? logs;

  /// Query log lines for this session.
  List<_inqjskye.QueryLogEntry>? queries;

  /// Streaming message log lines for this session.
  List<_iky1nb92.MessageLogEntry>? messages;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SessionLogEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
    List<_iv7ld46g.LogEntry>? logs,
    List<_inqjskye.QueryLogEntry>? queries,
    List<_iky1nb92.MessageLogEntry>? messages,
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

  /// Builds a complete [SessionLogEntryInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static SessionLogEntryInclude include({
    _iv7ld46g.LogEntryIncludeList? logs,
    _inqjskye.QueryLogEntryIncludeList? queries,
    _iky1nb92.MessageLogEntryIncludeList? messages,
  }) {
    return SessionLogEntryInclude._(
      logs: logs,
      queries: queries,
      messages: messages,
    );
  }

  /// Builds a complete [SessionLogEntryIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static SessionLogEntryIncludeList includeList({
    _is.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    SessionLogEntryInclude? include,
  }) {
    return SessionLogEntryIncludeList._(
      where: where?.call(SessionLogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [SessionLogEntryJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static SessionLogEntryJsonInclude includeJson({
    _iv7ld46g.LogEntryJsonIncludeList? logs,
    _inqjskye.QueryLogEntryJsonIncludeList? queries,
    _iky1nb92.MessageLogEntryJsonIncludeList? messages,
    _is.SelectColumnsBuilder<SessionLogEntryTable>? select,
  }) {
    return _SessionLogEntryJsonInclude._(
      logs: logs,
      queries: queries,
      messages: messages,
      selectedColumns: select?.call(SessionLogEntry.t),
    );
  }

  /// Builds a JSON-compatible [SessionLogEntryJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static SessionLogEntryJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    SessionLogEntryJsonInclude? include,
    _is.SelectColumnsBuilder<SessionLogEntryTable>? select,
  }) {
    return _SessionLogEntryJsonIncludeList._(
      where: where?.call(SessionLogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      include: include,
      selectedColumns: select?.call(SessionLogEntry.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
    List<_iv7ld46g.LogEntry>? logs,
    List<_inqjskye.QueryLogEntry>? queries,
    List<_iky1nb92.MessageLogEntry>? messages,
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
  @_is.useResult
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
      logs: logs is List<_iv7ld46g.LogEntry>?
          ? logs
          : this.logs?.map((e0) => e0.copyWith()).toList(),
      queries: queries is List<_inqjskye.QueryLogEntry>?
          ? queries
          : this.queries?.map((e0) => e0.copyWith()).toList(),
      messages: messages is List<_iky1nb92.MessageLogEntry>?
          ? messages
          : this.messages?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class SessionLogEntryUpdateTable extends _is.UpdateTable<SessionLogEntryTable> {
  SessionLogEntryUpdateTable(super.table);

  _is.ColumnValue<String, String> serverId(String value) => _is.ColumnValue(
    table.serverId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> time(DateTime value) => _is.ColumnValue(
    table.time,
    value,
  );

  _is.ColumnValue<String, String> module(String? value) => _is.ColumnValue(
    table.module,
    value,
  );

  _is.ColumnValue<String, String> endpoint(String? value) => _is.ColumnValue(
    table.endpoint,
    value,
  );

  _is.ColumnValue<String, String> method(String? value) => _is.ColumnValue(
    table.method,
    value,
  );

  _is.ColumnValue<double, double> duration(double? value) => _is.ColumnValue(
    table.duration,
    value,
  );

  _is.ColumnValue<int, int> numQueries(int? value) => _is.ColumnValue(
    table.numQueries,
    value,
  );

  _is.ColumnValue<bool, bool> slow(bool? value) => _is.ColumnValue(
    table.slow,
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

  _is.ColumnValue<int, int> authenticatedUserId(int? value) => _is.ColumnValue(
    table.authenticatedUserId,
    value,
  );

  _is.ColumnValue<String, String> userId(String? value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<bool, bool> isOpen(bool? value) => _is.ColumnValue(
    table.isOpen,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> touched(DateTime value) =>
      _is.ColumnValue(
        table.touched,
        value,
      );
}

class SessionLogEntryTable extends _is.Table<int?> {
  SessionLogEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_session_log') {
    updateTable = SessionLogEntryUpdateTable(this);
    serverId = _is.ColumnString(
      'serverId',
      this,
    );
    time = _is.ColumnDateTime(
      'time',
      this,
    );
    module = _is.ColumnString(
      'module',
      this,
    );
    endpoint = _is.ColumnString(
      'endpoint',
      this,
    );
    method = _is.ColumnString(
      'method',
      this,
    );
    duration = _is.ColumnDouble(
      'duration',
      this,
    );
    numQueries = _is.ColumnInt(
      'numQueries',
      this,
    );
    slow = _is.ColumnBool(
      'slow',
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
    authenticatedUserId = _is.ColumnInt(
      'authenticatedUserId',
      this,
    );
    userId = _is.ColumnString(
      'userId',
      this,
    );
    isOpen = _is.ColumnBool(
      'isOpen',
      this,
    );
    touched = _is.ColumnDateTime(
      'touched',
      this,
    );
  }

  late final SessionLogEntryUpdateTable updateTable;

  /// The id of the server that handled this session.
  late final _is.ColumnString serverId;

  /// The starting time of this session.
  late final _is.ColumnDateTime time;

  /// The module this session is associated with, if any.
  late final _is.ColumnString module;

  /// The endpoint this session is associated with, if any.
  late final _is.ColumnString endpoint;

  /// The method this session is associated with, if any.
  late final _is.ColumnString method;

  /// The running time of this session, in seconds. May be null if the session
  /// is still active.
  late final _is.ColumnDouble duration;

  /// The number of queries performed during this session.
  late final _is.ColumnInt numQueries;

  /// True if this session was slow to complete.
  late final _is.ColumnBool slow;

  /// If the session ends with an exception, the error field will be set.
  late final _is.ColumnString error;

  /// If the session ends with an exception, a stack trace will be set.
  late final _is.ColumnString stackTrace;

  /// Deprecated. Use userId instead.
  late final _is.ColumnInt authenticatedUserId;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  late final _is.ColumnString userId;

  /// True if the session is still open.
  late final _is.ColumnBool isOpen;

  /// Timestamp of the last time this record was modified.
  late final _is.ColumnDateTime touched;

  /// Application log lines for this session.
  _iv7ld46g.LogEntryTable? ___logs;

  /// Application log lines for this session.
  _is.ManyRelation<_iv7ld46g.LogEntryTable>? _logs;

  /// Query log lines for this session.
  _inqjskye.QueryLogEntryTable? ___queries;

  /// Query log lines for this session.
  _is.ManyRelation<_inqjskye.QueryLogEntryTable>? _queries;

  /// Streaming message log lines for this session.
  _iky1nb92.MessageLogEntryTable? ___messages;

  /// Streaming message log lines for this session.
  _is.ManyRelation<_iky1nb92.MessageLogEntryTable>? _messages;

  _iv7ld46g.LogEntryTable get __logs {
    if (___logs != null) return ___logs!;
    ___logs = _is.createRelationTable(
      relationFieldName: '__logs',
      field: SessionLogEntry.t.id,
      foreignField: _iv7ld46g.LogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iv7ld46g.LogEntryTable(tableRelation: foreignTableRelation),
    );
    return ___logs!;
  }

  _inqjskye.QueryLogEntryTable get __queries {
    if (___queries != null) return ___queries!;
    ___queries = _is.createRelationTable(
      relationFieldName: '__queries',
      field: SessionLogEntry.t.id,
      foreignField: _inqjskye.QueryLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _inqjskye.QueryLogEntryTable(tableRelation: foreignTableRelation),
    );
    return ___queries!;
  }

  _iky1nb92.MessageLogEntryTable get __messages {
    if (___messages != null) return ___messages!;
    ___messages = _is.createRelationTable(
      relationFieldName: '__messages',
      field: SessionLogEntry.t.id,
      foreignField: _iky1nb92.MessageLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iky1nb92.MessageLogEntryTable(tableRelation: foreignTableRelation),
    );
    return ___messages!;
  }

  _is.ManyRelation<_iv7ld46g.LogEntryTable> get logs {
    if (_logs != null) return _logs!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'logs',
      field: SessionLogEntry.t.id,
      foreignField: _iv7ld46g.LogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iv7ld46g.LogEntryTable(tableRelation: foreignTableRelation),
    );
    _logs = _is.ManyRelation<_iv7ld46g.LogEntryTable>(
      tableWithRelations: relationTable,
      table: _iv7ld46g.LogEntryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _logs!;
  }

  _is.ManyRelation<_inqjskye.QueryLogEntryTable> get queries {
    if (_queries != null) return _queries!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'queries',
      field: SessionLogEntry.t.id,
      foreignField: _inqjskye.QueryLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _inqjskye.QueryLogEntryTable(tableRelation: foreignTableRelation),
    );
    _queries = _is.ManyRelation<_inqjskye.QueryLogEntryTable>(
      tableWithRelations: relationTable,
      table: _inqjskye.QueryLogEntryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _queries!;
  }

  _is.ManyRelation<_iky1nb92.MessageLogEntryTable> get messages {
    if (_messages != null) return _messages!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'messages',
      field: SessionLogEntry.t.id,
      foreignField: _iky1nb92.MessageLogEntry.t.sessionLogId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iky1nb92.MessageLogEntryTable(tableRelation: foreignTableRelation),
    );
    _messages = _is.ManyRelation<_iky1nb92.MessageLogEntryTable>(
      tableWithRelations: relationTable,
      table: _iky1nb92.MessageLogEntryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _messages!;
  }

  @override
  List<_is.Column> get columns => [
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
  _is.Table? getRelationTable(String relationField) {
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

abstract interface class SessionLogEntryJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class SessionLogEntryJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class SessionLogEntryInclude extends _is.IncludeObject
    implements SessionLogEntryJsonInclude, _is.FullModelInclude {
  SessionLogEntryInclude._({
    _iv7ld46g.LogEntryIncludeList? logs,
    _inqjskye.QueryLogEntryIncludeList? queries,
    _iky1nb92.MessageLogEntryIncludeList? messages,
  }) {
    _logs = logs;
    _queries = queries;
    _messages = messages;
  }

  _iv7ld46g.LogEntryIncludeList? _logs;

  _inqjskye.QueryLogEntryIncludeList? _queries;

  _iky1nb92.MessageLogEntryIncludeList? _messages;

  @override
  Map<String, _is.Include?> get includes => {
    'logs': _logs,
    'queries': _queries,
    'messages': _messages,
  };

  @override
  _is.Table<int?> get table => SessionLogEntry.t;
}

final class SessionLogEntryIncludeList extends _is.IncludeList
    implements SessionLogEntryJsonIncludeList, _is.FullModelInclude {
  SessionLogEntryIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    SessionLogEntryInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SessionLogEntry.t;
}

final class _SessionLogEntryJsonInclude extends _is.IncludeObject
    implements SessionLogEntryJsonInclude {
  _SessionLogEntryJsonInclude._({
    _iv7ld46g.LogEntryJsonIncludeList? logs,
    _inqjskye.QueryLogEntryJsonIncludeList? queries,
    _iky1nb92.MessageLogEntryJsonIncludeList? messages,
    this.selectedColumns,
  }) {
    _logs = logs;
    _queries = queries;
    _messages = messages;
  }

  _iv7ld46g.LogEntryJsonIncludeList? _logs;

  _inqjskye.QueryLogEntryJsonIncludeList? _queries;

  _iky1nb92.MessageLogEntryJsonIncludeList? _messages;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'logs': _logs,
    'queries': _queries,
    'messages': _messages,
  };

  @override
  _is.Table<int?> get table => SessionLogEntry.t;
}

final class _SessionLogEntryJsonIncludeList extends _is.IncludeList
    implements SessionLogEntryJsonIncludeList {
  _SessionLogEntryJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    SessionLogEntryJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SessionLogEntry.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    SessionLogEntryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    SessionLogEntryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SessionLogEntry] by its [id] or null if no such row exists.
  Future<SessionLogEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    SessionLogEntryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SessionLogEntry>(
      id,
      transaction: transaction,
      include: include,
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
    _is.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    SessionLogEntryJsonInclude? include,
    _is.SelectColumnsBuilder<SessionLogEntryTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(SessionLogEntry.t),
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
    _is.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    SessionLogEntryJsonInclude? include,
    _is.SelectColumnsBuilder<SessionLogEntryTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(SessionLogEntry.t),
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
    SessionLogEntryJsonInclude? include,
    _is.SelectColumnsBuilder<SessionLogEntryTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<SessionLogEntry>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(SessionLogEntry.t),
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
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionLogEntry>> insert(
    _is.DatabaseSession session,
    List<SessionLogEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SessionLogEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SessionLogEntry] and returns the inserted row.
  ///
  /// The returned [SessionLogEntry] will have its `id` field set.
  Future<SessionLogEntry> insertRow(
    _is.DatabaseSession session,
    SessionLogEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SessionLogEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SessionLogEntry]s in the list and returns the resulting rows.
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
  /// The returned [SessionLogEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionLogEntry>> upsert(
    _is.DatabaseSession session,
    List<SessionLogEntry> rows, {
    required _is.ColumnSelections<SessionLogEntryTable> conflictColumns,
    _is.ColumnSelections<SessionLogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionLogEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SessionLogEntry>(
      rows,
      conflictColumns: conflictColumns(SessionLogEntry.t),
      updateColumns: updateColumns?.call(SessionLogEntry.t),
      updateWhere: updateWhere?.call(SessionLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SessionLogEntry] and returns the resulting row.
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
  /// The returned [SessionLogEntry] will have its `id` field set.
  Future<SessionLogEntry?> upsertRow(
    _is.DatabaseSession session,
    SessionLogEntry row, {
    required _is.ColumnSelections<SessionLogEntryTable> conflictColumns,
    _is.ColumnSelections<SessionLogEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<SessionLogEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SessionLogEntry>(
      row,
      conflictColumns: conflictColumns(SessionLogEntry.t),
      updateColumns: updateColumns?.call(SessionLogEntry.t),
      updateWhere: updateWhere?.call(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [SessionLogEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionLogEntry>> update(
    _is.DatabaseSession session,
    List<SessionLogEntry> rows, {
    _is.ColumnSelections<SessionLogEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SessionLogEntry>(
      rows,
      columns: columns?.call(SessionLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SessionLogEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SessionLogEntry> updateRow(
    _is.DatabaseSession session,
    SessionLogEntry row, {
    _is.ColumnSelections<SessionLogEntryTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SessionLogEntryUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SessionLogEntry>(
      id,
      columnValues: columnValues(SessionLogEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SessionLogEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionLogEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SessionLogEntryUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<SessionLogEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SessionLogEntry>(
      columnValues: columnValues(SessionLogEntry.t.updateTable),
      where: where(SessionLogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SessionLogEntry]s in the list and returns the deleted rows.
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
  Future<List<SessionLogEntry>> delete(
    _is.DatabaseSession session,
    List<SessionLogEntry> rows, {
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SessionLogEntry>(
      rows,
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SessionLogEntry].
  Future<SessionLogEntry> deleteRow(
    _is.DatabaseSession session,
    SessionLogEntry row, {
    _is.Transaction? transaction,
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
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SessionLogEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionLogEntryTable> where,
    _is.OrderByBuilder<SessionLogEntryTable>? orderBy,
    _is.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SessionLogEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SessionLogEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
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
    _is.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    List<_iv7ld46g.LogEntry> logEntry, {
    _is.Transaction? transaction,
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
    await session.db.update<_iv7ld46g.LogEntry>(
      $logEntry,
      columns: [_iv7ld46g.LogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [QueryLogEntry]s
  /// by setting each [QueryLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> queries(
    _is.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    List<_inqjskye.QueryLogEntry> queryLogEntry, {
    _is.Transaction? transaction,
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
    await session.db.update<_inqjskye.QueryLogEntry>(
      $queryLogEntry,
      columns: [_inqjskye.QueryLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [MessageLogEntry]s
  /// by setting each [MessageLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> messages(
    _is.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    List<_iky1nb92.MessageLogEntry> messageLogEntry, {
    _is.Transaction? transaction,
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
    await session.db.update<_iky1nb92.MessageLogEntry>(
      $messageLogEntry,
      columns: [_iky1nb92.MessageLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }
}

class SessionLogEntryAttachRowRepository {
  const SessionLogEntryAttachRowRepository._();

  /// Creates a relation between this [SessionLogEntry] and the given [LogEntry]
  /// by setting the [LogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> logs(
    _is.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    _iv7ld46g.LogEntry logEntry, {
    _is.Transaction? transaction,
  }) async {
    if (logEntry.id == null) {
      throw ArgumentError.notNull('logEntry.id');
    }
    if (sessionLogEntry.id == null) {
      throw ArgumentError.notNull('sessionLogEntry.id');
    }

    var $logEntry = logEntry.copyWith(sessionLogId: sessionLogEntry.id);
    await session.db.updateRow<_iv7ld46g.LogEntry>(
      $logEntry,
      columns: [_iv7ld46g.LogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [QueryLogEntry]
  /// by setting the [QueryLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> queries(
    _is.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    _inqjskye.QueryLogEntry queryLogEntry, {
    _is.Transaction? transaction,
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
    await session.db.updateRow<_inqjskye.QueryLogEntry>(
      $queryLogEntry,
      columns: [_inqjskye.QueryLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [SessionLogEntry] and the given [MessageLogEntry]
  /// by setting the [MessageLogEntry]'s foreign key `sessionLogId` to refer to this [SessionLogEntry].
  Future<void> messages(
    _is.DatabaseSession session,
    SessionLogEntry sessionLogEntry,
    _iky1nb92.MessageLogEntry messageLogEntry, {
    _is.Transaction? transaction,
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
    await session.db.updateRow<_iky1nb92.MessageLogEntry>(
      $messageLogEntry,
      columns: [_iky1nb92.MessageLogEntry.t.sessionLogId],
      transaction: transaction,
    );
  }
}

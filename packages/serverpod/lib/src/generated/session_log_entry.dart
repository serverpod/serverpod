/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class _Undefined {}

/// Log entry for a session.
class SessionLogEntry extends _i1.TableRow {
  SessionLogEntry({
    int? id,
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
  }) : super(id);

  factory SessionLogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SessionLogEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      module: serializationManager
          .deserialize<String?>(jsonSerialization['module']),
      endpoint: serializationManager
          .deserialize<String?>(jsonSerialization['endpoint']),
      method: serializationManager
          .deserialize<String?>(jsonSerialization['method']),
      duration: serializationManager
          .deserialize<double?>(jsonSerialization['duration']),
      numQueries: serializationManager
          .deserialize<int?>(jsonSerialization['numQueries']),
      slow: serializationManager.deserialize<bool?>(jsonSerialization['slow']),
      error:
          serializationManager.deserialize<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserialize<String?>(jsonSerialization['stackTrace']),
      authenticatedUserId: serializationManager
          .deserialize<int?>(jsonSerialization['authenticatedUserId']),
      isOpen:
          serializationManager.deserialize<bool?>(jsonSerialization['isOpen']),
      touched: serializationManager
          .deserialize<DateTime>(jsonSerialization['touched']),
    );
  }

  static var t = SessionLogEntryTable();

  /// The id of the server that handled this session.
  final String serverId;

  /// The starting time of this session.
  final DateTime time;

  /// The module this session is associated with, if any.
  final String? module;

  /// The endpoint this session is associated with, if any.
  final String? endpoint;

  /// The method this session is associated with, if any.
  final String? method;

  /// The running time of this session. May be null if the session is still
  /// active.
  final double? duration;

  /// The number of queries performed during this session.
  final int? numQueries;

  /// True if this session was slow to complete.
  final bool? slow;

  /// If the session ends with an exception, the error field will be set.
  final String? error;

  /// If the session ends with an exception, a stack trace will be set.
  final String? stackTrace;

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  final int? authenticatedUserId;

  /// True if the session is still open.
  final bool? isOpen;

  /// Timestamp of the last time this record was modified.
  final DateTime touched;

  late Function({
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
  }) copyWith = _copyWith;

  @override
  String get tableName => 'serverpod_session_log';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'time': time,
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
      'isOpen': isOpen,
      'touched': touched,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is SessionLogEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.time,
                  time,
                ) ||
                other.time == time) &&
            (identical(
                  other.module,
                  module,
                ) ||
                other.module == module) &&
            (identical(
                  other.endpoint,
                  endpoint,
                ) ||
                other.endpoint == endpoint) &&
            (identical(
                  other.method,
                  method,
                ) ||
                other.method == method) &&
            (identical(
                  other.duration,
                  duration,
                ) ||
                other.duration == duration) &&
            (identical(
                  other.numQueries,
                  numQueries,
                ) ||
                other.numQueries == numQueries) &&
            (identical(
                  other.slow,
                  slow,
                ) ||
                other.slow == slow) &&
            (identical(
                  other.error,
                  error,
                ) ||
                other.error == error) &&
            (identical(
                  other.stackTrace,
                  stackTrace,
                ) ||
                other.stackTrace == stackTrace) &&
            (identical(
                  other.authenticatedUserId,
                  authenticatedUserId,
                ) ||
                other.authenticatedUserId == authenticatedUserId) &&
            (identical(
                  other.isOpen,
                  isOpen,
                ) ||
                other.isOpen == isOpen) &&
            (identical(
                  other.touched,
                  touched,
                ) ||
                other.touched == touched));
  }

  @override
  int get hashCode => Object.hash(
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
      );

  SessionLogEntry _copyWith({
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
      id: id == _Undefined ? this.id : (id as int?),
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      module: module == _Undefined ? this.module : (module as String?),
      endpoint: endpoint == _Undefined ? this.endpoint : (endpoint as String?),
      method: method == _Undefined ? this.method : (method as String?),
      duration: duration == _Undefined ? this.duration : (duration as double?),
      numQueries:
          numQueries == _Undefined ? this.numQueries : (numQueries as int?),
      slow: slow == _Undefined ? this.slow : (slow as bool?),
      error: error == _Undefined ? this.error : (error as String?),
      stackTrace:
          stackTrace == _Undefined ? this.stackTrace : (stackTrace as String?),
      authenticatedUserId: authenticatedUserId == _Undefined
          ? this.authenticatedUserId
          : (authenticatedUserId as int?),
      isOpen: isOpen == _Undefined ? this.isOpen : (isOpen as bool?),
      touched: touched ?? this.touched,
    );
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'serverId': serverId,
      'time': time,
      'module': module,
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
      'isOpen': isOpen,
      'touched': touched,
    };
  }

  static Future<List<SessionLogEntry>> find(
    _i1.Session session, {
    SessionLogEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SessionLogEntry>(
      where: where != null ? where(SessionLogEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SessionLogEntry?> findSingleRow(
    _i1.Session session, {
    SessionLogEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SessionLogEntry>(
      where: where != null ? where(SessionLogEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SessionLogEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SessionLogEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required SessionLogEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    SessionLogEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SessionLogEntry>(
      where: where != null ? where(SessionLogEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef SessionLogEntryExpressionBuilder = _i1.Expression Function(
    SessionLogEntryTable);

class SessionLogEntryTable extends _i1.Table {
  SessionLogEntryTable() : super(tableName: 'serverpod_session_log');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = _i1.ColumnInt('id');

  /// The id of the server that handled this session.
  final serverId = _i1.ColumnString('serverId');

  /// The starting time of this session.
  final time = _i1.ColumnDateTime('time');

  /// The module this session is associated with, if any.
  final module = _i1.ColumnString('module');

  /// The endpoint this session is associated with, if any.
  final endpoint = _i1.ColumnString('endpoint');

  /// The method this session is associated with, if any.
  final method = _i1.ColumnString('method');

  /// The running time of this session. May be null if the session is still
  /// active.
  final duration = _i1.ColumnDouble('duration');

  /// The number of queries performed during this session.
  final numQueries = _i1.ColumnInt('numQueries');

  /// True if this session was slow to complete.
  final slow = _i1.ColumnBool('slow');

  /// If the session ends with an exception, the error field will be set.
  final error = _i1.ColumnString('error');

  /// If the session ends with an exception, a stack trace will be set.
  final stackTrace = _i1.ColumnString('stackTrace');

  /// The id of an authenticated user associated with this session. The user id
  /// is only set if it has been requested during the session. This means that
  /// it can be null, even though the session was performed by an authenticated
  /// user.
  final authenticatedUserId = _i1.ColumnInt('authenticatedUserId');

  /// True if the session is still open.
  final isOpen = _i1.ColumnBool('isOpen');

  /// Timestamp of the last time this record was modified.
  final touched = _i1.ColumnDateTime('touched');

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

@Deprecated('Use SessionLogEntryTable.t instead.')
SessionLogEntryTable tSessionLogEntry = SessionLogEntryTable();

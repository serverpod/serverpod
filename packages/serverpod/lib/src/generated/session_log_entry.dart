/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

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
    _i2.SerializationManager serializationManager,
  ) {
    return SessionLogEntry(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      time: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['time']),
      module: serializationManager
          .deserializeJson<String?>(jsonSerialization['module']),
      endpoint: serializationManager
          .deserializeJson<String?>(jsonSerialization['endpoint']),
      method: serializationManager
          .deserializeJson<String?>(jsonSerialization['method']),
      duration: serializationManager
          .deserializeJson<double?>(jsonSerialization['duration']),
      numQueries: serializationManager
          .deserializeJson<int?>(jsonSerialization['numQueries']),
      slow: serializationManager
          .deserializeJson<bool?>(jsonSerialization['slow']),
      error: serializationManager
          .deserializeJson<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserializeJson<String?>(jsonSerialization['stackTrace']),
      authenticatedUserId: serializationManager
          .deserializeJson<int?>(jsonSerialization['authenticatedUserId']),
      isOpen: serializationManager
          .deserializeJson<bool?>(jsonSerialization['isOpen']),
      touched: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['touched']),
    );
  }

  static final t = SessionLogEntryTable();

  String serverId;

  DateTime time;

  String? module;

  String? endpoint;

  String? method;

  double? duration;

  int? numQueries;

  bool? slow;

  String? error;

  String? stackTrace;

  int? authenticatedUserId;

  bool? isOpen;

  DateTime touched;

  @override
  String get className => 'SessionLogEntry';
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

  @override
  Map<String, dynamic> allToJson() {
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
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'time':
        time = value;
        return;
      case 'module':
        module = value;
        return;
      case 'endpoint':
        endpoint = value;
        return;
      case 'method':
        method = value;
        return;
      case 'duration':
        duration = value;
        return;
      case 'numQueries':
        numQueries = value;
        return;
      case 'slow':
        slow = value;
        return;
      case 'error':
        error = value;
        return;
      case 'stackTrace':
        stackTrace = value;
        return;
      case 'authenticatedUserId':
        authenticatedUserId = value;
        return;
      case 'isOpen':
        isOpen = value;
        return;
      case 'touched':
        touched = value;
        return;
      default:
        throw UnimplementedError();
    }
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

  final id = _i1.ColumnInt('id');

  final serverId = _i1.ColumnString('serverId');

  final time = _i1.ColumnDateTime('time');

  final module = _i1.ColumnString('module');

  final endpoint = _i1.ColumnString('endpoint');

  final method = _i1.ColumnString('method');

  final duration = _i1.ColumnDouble('duration');

  final numQueries = _i1.ColumnInt('numQueries');

  final slow = _i1.ColumnBool('slow');

  final error = _i1.ColumnString('error');

  final stackTrace = _i1.ColumnString('stackTrace');

  final authenticatedUserId = _i1.ColumnInt('authenticatedUserId');

  final isOpen = _i1.ColumnBool('isOpen');

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

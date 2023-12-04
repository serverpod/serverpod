/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Log entry for a session.
abstract class SessionLogEntry extends _i1.TableRow {
  SessionLogEntry._({
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

  static final t = SessionLogEntryTable();

  static const db = SessionLogEntryRepository._();

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
  _i1.Table get table => t;

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
  @Deprecated('Will be removed in 2.0.0')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<SessionLogEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<SessionLogEntry?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<SessionLogEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<SessionLogEntry>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SessionLogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
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

class SessionLogEntryTable extends _i1.Table {
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

@Deprecated('Use SessionLogEntryTable.t instead.')
SessionLogEntryTable tSessionLogEntry = SessionLogEntryTable();

class SessionLogEntryInclude extends _i1.IncludeObject {
  SessionLogEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => SessionLogEntry.t;
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
  _i1.Table get table => SessionLogEntry.t;
}

class SessionLogEntryRepository {
  const SessionLogEntryRepository._();

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
    return session.dbNext.find<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<SessionLogEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<SessionLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SessionLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      orderBy: orderBy?.call(SessionLogEntry.t),
      orderByList: orderByList?.call(SessionLogEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<SessionLogEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<SessionLogEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<SessionLogEntry>> insert(
    _i1.Session session,
    List<SessionLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<SessionLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<SessionLogEntry> insertRow(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<SessionLogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<SessionLogEntry>> update(
    _i1.Session session,
    List<SessionLogEntry> rows, {
    _i1.ColumnSelections<SessionLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<SessionLogEntry>(
      rows,
      columns: columns?.call(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  Future<SessionLogEntry> updateRow(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.ColumnSelections<SessionLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<SessionLogEntry>(
      row,
      columns: columns?.call(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<SessionLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<SessionLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    SessionLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<SessionLogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SessionLogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<SessionLogEntry>(
      where: where(SessionLogEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SessionLogEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<SessionLogEntry>(
      where: where?.call(SessionLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

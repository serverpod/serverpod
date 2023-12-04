/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

/// Bindings to a log entry in the database.
abstract class LogEntry extends _i1.TableRow {
  LogEntry._({
    int? id,
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
  }) : super(id);

  factory LogEntry({
    int? id,
    required int sessionLogId,
    int? messageId,
    String? reference,
    required String serverId,
    required DateTime time,
    required _i2.LogLevel logLevel,
    required String message,
    String? error,
    String? stackTrace,
    required int order,
  }) = _LogEntryImpl;

  factory LogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LogEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      sessionLogId: serializationManager
          .deserialize<int>(jsonSerialization['sessionLogId']),
      messageId: serializationManager
          .deserialize<int?>(jsonSerialization['messageId']),
      reference: serializationManager
          .deserialize<String?>(jsonSerialization['reference']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      logLevel: serializationManager
          .deserialize<_i2.LogLevel>(jsonSerialization['logLevel']),
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      error:
          serializationManager.deserialize<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserialize<String?>(jsonSerialization['stackTrace']),
      order: serializationManager.deserialize<int>(jsonSerialization['order']),
    );
  }

  static final t = LogEntryTable();

  static const db = LogEntryRepository._();

  /// The id of the session this log entry is associated with.
  int sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  int? messageId;

  /// Currently unused.
  String? reference;

  /// The id of the server which created this log entry.
  String serverId;

  /// Timpstamp of this log entry.
  DateTime time;

  /// The log level of this entry.
  _i2.LogLevel logLevel;

  /// The logging message.
  String message;

  /// Optional error associated with this log entry.
  String? error;

  /// Optional stack trace associated with this log entry.
  String? stackTrace;

  /// The order of this log entry, used for sorting.
  int order;

  @override
  _i1.Table get table => t;

  LogEntry copyWith({
    int? id,
    int? sessionLogId,
    int? messageId,
    String? reference,
    String? serverId,
    DateTime? time,
    _i2.LogLevel? logLevel,
    String? message,
    String? error,
    String? stackTrace,
    int? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'reference': reference,
      'serverId': serverId,
      'time': time,
      'logLevel': logLevel,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
      'order': order,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'reference': reference,
      'serverId': serverId,
      'time': time,
      'logLevel': logLevel,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
      'order': order,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'reference': reference,
      'serverId': serverId,
      'time': time,
      'logLevel': logLevel,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
      'order': order,
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
      case 'sessionLogId':
        sessionLogId = value;
        return;
      case 'messageId':
        messageId = value;
        return;
      case 'reference':
        reference = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'time':
        time = value;
        return;
      case 'logLevel':
        logLevel = value;
        return;
      case 'message':
        message = value;
        return;
      case 'error':
        error = value;
        return;
      case 'stackTrace':
        stackTrace = value;
        return;
      case 'order':
        order = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<LogEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<LogEntry>(
      where: where != null ? where(LogEntry.t) : null,
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
  static Future<LogEntry?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<LogEntry>(
      where: where != null ? where(LogEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<LogEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<LogEntry>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LogEntry>(
      where: where(LogEntry.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    LogEntry row, {
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
    LogEntry row, {
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
    LogEntry row, {
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
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LogEntry>(
      where: where != null ? where(LogEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static LogEntryInclude include() {
    return LogEntryInclude._();
  }

  static LogEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LogEntryTable>? orderByList,
    LogEntryInclude? include,
  }) {
    return LogEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LogEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LogEntry.t),
      include: include,
    );
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
    required _i2.LogLevel logLevel,
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

  @override
  LogEntry copyWith({
    Object? id = _Undefined,
    int? sessionLogId,
    Object? messageId = _Undefined,
    Object? reference = _Undefined,
    String? serverId,
    DateTime? time,
    _i2.LogLevel? logLevel,
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

class LogEntryTable extends _i1.Table {
  LogEntryTable({super.tableRelation}) : super(tableName: 'serverpod_log') {
    sessionLogId = _i1.ColumnInt(
      'sessionLogId',
      this,
    );
    messageId = _i1.ColumnInt(
      'messageId',
      this,
    );
    reference = _i1.ColumnString(
      'reference',
      this,
    );
    serverId = _i1.ColumnString(
      'serverId',
      this,
    );
    time = _i1.ColumnDateTime(
      'time',
      this,
    );
    logLevel = _i1.ColumnEnum(
      'logLevel',
      this,
      _i1.EnumSerialization.byIndex,
    );
    message = _i1.ColumnString(
      'message',
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
    order = _i1.ColumnInt(
      'order',
      this,
    );
  }

  /// The id of the session this log entry is associated with.
  late final _i1.ColumnInt sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  late final _i1.ColumnInt messageId;

  /// Currently unused.
  late final _i1.ColumnString reference;

  /// The id of the server which created this log entry.
  late final _i1.ColumnString serverId;

  /// Timpstamp of this log entry.
  late final _i1.ColumnDateTime time;

  /// The log level of this entry.
  late final _i1.ColumnEnum<_i2.LogLevel> logLevel;

  /// The logging message.
  late final _i1.ColumnString message;

  /// Optional error associated with this log entry.
  late final _i1.ColumnString error;

  /// Optional stack trace associated with this log entry.
  late final _i1.ColumnString stackTrace;

  /// The order of this log entry, used for sorting.
  late final _i1.ColumnInt order;

  @override
  List<_i1.Column> get columns => [
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

@Deprecated('Use LogEntryTable.t instead.')
LogEntryTable tLogEntry = LogEntryTable();

class LogEntryInclude extends _i1.IncludeObject {
  LogEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => LogEntry.t;
}

class LogEntryIncludeList extends _i1.IncludeList {
  LogEntryIncludeList._({
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LogEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => LogEntry.t;
}

class LogEntryRepository {
  const LogEntryRepository._();

  Future<List<LogEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<LogEntry>(
      where: where?.call(LogEntry.t),
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<LogEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<LogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<LogEntry>(
      where: where?.call(LogEntry.t),
      orderBy: orderBy?.call(LogEntry.t),
      orderByList: orderByList?.call(LogEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<LogEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<LogEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<LogEntry>> insert(
    _i1.Session session,
    List<LogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<LogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<LogEntry> insertRow(
    _i1.Session session,
    LogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<LogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<LogEntry>> update(
    _i1.Session session,
    List<LogEntry> rows, {
    _i1.ColumnSelections<LogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<LogEntry>(
      rows,
      columns: columns?.call(LogEntry.t),
      transaction: transaction,
    );
  }

  Future<LogEntry> updateRow(
    _i1.Session session,
    LogEntry row, {
    _i1.ColumnSelections<LogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<LogEntry>(
      row,
      columns: columns?.call(LogEntry.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<LogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<LogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    LogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<LogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<LogEntry>(
      where: where(LogEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LogEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<LogEntry>(
      where: where?.call(LogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

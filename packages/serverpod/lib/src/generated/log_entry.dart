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
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  factory LogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LogEntry(
      id: jsonSerialization['id'] as int?,
      sessionLogId: jsonSerialization['sessionLogId'] as int,
      messageId: jsonSerialization['messageId'] as int?,
      reference: jsonSerialization['reference'] as String?,
      serverId: jsonSerialization['serverId'] as String,
      time: _i1.DateTimeExt.getDateTime<DateTime>(jsonSerialization['time'])!,
      logLevel: _i2.LogLevel.fromJson((jsonSerialization['logLevel'] as int)),
      message: jsonSerialization['message'] as String,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      order: jsonSerialization['order'] as int,
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
  Map<String, dynamic> allToJson() {
    return {
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
    return session.db.find<LogEntry>(
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
    return session.db.findFirstRow<LogEntry>(
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
    return session.db.findById<LogEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<LogEntry>> insert(
    _i1.Session session,
    List<LogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<LogEntry> insertRow(
    _i1.Session session,
    LogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LogEntry>(
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
    return session.db.update<LogEntry>(
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
    return session.db.updateRow<LogEntry>(
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
    return session.db.delete<LogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    LogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LogEntry>(
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
    return session.db.count<LogEntry>(
      where: where?.call(LogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

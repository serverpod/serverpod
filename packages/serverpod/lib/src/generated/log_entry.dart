/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

typedef LogEntryExpressionBuilder = _i1.Expression Function(LogEntryTable);

/// Bindings to a log entry in the database.
abstract class LogEntry extends _i1.TableRow {
  const LogEntry._();

  const factory LogEntry({
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
  }) = _LogEntry;

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

  static const t = LogEntryTable();

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
  String get tableName => 'serverpod_log';
  @override
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

  static Future<List<LogEntry>> find(
    _i1.Session session, {
    LogEntryExpressionBuilder? where,
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

  static Future<LogEntry?> findSingleRow(
    _i1.Session session, {
    LogEntryExpressionBuilder? where,
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

  static Future<LogEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<LogEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required LogEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LogEntry>(
      where: where(LogEntry.t),
      transaction: transaction,
    );
  }

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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<LogEntry> insert(
    _i1.Session session,
    LogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    LogEntryExpressionBuilder? where,
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

  /// The id of the session this log entry is associated with.
  int get sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  int? get messageId;

  /// Currently unused.
  String? get reference;

  /// The id of the server which created this log entry.
  String get serverId;

  /// Timpstamp of this log entry.
  DateTime get time;

  /// The log level of this entry.
  _i2.LogLevel get logLevel;

  /// The logging message.
  String get message;

  /// Optional error associated with this log entry.
  String? get error;

  /// Optional stack trace associated with this log entry.
  String? get stackTrace;

  /// The order of this log entry, used for sorting.
  int get order;
}

class _Undefined {}

/// Bindings to a log entry in the database.
class _LogEntry extends LogEntry {
  const _LogEntry({
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
  }) : super._();

  /// The id of the session this log entry is associated with.
  @override
  final int sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  @override
  final int? messageId;

  /// Currently unused.
  @override
  final String? reference;

  /// The id of the server which created this log entry.
  @override
  final String serverId;

  /// Timpstamp of this log entry.
  @override
  final DateTime time;

  /// The log level of this entry.
  @override
  final _i2.LogLevel logLevel;

  /// The logging message.
  @override
  final String message;

  /// Optional error associated with this log entry.
  @override
  final String? error;

  /// Optional stack trace associated with this log entry.
  @override
  final String? stackTrace;

  /// The order of this log entry, used for sorting.
  @override
  final int order;

  @override
  String get tableName => 'serverpod_log';
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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is LogEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.sessionLogId,
                  sessionLogId,
                ) ||
                other.sessionLogId == sessionLogId) &&
            (identical(
                  other.messageId,
                  messageId,
                ) ||
                other.messageId == messageId) &&
            (identical(
                  other.reference,
                  reference,
                ) ||
                other.reference == reference) &&
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
                  other.logLevel,
                  logLevel,
                ) ||
                other.logLevel == logLevel) &&
            (identical(
                  other.message,
                  message,
                ) ||
                other.message == message) &&
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
                  other.order,
                  order,
                ) ||
                other.order == order));
  }

  @override
  int get hashCode => Object.hash(
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
      id: id == _Undefined ? this.id : (id as int?),
      sessionLogId: sessionLogId ?? this.sessionLogId,
      messageId: messageId == _Undefined ? this.messageId : (messageId as int?),
      reference:
          reference == _Undefined ? this.reference : (reference as String?),
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      logLevel: logLevel ?? this.logLevel,
      message: message ?? this.message,
      error: error == _Undefined ? this.error : (error as String?),
      stackTrace:
          stackTrace == _Undefined ? this.stackTrace : (stackTrace as String?),
      order: order ?? this.order,
    );
  }
}

class LogEntryTable extends _i1.Table {
  const LogEntryTable() : super(tableName: 'serverpod_log');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The id of the session this log entry is associated with.
  final sessionLogId = const _i1.ColumnInt('sessionLogId');

  /// The message id this entry is associated with, if in a streaming session.
  final messageId = const _i1.ColumnInt('messageId');

  /// Currently unused.
  final reference = const _i1.ColumnString('reference');

  /// The id of the server which created this log entry.
  final serverId = const _i1.ColumnString('serverId');

  /// Timpstamp of this log entry.
  final time = const _i1.ColumnDateTime('time');

  /// The log level of this entry.
  final logLevel = const _i1.ColumnEnum('logLevel');

  /// The logging message.
  final message = const _i1.ColumnString('message');

  /// Optional error associated with this log entry.
  final error = const _i1.ColumnString('error');

  /// Optional stack trace associated with this log entry.
  final stackTrace = const _i1.ColumnString('stackTrace');

  /// The order of this log entry, used for sorting.
  final order = const _i1.ColumnInt('order');

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
LogEntryTable tLogEntry = const LogEntryTable();

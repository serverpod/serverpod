/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef MessageLogEntryExpressionBuilder = _i1.Expression Function(
    MessageLogEntryTable);

/// A log entry for a message sent in a streaming session.
abstract class MessageLogEntry extends _i1.TableRow {
  const MessageLogEntry._();

  const factory MessageLogEntry({
    int? id,
    required int sessionLogId,
    required String serverId,
    required int messageId,
    required String endpoint,
    required String messageName,
    required double duration,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) = _MessageLogEntry;

  factory MessageLogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return MessageLogEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      sessionLogId: serializationManager
          .deserialize<int>(jsonSerialization['sessionLogId']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      messageId:
          serializationManager.deserialize<int>(jsonSerialization['messageId']),
      endpoint: serializationManager
          .deserialize<String>(jsonSerialization['endpoint']),
      messageName: serializationManager
          .deserialize<String>(jsonSerialization['messageName']),
      duration: serializationManager
          .deserialize<double>(jsonSerialization['duration']),
      error:
          serializationManager.deserialize<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserialize<String?>(jsonSerialization['stackTrace']),
      slow: serializationManager.deserialize<bool>(jsonSerialization['slow']),
      order: serializationManager.deserialize<int>(jsonSerialization['order']),
    );
  }

  static const t = MessageLogEntryTable();

  MessageLogEntry copyWith({
    int? id,
    int? sessionLogId,
    String? serverId,
    int? messageId,
    String? endpoint,
    String? messageName,
    double? duration,
    String? error,
    String? stackTrace,
    bool? slow,
    int? order,
  });
  @override
  String get tableName => 'serverpod_message_log';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      'error': error,
      'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  static Future<List<MessageLogEntry>> find(
    _i1.Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MessageLogEntry>(
      where: where != null ? where(MessageLogEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<MessageLogEntry?> findSingleRow(
    _i1.Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<MessageLogEntry>(
      where: where != null ? where(MessageLogEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<MessageLogEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<MessageLogEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required MessageLogEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MessageLogEntry>(
      where: where(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MessageLogEntry>(
      where: where != null ? where(MessageLogEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  /// Id of the session this entry is associated with.
  int get sessionLogId;

  /// The id of the server that handled the message.
  String get serverId;

  /// The id of the message this entry is associcated with.
  int get messageId;

  /// The entpoint this message is associated with.
  String get endpoint;

  /// The class name of the message this entry is associated with.
  String get messageName;

  /// The duration of handling of this message.
  double get duration;

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  String? get error;

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  String? get stackTrace;

  /// The handling of this message was slow.
  bool get slow;

  /// Used for sorting the message log.
  int get order;
}

class _Undefined {}

/// A log entry for a message sent in a streaming session.
class _MessageLogEntry extends MessageLogEntry {
  const _MessageLogEntry({
    int? id,
    required this.sessionLogId,
    required this.serverId,
    required this.messageId,
    required this.endpoint,
    required this.messageName,
    required this.duration,
    this.error,
    this.stackTrace,
    required this.slow,
    required this.order,
  }) : super._();

  /// Id of the session this entry is associated with.
  @override
  final int sessionLogId;

  /// The id of the server that handled the message.
  @override
  final String serverId;

  /// The id of the message this entry is associcated with.
  @override
  final int messageId;

  /// The entpoint this message is associated with.
  @override
  final String endpoint;

  /// The class name of the message this entry is associated with.
  @override
  final String messageName;

  /// The duration of handling of this message.
  @override
  final double duration;

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  @override
  final String? error;

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  @override
  final String? stackTrace;

  /// The handling of this message was slow.
  @override
  final bool slow;

  /// Used for sorting the message log.
  @override
  final int order;

  @override
  String get tableName => 'serverpod_message_log';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      'error': error,
      'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is MessageLogEntry &&
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
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.messageId,
                  messageId,
                ) ||
                other.messageId == messageId) &&
            (identical(
                  other.endpoint,
                  endpoint,
                ) ||
                other.endpoint == endpoint) &&
            (identical(
                  other.messageName,
                  messageName,
                ) ||
                other.messageName == messageName) &&
            (identical(
                  other.duration,
                  duration,
                ) ||
                other.duration == duration) &&
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
                  other.slow,
                  slow,
                ) ||
                other.slow == slow) &&
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
        serverId,
        messageId,
        endpoint,
        messageName,
        duration,
        error,
        stackTrace,
        slow,
        order,
      );

  @override
  MessageLogEntry copyWith({
    Object? id = _Undefined,
    int? sessionLogId,
    String? serverId,
    int? messageId,
    String? endpoint,
    String? messageName,
    double? duration,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    bool? slow,
    int? order,
  }) {
    return MessageLogEntry(
      id: id == _Undefined ? this.id : (id as int?),
      sessionLogId: sessionLogId ?? this.sessionLogId,
      serverId: serverId ?? this.serverId,
      messageId: messageId ?? this.messageId,
      endpoint: endpoint ?? this.endpoint,
      messageName: messageName ?? this.messageName,
      duration: duration ?? this.duration,
      error: error == _Undefined ? this.error : (error as String?),
      stackTrace:
          stackTrace == _Undefined ? this.stackTrace : (stackTrace as String?),
      slow: slow ?? this.slow,
      order: order ?? this.order,
    );
  }
}

class MessageLogEntryTable extends _i1.Table {
  const MessageLogEntryTable() : super(tableName: 'serverpod_message_log');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// Id of the session this entry is associated with.
  final sessionLogId = const _i1.ColumnInt('sessionLogId');

  /// The id of the server that handled the message.
  final serverId = const _i1.ColumnString('serverId');

  /// The id of the message this entry is associcated with.
  final messageId = const _i1.ColumnInt('messageId');

  /// The entpoint this message is associated with.
  final endpoint = const _i1.ColumnString('endpoint');

  /// The class name of the message this entry is associated with.
  final messageName = const _i1.ColumnString('messageName');

  /// The duration of handling of this message.
  final duration = const _i1.ColumnDouble('duration');

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  final error = const _i1.ColumnString('error');

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  final stackTrace = const _i1.ColumnString('stackTrace');

  /// The handling of this message was slow.
  final slow = const _i1.ColumnBool('slow');

  /// Used for sorting the message log.
  final order = const _i1.ColumnInt('order');

  @override
  List<_i1.Column> get columns => [
        id,
        sessionLogId,
        serverId,
        messageId,
        endpoint,
        messageName,
        duration,
        error,
        stackTrace,
        slow,
        order,
      ];
}

@Deprecated('Use MessageLogEntryTable.t instead.')
MessageLogEntryTable tMessageLogEntry = const MessageLogEntryTable();

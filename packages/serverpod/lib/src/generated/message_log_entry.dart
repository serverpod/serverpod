/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A log entry for a message sent in a streaming session.
abstract class MessageLogEntry extends _i1.TableRow {
  MessageLogEntry._({
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
  }) : super(id);

  factory MessageLogEntry({
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
  }) = _MessageLogEntryImpl;

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

  static final t = MessageLogEntryTable();

  static const db = MessageLogEntryRepository._();

  /// Id of the session this entry is associated with.
  int sessionLogId;

  /// The id of the server that handled the message.
  String serverId;

  /// The id of the message this entry is associated with.
  int messageId;

  /// The entpoint this message is associated with.
  String endpoint;

  /// The class name of the message this entry is associated with.
  String messageName;

  /// The duration of handling of this message.
  double duration;

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  String? error;

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  String? stackTrace;

  /// The handling of this message was slow.
  bool slow;

  /// Used for sorting the message log.
  int order;

  @override
  _i1.Table get table => t;

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
  @Deprecated('Will be removed in 2.0.0')
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

  @override
  Map<String, dynamic> allToJson() {
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
      case 'serverId':
        serverId = value;
        return;
      case 'messageId':
        messageId = value;
        return;
      case 'endpoint':
        endpoint = value;
        return;
      case 'messageName':
        messageName = value;
        return;
      case 'duration':
        duration = value;
        return;
      case 'error':
        error = value;
        return;
      case 'stackTrace':
        stackTrace = value;
        return;
      case 'slow':
        slow = value;
        return;
      case 'order':
        order = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<MessageLogEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<MessageLogEntry>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
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

  static MessageLogEntryInclude include() {
    return MessageLogEntryInclude._();
  }
}

class _Undefined {}

class _MessageLogEntryImpl extends MessageLogEntry {
  _MessageLogEntryImpl({
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
  }) : super._(
          id: id,
          sessionLogId: sessionLogId,
          serverId: serverId,
          messageId: messageId,
          endpoint: endpoint,
          messageName: messageName,
          duration: duration,
          error: error,
          stackTrace: stackTrace,
          slow: slow,
          order: order,
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
      id: id is int? ? id : this.id,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      serverId: serverId ?? this.serverId,
      messageId: messageId ?? this.messageId,
      endpoint: endpoint ?? this.endpoint,
      messageName: messageName ?? this.messageName,
      duration: duration ?? this.duration,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      slow: slow ?? this.slow,
      order: order ?? this.order,
    );
  }
}

typedef MessageLogEntryExpressionBuilder = _i1.Expression Function(
    MessageLogEntryTable);

class MessageLogEntryTable extends _i1.Table {
  MessageLogEntryTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_message_log') {
    sessionLogId = _i1.ColumnInt(
      'sessionLogId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    serverId = _i1.ColumnString(
      'serverId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    messageId = _i1.ColumnInt(
      'messageId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    endpoint = _i1.ColumnString(
      'endpoint',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    messageName = _i1.ColumnString(
      'messageName',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    duration = _i1.ColumnDouble(
      'duration',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    error = _i1.ColumnString(
      'error',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    stackTrace = _i1.ColumnString(
      'stackTrace',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    slow = _i1.ColumnBool(
      'slow',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    order = _i1.ColumnInt(
      'order',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// Id of the session this entry is associated with.
  late final _i1.ColumnInt sessionLogId;

  /// The id of the server that handled the message.
  late final _i1.ColumnString serverId;

  /// The id of the message this entry is associated with.
  late final _i1.ColumnInt messageId;

  /// The entpoint this message is associated with.
  late final _i1.ColumnString endpoint;

  /// The class name of the message this entry is associated with.
  late final _i1.ColumnString messageName;

  /// The duration of handling of this message.
  late final _i1.ColumnDouble duration;

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  late final _i1.ColumnString error;

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  late final _i1.ColumnString stackTrace;

  /// The handling of this message was slow.
  late final _i1.ColumnBool slow;

  /// Used for sorting the message log.
  late final _i1.ColumnInt order;

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
MessageLogEntryTable tMessageLogEntry = MessageLogEntryTable();

class MessageLogEntryInclude extends _i1.Include {
  MessageLogEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => MessageLogEntry.t;
}

class MessageLogEntryRepository {
  const MessageLogEntryRepository._();

  Future<List<MessageLogEntry>> find(
    _i1.Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<MessageLogEntry?> findRow(
    _i1.Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  Future<MessageLogEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<MessageLogEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<MessageLogEntry>> insert(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<MessageLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<MessageLogEntry> insertRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<MessageLogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<MessageLogEntry>> update(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<MessageLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<MessageLogEntry> updateRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<MessageLogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<MessageLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<MessageLogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required MessageLogEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<MessageLogEntry>(
      where: where(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

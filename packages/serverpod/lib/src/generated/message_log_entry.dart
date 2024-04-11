/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

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
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  static MessageLogEntryInclude include() {
    return MessageLogEntryInclude._();
  }

  static MessageLogEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MessageLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageLogEntryTable>? orderByList,
    MessageLogEntryInclude? include,
  }) {
    return MessageLogEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MessageLogEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(MessageLogEntry.t),
      include: include,
    );
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

class MessageLogEntryTable extends _i1.Table {
  MessageLogEntryTable({super.tableRelation})
      : super(tableName: 'serverpod_message_log') {
    sessionLogId = _i1.ColumnInt(
      'sessionLogId',
      this,
    );
    serverId = _i1.ColumnString(
      'serverId',
      this,
    );
    messageId = _i1.ColumnInt(
      'messageId',
      this,
    );
    endpoint = _i1.ColumnString(
      'endpoint',
      this,
    );
    messageName = _i1.ColumnString(
      'messageName',
      this,
    );
    duration = _i1.ColumnDouble(
      'duration',
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
    slow = _i1.ColumnBool(
      'slow',
      this,
    );
    order = _i1.ColumnInt(
      'order',
      this,
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

class MessageLogEntryInclude extends _i1.IncludeObject {
  MessageLogEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => MessageLogEntry.t;
}

class MessageLogEntryIncludeList extends _i1.IncludeList {
  MessageLogEntryIncludeList._({
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MessageLogEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => MessageLogEntry.t;
}

class MessageLogEntryRepository {
  const MessageLogEntryRepository._();

  Future<List<MessageLogEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<MessageLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      orderBy: orderBy?.call(MessageLogEntry.t),
      orderByList: orderByList?.call(MessageLogEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MessageLogEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<MessageLogEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<MessageLogEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      orderBy: orderBy?.call(MessageLogEntry.t),
      orderByList: orderByList?.call(MessageLogEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<MessageLogEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<MessageLogEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<MessageLogEntry>> insert(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<MessageLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<MessageLogEntry> insertRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<MessageLogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<MessageLogEntry>> update(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.ColumnSelections<MessageLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<MessageLogEntry>(
      rows,
      columns: columns?.call(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  Future<MessageLogEntry> updateRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.ColumnSelections<MessageLogEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<MessageLogEntry>(
      row,
      columns: columns?.call(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  Future<List<MessageLogEntry>> delete(
    _i1.Session session,
    List<MessageLogEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<MessageLogEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<MessageLogEntry> deleteRow(
    _i1.Session session,
    MessageLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MessageLogEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<MessageLogEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<MessageLogEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<MessageLogEntry>(
      where: where(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<MessageLogEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<MessageLogEntry>(
      where: where?.call(MessageLogEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

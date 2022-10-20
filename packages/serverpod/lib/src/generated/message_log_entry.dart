/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i2;

class MessageLogEntry extends _i1.TableRow {
  MessageLogEntry({
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

  factory MessageLogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i2.SerializationManager serializationManager,
  ) {
    return MessageLogEntry(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      sessionLogId: serializationManager
          .deserializeJson<int>(jsonSerialization['sessionLogId']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      messageId: serializationManager
          .deserializeJson<int>(jsonSerialization['messageId']),
      endpoint: serializationManager
          .deserializeJson<String>(jsonSerialization['endpoint']),
      messageName: serializationManager
          .deserializeJson<String>(jsonSerialization['messageName']),
      duration: serializationManager
          .deserializeJson<double>(jsonSerialization['duration']),
      error: serializationManager
          .deserializeJson<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserializeJson<String?>(jsonSerialization['stackTrace']),
      slow:
          serializationManager.deserializeJson<bool>(jsonSerialization['slow']),
      order:
          serializationManager.deserializeJson<int>(jsonSerialization['order']),
    );
  }

  static final t = MessageLogEntryTable();

  int sessionLogId;

  String serverId;

  int messageId;

  String endpoint;

  String messageName;

  double duration;

  String? error;

  String? stackTrace;

  bool slow;

  int order;

  @override
  String get className => 'MessageLogEntry';
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
}

typedef MessageLogEntryExpressionBuilder = _i1.Expression Function(
    MessageLogEntryTable);

class MessageLogEntryTable extends _i1.Table {
  MessageLogEntryTable() : super(tableName: 'serverpod_message_log');

  final id = _i1.ColumnInt('id');

  final sessionLogId = _i1.ColumnInt('sessionLogId');

  final serverId = _i1.ColumnString('serverId');

  final messageId = _i1.ColumnInt('messageId');

  final endpoint = _i1.ColumnString('endpoint');

  final messageName = _i1.ColumnString('messageName');

  final duration = _i1.ColumnDouble('duration');

  final error = _i1.ColumnString('error');

  final stackTrace = _i1.ColumnString('stackTrace');

  final slow = _i1.ColumnBool('slow');

  final order = _i1.ColumnInt('order');

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

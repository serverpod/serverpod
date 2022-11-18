/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class MessageLogEntry extends TableRow {
  @override
  String get className => 'MessageLogEntry';
  @override
  String get tableName => 'serverpod_message_log';

  static final t = MessageLogEntryTable();

  @override
  int? id;
  late int sessionLogId;
  late String serverId;
  late int messageId;
  late String endpoint;
  late String messageName;
  late double duration;
  String? error;
  String? stackTrace;
  late bool slow;
  late int order;

  MessageLogEntry({
    this.id,
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
  });

  MessageLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogId = _data['sessionLogId']!;
    serverId = _data['serverId']!;
    messageId = _data['messageId']!;
    endpoint = _data['endpoint']!;
    messageName = _data['messageName']!;
    duration = _data['duration']!;
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    slow = _data['slow']!;
    order = _data['order']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
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
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
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
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
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
    });
  }

  @override
  void setColumn(String columnName, value) {
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
    Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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
    Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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

  static Future<MessageLogEntry?> findById(Session session, int id) async {
    return session.db.findById<MessageLogEntry>(id);
  }

  static Future<int> delete(
    Session session, {
    required MessageLogEntryExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<MessageLogEntry>(
      where: where(MessageLogEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    MessageLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    MessageLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    MessageLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    MessageLogEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<MessageLogEntry>(
      where: where != null ? where(MessageLogEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef MessageLogEntryExpressionBuilder = Expression Function(
    MessageLogEntryTable t);

class MessageLogEntryTable extends Table {
  MessageLogEntryTable() : super(tableName: 'serverpod_message_log');

  @override
  String tableName = 'serverpod_message_log';
  final id = ColumnInt('id');
  final sessionLogId = ColumnInt('sessionLogId');
  final serverId = ColumnString('serverId');
  final messageId = ColumnInt('messageId');
  final endpoint = ColumnString('endpoint');
  final messageName = ColumnString('messageName');
  final duration = ColumnDouble('duration');
  final error = ColumnString('error');
  final stackTrace = ColumnString('stackTrace');
  final slow = ColumnBool('slow');
  final order = ColumnInt('order');

  @override
  List<Column> get columns => [
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

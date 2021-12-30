/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_auth_server/module.dart' as serverpod_auth;
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessage extends TableRow {
  @override
  String get className => 'serverpod_chat_server.ChatMessage';
  @override
  String get tableName => 'serverpod_chat_message';

  static final t = ChatMessageTable();

  @override
  int? id;
  late String channel;
  late String message;
  late DateTime time;
  late int sender;
  serverpod_auth.UserInfo? senderInfo;
  late bool removed;
  int? clientMessageId;
  bool? sent;
  List<ChatMessageAttachment>? attachments;

  ChatMessage({
    this.id,
    required this.channel,
    required this.message,
    required this.time,
    required this.sender,
    this.senderInfo,
    required this.removed,
    this.clientMessageId,
    this.sent,
    this.attachments,
  });

  ChatMessage.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    message = _data['message']!;
    time = DateTime.tryParse(_data['time'])!;
    sender = _data['sender']!;
    senderInfo = _data['senderInfo'] != null
        ? serverpod_auth.UserInfo?.fromSerialization(_data['senderInfo'])
        : null;
    removed = _data['removed']!;
    clientMessageId = _data['clientMessageId'];
    sent = _data['sent'];
    attachments = _data['attachments']
        ?.map<ChatMessageAttachment>(
            (a) => ChatMessageAttachment.fromSerialization(a))
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'message': message,
      'time': time.toUtc().toIso8601String(),
      'sender': sender,
      'senderInfo': senderInfo?.serialize(),
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
      'attachments':
          attachments?.map((ChatMessageAttachment a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'message': message,
      'time': time.toUtc().toIso8601String(),
      'sender': sender,
      'removed': removed,
      'attachments':
          attachments?.map((ChatMessageAttachment a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'message': message,
      'time': time.toUtc().toIso8601String(),
      'sender': sender,
      'senderInfo': senderInfo?.serialize(),
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
      'attachments':
          attachments?.map((ChatMessageAttachment a) => a.serialize()).toList(),
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'channel':
        channel = value;
        return;
      case 'message':
        message = value;
        return;
      case 'time':
        time = value;
        return;
      case 'sender':
        sender = value;
        return;
      case 'removed':
        removed = value;
        return;
      case 'attachments':
        attachments = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ChatMessage>> find(
    Session session, {
    ChatMessageExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<ChatMessage>(
      where: where != null ? where(ChatMessage.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ChatMessage?> findSingleRow(
    Session session, {
    ChatMessageExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ChatMessage>(
      where: where != null ? where(ChatMessage.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ChatMessage?> findById(Session session, int id) async {
    return session.db.findById<ChatMessage>(id);
  }

  static Future<int> delete(
    Session session, {
    required ChatMessageExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ChatMessage>(
      where: where(ChatMessage.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ChatMessage row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ChatMessage row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ChatMessage row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ChatMessageExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ChatMessage>(
      where: where != null ? where(ChatMessage.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ChatMessageExpressionBuilder = Expression Function(ChatMessageTable t);

class ChatMessageTable extends Table {
  ChatMessageTable() : super(tableName: 'serverpod_chat_message');

  @override
  String tableName = 'serverpod_chat_message';
  final id = ColumnInt('id');
  final channel = ColumnString('channel');
  final message = ColumnString('message');
  final time = ColumnDateTime('time');
  final sender = ColumnInt('sender');
  final removed = ColumnBool('removed');
  final attachments = ColumnSerializable('attachments');

  @override
  List<Column> get columns => [
        id,
        channel,
        message,
        time,
        sender,
        removed,
        attachments,
      ];
}

@Deprecated('Use ChatMessageTable.t instead.')
ChatMessageTable tChatMessage = ChatMessageTable();

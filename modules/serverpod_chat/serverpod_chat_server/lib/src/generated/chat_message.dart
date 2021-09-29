/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_auth_server/module.dart' as serverpod_auth;
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessage extends TableRow {
  @override
  String get className => 'serverpod_chat_server.ChatMessage';
  @override
  String get tableName => 'serverpod_chat_message';

  @override
  int? id;
  late String channel;
  late String type;
  late String message;
  late DateTime time;
  late int sender;
  serverpod_auth.UserInfo? senderInfo;
  late bool removed;
  int? clientMessageId;
  bool? sent;

  ChatMessage({
    this.id,
    required this.channel,
    required this.type,
    required this.message,
    required this.time,
    required this.sender,
    this.senderInfo,
    required this.removed,
    this.clientMessageId,
    this.sent,
});

  ChatMessage.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    type = _data['type']!;
    message = _data['message']!;
    time = DateTime.tryParse(_data['time'])!;
    sender = _data['sender']!;
    senderInfo = _data['senderInfo'] != null ? serverpod_auth.UserInfo?.fromSerialization(_data['senderInfo']) : null;
    removed = _data['removed']!;
    clientMessageId = _data['clientMessageId'];
    sent = _data['sent'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'type': type,
      'message': message,
      'time': time.toUtc().toIso8601String(),
      'sender': sender,
      'senderInfo': senderInfo?.serialize(),
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'type': type,
      'message': message,
      'time': time.toUtc().toIso8601String(),
      'sender': sender,
      'removed': removed,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'type': type,
      'message': message,
      'time': time.toUtc().toIso8601String(),
      'sender': sender,
      'senderInfo': senderInfo?.serialize(),
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
    });
  }
}

class ChatMessageTable extends Table {
  ChatMessageTable() : super(tableName: 'serverpod_chat_message');

  @override
  String tableName = 'serverpod_chat_message';
  final id = ColumnInt('id');
  final channel = ColumnString('channel');
  final type = ColumnString('type');
  final message = ColumnString('message');
  final time = ColumnDateTime('time');
  final sender = ColumnInt('sender');
  final removed = ColumnBool('removed');

  @override
  List<Column> get columns => [
    id,
    channel,
    type,
    message,
    time,
    sender,
    removed,
  ];
}

ChatMessageTable tChatMessage = ChatMessageTable();

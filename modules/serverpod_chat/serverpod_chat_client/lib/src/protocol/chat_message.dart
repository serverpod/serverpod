/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_auth_client/module.dart' as serverpod_auth;
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessage extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessage';

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
}

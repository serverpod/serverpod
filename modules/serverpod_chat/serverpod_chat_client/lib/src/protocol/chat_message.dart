/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_auth_client/module.dart' as serverpod_auth;
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessage extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessage';

  int? id;
  late String channel;
  late String type;
  late String message;
  late DateTime time;
  late int sender;
  serverpod_auth.UserInfo? senderInfo;
  late bool removed;

  ChatMessage({
    this.id,
    required this.channel,
    required this.type,
    required this.message,
    required this.time,
    required this.sender,
    this.senderInfo,
    required this.removed,
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
    });
  }
}


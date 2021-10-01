/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatReadMessage extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatReadMessage';

  int? id;
  late String channel;
  late int userId;
  late int lastReadMessageId;

  ChatReadMessage({
    this.id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
});

  ChatReadMessage.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    userId = _data['userId']!;
    lastReadMessageId = _data['lastReadMessageId']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    });
  }
}


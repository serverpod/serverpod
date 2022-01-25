/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessageChunk extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessageChunk';

  int? id;
  late String channel;
  late List<ChatMessage> messages;
  late bool hasOlderMessages;

  ChatMessageChunk({
    this.id,
    required this.channel,
    required this.messages,
    required this.hasOlderMessages,
  });

  ChatMessageChunk.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    messages = _data['messages']!
        .map<ChatMessage>((a) => ChatMessage.fromSerialization(a))
        ?.toList();
    hasOlderMessages = _data['hasOlderMessages']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'messages': messages.map((ChatMessage a) => a.serialize()).toList(),
      'hasOlderMessages': hasOlderMessages,
    });
  }
}

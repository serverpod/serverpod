/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessageChunk extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessageChunk';

  late String channel;
  late List<ChatMessage> messages;
  late bool hasOlderMessages;

  ChatMessageChunk({
    required this.channel,
    required this.messages,
    required this.hasOlderMessages,
  });

  ChatMessageChunk.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    channel = _data['channel']!;
    messages = _data['messages']!
        .map<ChatMessage>((a) => ChatMessage.fromSerialization(a))
        ?.toList();
    hasOlderMessages = _data['hasOlderMessages']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'channel': channel,
      'messages': messages.map((ChatMessage a) => a.serialize()).toList(),
      'hasOlderMessages': hasOlderMessages,
    });
  }
}

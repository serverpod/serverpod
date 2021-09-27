/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessagePost extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessagePost';

  int? id;
  late String channel;
  late String type;
  late String message;

  ChatMessagePost({
    this.id,
    required this.channel,
    required this.type,
    required this.message,
});

  ChatMessagePost.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    type = _data['type']!;
    message = _data['message']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'type': type,
      'message': message,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'type': type,
      'message': message,
    });
  }
}


/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatMessagePost extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessagePost';

  int? id;
  late String channel;
  late String message;
  late int clientMessageId;
  List<ChatMessageAttachment>? attachments;

  ChatMessagePost({
    this.id,
    required this.channel,
    required this.message,
    required this.clientMessageId,
    this.attachments,
  });

  ChatMessagePost.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    message = _data['message']!;
    clientMessageId = _data['clientMessageId']!;
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
      'clientMessageId': clientMessageId,
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
      'clientMessageId': clientMessageId,
      'attachments':
          attachments?.map((ChatMessageAttachment a) => a.serialize()).toList(),
    });
  }
}

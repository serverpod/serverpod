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

class ChatMessagePost extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatMessagePost';

  late String channel;
  late String message;
  late int clientMessageId;
  List<ChatMessageAttachment>? attachments;

  ChatMessagePost({
    required this.channel,
    required this.message,
    required this.clientMessageId,
    this.attachments,
  });

  ChatMessagePost.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
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
      'channel': channel,
      'message': message,
      'clientMessageId': clientMessageId,
      'attachments':
          attachments?.map((ChatMessageAttachment a) => a.serialize()).toList(),
    });
  }
}

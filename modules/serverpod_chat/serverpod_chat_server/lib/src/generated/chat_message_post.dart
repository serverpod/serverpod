/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class ChatMessagePost extends _i1.SerializableEntity {
  ChatMessagePost({
    required this.channel,
    required this.message,
    required this.clientMessageId,
    this.attachments,
  });

  factory ChatMessagePost.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessagePost(
      channel: serializationManager
          .deserializeJson<String>(jsonSerialization['channel']),
      message: serializationManager
          .deserializeJson<String>(jsonSerialization['message']),
      clientMessageId: serializationManager
          .deserializeJson<int>(jsonSerialization['clientMessageId']),
      attachments: serializationManager.deserializeJson<
          List<_i2.ChatMessageAttachment>?>(jsonSerialization['attachments']),
    );
  }

  String channel;

  String message;

  int clientMessageId;

  List<_i2.ChatMessageAttachment>? attachments;

  @override
  String get className => 'serverpod_chat_server.ChatMessagePost';
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'message': message,
      'clientMessageId': clientMessageId,
      'attachments': attachments,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'channel': channel,
      'message': message,
      'clientMessageId': clientMessageId,
      'attachments': attachments,
    };
  }
}

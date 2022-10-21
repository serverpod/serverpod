/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_auth_client/module.dart' as _i2;
import 'protocol.dart' as _i3;

class ChatMessage extends _i1.SerializableEntity {
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

  factory ChatMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessage(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      channel: serializationManager
          .deserializeJson<String>(jsonSerialization['channel']),
      message: serializationManager
          .deserializeJson<String>(jsonSerialization['message']),
      time: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['time']),
      sender: serializationManager
          .deserializeJson<int>(jsonSerialization['sender']),
      senderInfo: serializationManager
          .deserializeJson<_i2.UserInfo?>(jsonSerialization['senderInfo']),
      removed: serializationManager
          .deserializeJson<bool>(jsonSerialization['removed']),
      clientMessageId: serializationManager
          .deserializeJson<int?>(jsonSerialization['clientMessageId']),
      sent: serializationManager
          .deserializeJson<bool?>(jsonSerialization['sent']),
      attachments: serializationManager.deserializeJson<
          List<_i3.ChatMessageAttachment>?>(jsonSerialization['attachments']),
    );
  }

  int? id;

  String channel;

  String message;

  DateTime time;

  int sender;

  _i2.UserInfo? senderInfo;

  bool removed;

  int? clientMessageId;

  bool? sent;

  List<_i3.ChatMessageAttachment>? attachments;

  @override
  String get className => 'serverpod_chat_server.ChatMessage';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'message': message,
      'time': time,
      'sender': sender,
      'senderInfo': senderInfo,
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
      'attachments': attachments,
    };
  }
}

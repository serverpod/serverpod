/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class ChatReadMessage extends _i1.SerializableEntity {
  ChatReadMessage({
    this.id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  });

  factory ChatReadMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatReadMessage(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      channel: serializationManager
          .deserializeJson<String>(jsonSerialization['channel']),
      userId: serializationManager
          .deserializeJson<int>(jsonSerialization['userId']),
      lastReadMessageId: serializationManager
          .deserializeJson<int>(jsonSerialization['lastReadMessageId']),
    );
  }

  int? id;

  String channel;

  int userId;

  int lastReadMessageId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }
}

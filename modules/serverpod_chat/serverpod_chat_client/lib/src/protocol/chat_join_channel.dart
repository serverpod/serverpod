/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class ChatJoinChannel extends _i1.SerializableEntity {
  ChatJoinChannel({
    required this.channel,
    this.userName,
  });

  factory ChatJoinChannel.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatJoinChannel(
      channel: serializationManager
          .deserializeJson<String>(jsonSerialization['channel']),
      userName: serializationManager
          .deserializeJson<String?>(jsonSerialization['userName']),
    );
  }

  String channel;

  String? userName;

  @override
  String get className => 'serverpod_chat_server.ChatJoinChannel';
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'userName': userName,
    };
  }
}

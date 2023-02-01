/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A message indicating an attempt to join a channel.
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
          .deserialize<String>(jsonSerialization['channel']),
      userName: serializationManager
          .deserialize<String?>(jsonSerialization['userName']),
    );
  }

  /// The channel the user wants to join.
  String channel;

  /// The name of the user.
  String? userName;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'userName': userName,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'channel': channel,
      'userName': userName,
    };
  }
}

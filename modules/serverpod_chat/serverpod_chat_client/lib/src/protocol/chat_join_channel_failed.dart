/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Message being sent if a user failed to join a channel.
class ChatJoinChannelFailed extends _i1.SerializableEntity {
  ChatJoinChannelFailed({
    required this.channel,
    required this.reason,
  });

  factory ChatJoinChannelFailed.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatJoinChannelFailed(
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      reason:
          serializationManager.deserialize<String>(jsonSerialization['reason']),
    );
  }

  /// The name of the channel the user attempted to join.
  String channel;

  /// The reason of failure.
  String reason;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'reason': reason,
    };
  }
}

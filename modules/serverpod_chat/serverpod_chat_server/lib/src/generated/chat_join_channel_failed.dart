/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

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
          .deserializeJson<String>(jsonSerialization['channel']),
      reason: serializationManager
          .deserializeJson<String>(jsonSerialization['reason']),
    );
  }

  String channel;

  String reason;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'reason': reason,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'channel': channel,
      'reason': reason,
    };
  }
}

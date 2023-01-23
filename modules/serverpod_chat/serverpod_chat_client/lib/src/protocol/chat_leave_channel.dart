/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Indicates that a user wants to leave a channel.
class ChatLeaveChannel extends _i1.SerializableEntity {
  ChatLeaveChannel({required this.channel});

  factory ChatLeaveChannel.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatLeaveChannel(
        channel: serializationManager
            .deserialize<String>(jsonSerialization['channel']));
  }

  /// The name of the channel to leave.
  String channel;

  @override
  Map<String, dynamic> toJson() {
    return {'channel': channel};
  }
}

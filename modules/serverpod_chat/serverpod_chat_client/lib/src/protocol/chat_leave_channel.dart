/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Indicates that a user wants to leave a channel.
abstract class ChatLeaveChannel extends _i1.SerializableEntity {
  const ChatLeaveChannel._();

  const factory ChatLeaveChannel({required String channel}) = _ChatLeaveChannel;

  factory ChatLeaveChannel.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatLeaveChannel(
        channel: serializationManager
            .deserialize<String>(jsonSerialization['channel']));
  }

  ChatLeaveChannel copyWith({String? channel});

  /// The name of the channel to leave.
  String get channel;
}

/// Indicates that a user wants to leave a channel.
class _ChatLeaveChannel extends ChatLeaveChannel {
  const _ChatLeaveChannel({required this.channel}) : super._();

  /// The name of the channel to leave.
  @override
  final String channel;

  @override
  Map<String, dynamic> toJson() {
    return {'channel': channel};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatLeaveChannel &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel));
  }

  @override
  int get hashCode => channel.hashCode;

  @override
  ChatLeaveChannel copyWith({String? channel}) {
    return ChatLeaveChannel(channel: channel ?? this.channel);
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

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
  final String channel;

  /// The name of the user.
  final String? userName;

  late Function({
    String? channel,
    String? userName,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'userName': userName,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatJoinChannel &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel) &&
            (identical(
                  other.userName,
                  userName,
                ) ||
                other.userName == userName));
  }

  @override
  int get hashCode => Object.hash(
        channel,
        userName,
      );

  ChatJoinChannel _copyWith({
    String? channel,
    Object? userName = _Undefined,
  }) {
    return ChatJoinChannel(
      channel: channel ?? this.channel,
      userName: userName == _Undefined ? this.userName : (userName as String?),
    );
  }
}

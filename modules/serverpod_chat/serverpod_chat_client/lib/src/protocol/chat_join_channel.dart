/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A message indicating an attempt to join a channel.
abstract class ChatJoinChannel extends _i1.SerializableEntity {
  const ChatJoinChannel._();

  const factory ChatJoinChannel({
    required String channel,
    String? userName,
  }) = _ChatJoinChannel;

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

  ChatJoinChannel copyWith({
    String? channel,
    String? userName,
  });

  /// The channel the user wants to join.
  String get channel;

  /// The name of the user.
  String? get userName;
}

class _Undefined {}

/// A message indicating an attempt to join a channel.
class _ChatJoinChannel extends ChatJoinChannel {
  const _ChatJoinChannel({
    required this.channel,
    this.userName,
  }) : super._();

  /// The channel the user wants to join.
  @override
  final String channel;

  /// The name of the user.
  @override
  final String? userName;

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

  @override
  ChatJoinChannel copyWith({
    String? channel,
    Object? userName = _Undefined,
  }) {
    return ChatJoinChannel(
      channel: channel ?? this.channel,
      userName: userName == _Undefined ? this.userName : (userName as String?),
    );
  }
}

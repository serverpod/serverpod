/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_auth_server/module.dart' as _i3;

class _Undefined {}

/// A message passed to a user when it joins a channel.
class ChatJoinedChannel extends _i1.SerializableEntity {
  ChatJoinedChannel({
    required this.channel,
    required this.initialMessageChunk,
    required this.lastReadMessageId,
    required this.userInfo,
  });

  factory ChatJoinedChannel.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatJoinedChannel(
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      initialMessageChunk:
          serializationManager.deserialize<_i2.ChatMessageChunk>(
              jsonSerialization['initialMessageChunk']),
      lastReadMessageId: serializationManager
          .deserialize<int>(jsonSerialization['lastReadMessageId']),
      userInfo: serializationManager
          .deserialize<_i3.UserInfo>(jsonSerialization['userInfo']),
    );
  }

  /// The channel the user joined.
  final String channel;

  /// Initial chunk of chat messages from the channel the user joined.
  final _i2.ChatMessageChunk initialMessageChunk;

  /// The id of the last read message.
  final int lastReadMessageId;

  /// The user info of the user who joined the channel.
  final _i3.UserInfo userInfo;

  late Function({
    String? channel,
    _i2.ChatMessageChunk? initialMessageChunk,
    int? lastReadMessageId,
    _i3.UserInfo? userInfo,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'initialMessageChunk': initialMessageChunk,
      'lastReadMessageId': lastReadMessageId,
      'userInfo': userInfo,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatJoinedChannel &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel) &&
            (identical(
                  other.initialMessageChunk,
                  initialMessageChunk,
                ) ||
                other.initialMessageChunk == initialMessageChunk) &&
            (identical(
                  other.lastReadMessageId,
                  lastReadMessageId,
                ) ||
                other.lastReadMessageId == lastReadMessageId) &&
            (identical(
                  other.userInfo,
                  userInfo,
                ) ||
                other.userInfo == userInfo));
  }

  @override
  int get hashCode => Object.hash(
        channel,
        initialMessageChunk,
        lastReadMessageId,
        userInfo,
      );

  ChatJoinedChannel _copyWith({
    String? channel,
    _i2.ChatMessageChunk? initialMessageChunk,
    int? lastReadMessageId,
    _i3.UserInfo? userInfo,
  }) {
    return ChatJoinedChannel(
      channel: channel ?? this.channel,
      initialMessageChunk: initialMessageChunk ?? this.initialMessageChunk,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      userInfo: userInfo ?? this.userInfo,
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i3;

/// A message passed to a user when it joins a channel.
abstract class ChatJoinedChannel implements _i1.SerializableModel {
  ChatJoinedChannel._({
    required this.channel,
    required this.initialMessageChunk,
    required this.lastReadMessageId,
    required this.userInfo,
  });

  factory ChatJoinedChannel({
    required String channel,
    required _i2.ChatMessageChunk initialMessageChunk,
    required int lastReadMessageId,
    required _i3.UserInfo userInfo,
  }) = _ChatJoinedChannelImpl;

  factory ChatJoinedChannel.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatJoinedChannel(
      channel: jsonSerialization['channel'] as String,
      initialMessageChunk: _i2.ChatMessageChunk.fromJson(
          (jsonSerialization['initialMessageChunk'] as Map<String, dynamic>)),
      lastReadMessageId: jsonSerialization['lastReadMessageId'] as int,
      userInfo: _i3.UserInfo.fromJson(
          (jsonSerialization['userInfo'] as Map<String, dynamic>)),
    );
  }

  /// The channel the user joined.
  String channel;

  /// Initial chunk of chat messages from the channel the user joined.
  _i2.ChatMessageChunk initialMessageChunk;

  /// The id of the last read message.
  int lastReadMessageId;

  /// The user info of the user who joined the channel.
  _i3.UserInfo userInfo;

  ChatJoinedChannel copyWith({
    String? channel,
    _i2.ChatMessageChunk? initialMessageChunk,
    int? lastReadMessageId,
    _i3.UserInfo? userInfo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'initialMessageChunk': initialMessageChunk.toJson(),
      'lastReadMessageId': lastReadMessageId,
      'userInfo': userInfo.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatJoinedChannelImpl extends ChatJoinedChannel {
  _ChatJoinedChannelImpl({
    required String channel,
    required _i2.ChatMessageChunk initialMessageChunk,
    required int lastReadMessageId,
    required _i3.UserInfo userInfo,
  }) : super._(
          channel: channel,
          initialMessageChunk: initialMessageChunk,
          lastReadMessageId: lastReadMessageId,
          userInfo: userInfo,
        );

  @override
  ChatJoinedChannel copyWith({
    String? channel,
    _i2.ChatMessageChunk? initialMessageChunk,
    int? lastReadMessageId,
    _i3.UserInfo? userInfo,
  }) {
    return ChatJoinedChannel(
      channel: channel ?? this.channel,
      initialMessageChunk:
          initialMessageChunk ?? this.initialMessageChunk.copyWith(),
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
      userInfo: userInfo ?? this.userInfo.copyWith(),
    );
  }
}

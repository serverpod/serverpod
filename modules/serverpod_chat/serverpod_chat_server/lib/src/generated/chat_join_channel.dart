/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A message indicating an attempt to join a channel.
abstract class ChatJoinChannel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatJoinChannel._({
    required this.channel,
    this.userName,
  });

  factory ChatJoinChannel({
    required String channel,
    String? userName,
  }) = _ChatJoinChannelImpl;

  factory ChatJoinChannel.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatJoinChannel(
      channel: jsonSerialization['channel'] as String,
      userName: jsonSerialization['userName'] as String?,
    );
  }

  /// The channel the user wants to join.
  String channel;

  /// The name of the user.
  String? userName;

  /// Returns a shallow copy of this [ChatJoinChannel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatJoinChannel copyWith({
    String? channel,
    String? userName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      if (userName != null) 'userName': userName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'channel': channel,
      if (userName != null) 'userName': userName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatJoinChannelImpl extends ChatJoinChannel {
  _ChatJoinChannelImpl({
    required String channel,
    String? userName,
  }) : super._(
          channel: channel,
          userName: userName,
        );

  /// Returns a shallow copy of this [ChatJoinChannel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatJoinChannel copyWith({
    String? channel,
    Object? userName = _Undefined,
  }) {
    return ChatJoinChannel(
      channel: channel ?? this.channel,
      userName: userName is String? ? userName : this.userName,
    );
  }
}

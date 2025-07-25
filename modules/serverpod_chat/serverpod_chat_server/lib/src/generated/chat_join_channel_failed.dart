/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Message being sent if a user failed to join a channel.
abstract class ChatJoinChannelFailed
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatJoinChannelFailed._({
    required this.channel,
    required this.reason,
  });

  factory ChatJoinChannelFailed({
    required String channel,
    required String reason,
  }) = _ChatJoinChannelFailedImpl;

  factory ChatJoinChannelFailed.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ChatJoinChannelFailed(
      channel: jsonSerialization['channel'] as String,
      reason: jsonSerialization['reason'] as String,
    );
  }

  /// The name of the channel the user attempted to join.
  String channel;

  /// The reason of failure.
  String reason;

  /// Returns a shallow copy of this [ChatJoinChannelFailed]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatJoinChannelFailed copyWith({
    String? channel,
    String? reason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'reason': reason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'channel': channel,
      'reason': reason,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatJoinChannelFailedImpl extends ChatJoinChannelFailed {
  _ChatJoinChannelFailedImpl({
    required String channel,
    required String reason,
  }) : super._(
          channel: channel,
          reason: reason,
        );

  /// Returns a shallow copy of this [ChatJoinChannelFailed]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatJoinChannelFailed copyWith({
    String? channel,
    String? reason,
  }) {
    return ChatJoinChannelFailed(
      channel: channel ?? this.channel,
      reason: reason ?? this.reason,
    );
  }
}

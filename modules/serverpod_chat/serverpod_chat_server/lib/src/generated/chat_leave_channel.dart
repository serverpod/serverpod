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

/// Indicates that a user wants to leave a channel.
abstract class ChatLeaveChannel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatLeaveChannel._({required this.channel});

  factory ChatLeaveChannel({required String channel}) = _ChatLeaveChannelImpl;

  factory ChatLeaveChannel.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatLeaveChannel(channel: jsonSerialization['channel'] as String);
  }

  /// The name of the channel to leave.
  String channel;

  /// Returns a shallow copy of this [ChatLeaveChannel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatLeaveChannel copyWith({String? channel});
  @override
  Map<String, dynamic> toJson() {
    return {'channel': channel};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'channel': channel};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatLeaveChannelImpl extends ChatLeaveChannel {
  _ChatLeaveChannelImpl({required String channel}) : super._(channel: channel);

  /// Returns a shallow copy of this [ChatLeaveChannel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatLeaveChannel copyWith({String? channel}) {
    return ChatLeaveChannel(channel: channel ?? this.channel);
  }
}

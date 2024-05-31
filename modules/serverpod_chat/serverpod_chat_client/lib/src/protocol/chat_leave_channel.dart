/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Indicates that a user wants to leave a channel.
abstract class ChatLeaveChannel implements _i1.SerializableModel {
  ChatLeaveChannel._({required this.channel});

  factory ChatLeaveChannel({required String channel}) = _ChatLeaveChannelImpl;

  factory ChatLeaveChannel.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatLeaveChannel(channel: jsonSerialization['channel'] as String);
  }

  /// The name of the channel to leave.
  String channel;

  ChatLeaveChannel copyWith({String? channel});
  @override
  Map<String, dynamic> toJson() {
    return {'channel': channel};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatLeaveChannelImpl extends ChatLeaveChannel {
  _ChatLeaveChannelImpl({required String channel}) : super._(channel: channel);

  @override
  ChatLeaveChannel copyWith({String? channel}) {
    return ChatLeaveChannel(channel: channel ?? this.channel);
  }
}

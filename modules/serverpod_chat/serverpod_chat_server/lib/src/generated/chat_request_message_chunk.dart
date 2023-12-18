/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Message to request a new chunk of messages from the server.
abstract class ChatRequestMessageChunk extends _i1.SerializableEntity {
  ChatRequestMessageChunk._({
    required this.channel,
    required this.lastMessageId,
  });

  factory ChatRequestMessageChunk({
    required String channel,
    required int lastMessageId,
  }) = _ChatRequestMessageChunkImpl;

  factory ChatRequestMessageChunk.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatRequestMessageChunk(
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      lastMessageId: serializationManager
          .deserialize<int>(jsonSerialization['lastMessageId']),
    );
  }

  /// The channel to request messages from.
  String channel;

  /// The id of the last read message.
  int lastMessageId;

  ChatRequestMessageChunk copyWith({
    String? channel,
    int? lastMessageId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'lastMessageId': lastMessageId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'channel': channel,
      'lastMessageId': lastMessageId,
    };
  }
}

class _ChatRequestMessageChunkImpl extends ChatRequestMessageChunk {
  _ChatRequestMessageChunkImpl({
    required String channel,
    required int lastMessageId,
  }) : super._(
          channel: channel,
          lastMessageId: lastMessageId,
        );

  @override
  ChatRequestMessageChunk copyWith({
    String? channel,
    int? lastMessageId,
  }) {
    return ChatRequestMessageChunk(
      channel: channel ?? this.channel,
      lastMessageId: lastMessageId ?? this.lastMessageId,
    );
  }
}

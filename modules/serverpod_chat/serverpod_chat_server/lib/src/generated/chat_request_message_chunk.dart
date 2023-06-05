/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class _Undefined {}

/// Message to request a new chunk of messages from the server.
class ChatRequestMessageChunk extends _i1.SerializableEntity {
  ChatRequestMessageChunk({
    required this.channel,
    required this.lastMessageId,
  });

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
  final String channel;

  /// The id of the last read message.
  final int lastMessageId;

  late Function({
    String? channel,
    int? lastMessageId,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'lastMessageId': lastMessageId,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatRequestMessageChunk &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel) &&
            (identical(
                  other.lastMessageId,
                  lastMessageId,
                ) ||
                other.lastMessageId == lastMessageId));
  }

  @override
  int get hashCode => Object.hash(
        channel,
        lastMessageId,
      );

  ChatRequestMessageChunk _copyWith({
    String? channel,
    int? lastMessageId,
  }) {
    return ChatRequestMessageChunk(
      channel: channel ?? this.channel,
      lastMessageId: lastMessageId ?? this.lastMessageId,
    );
  }
}

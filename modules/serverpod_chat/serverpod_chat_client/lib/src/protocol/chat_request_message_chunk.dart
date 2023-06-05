/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Message to request a new chunk of messages from the server.
abstract class ChatRequestMessageChunk extends _i1.SerializableEntity {
  const ChatRequestMessageChunk._();

  const factory ChatRequestMessageChunk({
    required String channel,
    required int lastMessageId,
  }) = _ChatRequestMessageChunk;

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

  ChatRequestMessageChunk copyWith({
    String? channel,
    int? lastMessageId,
  });

  /// The channel to request messages from.
  String get channel;

  /// The id of the last read message.
  int get lastMessageId;
}

/// Message to request a new chunk of messages from the server.
class _ChatRequestMessageChunk extends ChatRequestMessageChunk {
  const _ChatRequestMessageChunk({
    required this.channel,
    required this.lastMessageId,
  }) : super._();

  /// The channel to request messages from.
  @override
  final String channel;

  /// The id of the last read message.
  @override
  final int lastMessageId;

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

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// A chunk of chat messages.
class ChatMessageChunk extends _i1.SerializableEntity {
  ChatMessageChunk({
    required this.channel,
    required this.messages,
    required this.hasOlderMessages,
  });

  factory ChatMessageChunk.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessageChunk(
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      messages: serializationManager
          .deserialize<List<_i2.ChatMessage>>(jsonSerialization['messages']),
      hasOlderMessages: serializationManager
          .deserialize<bool>(jsonSerialization['hasOlderMessages']),
    );
  }

  /// The chat channel.
  final String channel;

  /// List of chat messages.
  final List<_i2.ChatMessage> messages;

  /// True if there are more chat messages to fetch from this channel.
  final bool hasOlderMessages;

  late Function({
    String? channel,
    List<_i2.ChatMessage>? messages,
    bool? hasOlderMessages,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'messages': messages,
      'hasOlderMessages': hasOlderMessages,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatMessageChunk &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel) &&
            (identical(
                  other.hasOlderMessages,
                  hasOlderMessages,
                ) ||
                other.hasOlderMessages == hasOlderMessages) &&
            const _i3.DeepCollectionEquality().equals(
              messages,
              other.messages,
            ));
  }

  @override
  int get hashCode => Object.hash(
        channel,
        hasOlderMessages,
        const _i3.DeepCollectionEquality().hash(messages),
      );

  ChatMessageChunk _copyWith({
    String? channel,
    List<_i2.ChatMessage>? messages,
    bool? hasOlderMessages,
  }) {
    return ChatMessageChunk(
      channel: channel ?? this.channel,
      messages: messages ?? this.messages,
      hasOlderMessages: hasOlderMessages ?? this.hasOlderMessages,
    );
  }
}

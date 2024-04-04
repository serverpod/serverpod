/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// A chunk of chat messages.
abstract class ChatMessageChunk extends _i1.SerializableEntity {
  ChatMessageChunk._({
    required this.channel,
    required this.messages,
    required this.hasOlderMessages,
  });

  factory ChatMessageChunk({
    required String channel,
    required List<_i2.ChatMessage> messages,
    required bool hasOlderMessages,
  }) = _ChatMessageChunkImpl;

  factory ChatMessageChunk.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessageChunk(
      channel: jsonSerialization['channel'] as String,
      messages: (jsonSerialization['messages'] as List<dynamic>)
          .map((e) => _i2.ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasOlderMessages: jsonSerialization['hasOlderMessages'] as bool,
    );
  }

  /// The chat channel.
  String channel;

  /// List of chat messages.
  List<_i2.ChatMessage> messages;

  /// True if there are more chat messages to fetch from this channel.
  bool hasOlderMessages;

  ChatMessageChunk copyWith({
    String? channel,
    List<_i2.ChatMessage>? messages,
    bool? hasOlderMessages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'messages': messages.toJson(valueToJson: (v) => v.toJson()),
      'hasOlderMessages': hasOlderMessages,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'channel': channel,
      'messages': messages.toJson(valueToJson: (v) => v.allToJson()),
      'hasOlderMessages': hasOlderMessages,
    };
  }
}

class _ChatMessageChunkImpl extends ChatMessageChunk {
  _ChatMessageChunkImpl({
    required String channel,
    required List<_i2.ChatMessage> messages,
    required bool hasOlderMessages,
  }) : super._(
          channel: channel,
          messages: messages,
          hasOlderMessages: hasOlderMessages,
        );

  @override
  ChatMessageChunk copyWith({
    String? channel,
    List<_i2.ChatMessage>? messages,
    bool? hasOlderMessages,
  }) {
    return ChatMessageChunk(
      channel: channel ?? this.channel,
      messages: messages ?? this.messages.clone(),
      hasOlderMessages: hasOlderMessages ?? this.hasOlderMessages,
    );
  }
}

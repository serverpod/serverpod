/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

/// A chat message post request.
abstract class ChatMessagePost extends _i1.SerializableEntity {
  const ChatMessagePost._();

  const factory ChatMessagePost({
    required String channel,
    required String message,
    required int clientMessageId,
    List<_i2.ChatMessageAttachment>? attachments,
  }) = _ChatMessagePost;

  factory ChatMessagePost.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessagePost(
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      clientMessageId: serializationManager
          .deserialize<int>(jsonSerialization['clientMessageId']),
      attachments:
          serializationManager.deserialize<List<_i2.ChatMessageAttachment>?>(
              jsonSerialization['attachments']),
    );
  }

  ChatMessagePost copyWith({
    String? channel,
    String? message,
    int? clientMessageId,
    List<_i2.ChatMessageAttachment>? attachments,
  });

  /// The channel this message is posted to.
  String get channel;

  /// The body of the message.
  String get message;

  /// The client id of the message, used to track message deliveries.
  int get clientMessageId;

  /// List of attachments associated with this message.
  List<_i2.ChatMessageAttachment>? get attachments;
}

class _Undefined {}

/// A chat message post request.
class _ChatMessagePost extends ChatMessagePost {
  const _ChatMessagePost({
    required this.channel,
    required this.message,
    required this.clientMessageId,
    this.attachments,
  }) : super._();

  /// The channel this message is posted to.
  @override
  final String channel;

  /// The body of the message.
  @override
  final String message;

  /// The client id of the message, used to track message deliveries.
  @override
  final int clientMessageId;

  /// List of attachments associated with this message.
  @override
  final List<_i2.ChatMessageAttachment>? attachments;

  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'message': message,
      'clientMessageId': clientMessageId,
      'attachments': attachments,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatMessagePost &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel) &&
            (identical(
                  other.message,
                  message,
                ) ||
                other.message == message) &&
            (identical(
                  other.clientMessageId,
                  clientMessageId,
                ) ||
                other.clientMessageId == clientMessageId) &&
            const _i3.DeepCollectionEquality().equals(
              attachments,
              other.attachments,
            ));
  }

  @override
  int get hashCode => Object.hash(
        channel,
        message,
        clientMessageId,
        const _i3.DeepCollectionEquality().hash(attachments),
      );

  @override
  ChatMessagePost copyWith({
    String? channel,
    String? message,
    int? clientMessageId,
    Object? attachments = _Undefined,
  }) {
    return ChatMessagePost(
      channel: channel ?? this.channel,
      message: message ?? this.message,
      clientMessageId: clientMessageId ?? this.clientMessageId,
      attachments: attachments == _Undefined
          ? this.attachments
          : (attachments as List<_i2.ChatMessageAttachment>?),
    );
  }
}

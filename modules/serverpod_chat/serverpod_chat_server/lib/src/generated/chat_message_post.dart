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
import 'chat_message_attachment.dart' as _i2;

/// A chat message post request.
abstract class ChatMessagePost
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatMessagePost._({
    required this.channel,
    required this.message,
    required this.clientMessageId,
    this.attachments,
  });

  factory ChatMessagePost({
    required String channel,
    required String message,
    required int clientMessageId,
    List<_i2.ChatMessageAttachment>? attachments,
  }) = _ChatMessagePostImpl;

  factory ChatMessagePost.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessagePost(
      channel: jsonSerialization['channel'] as String,
      message: jsonSerialization['message'] as String,
      clientMessageId: jsonSerialization['clientMessageId'] as int,
      attachments: (jsonSerialization['attachments'] as List?)
          ?.map((e) =>
              _i2.ChatMessageAttachment.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The channel this message is posted to.
  String channel;

  /// The body of the message.
  String message;

  /// The client id of the message, used to track message deliveries.
  int clientMessageId;

  /// List of attachments associated with this message.
  List<_i2.ChatMessageAttachment>? attachments;

  /// Returns a shallow copy of this [ChatMessagePost]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessagePost copyWith({
    String? channel,
    String? message,
    int? clientMessageId,
    List<_i2.ChatMessageAttachment>? attachments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'channel': channel,
      'message': message,
      'clientMessageId': clientMessageId,
      if (attachments != null)
        'attachments': attachments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'channel': channel,
      'message': message,
      'clientMessageId': clientMessageId,
      if (attachments != null)
        'attachments':
            attachments?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatMessagePostImpl extends ChatMessagePost {
  _ChatMessagePostImpl({
    required String channel,
    required String message,
    required int clientMessageId,
    List<_i2.ChatMessageAttachment>? attachments,
  }) : super._(
          channel: channel,
          message: message,
          clientMessageId: clientMessageId,
          attachments: attachments,
        );

  /// Returns a shallow copy of this [ChatMessagePost]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      attachments: attachments is List<_i2.ChatMessageAttachment>?
          ? attachments
          : this.attachments?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

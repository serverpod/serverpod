/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_auth_client/module.dart' as _i2;
import 'protocol.dart' as _i3;
import 'package:collection/collection.dart' as _i4;

class _Undefined {}

/// A chat message.
class ChatMessage extends _i1.SerializableEntity {
  ChatMessage({
    this.id,
    required this.channel,
    required this.message,
    required this.time,
    required this.sender,
    this.senderInfo,
    required this.removed,
    this.clientMessageId,
    this.sent,
    this.attachments,
  });

  factory ChatMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessage(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      sender:
          serializationManager.deserialize<int>(jsonSerialization['sender']),
      senderInfo: serializationManager
          .deserialize<_i2.UserInfoPublic?>(jsonSerialization['senderInfo']),
      removed:
          serializationManager.deserialize<bool>(jsonSerialization['removed']),
      clientMessageId: serializationManager
          .deserialize<int?>(jsonSerialization['clientMessageId']),
      sent: serializationManager.deserialize<bool?>(jsonSerialization['sent']),
      attachments:
          serializationManager.deserialize<List<_i3.ChatMessageAttachment>?>(
              jsonSerialization['attachments']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// The channel this message was posted to.
  final String channel;

  /// The body of the message.
  final String message;

  /// The time when this message was posted.
  final DateTime time;

  /// The user id of the sender.
  final int sender;

  /// Information about the sender.
  final _i2.UserInfoPublic? senderInfo;

  /// True, if this message has been removed.
  final bool removed;

  /// The client message id, used to track if a message has been delivered.
  final int? clientMessageId;

  /// True if the message has been sent.
  final bool? sent;

  /// List of attachments associated with this message.
  final List<_i3.ChatMessageAttachment>? attachments;

  late Function({
    int? id,
    String? channel,
    String? message,
    DateTime? time,
    int? sender,
    _i2.UserInfoPublic? senderInfo,
    bool? removed,
    int? clientMessageId,
    bool? sent,
    List<_i3.ChatMessageAttachment>? attachments,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'message': message,
      'time': time,
      'sender': sender,
      'senderInfo': senderInfo,
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
      'attachments': attachments,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatMessage &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
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
                  other.time,
                  time,
                ) ||
                other.time == time) &&
            (identical(
                  other.sender,
                  sender,
                ) ||
                other.sender == sender) &&
            (identical(
                  other.senderInfo,
                  senderInfo,
                ) ||
                other.senderInfo == senderInfo) &&
            (identical(
                  other.removed,
                  removed,
                ) ||
                other.removed == removed) &&
            (identical(
                  other.clientMessageId,
                  clientMessageId,
                ) ||
                other.clientMessageId == clientMessageId) &&
            (identical(
                  other.sent,
                  sent,
                ) ||
                other.sent == sent) &&
            const _i4.DeepCollectionEquality().equals(
              attachments,
              other.attachments,
            ));
  }

  @override
  int get hashCode => Object.hash(
        id,
        channel,
        message,
        time,
        sender,
        senderInfo,
        removed,
        clientMessageId,
        sent,
        const _i4.DeepCollectionEquality().hash(attachments),
      );

  ChatMessage _copyWith({
    Object? id = _Undefined,
    String? channel,
    String? message,
    DateTime? time,
    int? sender,
    Object? senderInfo = _Undefined,
    bool? removed,
    Object? clientMessageId = _Undefined,
    Object? sent = _Undefined,
    Object? attachments = _Undefined,
  }) {
    return ChatMessage(
      id: id == _Undefined ? this.id : (id as int?),
      channel: channel ?? this.channel,
      message: message ?? this.message,
      time: time ?? this.time,
      sender: sender ?? this.sender,
      senderInfo: senderInfo == _Undefined
          ? this.senderInfo
          : (senderInfo as _i2.UserInfoPublic?),
      removed: removed ?? this.removed,
      clientMessageId: clientMessageId == _Undefined
          ? this.clientMessageId
          : (clientMessageId as int?),
      sent: sent == _Undefined ? this.sent : (sent as bool?),
      attachments: attachments == _Undefined
          ? this.attachments
          : (attachments as List<_i3.ChatMessageAttachment>?),
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Message to notifiy the server that messages have been read.
abstract class ChatReadMessage extends _i1.SerializableEntity {
  const ChatReadMessage._();

  const factory ChatReadMessage({
    int? id,
    required String channel,
    required int userId,
    required int lastReadMessageId,
  }) = _ChatReadMessage;

  factory ChatReadMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatReadMessage(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      lastReadMessageId: serializationManager
          .deserialize<int>(jsonSerialization['lastReadMessageId']),
    );
  }

  ChatReadMessage copyWith({
    int? id,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The channel this that has been read.
  String get channel;

  /// The id of the user that read the messages.
  int get userId;

  /// The id of the last read message.
  int get lastReadMessageId;
}

class _Undefined {}

/// Message to notifiy the server that messages have been read.
class _ChatReadMessage extends ChatReadMessage {
  const _ChatReadMessage({
    this.id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The channel this that has been read.
  @override
  final String channel;

  /// The id of the user that read the messages.
  @override
  final int userId;

  /// The id of the last read message.
  @override
  final int lastReadMessageId;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatReadMessage &&
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
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.lastReadMessageId,
                  lastReadMessageId,
                ) ||
                other.lastReadMessageId == lastReadMessageId));
  }

  @override
  int get hashCode => Object.hash(
        id,
        channel,
        userId,
        lastReadMessageId,
      );

  @override
  ChatReadMessage copyWith({
    Object? id = _Undefined,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  }) {
    return ChatReadMessage(
      id: id == _Undefined ? this.id : (id as int?),
      channel: channel ?? this.channel,
      userId: userId ?? this.userId,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }
}

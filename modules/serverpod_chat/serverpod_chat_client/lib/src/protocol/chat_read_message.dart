/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Message to notify the server that messages have been read.
abstract class ChatReadMessage implements _i1.SerializableModel {
  ChatReadMessage._({
    this.id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  });

  factory ChatReadMessage({
    int? id,
    required String channel,
    required int userId,
    required int lastReadMessageId,
  }) = _ChatReadMessageImpl;

  factory ChatReadMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatReadMessage(
      id: jsonSerialization['id'] as int?,
      channel: jsonSerialization['channel'] as String,
      userId: jsonSerialization['userId'] as int,
      lastReadMessageId: jsonSerialization['lastReadMessageId'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The channel this that has been read.
  String channel;

  /// The id of the user that read the messages.
  int userId;

  /// The id of the last read message.
  int lastReadMessageId;

  /// Returns a shallow copy of this [ChatReadMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatReadMessage copyWith({
    int? id,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatReadMessageImpl extends ChatReadMessage {
  _ChatReadMessageImpl({
    int? id,
    required String channel,
    required int userId,
    required int lastReadMessageId,
  }) : super._(
          id: id,
          channel: channel,
          userId: userId,
          lastReadMessageId: lastReadMessageId,
        );

  /// Returns a shallow copy of this [ChatReadMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatReadMessage copyWith({
    Object? id = _Undefined,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  }) {
    return ChatReadMessage(
      id: id is int? ? id : this.id,
      channel: channel ?? this.channel,
      userId: userId ?? this.userId,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }
}

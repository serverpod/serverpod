/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Message to notifiy the server that messages have been read.
class ChatReadMessage extends _i1.SerializableEntity {
  ChatReadMessage({
    this.id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  });

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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }
}

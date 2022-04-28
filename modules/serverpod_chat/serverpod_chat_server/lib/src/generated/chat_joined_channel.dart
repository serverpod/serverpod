/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:serverpod_auth_server/module.dart' as serverpod_auth;
import 'dart:typed_data';
import 'protocol.dart';

class ChatJoinedChannel extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatJoinedChannel';

  int? id;
  late String channel;
  late ChatMessageChunk initialMessageChunk;
  late int lastReadMessageId;
  late serverpod_auth.UserInfo userInfo;

  ChatJoinedChannel({
    this.id,
    required this.channel,
    required this.initialMessageChunk,
    required this.lastReadMessageId,
    required this.userInfo,
  });

  ChatJoinedChannel.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    initialMessageChunk =
        ChatMessageChunk.fromSerialization(_data['initialMessageChunk']);
    lastReadMessageId = _data['lastReadMessageId']!;
    userInfo = serverpod_auth.UserInfo.fromSerialization(_data['userInfo']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'channel': channel,
      'initialMessageChunk': initialMessageChunk.serialize(),
      'lastReadMessageId': lastReadMessageId,
      'userInfo': userInfo.serialize(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'channel': channel,
      'initialMessageChunk': initialMessageChunk.serialize(),
      'lastReadMessageId': lastReadMessageId,
      'userInfo': userInfo.serialize(),
    });
  }
}

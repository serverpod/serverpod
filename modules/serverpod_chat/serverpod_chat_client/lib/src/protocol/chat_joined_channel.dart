/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatJoinedChannel extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatJoinedChannel';

  int? id;
  late String channel;
  late ChatMessageChunk initialMessageChunk;
  late int lastReadMessageId;
  late module:auth:UserInfo userInfo;

  ChatJoinedChannel({
    this.id,
    required this.channel,
    required this.initialMessageChunk,
    required this.lastReadMessageId,
    required this.userInfo,
});

  ChatJoinedChannel.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    initialMessageChunk = ChatMessageChunk.fromSerialization(_data['initialMessageChunk']);
    lastReadMessageId = _data['lastReadMessageId']!;
    userInfo = module:auth:UserInfo.fromSerialization(_data['userInfo']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'initialMessageChunk': initialMessageChunk.serialize(),
      'lastReadMessageId': lastReadMessageId,
      'userInfo': userInfo.serialize(),
    });
  }
}


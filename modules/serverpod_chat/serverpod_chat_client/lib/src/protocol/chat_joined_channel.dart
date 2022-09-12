/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_auth_client/module.dart' as serverpod_auth;
import 'dart:typed_data';
import 'protocol.dart';

class ChatJoinedChannel extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatJoinedChannel';

  late String channel;
  late ChatMessageChunk initialMessageChunk;
  late int lastReadMessageId;
  late serverpod_auth.UserInfo userInfo;

  ChatJoinedChannel({
    required this.channel,
    required this.initialMessageChunk,
    required this.lastReadMessageId,
    required this.userInfo,
  });

  ChatJoinedChannel.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    channel = _data['channel']!;
    initialMessageChunk =
        ChatMessageChunk.fromSerialization(_data['initialMessageChunk']);
    lastReadMessageId = _data['lastReadMessageId']!;
    userInfo = serverpod_auth.UserInfo.fromSerialization(_data['userInfo']);
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'channel': channel,
      'initialMessageChunk': initialMessageChunk.serialize(),
      'lastReadMessageId': lastReadMessageId,
      'userInfo': userInfo.serialize(),
    });
  }
}

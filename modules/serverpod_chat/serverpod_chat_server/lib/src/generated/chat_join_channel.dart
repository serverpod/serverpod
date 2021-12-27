/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatJoinChannel extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatJoinChannel';

  int? id;
  late String channel;
  String? userName;

  ChatJoinChannel({
    this.id,
    required this.channel,
    this.userName,
  });

  ChatJoinChannel.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    userName = _data['userName'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'userName': userName,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'userName': userName,
    });
  }
}

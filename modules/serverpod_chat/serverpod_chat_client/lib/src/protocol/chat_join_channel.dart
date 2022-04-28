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
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    userName = _data['userName'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'channel': channel,
      'userName': userName,
    });
  }
}

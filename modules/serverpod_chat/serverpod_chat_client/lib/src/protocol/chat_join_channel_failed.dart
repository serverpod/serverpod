/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatJoinChannelFailed extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatJoinChannelFailed';

  int? id;
  late String channel;
  late String reason;

  ChatJoinChannelFailed({
    this.id,
    required this.channel,
    required this.reason,
  });

  ChatJoinChannelFailed.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    reason = _data['reason']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'reason': reason,
    });
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatJoinChannelFailed extends SerializableEntity {
  @override
  String get className => 'serverpod_chat_server.ChatJoinChannelFailed';

  int? id;
  late String reason;

  ChatJoinChannelFailed({
    this.id,
    required this.reason,
});

  ChatJoinChannelFailed.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    reason = _data['reason']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'reason': reason,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'reason': reason,
    });
  }
}


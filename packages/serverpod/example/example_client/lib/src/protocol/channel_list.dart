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

class ChannelList extends SerializableEntity {
  @override
  String get className => 'ChannelList';

  int? id;
  late List<Channel> channels;

  ChannelList({
    this.id,
    required this.channels,
  });

  ChannelList.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channels = _data['channels']!
        .map<Channel>((a) => Channel.fromSerialization(a))
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channels': channels.map((Channel a) => a.serialize()).toList(),
    });
  }
}

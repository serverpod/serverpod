/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs

library protocol;

// ignore: unused_import
import 'dart:typed_data';
import 'package:serverpod/serverpod.dart';

import 'chat_leave_channel.dart';
import 'chat_join_channel.dart';
import 'chat_join_channel_failed.dart';
import 'chat_message.dart';
import 'chat_message_post.dart';
import 'chat_joined_channel.dart';

export 'chat_leave_channel.dart';
export 'chat_join_channel.dart';
export 'chat_join_channel_failed.dart';
export 'chat_message.dart';
export 'chat_message_post.dart';
export 'chat_joined_channel.dart';

class Protocol extends SerializationManager {
  static final Protocol instance = Protocol();

  final Map<String, constructor> _constructors = {};
  @override
  Map<String, constructor> get constructors => _constructors;
  final Map<String,String> _tableClassMapping = {};
  @override
  Map<String,String> get tableClassMapping => _tableClassMapping;

  Protocol() {
    constructors['serverpod_chat_server.ChatLeaveChannel'] = (Map<String, dynamic> serialization) => ChatLeaveChannel.fromSerialization(serialization);
    constructors['serverpod_chat_server.ChatJoinChannel'] = (Map<String, dynamic> serialization) => ChatJoinChannel.fromSerialization(serialization);
    constructors['serverpod_chat_server.ChatJoinChannelFailed'] = (Map<String, dynamic> serialization) => ChatJoinChannelFailed.fromSerialization(serialization);
    constructors['serverpod_chat_server.ChatMessage'] = (Map<String, dynamic> serialization) => ChatMessage.fromSerialization(serialization);
    constructors['serverpod_chat_server.ChatMessagePost'] = (Map<String, dynamic> serialization) => ChatMessagePost.fromSerialization(serialization);
    constructors['serverpod_chat_server.ChatJoinedChannel'] = (Map<String, dynamic> serialization) => ChatJoinedChannel.fromSerialization(serialization);

    tableClassMapping['serverpod_chat_message'] = 'serverpod_chat_server.ChatMessage';
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'chat_join_channel.dart' as _i2;
import 'chat_join_channel_failed.dart' as _i3;
import 'chat_joined_channel.dart' as _i4;
import 'chat_leave_channel.dart' as _i5;
import 'chat_message.dart' as _i6;
import 'chat_message_attachment.dart' as _i7;
import 'chat_message_attachment_upload_description.dart' as _i8;
import 'chat_message_chunk.dart' as _i9;
import 'chat_message_post.dart' as _i10;
import 'chat_read_message.dart' as _i11;
import 'chat_request_message_chunk.dart' as _i12;
import 'protocol.dart' as _i13;
export 'chat_join_channel.dart';
export 'chat_join_channel_failed.dart';
export 'chat_joined_channel.dart';
export 'chat_leave_channel.dart';
export 'chat_message.dart';
export 'chat_message_attachment.dart';
export 'chat_message_attachment_upload_description.dart';
export 'chat_message_chunk.dart';
export 'chat_message_post.dart';
export 'chat_read_message.dart';
export 'chat_request_message_chunk.dart';
export 'client.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManager {
  static final Protocol instance = Protocol();

  @override
  final Map<Type, _i1.constructor> constructors = {
    _i2.ChatJoinChannel: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i2.ChatJoinChannel.fromJson(jsonSerialization, serializationManager),
    _i3.ChatJoinChannelFailed:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i3.ChatJoinChannelFailed.fromJson(
                jsonSerialization, serializationManager),
    _i4.ChatJoinedChannel: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i4.ChatJoinedChannel.fromJson(jsonSerialization, serializationManager),
    _i5.ChatLeaveChannel: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i5.ChatLeaveChannel.fromJson(jsonSerialization, serializationManager),
    _i6.ChatMessage:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i6.ChatMessage.fromJson(jsonSerialization, serializationManager),
    _i7.ChatMessageAttachment:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i7.ChatMessageAttachment.fromJson(
                jsonSerialization, serializationManager),
    _i8.ChatMessageAttachmentUploadDescription:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i8.ChatMessageAttachmentUploadDescription.fromJson(
                jsonSerialization, serializationManager),
    _i9.ChatMessageChunk: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i9.ChatMessageChunk.fromJson(jsonSerialization, serializationManager),
    _i10.ChatMessagePost: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i10.ChatMessagePost.fromJson(jsonSerialization, serializationManager),
    _i11.ChatReadMessage: (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        _i11.ChatReadMessage.fromJson(jsonSerialization, serializationManager),
    _i12.ChatRequestMessageChunk:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            _i12.ChatRequestMessageChunk.fromJson(
                jsonSerialization, serializationManager),
    _i1.getType<_i2.ChatJoinChannel?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i2.ChatJoinChannel.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i3.ChatJoinChannelFailed?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i3.ChatJoinChannelFailed.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i4.ChatJoinedChannel?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i4.ChatJoinedChannel.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i5.ChatLeaveChannel?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i5.ChatLeaveChannel.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i6.ChatMessage?>(): (jsonSerialization,
            _i1.SerializationManager serializationManager) =>
        jsonSerialization != null
            ? _i6.ChatMessage.fromJson(jsonSerialization, serializationManager)
            : null,
    _i1.getType<_i7.ChatMessageAttachment?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i7.ChatMessageAttachment.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i8.ChatMessageAttachmentUploadDescription?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i8.ChatMessageAttachmentUploadDescription.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i9.ChatMessageChunk?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i9.ChatMessageChunk.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i10.ChatMessagePost?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i10.ChatMessagePost.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i11.ChatReadMessage?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i11.ChatReadMessage.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<_i12.ChatRequestMessageChunk?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? _i12.ChatRequestMessageChunk.fromJson(
                    jsonSerialization, serializationManager)
                : null,
    _i1.getType<List<_i13.ChatMessageAttachment>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager
                        .deserializeJson<_i13.ChatMessageAttachment>(e))
                    .toList()
                : null,
    List<_i13.ChatMessage>:
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            (jsonSerialization as List)
                .map((e) =>
                    serializationManager.deserializeJson<_i13.ChatMessage>(e))
                .toList(),
    _i1.getType<List<_i13.ChatMessageAttachment>?>():
        (jsonSerialization, _i1.SerializationManager serializationManager) =>
            jsonSerialization != null
                ? (jsonSerialization as List)
                    .map((e) => serializationManager
                        .deserializeJson<_i13.ChatMessageAttachment>(e))
                    .toList()
                : null,
  };

  @override
  final Map<String, Type> classNameTypeMapping = {};
}

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
import 'package:serverpod_auth_client/module.dart' as _i14;
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
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserializeJson<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.ChatJoinChannel) {
      return _i2.ChatJoinChannel.fromJson(data, this) as T;
    }
    if (t == _i3.ChatJoinChannelFailed) {
      return _i3.ChatJoinChannelFailed.fromJson(data, this) as T;
    }
    if (t == _i4.ChatJoinedChannel) {
      return _i4.ChatJoinedChannel.fromJson(data, this) as T;
    }
    if (t == _i5.ChatLeaveChannel) {
      return _i5.ChatLeaveChannel.fromJson(data, this) as T;
    }
    if (t == _i6.ChatMessage) {
      return _i6.ChatMessage.fromJson(data, this) as T;
    }
    if (t == _i7.ChatMessageAttachment) {
      return _i7.ChatMessageAttachment.fromJson(data, this) as T;
    }
    if (t == _i8.ChatMessageAttachmentUploadDescription) {
      return _i8.ChatMessageAttachmentUploadDescription.fromJson(data, this)
          as T;
    }
    if (t == _i9.ChatMessageChunk) {
      return _i9.ChatMessageChunk.fromJson(data, this) as T;
    }
    if (t == _i10.ChatMessagePost) {
      return _i10.ChatMessagePost.fromJson(data, this) as T;
    }
    if (t == _i11.ChatReadMessage) {
      return _i11.ChatReadMessage.fromJson(data, this) as T;
    }
    if (t == _i12.ChatRequestMessageChunk) {
      return _i12.ChatRequestMessageChunk.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.ChatJoinChannel?>()) {
      return (data != null ? _i2.ChatJoinChannel.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i3.ChatJoinChannelFailed?>()) {
      return (data != null
          ? _i3.ChatJoinChannelFailed.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i4.ChatJoinedChannel?>()) {
      return (data != null ? _i4.ChatJoinedChannel.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i5.ChatLeaveChannel?>()) {
      return (data != null ? _i5.ChatLeaveChannel.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ChatMessage?>()) {
      return (data != null ? _i6.ChatMessage.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.ChatMessageAttachment?>()) {
      return (data != null
          ? _i7.ChatMessageAttachment.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i8.ChatMessageAttachmentUploadDescription?>()) {
      return (data != null
          ? _i8.ChatMessageAttachmentUploadDescription.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i9.ChatMessageChunk?>()) {
      return (data != null ? _i9.ChatMessageChunk.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ChatMessagePost?>()) {
      return (data != null ? _i10.ChatMessagePost.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i11.ChatReadMessage?>()) {
      return (data != null ? _i11.ChatReadMessage.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i12.ChatRequestMessageChunk?>()) {
      return (data != null
          ? _i12.ChatRequestMessageChunk.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<List<_i13.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i13.ChatMessageAttachment>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<_i13.ChatMessage>) {
      return (data as List)
          .map((e) => deserializeJson<_i13.ChatMessage>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i13.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserializeJson<_i13.ChatMessageAttachment>(e))
              .toList()
          : null) as dynamic;
    }
    try {
      return _i14.Protocol().deserializeJson<T>(data, t);
    } catch (_) {}
    return super.deserializeJson<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i14.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i2.ChatJoinChannel) {
      return 'ChatJoinChannel';
    }
    if (data is _i3.ChatJoinChannelFailed) {
      return 'ChatJoinChannelFailed';
    }
    if (data is _i4.ChatJoinedChannel) {
      return 'ChatJoinedChannel';
    }
    if (data is _i5.ChatLeaveChannel) {
      return 'ChatLeaveChannel';
    }
    if (data is _i6.ChatMessage) {
      return 'ChatMessage';
    }
    if (data is _i7.ChatMessageAttachment) {
      return 'ChatMessageAttachment';
    }
    if (data is _i8.ChatMessageAttachmentUploadDescription) {
      return 'ChatMessageAttachmentUploadDescription';
    }
    if (data is _i9.ChatMessageChunk) {
      return 'ChatMessageChunk';
    }
    if (data is _i10.ChatMessagePost) {
      return 'ChatMessagePost';
    }
    if (data is _i11.ChatReadMessage) {
      return 'ChatReadMessage';
    }
    if (data is _i12.ChatRequestMessageChunk) {
      return 'ChatRequestMessageChunk';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeJsonByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i14.Protocol().deserializeJsonByClassName(data);
    }
    if (data['className'] == 'ChatJoinChannel') {
      return deserializeJson<_i2.ChatJoinChannel>(data['data']);
    }
    if (data['className'] == 'ChatJoinChannelFailed') {
      return deserializeJson<_i3.ChatJoinChannelFailed>(data['data']);
    }
    if (data['className'] == 'ChatJoinedChannel') {
      return deserializeJson<_i4.ChatJoinedChannel>(data['data']);
    }
    if (data['className'] == 'ChatLeaveChannel') {
      return deserializeJson<_i5.ChatLeaveChannel>(data['data']);
    }
    if (data['className'] == 'ChatMessage') {
      return deserializeJson<_i6.ChatMessage>(data['data']);
    }
    if (data['className'] == 'ChatMessageAttachment') {
      return deserializeJson<_i7.ChatMessageAttachment>(data['data']);
    }
    if (data['className'] == 'ChatMessageAttachmentUploadDescription') {
      return deserializeJson<_i8.ChatMessageAttachmentUploadDescription>(
          data['data']);
    }
    if (data['className'] == 'ChatMessageChunk') {
      return deserializeJson<_i9.ChatMessageChunk>(data['data']);
    }
    if (data['className'] == 'ChatMessagePost') {
      return deserializeJson<_i10.ChatMessagePost>(data['data']);
    }
    if (data['className'] == 'ChatReadMessage') {
      return deserializeJson<_i11.ChatReadMessage>(data['data']);
    }
    if (data['className'] == 'ChatRequestMessageChunk') {
      return deserializeJson<_i12.ChatRequestMessageChunk>(data['data']);
    }
    return super.deserializeJsonByClassName(data);
  }
}

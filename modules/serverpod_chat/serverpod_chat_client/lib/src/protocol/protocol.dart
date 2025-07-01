/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
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
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i13;
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
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.ChatJoinChannel) {
      return _i2.ChatJoinChannel.fromJson(data) as T;
    }
    if (t == _i3.ChatJoinChannelFailed) {
      return _i3.ChatJoinChannelFailed.fromJson(data) as T;
    }
    if (t == _i4.ChatJoinedChannel) {
      return _i4.ChatJoinedChannel.fromJson(data) as T;
    }
    if (t == _i5.ChatLeaveChannel) {
      return _i5.ChatLeaveChannel.fromJson(data) as T;
    }
    if (t == _i6.ChatMessage) {
      return _i6.ChatMessage.fromJson(data) as T;
    }
    if (t == _i7.ChatMessageAttachment) {
      return _i7.ChatMessageAttachment.fromJson(data) as T;
    }
    if (t == _i8.ChatMessageAttachmentUploadDescription) {
      return _i8.ChatMessageAttachmentUploadDescription.fromJson(data) as T;
    }
    if (t == _i9.ChatMessageChunk) {
      return _i9.ChatMessageChunk.fromJson(data) as T;
    }
    if (t == _i10.ChatMessagePost) {
      return _i10.ChatMessagePost.fromJson(data) as T;
    }
    if (t == _i11.ChatReadMessage) {
      return _i11.ChatReadMessage.fromJson(data) as T;
    }
    if (t == _i12.ChatRequestMessageChunk) {
      return _i12.ChatRequestMessageChunk.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ChatJoinChannel?>()) {
      return (data != null ? _i2.ChatJoinChannel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ChatJoinChannelFailed?>()) {
      return (data != null ? _i3.ChatJoinChannelFailed.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.ChatJoinedChannel?>()) {
      return (data != null ? _i4.ChatJoinedChannel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ChatLeaveChannel?>()) {
      return (data != null ? _i5.ChatLeaveChannel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ChatMessage?>()) {
      return (data != null ? _i6.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ChatMessageAttachment?>()) {
      return (data != null ? _i7.ChatMessageAttachment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ChatMessageAttachmentUploadDescription?>()) {
      return (data != null
          ? _i8.ChatMessageAttachmentUploadDescription.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.ChatMessageChunk?>()) {
      return (data != null ? _i9.ChatMessageChunk.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ChatMessagePost?>()) {
      return (data != null ? _i10.ChatMessagePost.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ChatReadMessage?>()) {
      return (data != null ? _i11.ChatReadMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ChatRequestMessageChunk?>()) {
      return (data != null ? _i12.ChatRequestMessageChunk.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<List<_i7.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i7.ChatMessageAttachment>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i6.ChatMessage>) {
      return (data as List).map((e) => deserialize<_i6.ChatMessage>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i7.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i7.ChatMessageAttachment>(e))
              .toList()
          : null) as T;
    }
    try {
      return _i13.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i2.ChatJoinChannel():
        return 'ChatJoinChannel';
      case _i3.ChatJoinChannelFailed():
        return 'ChatJoinChannelFailed';
      case _i4.ChatJoinedChannel():
        return 'ChatJoinedChannel';
      case _i5.ChatLeaveChannel():
        return 'ChatLeaveChannel';
      case _i6.ChatMessage():
        return 'ChatMessage';
      case _i7.ChatMessageAttachment():
        return 'ChatMessageAttachment';
      case _i8.ChatMessageAttachmentUploadDescription():
        return 'ChatMessageAttachmentUploadDescription';
      case _i9.ChatMessageChunk():
        return 'ChatMessageChunk';
      case _i10.ChatMessagePost():
        return 'ChatMessagePost';
      case _i11.ChatReadMessage():
        return 'ChatReadMessage';
      case _i12.ChatRequestMessageChunk():
        return 'ChatRequestMessageChunk';
    }
    className = _i13.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ChatJoinChannel') {
      return deserialize<_i2.ChatJoinChannel>(data['data']);
    }
    if (dataClassName == 'ChatJoinChannelFailed') {
      return deserialize<_i3.ChatJoinChannelFailed>(data['data']);
    }
    if (dataClassName == 'ChatJoinedChannel') {
      return deserialize<_i4.ChatJoinedChannel>(data['data']);
    }
    if (dataClassName == 'ChatLeaveChannel') {
      return deserialize<_i5.ChatLeaveChannel>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i6.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatMessageAttachment') {
      return deserialize<_i7.ChatMessageAttachment>(data['data']);
    }
    if (dataClassName == 'ChatMessageAttachmentUploadDescription') {
      return deserialize<_i8.ChatMessageAttachmentUploadDescription>(
          data['data']);
    }
    if (dataClassName == 'ChatMessageChunk') {
      return deserialize<_i9.ChatMessageChunk>(data['data']);
    }
    if (dataClassName == 'ChatMessagePost') {
      return deserialize<_i10.ChatMessagePost>(data['data']);
    }
    if (dataClassName == 'ChatReadMessage') {
      return deserialize<_i11.ChatReadMessage>(data['data']);
    }
    if (dataClassName == 'ChatRequestMessageChunk') {
      return deserialize<_i12.ChatRequestMessageChunk>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i13.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

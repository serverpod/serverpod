/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/module.dart' as _i3;
import 'chat_join_channel.dart' as _i4;
import 'chat_join_channel_failed.dart' as _i5;
import 'chat_joined_channel.dart' as _i6;
import 'chat_leave_channel.dart' as _i7;
import 'chat_message.dart' as _i8;
import 'chat_message_attachment.dart' as _i9;
import 'chat_message_attachment_upload_description.dart' as _i10;
import 'chat_message_chunk.dart' as _i11;
import 'chat_message_post.dart' as _i12;
import 'chat_read_message.dart' as _i13;
import 'chat_request_message_chunk.dart' as _i14;
import 'protocol.dart' as _i15;
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
export 'chat_request_message_chunk.dart'; // ignore_for_file: equal_keys_in_map

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  static final desiredDatabaseDefinition = _i2.DatabaseDefinition(tables: [
    _i2.TableDefinition(
      name: 'serverpod_chat_message',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_chat_message_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'channel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'message',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'time',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'sender',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'removed',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'attachments',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:ChatMessageAttachment>?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_chat_message_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_chat_message_channel_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'channel',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_chat_read_message',
      schema: 'public',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_chat_read_message_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'channel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'lastReadMessageId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_chat_read_message_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_chat_read_message_channel_user_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'channel',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.desiredDatabaseDefinition.tables,
  ]);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i4.ChatJoinChannel) {
      return _i4.ChatJoinChannel.fromJson(data, this) as T;
    }
    if (t == _i5.ChatJoinChannelFailed) {
      return _i5.ChatJoinChannelFailed.fromJson(data, this) as T;
    }
    if (t == _i6.ChatJoinedChannel) {
      return _i6.ChatJoinedChannel.fromJson(data, this) as T;
    }
    if (t == _i7.ChatLeaveChannel) {
      return _i7.ChatLeaveChannel.fromJson(data, this) as T;
    }
    if (t == _i8.ChatMessage) {
      return _i8.ChatMessage.fromJson(data, this) as T;
    }
    if (t == _i9.ChatMessageAttachment) {
      return _i9.ChatMessageAttachment.fromJson(data, this) as T;
    }
    if (t == _i10.ChatMessageAttachmentUploadDescription) {
      return _i10.ChatMessageAttachmentUploadDescription.fromJson(data, this)
          as T;
    }
    if (t == _i11.ChatMessageChunk) {
      return _i11.ChatMessageChunk.fromJson(data, this) as T;
    }
    if (t == _i12.ChatMessagePost) {
      return _i12.ChatMessagePost.fromJson(data, this) as T;
    }
    if (t == _i13.ChatReadMessage) {
      return _i13.ChatReadMessage.fromJson(data, this) as T;
    }
    if (t == _i14.ChatRequestMessageChunk) {
      return _i14.ChatRequestMessageChunk.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i4.ChatJoinChannel?>()) {
      return (data != null ? _i4.ChatJoinChannel.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i5.ChatJoinChannelFailed?>()) {
      return (data != null
          ? _i5.ChatJoinChannelFailed.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i6.ChatJoinedChannel?>()) {
      return (data != null ? _i6.ChatJoinedChannel.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i7.ChatLeaveChannel?>()) {
      return (data != null ? _i7.ChatLeaveChannel.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ChatMessage?>()) {
      return (data != null ? _i8.ChatMessage.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i9.ChatMessageAttachment?>()) {
      return (data != null
          ? _i9.ChatMessageAttachment.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i10.ChatMessageAttachmentUploadDescription?>()) {
      return (data != null
          ? _i10.ChatMessageAttachmentUploadDescription.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i11.ChatMessageChunk?>()) {
      return (data != null ? _i11.ChatMessageChunk.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i12.ChatMessagePost?>()) {
      return (data != null ? _i12.ChatMessagePost.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i13.ChatReadMessage?>()) {
      return (data != null ? _i13.ChatReadMessage.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.ChatRequestMessageChunk?>()) {
      return (data != null
          ? _i14.ChatRequestMessageChunk.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<List<_i15.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i15.ChatMessageAttachment>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<_i15.ChatMessage>) {
      return (data as List)
          .map((e) => deserialize<_i15.ChatMessage>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i15.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i15.ChatMessageAttachment>(e))
              .toList()
          : null) as dynamic;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i4.ChatJoinChannel) {
      return 'ChatJoinChannel';
    }
    if (data is _i5.ChatJoinChannelFailed) {
      return 'ChatJoinChannelFailed';
    }
    if (data is _i6.ChatJoinedChannel) {
      return 'ChatJoinedChannel';
    }
    if (data is _i7.ChatLeaveChannel) {
      return 'ChatLeaveChannel';
    }
    if (data is _i8.ChatMessage) {
      return 'ChatMessage';
    }
    if (data is _i9.ChatMessageAttachment) {
      return 'ChatMessageAttachment';
    }
    if (data is _i10.ChatMessageAttachmentUploadDescription) {
      return 'ChatMessageAttachmentUploadDescription';
    }
    if (data is _i11.ChatMessageChunk) {
      return 'ChatMessageChunk';
    }
    if (data is _i12.ChatMessagePost) {
      return 'ChatMessagePost';
    }
    if (data is _i13.ChatReadMessage) {
      return 'ChatReadMessage';
    }
    if (data is _i14.ChatRequestMessageChunk) {
      return 'ChatRequestMessageChunk';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'ChatJoinChannel') {
      return deserialize<_i4.ChatJoinChannel>(data['data']);
    }
    if (data['className'] == 'ChatJoinChannelFailed') {
      return deserialize<_i5.ChatJoinChannelFailed>(data['data']);
    }
    if (data['className'] == 'ChatJoinedChannel') {
      return deserialize<_i6.ChatJoinedChannel>(data['data']);
    }
    if (data['className'] == 'ChatLeaveChannel') {
      return deserialize<_i7.ChatLeaveChannel>(data['data']);
    }
    if (data['className'] == 'ChatMessage') {
      return deserialize<_i8.ChatMessage>(data['data']);
    }
    if (data['className'] == 'ChatMessageAttachment') {
      return deserialize<_i9.ChatMessageAttachment>(data['data']);
    }
    if (data['className'] == 'ChatMessageAttachmentUploadDescription') {
      return deserialize<_i10.ChatMessageAttachmentUploadDescription>(
          data['data']);
    }
    if (data['className'] == 'ChatMessageChunk') {
      return deserialize<_i11.ChatMessageChunk>(data['data']);
    }
    if (data['className'] == 'ChatMessagePost') {
      return deserialize<_i12.ChatMessagePost>(data['data']);
    }
    if (data['className'] == 'ChatReadMessage') {
      return deserialize<_i13.ChatReadMessage>(data['data']);
    }
    if (data['className'] == 'ChatRequestMessageChunk') {
      return deserialize<_i14.ChatRequestMessageChunk>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i8.ChatMessage:
        return _i8.ChatMessage.t;
      case _i13.ChatReadMessage:
        return _i13.ChatReadMessage.t;
    }
    return null;
  }

  @override
  _i2.DatabaseDefinition getDesiredDatabaseDefinition() =>
      desiredDatabaseDefinition;
}

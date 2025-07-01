/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_chat_message',
      dartName: 'ChatMessage',
      schema: 'public',
      module: 'serverpod_chat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
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
          columnType: _i2.ColumnType.bigint,
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
      dartName: 'ChatReadMessage',
      schema: 'public',
      module: 'serverpod_chat',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
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
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'lastReadMessageId',
          columnType: _i2.ColumnType.bigint,
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
    ..._i3.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.ChatJoinChannel) {
      return _i4.ChatJoinChannel.fromJson(data) as T;
    }
    if (t == _i5.ChatJoinChannelFailed) {
      return _i5.ChatJoinChannelFailed.fromJson(data) as T;
    }
    if (t == _i6.ChatJoinedChannel) {
      return _i6.ChatJoinedChannel.fromJson(data) as T;
    }
    if (t == _i7.ChatLeaveChannel) {
      return _i7.ChatLeaveChannel.fromJson(data) as T;
    }
    if (t == _i8.ChatMessage) {
      return _i8.ChatMessage.fromJson(data) as T;
    }
    if (t == _i9.ChatMessageAttachment) {
      return _i9.ChatMessageAttachment.fromJson(data) as T;
    }
    if (t == _i10.ChatMessageAttachmentUploadDescription) {
      return _i10.ChatMessageAttachmentUploadDescription.fromJson(data) as T;
    }
    if (t == _i11.ChatMessageChunk) {
      return _i11.ChatMessageChunk.fromJson(data) as T;
    }
    if (t == _i12.ChatMessagePost) {
      return _i12.ChatMessagePost.fromJson(data) as T;
    }
    if (t == _i13.ChatReadMessage) {
      return _i13.ChatReadMessage.fromJson(data) as T;
    }
    if (t == _i14.ChatRequestMessageChunk) {
      return _i14.ChatRequestMessageChunk.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.ChatJoinChannel?>()) {
      return (data != null ? _i4.ChatJoinChannel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ChatJoinChannelFailed?>()) {
      return (data != null ? _i5.ChatJoinChannelFailed.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ChatJoinedChannel?>()) {
      return (data != null ? _i6.ChatJoinedChannel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ChatLeaveChannel?>()) {
      return (data != null ? _i7.ChatLeaveChannel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ChatMessage?>()) {
      return (data != null ? _i8.ChatMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ChatMessageAttachment?>()) {
      return (data != null ? _i9.ChatMessageAttachment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.ChatMessageAttachmentUploadDescription?>()) {
      return (data != null
          ? _i10.ChatMessageAttachmentUploadDescription.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.ChatMessageChunk?>()) {
      return (data != null ? _i11.ChatMessageChunk.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ChatMessagePost?>()) {
      return (data != null ? _i12.ChatMessagePost.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ChatReadMessage?>()) {
      return (data != null ? _i13.ChatReadMessage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ChatRequestMessageChunk?>()) {
      return (data != null ? _i14.ChatRequestMessageChunk.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<List<_i9.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i9.ChatMessageAttachment>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i8.ChatMessage>) {
      return (data as List).map((e) => deserialize<_i8.ChatMessage>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.ChatMessageAttachment>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i9.ChatMessageAttachment>(e))
              .toList()
          : null) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i4.ChatJoinChannel():
        return 'ChatJoinChannel';
      case _i5.ChatJoinChannelFailed():
        return 'ChatJoinChannelFailed';
      case _i6.ChatJoinedChannel():
        return 'ChatJoinedChannel';
      case _i7.ChatLeaveChannel():
        return 'ChatLeaveChannel';
      case _i8.ChatMessage():
        return 'ChatMessage';
      case _i9.ChatMessageAttachment():
        return 'ChatMessageAttachment';
      case _i10.ChatMessageAttachmentUploadDescription():
        return 'ChatMessageAttachmentUploadDescription';
      case _i11.ChatMessageChunk():
        return 'ChatMessageChunk';
      case _i12.ChatMessagePost():
        return 'ChatMessagePost';
      case _i13.ChatReadMessage():
        return 'ChatReadMessage';
      case _i14.ChatRequestMessageChunk():
        return 'ChatRequestMessageChunk';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
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
      return deserialize<_i4.ChatJoinChannel>(data['data']);
    }
    if (dataClassName == 'ChatJoinChannelFailed') {
      return deserialize<_i5.ChatJoinChannelFailed>(data['data']);
    }
    if (dataClassName == 'ChatJoinedChannel') {
      return deserialize<_i6.ChatJoinedChannel>(data['data']);
    }
    if (dataClassName == 'ChatLeaveChannel') {
      return deserialize<_i7.ChatLeaveChannel>(data['data']);
    }
    if (dataClassName == 'ChatMessage') {
      return deserialize<_i8.ChatMessage>(data['data']);
    }
    if (dataClassName == 'ChatMessageAttachment') {
      return deserialize<_i9.ChatMessageAttachment>(data['data']);
    }
    if (dataClassName == 'ChatMessageAttachmentUploadDescription') {
      return deserialize<_i10.ChatMessageAttachmentUploadDescription>(
          data['data']);
    }
    if (dataClassName == 'ChatMessageChunk') {
      return deserialize<_i11.ChatMessageChunk>(data['data']);
    }
    if (dataClassName == 'ChatMessagePost') {
      return deserialize<_i12.ChatMessagePost>(data['data']);
    }
    if (dataClassName == 'ChatReadMessage') {
      return deserialize<_i13.ChatReadMessage>(data['data']);
    }
    if (dataClassName == 'ChatRequestMessageChunk') {
      return deserialize<_i14.ChatRequestMessageChunk>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
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
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_chat';
}

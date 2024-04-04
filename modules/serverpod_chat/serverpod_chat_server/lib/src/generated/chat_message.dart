/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i2;
import 'protocol.dart' as _i3;
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// A chat message.
abstract class ChatMessage extends _i1.TableRow {
  ChatMessage._({
    int? id,
    required this.channel,
    required this.message,
    required this.time,
    required this.sender,
    this.senderInfo,
    required this.removed,
    this.clientMessageId,
    this.sent,
    this.attachments,
  }) : super(id);

  factory ChatMessage({
    int? id,
    required String channel,
    required String message,
    required DateTime time,
    required int sender,
    _i2.UserInfoPublic? senderInfo,
    required bool removed,
    int? clientMessageId,
    bool? sent,
    List<_i3.ChatMessageAttachment>? attachments,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      id: jsonSerialization['id'] as int?,
      channel: jsonSerialization['channel'] as String,
      message: jsonSerialization['message'] as String,
      time: DateTime.parse(jsonSerialization['time']),
      sender: jsonSerialization['sender'] as int,
      senderInfo: jsonSerialization.containsKey('senderInfo')
          ? _i2.UserInfoPublic.fromJson(
              jsonSerialization['senderInfo'] as Map<String, dynamic>)
          : null,
      removed: jsonSerialization['removed'] as bool,
      clientMessageId: jsonSerialization['clientMessageId'] as int?,
      sent: jsonSerialization['sent'] as bool?,
      attachments: (jsonSerialization['attachments'] as List<dynamic>?)
          ?.map((e) =>
              _i3.ChatMessageAttachment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static final t = ChatMessageTable();

  static const db = ChatMessageRepository._();

  /// The channel this message was posted to.
  String channel;

  /// The body of the message.
  String message;

  /// The time when this message was posted.
  DateTime time;

  /// The user id of the sender.
  int sender;

  /// Information about the sender.
  _i2.UserInfoPublic? senderInfo;

  /// True, if this message has been removed.
  bool removed;

  /// The client message id, used to track if a message has been delivered.
  int? clientMessageId;

  /// True if the message has been sent.
  bool? sent;

  /// List of attachments associated with this message.
  List<_i3.ChatMessageAttachment>? attachments;

  @override
  _i1.Table get table => t;

  ChatMessage copyWith({
    int? id,
    String? channel,
    String? message,
    DateTime? time,
    int? sender,
    _i2.UserInfoPublic? senderInfo,
    bool? removed,
    int? clientMessageId,
    bool? sent,
    List<_i3.ChatMessageAttachment>? attachments,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'channel': channel,
      'message': message,
      'time': time.toJson(),
      'sender': sender,
      if (senderInfo != null) 'senderInfo': senderInfo?.toJson(),
      'removed': removed,
      if (clientMessageId != null) 'clientMessageId': clientMessageId,
      if (sent != null) 'sent': sent,
      if (attachments != null)
        'attachments': attachments?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'channel': channel,
      'message': message,
      'time': time.toJson(),
      'sender': sender,
      if (senderInfo != null) 'senderInfo': senderInfo?.allToJson(),
      'removed': removed,
      if (clientMessageId != null) 'clientMessageId': clientMessageId,
      if (sent != null) 'sent': sent,
      if (attachments != null)
        'attachments': attachments?.toJson(valueToJson: (v) => v.allToJson()),
    };
  }

  static ChatMessageInclude include() {
    return ChatMessageInclude._();
  }

  static ChatMessageIncludeList includeList({
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatMessageTable>? orderByList,
    ChatMessageInclude? include,
  }) {
    return ChatMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatMessage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChatMessage.t),
      include: include,
    );
  }
}

class _Undefined {}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    int? id,
    required String channel,
    required String message,
    required DateTime time,
    required int sender,
    _i2.UserInfoPublic? senderInfo,
    required bool removed,
    int? clientMessageId,
    bool? sent,
    List<_i3.ChatMessageAttachment>? attachments,
  }) : super._(
          id: id,
          channel: channel,
          message: message,
          time: time,
          sender: sender,
          senderInfo: senderInfo,
          removed: removed,
          clientMessageId: clientMessageId,
          sent: sent,
          attachments: attachments,
        );

  @override
  ChatMessage copyWith({
    Object? id = _Undefined,
    String? channel,
    String? message,
    DateTime? time,
    int? sender,
    Object? senderInfo = _Undefined,
    bool? removed,
    Object? clientMessageId = _Undefined,
    Object? sent = _Undefined,
    Object? attachments = _Undefined,
  }) {
    return ChatMessage(
      id: id is int? ? id : this.id,
      channel: channel ?? this.channel,
      message: message ?? this.message,
      time: time ?? this.time,
      sender: sender ?? this.sender,
      senderInfo: senderInfo is _i2.UserInfoPublic?
          ? senderInfo
          : this.senderInfo?.copyWith(),
      removed: removed ?? this.removed,
      clientMessageId:
          clientMessageId is int? ? clientMessageId : this.clientMessageId,
      sent: sent is bool? ? sent : this.sent,
      attachments: attachments is List<_i3.ChatMessageAttachment>?
          ? attachments
          : this.attachments?.clone(),
    );
  }
}

class ChatMessageTable extends _i1.Table {
  ChatMessageTable({super.tableRelation})
      : super(tableName: 'serverpod_chat_message') {
    channel = _i1.ColumnString(
      'channel',
      this,
    );
    message = _i1.ColumnString(
      'message',
      this,
    );
    time = _i1.ColumnDateTime(
      'time',
      this,
    );
    sender = _i1.ColumnInt(
      'sender',
      this,
    );
    removed = _i1.ColumnBool(
      'removed',
      this,
    );
    attachments = _i1.ColumnSerializable(
      'attachments',
      this,
    );
  }

  /// The channel this message was posted to.
  late final _i1.ColumnString channel;

  /// The body of the message.
  late final _i1.ColumnString message;

  /// The time when this message was posted.
  late final _i1.ColumnDateTime time;

  /// The user id of the sender.
  late final _i1.ColumnInt sender;

  /// True, if this message has been removed.
  late final _i1.ColumnBool removed;

  /// List of attachments associated with this message.
  late final _i1.ColumnSerializable attachments;

  @override
  List<_i1.Column> get columns => [
        id,
        channel,
        message,
        time,
        sender,
        removed,
        attachments,
      ];
}

class ChatMessageInclude extends _i1.IncludeObject {
  ChatMessageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ChatMessage.t;
}

class ChatMessageIncludeList extends _i1.IncludeList {
  ChatMessageIncludeList._({
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChatMessage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ChatMessage.t;
}

class ChatMessageRepository {
  const ChatMessageRepository._();

  Future<List<ChatMessage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChatMessage>(
      where: where?.call(ChatMessage.t),
      orderBy: orderBy?.call(ChatMessage.t),
      orderByList: orderByList?.call(ChatMessage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ChatMessage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChatMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChatMessage>(
      where: where?.call(ChatMessage.t),
      orderBy: orderBy?.call(ChatMessage.t),
      orderByList: orderByList?.call(ChatMessage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ChatMessage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ChatMessage>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ChatMessage>> insert(
    _i1.Session session,
    List<ChatMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChatMessage>(
      rows,
      transaction: transaction,
    );
  }

  Future<ChatMessage> insertRow(
    _i1.Session session,
    ChatMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChatMessage>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ChatMessage>> update(
    _i1.Session session,
    List<ChatMessage> rows, {
    _i1.ColumnSelections<ChatMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChatMessage>(
      rows,
      columns: columns?.call(ChatMessage.t),
      transaction: transaction,
    );
  }

  Future<ChatMessage> updateRow(
    _i1.Session session,
    ChatMessage row, {
    _i1.ColumnSelections<ChatMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChatMessage>(
      row,
      columns: columns?.call(ChatMessage.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<ChatMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChatMessage>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    ChatMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChatMessage>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChatMessageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChatMessage>(
      where: where(ChatMessage.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatMessageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChatMessage>(
      where: where?.call(ChatMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

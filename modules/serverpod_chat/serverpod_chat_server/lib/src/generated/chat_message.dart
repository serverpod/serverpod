/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_auth_server/module.dart' as _i2;
import 'protocol.dart' as _i3;

class ChatMessage extends _i1.TableRow {
  ChatMessage({
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

  factory ChatMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatMessage(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      channel: serializationManager
          .deserializeJson<String>(jsonSerialization['channel']),
      message: serializationManager
          .deserializeJson<String>(jsonSerialization['message']),
      time: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['time']),
      sender: serializationManager
          .deserializeJson<int>(jsonSerialization['sender']),
      senderInfo: serializationManager
          .deserializeJson<_i2.UserInfo?>(jsonSerialization['senderInfo']),
      removed: serializationManager
          .deserializeJson<bool>(jsonSerialization['removed']),
      clientMessageId: serializationManager
          .deserializeJson<int?>(jsonSerialization['clientMessageId']),
      sent: serializationManager
          .deserializeJson<bool?>(jsonSerialization['sent']),
      attachments: serializationManager.deserializeJson<
          List<_i3.ChatMessageAttachment>?>(jsonSerialization['attachments']),
    );
  }

  static final t = ChatMessageTable();

  String channel;

  String message;

  DateTime time;

  int sender;

  _i2.UserInfo? senderInfo;

  bool removed;

  int? clientMessageId;

  bool? sent;

  List<_i3.ChatMessageAttachment>? attachments;

  @override
  String get tableName => 'serverpod_chat_message';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'message': message,
      'time': time,
      'sender': sender,
      'senderInfo': senderInfo,
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
      'attachments': attachments,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'channel': channel,
      'message': message,
      'time': time,
      'sender': sender,
      'removed': removed,
      'attachments': attachments,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'channel': channel,
      'message': message,
      'time': time,
      'sender': sender,
      'senderInfo': senderInfo,
      'removed': removed,
      'clientMessageId': clientMessageId,
      'sent': sent,
      'attachments': attachments,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'channel':
        channel = value;
        return;
      case 'message':
        message = value;
        return;
      case 'time':
        time = value;
        return;
      case 'sender':
        sender = value;
        return;
      case 'removed':
        removed = value;
        return;
      case 'attachments':
        attachments = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ChatMessage>> find(
    _i1.Session session, {
    ChatMessageExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChatMessage>(
      where: where != null ? where(ChatMessage.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ChatMessage?> findSingleRow(
    _i1.Session session, {
    ChatMessageExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ChatMessage>(
      where: where != null ? where(ChatMessage.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ChatMessage?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ChatMessage>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ChatMessageExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChatMessage>(
      where: where(ChatMessage.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ChatMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ChatMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ChatMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ChatMessageExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChatMessage>(
      where: where != null ? where(ChatMessage.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ChatMessageExpressionBuilder = _i1.Expression Function(
    ChatMessageTable);

class ChatMessageTable extends _i1.Table {
  ChatMessageTable() : super(tableName: 'serverpod_chat_message');

  final id = _i1.ColumnInt('id');

  final channel = _i1.ColumnString('channel');

  final message = _i1.ColumnString('message');

  final time = _i1.ColumnDateTime('time');

  final sender = _i1.ColumnInt('sender');

  final removed = _i1.ColumnBool('removed');

  final attachments = _i1.ColumnSerializable('attachments');

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

@Deprecated('Use ChatMessageTable.t instead.')
ChatMessageTable tChatMessage = ChatMessageTable();

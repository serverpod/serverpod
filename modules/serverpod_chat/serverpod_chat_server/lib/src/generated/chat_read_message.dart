/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Message to notifiy the server that messages have been read.
abstract class ChatReadMessage extends _i1.TableRow {
  ChatReadMessage._({
    int? id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  }) : super(id);

  factory ChatReadMessage({
    int? id,
    required String channel,
    required int userId,
    required int lastReadMessageId,
  }) = _ChatReadMessageImpl;

  factory ChatReadMessage.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ChatReadMessage(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
      userId:
          serializationManager.deserialize<int>(jsonSerialization['userId']),
      lastReadMessageId: serializationManager
          .deserialize<int>(jsonSerialization['lastReadMessageId']),
    );
  }

  static final t = ChatReadMessageTable();

  /// The channel this that has been read.
  String channel;

  /// The id of the user that read the messages.
  int userId;

  /// The id of the last read message.
  int lastReadMessageId;

  @override
  _i1.Table get table => t;
  ChatReadMessage copyWith({
    int? id,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
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
      case 'userId':
        userId = value;
        return;
      case 'lastReadMessageId':
        lastReadMessageId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ChatReadMessage>> find(
    _i1.Session session, {
    ChatReadMessageExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChatReadMessage>(
      where: where != null ? where(ChatReadMessage.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ChatReadMessage?> findSingleRow(
    _i1.Session session, {
    ChatReadMessageExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ChatReadMessage>(
      where: where != null ? where(ChatReadMessage.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ChatReadMessage?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<ChatReadMessage>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required ChatReadMessageWithoutManyRelationsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChatReadMessage>(
      where: where(ChatReadMessage.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    ChatReadMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    ChatReadMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    ChatReadMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    ChatReadMessageExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChatReadMessage>(
      where: where != null ? where(ChatReadMessage.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static ChatReadMessageInclude include() {
    return ChatReadMessageInclude._();
  }
}

class _Undefined {}

class _ChatReadMessageImpl extends ChatReadMessage {
  _ChatReadMessageImpl({
    int? id,
    required String channel,
    required int userId,
    required int lastReadMessageId,
  }) : super._(
          id: id,
          channel: channel,
          userId: userId,
          lastReadMessageId: lastReadMessageId,
        );

  @override
  ChatReadMessage copyWith({
    Object? id = _Undefined,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  }) {
    return ChatReadMessage(
      id: id is int? ? id : this.id,
      channel: channel ?? this.channel,
      userId: userId ?? this.userId,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }
}

typedef ChatReadMessageExpressionBuilder = _i1.Expression Function(
    ChatReadMessageTable);
typedef ChatReadMessageWithoutManyRelationsExpressionBuilder = _i1.Expression
    Function(ChatReadMessageWithoutManyRelationsTable);

class ChatReadMessageTable extends ChatReadMessageWithoutManyRelationsTable {
  ChatReadMessageTable({
    super.queryPrefix,
    super.tableRelations,
  });
}

class ChatReadMessageWithoutManyRelationsTable extends _i1.Table {
  ChatReadMessageWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_chat_read_message') {
    channel = _i1.ColumnString(
      'channel',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    userId = _i1.ColumnInt(
      'userId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    lastReadMessageId = _i1.ColumnInt(
      'lastReadMessageId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The channel this that has been read.
  late final _i1.ColumnString channel;

  /// The id of the user that read the messages.
  late final _i1.ColumnInt userId;

  /// The id of the last read message.
  late final _i1.ColumnInt lastReadMessageId;

  @override
  List<_i1.Column> get columns => [
        id,
        channel,
        userId,
        lastReadMessageId,
      ];
}

@Deprecated('Use ChatReadMessageTable.t instead.')
ChatReadMessageTable tChatReadMessage = ChatReadMessageTable();

class ChatReadMessageInclude extends _i1.Include {
  ChatReadMessageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => ChatReadMessage.t;
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Message to notify the server that messages have been read.
abstract class ChatReadMessage extends _i1.TableRow
    implements _i1.ProtocolSerialization {
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

  factory ChatReadMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatReadMessage(
      id: jsonSerialization['id'] as int?,
      channel: jsonSerialization['channel'] as String,
      userId: jsonSerialization['userId'] as int,
      lastReadMessageId: jsonSerialization['lastReadMessageId'] as int,
    );
  }

  static final t = ChatReadMessageTable();

  static const db = ChatReadMessageRepository._();

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
      if (id != null) 'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
  }

  static ChatReadMessageInclude include() {
    return ChatReadMessageInclude._();
  }

  static ChatReadMessageIncludeList includeList({
    _i1.WhereExpressionBuilder<ChatReadMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatReadMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatReadMessageTable>? orderByList,
    ChatReadMessageInclude? include,
  }) {
    return ChatReadMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChatReadMessage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ChatReadMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

class ChatReadMessageTable extends _i1.Table {
  ChatReadMessageTable({super.tableRelation})
      : super(tableName: 'serverpod_chat_read_message') {
    channel = _i1.ColumnString(
      'channel',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    lastReadMessageId = _i1.ColumnInt(
      'lastReadMessageId',
      this,
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

class ChatReadMessageInclude extends _i1.IncludeObject {
  ChatReadMessageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => ChatReadMessage.t;
}

class ChatReadMessageIncludeList extends _i1.IncludeList {
  ChatReadMessageIncludeList._({
    _i1.WhereExpressionBuilder<ChatReadMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ChatReadMessage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => ChatReadMessage.t;
}

class ChatReadMessageRepository {
  const ChatReadMessageRepository._();

  Future<List<ChatReadMessage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatReadMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ChatReadMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatReadMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ChatReadMessage>(
      where: where?.call(ChatReadMessage.t),
      orderBy: orderBy?.call(ChatReadMessage.t),
      orderByList: orderByList?.call(ChatReadMessage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ChatReadMessage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatReadMessageTable>? where,
    int? offset,
    _i1.OrderByBuilder<ChatReadMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ChatReadMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ChatReadMessage>(
      where: where?.call(ChatReadMessage.t),
      orderBy: orderBy?.call(ChatReadMessage.t),
      orderByList: orderByList?.call(ChatReadMessage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<ChatReadMessage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ChatReadMessage>(
      id,
      transaction: transaction,
    );
  }

  Future<List<ChatReadMessage>> insert(
    _i1.Session session,
    List<ChatReadMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ChatReadMessage>(
      rows,
      transaction: transaction,
    );
  }

  Future<ChatReadMessage> insertRow(
    _i1.Session session,
    ChatReadMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChatReadMessage>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ChatReadMessage>> update(
    _i1.Session session,
    List<ChatReadMessage> rows, {
    _i1.ColumnSelections<ChatReadMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ChatReadMessage>(
      rows,
      columns: columns?.call(ChatReadMessage.t),
      transaction: transaction,
    );
  }

  Future<ChatReadMessage> updateRow(
    _i1.Session session,
    ChatReadMessage row, {
    _i1.ColumnSelections<ChatReadMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChatReadMessage>(
      row,
      columns: columns?.call(ChatReadMessage.t),
      transaction: transaction,
    );
  }

  Future<List<ChatReadMessage>> delete(
    _i1.Session session,
    List<ChatReadMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ChatReadMessage>(
      rows,
      transaction: transaction,
    );
  }

  Future<ChatReadMessage> deleteRow(
    _i1.Session session,
    ChatReadMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChatReadMessage>(
      row,
      transaction: transaction,
    );
  }

  Future<List<ChatReadMessage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ChatReadMessageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ChatReadMessage>(
      where: where(ChatReadMessage.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ChatReadMessageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ChatReadMessage>(
      where: where?.call(ChatReadMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

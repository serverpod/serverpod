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

/// Message to notify the server that messages have been read.
abstract class ChatReadMessage
    implements _i1.TableRow, _i1.ProtocolSerialization {
  ChatReadMessage._({
    this.id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  });

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

  @override
  int? id;

  /// The channel this that has been read.
  String channel;

  /// The id of the user that read the messages.
  int userId;

  /// The id of the last read message.
  int lastReadMessageId;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [ChatReadMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  /// Returns a shallow copy of this [ChatReadMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  /// Returns a list of [ChatReadMessage]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
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

  /// Returns the first matching [ChatReadMessage] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
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

  /// Finds a single [ChatReadMessage] by its [id] or null if no such row exists.
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

  /// Inserts all [ChatReadMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [ChatReadMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
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

  /// Inserts a single [ChatReadMessage] and returns the inserted row.
  ///
  /// The returned [ChatReadMessage] will have its `id` field set.
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

  /// Updates all [ChatReadMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
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

  /// Updates a single [ChatReadMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
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

  /// Deletes all [ChatReadMessage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
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

  /// Deletes a single [ChatReadMessage].
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

  /// Deletes all rows matching the [where] expression.
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

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
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

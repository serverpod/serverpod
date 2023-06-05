/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef ChatReadMessageExpressionBuilder = _i1.Expression Function(
    ChatReadMessageTable);

/// Message to notifiy the server that messages have been read.
abstract class ChatReadMessage extends _i1.TableRow {
  const ChatReadMessage._();

  const factory ChatReadMessage({
    int? id,
    required String channel,
    required int userId,
    required int lastReadMessageId,
  }) = _ChatReadMessage;

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

  static const t = ChatReadMessageTable();

  ChatReadMessage copyWith({
    int? id,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  });
  @override
  String get tableName => 'serverpod_chat_read_message';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    };
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
    required ChatReadMessageExpressionBuilder where,
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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<ChatReadMessage> insert(
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

  /// The channel this that has been read.
  String get channel;

  /// The id of the user that read the messages.
  int get userId;

  /// The id of the last read message.
  int get lastReadMessageId;
}

class _Undefined {}

/// Message to notifiy the server that messages have been read.
class _ChatReadMessage extends ChatReadMessage {
  const _ChatReadMessage({
    int? id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  }) : super._();

  /// The channel this that has been read.
  @override
  final String channel;

  /// The id of the user that read the messages.
  @override
  final int userId;

  /// The id of the last read message.
  @override
  final int lastReadMessageId;

  @override
  String get tableName => 'serverpod_chat_read_message';
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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ChatReadMessage &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel) &&
            (identical(
                  other.userId,
                  userId,
                ) ||
                other.userId == userId) &&
            (identical(
                  other.lastReadMessageId,
                  lastReadMessageId,
                ) ||
                other.lastReadMessageId == lastReadMessageId));
  }

  @override
  int get hashCode => Object.hash(
        id,
        channel,
        userId,
        lastReadMessageId,
      );

  @override
  ChatReadMessage copyWith({
    Object? id = _Undefined,
    String? channel,
    int? userId,
    int? lastReadMessageId,
  }) {
    return ChatReadMessage(
      id: id == _Undefined ? this.id : (id as int?),
      channel: channel ?? this.channel,
      userId: userId ?? this.userId,
      lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
    );
  }
}

class ChatReadMessageTable extends _i1.Table {
  const ChatReadMessageTable()
      : super(tableName: 'serverpod_chat_read_message');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The channel this that has been read.
  final channel = const _i1.ColumnString('channel');

  /// The id of the user that read the messages.
  final userId = const _i1.ColumnInt('userId');

  /// The id of the last read message.
  final lastReadMessageId = const _i1.ColumnInt('lastReadMessageId');

  @override
  List<_i1.Column> get columns => [
        id,
        channel,
        userId,
        lastReadMessageId,
      ];
}

@Deprecated('Use ChatReadMessageTable.t instead.')
ChatReadMessageTable tChatReadMessage = const ChatReadMessageTable();

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ChatReadMessage extends TableRow {
  @override
  String get className => 'serverpod_chat_server.ChatReadMessage';
  @override
  String get tableName => 'serverpod_chat_read_message';

  static final t = ChatReadMessageTable();

  @override
  int? id;
  late String channel;
  late int userId;
  late int lastReadMessageId;

  ChatReadMessage({
    this.id,
    required this.channel,
    required this.userId,
    required this.lastReadMessageId,
  });

  ChatReadMessage.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    channel = _data['channel']!;
    userId = _data['userId']!;
    lastReadMessageId = _data['lastReadMessageId']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'channel': channel,
      'userId': userId,
      'lastReadMessageId': lastReadMessageId,
    });
  }

  @override
  void setColumn(String columnName, value) {
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
    Session session, {
    ChatReadMessageExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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
    Session session, {
    ChatReadMessageExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
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

  static Future<ChatReadMessage?> findById(Session session, int id) async {
    return session.db.findById<ChatReadMessage>(id);
  }

  static Future<int> delete(
    Session session, {
    required ChatReadMessageExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ChatReadMessage>(
      where: where(ChatReadMessage.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ChatReadMessage row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ChatReadMessage row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ChatReadMessage row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ChatReadMessageExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ChatReadMessage>(
      where: where != null ? where(ChatReadMessage.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ChatReadMessageExpressionBuilder = Expression Function(
    ChatReadMessageTable t);

class ChatReadMessageTable extends Table {
  ChatReadMessageTable() : super(tableName: 'serverpod_chat_read_message');

  @override
  String tableName = 'serverpod_chat_read_message';
  final id = ColumnInt('id');
  final channel = ColumnString('channel');
  final userId = ColumnInt('userId');
  final lastReadMessageId = ColumnInt('lastReadMessageId');

  @override
  List<Column> get columns => [
        id,
        channel,
        userId,
        lastReadMessageId,
      ];
}

@Deprecated('Use ChatReadMessageTable.t instead.')
ChatReadMessageTable tChatReadMessage = ChatReadMessageTable();

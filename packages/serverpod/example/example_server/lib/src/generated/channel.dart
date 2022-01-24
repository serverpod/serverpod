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

class Channel extends TableRow {
  @override
  String get className => 'Channel';
  @override
  String get tableName => 'channel';

  static final t = ChannelTable();

  @override
  int? id;
  late String name;
  late String channel;

  Channel({
    this.id,
    required this.name,
    required this.channel,
  });

  Channel.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    channel = _data['channel']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'channel': channel,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'channel': channel,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'channel': channel,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      case 'channel':
        channel = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Channel>> find(
    Session session, {
    ChannelExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<Channel>(
      where: where != null ? where(Channel.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Channel?> findSingleRow(
    Session session, {
    ChannelExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Channel>(
      where: where != null ? where(Channel.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Channel?> findById(Session session, int id) async {
    return session.db.findById<Channel>(id);
  }

  static Future<int> delete(
    Session session, {
    required ChannelExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<Channel>(
      where: where(Channel.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    Channel row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    Channel row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    Channel row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ChannelExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<Channel>(
      where: where != null ? where(Channel.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ChannelExpressionBuilder = Expression Function(ChannelTable t);

class ChannelTable extends Table {
  ChannelTable() : super(tableName: 'channel');

  @override
  String tableName = 'channel';
  final id = ColumnInt('id');
  final name = ColumnString('name');
  final channel = ColumnString('channel');

  @override
  List<Column> get columns => [
        id,
        name,
        channel,
      ];
}

@Deprecated('Use ChannelTable.t instead.')
ChannelTable tChannel = ChannelTable();

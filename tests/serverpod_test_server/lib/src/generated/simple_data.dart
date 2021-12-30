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

class SimpleData extends TableRow {
  @override
  String get className => 'SimpleData';
  @override
  String get tableName => 'simple_data';

  static final t = SimpleDataTable();

  @override
  int? id;
  late int num;

  SimpleData({
    this.id,
    required this.num,
  });

  SimpleData.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    num = _data['num']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'num': num,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'num': num,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'num': num,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'num':
        num = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<SimpleData>> find(
    Session session, {
    SimpleDataExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SimpleData?> findSingleRow(
    Session session, {
    SimpleDataExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<SimpleData?> findById(Session session, int id) async {
    return session.db.findById<SimpleData>(id);
  }

  static Future<int> delete(
    Session session, {
    required SimpleDataExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<SimpleData>(
      where: where(SimpleData.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    SimpleData row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    SimpleData row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    SimpleData row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    SimpleDataExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<SimpleData>(
      where: where != null ? where(SimpleData.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef SimpleDataExpressionBuilder = Expression Function(SimpleDataTable t);

class SimpleDataTable extends Table {
  SimpleDataTable() : super(tableName: 'simple_data');

  @override
  String tableName = 'simple_data';
  final id = ColumnInt('id');
  final num = ColumnInt('num');

  @override
  List<Column> get columns => [
        id,
        num,
      ];
}

@Deprecated('Use SimpleDataTable.t instead.')
SimpleDataTable tSimpleData = SimpleDataTable();

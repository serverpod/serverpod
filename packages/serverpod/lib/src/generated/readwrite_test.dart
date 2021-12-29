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

class ReadWriteTestEntry extends TableRow {
  @override
  String get className => 'ReadWriteTestEntry';
  @override
  String get tableName => 'serverpod_readwrite_test';

  static final t = ReadWriteTestEntryTable();

  @override
  int? id;
  late int number;

  ReadWriteTestEntry({
    this.id,
    required this.number,
  });

  ReadWriteTestEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    number = _data['number']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'number': number,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'number': number,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'number': number,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'number':
        number = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ReadWriteTestEntry>> find(
    Session session, {
    ReadWriteTestEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<ReadWriteTestEntry>(
      where: where != null ? where(ReadWriteTestEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ReadWriteTestEntry?> findSingleRow(
    Session session, {
    ReadWriteTestEntryExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ReadWriteTestEntry>(
      where: where != null ? where(ReadWriteTestEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ReadWriteTestEntry?> findById(Session session, int id) async {
    return session.db.findById<ReadWriteTestEntry>(id);
  }

  static Future<int> delete(
    Session session, {
    required ReadWriteTestEntryExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ReadWriteTestEntry>(
      where: where(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ReadWriteTestEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ReadWriteTestEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ReadWriteTestEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ReadWriteTestEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ReadWriteTestEntry>(
      where: where != null ? where(ReadWriteTestEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ReadWriteTestEntryExpressionBuilder = Expression Function(
    ReadWriteTestEntryTable t);

class ReadWriteTestEntryTable extends Table {
  ReadWriteTestEntryTable() : super(tableName: 'serverpod_readwrite_test');

  @override
  String tableName = 'serverpod_readwrite_test';
  final id = ColumnInt('id');
  final number = ColumnInt('number');

  @override
  List<Column> get columns => [
        id,
        number,
      ];
}

@Deprecated('Use ReadWriteTestEntryTable.t instead.')
ReadWriteTestEntryTable tReadWriteTestEntry = ReadWriteTestEntryTable();

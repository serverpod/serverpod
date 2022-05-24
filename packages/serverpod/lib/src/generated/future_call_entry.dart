/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class FutureCallEntry extends TableRow {
  @override
  String get className => 'FutureCallEntry';
  @override
  String get tableName => 'serverpod_future_call';

  static final t = FutureCallEntryTable();

  @override
  int? id;
  late String name;
  late DateTime time;
  String? serializedObject;
  late String serverId;
  String? identifier;

  FutureCallEntry({
    this.id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
    this.identifier,
  });

  FutureCallEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    time = DateTime.tryParse(_data['time'])!;
    serializedObject = _data['serializedObject'];
    serverId = _data['serverId']!;
    identifier = _data['identifier'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
      'identifier': identifier,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
      'identifier': identifier,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
      'identifier': identifier,
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
      case 'time':
        time = value;
        return;
      case 'serializedObject':
        serializedObject = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'identifier':
        identifier = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<FutureCallEntry>> find(
    Session session, {
    FutureCallEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<FutureCallEntry>(
      where: where != null ? where(FutureCallEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<FutureCallEntry?> findSingleRow(
    Session session, {
    FutureCallEntryExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<FutureCallEntry>(
      where: where != null ? where(FutureCallEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<FutureCallEntry?> findById(Session session, int id) async {
    return session.db.findById<FutureCallEntry>(id);
  }

  static Future<int> delete(
    Session session, {
    required FutureCallEntryExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<FutureCallEntry>(
      where: where(FutureCallEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    FutureCallEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    FutureCallEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    FutureCallEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    FutureCallEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<FutureCallEntry>(
      where: where != null ? where(FutureCallEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef FutureCallEntryExpressionBuilder = Expression Function(
    FutureCallEntryTable t);

class FutureCallEntryTable extends Table {
  FutureCallEntryTable() : super(tableName: 'serverpod_future_call');

  @override
  String tableName = 'serverpod_future_call';
  final id = ColumnInt('id');
  final name = ColumnString('name');
  final time = ColumnDateTime('time');
  final serializedObject = ColumnString('serializedObject');
  final serverId = ColumnString('serverId');
  final identifier = ColumnString('identifier');

  @override
  List<Column> get columns => [
        id,
        name,
        time,
        serializedObject,
        serverId,
        identifier,
      ];
}

@Deprecated('Use FutureCallEntryTable.t instead.')
FutureCallEntryTable tFutureCallEntry = FutureCallEntryTable();

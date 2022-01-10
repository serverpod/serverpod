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

class Types extends TableRow {
  @override
  String get className => 'Types';
  @override
  String get tableName => 'types';

  static final t = TypesTable();

  @override
  int? id;
  int? anInt;
  bool? aBool;
  double? aDouble;
  DateTime? aDateTime;
  String? aString;
  ByteData? aByteData;

  Types({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
  });

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt'];
    aBool = _data['aBool'];
    aDouble = _data['aDouble'];
    aDateTime = _data['aDateTime'] != null
        ? DateTime.tryParse(_data['aDateTime'])
        : null;
    aString = _data['aString'];
    aByteData = _data['aByteData'] == null
        ? null
        : (_data['aByteData'] is String
            ? (_data['aByteData'] as String).base64DecodedByteData()
            : ByteData.view((_data['aByteData'] as Uint8List).buffer));
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
      'aByteData': aByteData?.base64encodedString(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
      'aByteData': aByteData?.base64encodedString(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
      'aByteData': aByteData?.base64encodedString(),
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'anInt':
        anInt = value;
        return;
      case 'aBool':
        aBool = value;
        return;
      case 'aDouble':
        aDouble = value;
        return;
      case 'aDateTime':
        aDateTime = value;
        return;
      case 'aString':
        aString = value;
        return;
      case 'aByteData':
        aByteData = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Types>> find(
    Session session, {
    TypesExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<Types>(
      where: where != null ? where(Types.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Types?> findSingleRow(
    Session session, {
    TypesExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Types>(
      where: where != null ? where(Types.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<Types?> findById(Session session, int id) async {
    return session.db.findById<Types>(id);
  }

  static Future<int> delete(
    Session session, {
    required TypesExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<Types>(
      where: where(Types.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    Types row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    Types row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    Types row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    TypesExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<Types>(
      where: where != null ? where(Types.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef TypesExpressionBuilder = Expression Function(TypesTable t);

class TypesTable extends Table {
  TypesTable() : super(tableName: 'types');

  @override
  String tableName = 'types';
  final id = ColumnInt('id');
  final anInt = ColumnInt('anInt');
  final aBool = ColumnBool('aBool');
  final aDouble = ColumnDouble('aDouble');
  final aDateTime = ColumnDateTime('aDateTime');
  final aString = ColumnString('aString');
  final aByteData = ColumnByteData('aByteData');

  @override
  List<Column> get columns => [
        id,
        anInt,
        aBool,
        aDouble,
        aDateTime,
        aString,
        aByteData,
      ];
}

@Deprecated('Use TypesTable.t instead.')
TypesTable tTypes = TypesTable();

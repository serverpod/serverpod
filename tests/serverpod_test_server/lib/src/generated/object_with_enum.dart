/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ObjectWithEnum extends TableRow {
  @override
  String get className => 'ObjectWithEnum';
  @override
  String get tableName => 'object_with_enum';

  static final t = ObjectWithEnumTable();

  @override
  int? id;
  late TestEnum testEnum;
  TestEnum? nullableEnum;
  late List<TestEnum> enumList;
  late List<TestEnum?> nullableEnumList;

  ObjectWithEnum({
    this.id,
    required this.testEnum,
    this.nullableEnum,
    required this.enumList,
    required this.nullableEnumList,
  });

  ObjectWithEnum.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    testEnum = TestEnum.fromSerialization(_data['testEnum']);
    nullableEnum = _data['nullableEnum'] != null
        ? TestEnum?.fromSerialization(_data['nullableEnum'])
        : null;
    enumList = _data['enumList']!
        .map<TestEnum>((a) => TestEnum.fromSerialization(a))
        ?.toList();
    nullableEnumList = _data['nullableEnumList']!
        .map<TestEnum?>(
            (a) => a != null ? TestEnum?.fromSerialization(a) : null)
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'testEnum': testEnum.serialize(),
      'nullableEnum': nullableEnum?.serialize(),
      'enumList': enumList.map((TestEnum a) => a.serialize()).toList(),
      'nullableEnumList':
          nullableEnumList.map((TestEnum? a) => a?.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'testEnum': testEnum.serialize(),
      'nullableEnum': nullableEnum?.serialize(),
      'enumList': enumList.map((TestEnum a) => a.serialize()).toList(),
      'nullableEnumList':
          nullableEnumList.map((TestEnum? a) => a?.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'testEnum': testEnum.serialize(),
      'nullableEnum': nullableEnum?.serialize(),
      'enumList': enumList.map((TestEnum a) => a.serialize()).toList(),
      'nullableEnumList':
          nullableEnumList.map((TestEnum? a) => a?.serialize()).toList(),
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'testEnum':
        testEnum = value;
        return;
      case 'nullableEnum':
        nullableEnum = value;
        return;
      case 'enumList':
        enumList = value;
        return;
      case 'nullableEnumList':
        nullableEnumList = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ObjectWithEnum>> find(
    Session session, {
    ObjectWithEnumExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<ObjectWithEnum>(
      where: where != null ? where(ObjectWithEnum.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithEnum?> findSingleRow(
    Session session, {
    ObjectWithEnumExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectWithEnum>(
      where: where != null ? where(ObjectWithEnum.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectWithEnum?> findById(Session session, int id) async {
    return session.db.findById<ObjectWithEnum>(id);
  }

  static Future<int> delete(
    Session session, {
    required ObjectWithEnumExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ObjectWithEnum>(
      where: where(ObjectWithEnum.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ObjectWithEnum row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ObjectWithEnum row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ObjectWithEnum row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ObjectWithEnumExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithEnum>(
      where: where != null ? where(ObjectWithEnum.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ObjectWithEnumExpressionBuilder = Expression Function(
    ObjectWithEnumTable t);

class ObjectWithEnumTable extends Table {
  ObjectWithEnumTable() : super(tableName: 'object_with_enum');

  @override
  String tableName = 'object_with_enum';
  final id = ColumnInt('id');
  final testEnum = ColumnSerializable('testEnum');
  final nullableEnum = ColumnSerializable('nullableEnum');
  final enumList = ColumnSerializable('enumList');
  final nullableEnumList = ColumnSerializable('nullableEnumList');

  @override
  List<Column> get columns => [
        id,
        testEnum,
        nullableEnum,
        enumList,
        nullableEnumList,
      ];
}

@Deprecated('Use ObjectWithEnumTable.t instead.')
ObjectWithEnumTable tObjectWithEnum = ObjectWithEnumTable();

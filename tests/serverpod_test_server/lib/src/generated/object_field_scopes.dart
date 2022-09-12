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

class ObjectFieldScopes extends TableRow {
  @override
  String get className => 'ObjectFieldScopes';
  @override
  String get tableName => 'object_field_scopes';

  static final t = ObjectFieldScopesTable();

  @override
  int? id;
  late String normal;
  String? api;
  String? database;

  ObjectFieldScopes({
    this.id,
    required this.normal,
    this.api,
    this.database,
  });

  ObjectFieldScopes.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    normal = _data['normal']!;
    api = _data['api'];
    database = _data['database'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'normal': normal,
      'api': api,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'normal': normal,
      'database': database,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'normal': normal,
      'api': api,
      'database': database,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'normal':
        normal = value;
        return;
      case 'database':
        database = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<ObjectFieldScopes>> find(
    Session session, {
    ObjectFieldScopesExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<ObjectFieldScopes>(
      where: where != null ? where(ObjectFieldScopes.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectFieldScopes?> findSingleRow(
    Session session, {
    ObjectFieldScopesExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<ObjectFieldScopes>(
      where: where != null ? where(ObjectFieldScopes.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<ObjectFieldScopes?> findById(Session session, int id) async {
    return session.db.findById<ObjectFieldScopes>(id);
  }

  static Future<int> delete(
    Session session, {
    required ObjectFieldScopesExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<ObjectFieldScopes>(
      where: where(ObjectFieldScopes.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    ObjectFieldScopes row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    ObjectFieldScopes row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    ObjectFieldScopes row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    ObjectFieldScopesExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<ObjectFieldScopes>(
      where: where != null ? where(ObjectFieldScopes.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef ObjectFieldScopesExpressionBuilder = Expression Function(
    ObjectFieldScopesTable t);

class ObjectFieldScopesTable extends Table {
  ObjectFieldScopesTable() : super(tableName: 'object_field_scopes');

  @override
  String tableName = 'object_field_scopes';
  final id = ColumnInt('id');
  final normal = ColumnString('normal');
  final database = ColumnString('database');

  @override
  List<Column> get columns => [
        id,
        normal,
        database,
      ];
}

@Deprecated('Use ObjectFieldScopesTable.t instead.')
ObjectFieldScopesTable tObjectFieldScopes = ObjectFieldScopesTable();

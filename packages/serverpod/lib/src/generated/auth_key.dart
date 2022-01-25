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

class AuthKey extends TableRow {
  @override
  String get className => 'AuthKey';
  @override
  String get tableName => 'serverpod_auth_key';

  static final t = AuthKeyTable();

  @override
  int? id;
  late int userId;
  late String hash;
  String? key;
  late List<String> scopeNames;
  late String method;

  AuthKey({
    this.id,
    required this.userId,
    required this.hash,
    this.key,
    required this.scopeNames,
    required this.method,
  });

  AuthKey.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    hash = _data['hash']!;
    key = _data['key'];
    scopeNames = _data['scopeNames']!.cast<String>();
    method = _data['method']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'hash': hash,
      'key': key,
      'scopeNames': scopeNames,
      'method': method,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'hash': hash,
      'scopeNames': scopeNames,
      'method': method,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'hash': hash,
      'key': key,
      'scopeNames': scopeNames,
      'method': method,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'userId':
        userId = value;
        return;
      case 'hash':
        hash = value;
        return;
      case 'scopeNames':
        scopeNames = value;
        return;
      case 'method':
        method = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<AuthKey>> find(
    Session session, {
    AuthKeyExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<AuthKey>(
      where: where != null ? where(AuthKey.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<AuthKey?> findSingleRow(
    Session session, {
    AuthKeyExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<AuthKey>(
      where: where != null ? where(AuthKey.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<AuthKey?> findById(Session session, int id) async {
    return session.db.findById<AuthKey>(id);
  }

  static Future<int> delete(
    Session session, {
    required AuthKeyExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<AuthKey>(
      where: where(AuthKey.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    AuthKey row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    AuthKey row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    AuthKey row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    AuthKeyExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<AuthKey>(
      where: where != null ? where(AuthKey.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef AuthKeyExpressionBuilder = Expression Function(AuthKeyTable t);

class AuthKeyTable extends Table {
  AuthKeyTable() : super(tableName: 'serverpod_auth_key');

  @override
  String tableName = 'serverpod_auth_key';
  final id = ColumnInt('id');
  final userId = ColumnInt('userId');
  final hash = ColumnString('hash');
  final scopeNames = ColumnSerializable('scopeNames');
  final method = ColumnString('method');

  @override
  List<Column> get columns => [
        id,
        userId,
        hash,
        scopeNames,
        method,
      ];
}

@Deprecated('Use AuthKeyTable.t instead.')
AuthKeyTable tAuthKey = AuthKeyTable();

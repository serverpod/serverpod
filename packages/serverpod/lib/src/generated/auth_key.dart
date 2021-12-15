/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class AuthKey extends TableRow {
  @override
  String get className => 'AuthKey';
  @override
  String get tableName => 'serverpod_auth_key';

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
}

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

AuthKeyTable tAuthKey = AuthKeyTable();

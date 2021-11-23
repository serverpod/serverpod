/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class EmailReset extends TableRow {
  @override
  String get className => 'serverpod_auth_server.EmailReset';
  @override
  String get tableName => 'serverpod_email_reset';

  @override
  int? id;
  late int userId;
  late String verificationCode;
  late DateTime expiration;

  EmailReset({
    this.id,
    required this.userId,
    required this.verificationCode,
    required this.expiration,
});

  EmailReset.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    verificationCode = _data['verificationCode']!;
    expiration = DateTime.tryParse(_data['expiration'])!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toUtc().toIso8601String(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toUtc().toIso8601String(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'verificationCode': verificationCode,
      'expiration': expiration.toUtc().toIso8601String(),
    });
  }
}

class EmailResetTable extends Table {
  EmailResetTable() : super(tableName: 'serverpod_email_reset');

  @override
  String tableName = 'serverpod_email_reset';
  final id = ColumnInt('id');
  final userId = ColumnInt('userId');
  final verificationCode = ColumnString('verificationCode');
  final expiration = ColumnDateTime('expiration');

  @override
  List<Column> get columns => [
    id,
    userId,
    verificationCode,
    expiration,
  ];
}

EmailResetTable tEmailReset = EmailResetTable();

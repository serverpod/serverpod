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

class EmailReset extends TableRow {
  @override
  String get className => 'serverpod_auth_server.EmailReset';
  @override
  String get tableName => 'serverpod_email_reset';

  static final t = EmailResetTable();

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

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'userId':
        userId = value;
        return;
      case 'verificationCode':
        verificationCode = value;
        return;
      case 'expiration':
        expiration = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<EmailReset>> find(
    Session session, {
    EmailResetExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailReset?> findSingleRow(
    Session session, {
    EmailResetExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailReset?> findById(Session session, int id) async {
    return session.db.findById<EmailReset>(id);
  }

  static Future<int> delete(
    Session session, {
    required EmailResetExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<EmailReset>(
      where: where(EmailReset.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    EmailReset row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    EmailReset row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    EmailReset row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    EmailResetExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<EmailReset>(
      where: where != null ? where(EmailReset.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef EmailResetExpressionBuilder = Expression Function(EmailResetTable t);

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

@Deprecated('Use EmailResetTable.t instead.')
EmailResetTable tEmailReset = EmailResetTable();

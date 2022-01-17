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

class EmailCreateAccountRequest extends TableRow {
  @override
  String get className => 'serverpod_auth_server.EmailCreateAccountRequest';
  @override
  String get tableName => 'serverpod_email_create_request';

  static final t = EmailCreateAccountRequestTable();

  @override
  int? id;
  late String userName;
  late String email;
  late String hash;
  late String verificationCode;

  EmailCreateAccountRequest({
    this.id,
    required this.userName,
    required this.email,
    required this.hash,
    required this.verificationCode,
  });

  EmailCreateAccountRequest.fromSerialization(
      Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userName = _data['userName']!;
    email = _data['email']!;
    hash = _data['hash']!;
    verificationCode = _data['verificationCode']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userName': userName,
      'email': email,
      'hash': hash,
      'verificationCode': verificationCode,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'userName':
        userName = value;
        return;
      case 'email':
        email = value;
        return;
      case 'hash':
        hash = value;
        return;
      case 'verificationCode':
        verificationCode = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<EmailCreateAccountRequest>> find(
    Session session, {
    EmailCreateAccountRequestExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<EmailCreateAccountRequest>(
      where: where != null ? where(EmailCreateAccountRequest.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailCreateAccountRequest?> findSingleRow(
    Session session, {
    EmailCreateAccountRequestExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailCreateAccountRequest>(
      where: where != null ? where(EmailCreateAccountRequest.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailCreateAccountRequest?> findById(
      Session session, int id) async {
    return session.db.findById<EmailCreateAccountRequest>(id);
  }

  static Future<int> delete(
    Session session, {
    required EmailCreateAccountRequestExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<EmailCreateAccountRequest>(
      where: where(EmailCreateAccountRequest.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    EmailCreateAccountRequest row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    EmailCreateAccountRequest row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    EmailCreateAccountRequest row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    EmailCreateAccountRequestExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<EmailCreateAccountRequest>(
      where: where != null ? where(EmailCreateAccountRequest.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef EmailCreateAccountRequestExpressionBuilder = Expression Function(
    EmailCreateAccountRequestTable t);

class EmailCreateAccountRequestTable extends Table {
  EmailCreateAccountRequestTable()
      : super(tableName: 'serverpod_email_create_request');

  @override
  String tableName = 'serverpod_email_create_request';
  final id = ColumnInt('id');
  final userName = ColumnString('userName');
  final email = ColumnString('email');
  final hash = ColumnString('hash');
  final verificationCode = ColumnString('verificationCode');

  @override
  List<Column> get columns => [
        id,
        userName,
        email,
        hash,
        verificationCode,
      ];
}

@Deprecated('Use EmailCreateAccountRequestTable.t instead.')
EmailCreateAccountRequestTable tEmailCreateAccountRequest =
    EmailCreateAccountRequestTable();

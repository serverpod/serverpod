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

class EmailFailedSignIn extends TableRow {
  @override
  String get className => 'serverpod_auth_server.EmailFailedSignIn';
  @override
  String get tableName => 'serverpod_email_failed_sign_in';

  static final t = EmailFailedSignInTable();

  @override
  int? id;
  late String email;
  late DateTime time;
  late String ipAddress;

  EmailFailedSignIn({
    this.id,
    required this.email,
    required this.time,
    required this.ipAddress,
  });

  EmailFailedSignIn.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    email = _data['email']!;
    time = DateTime.tryParse(_data['time'])!;
    ipAddress = _data['ipAddress']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'email': email,
      'time': time.toUtc().toIso8601String(),
      'ipAddress': ipAddress,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'email': email,
      'time': time.toUtc().toIso8601String(),
      'ipAddress': ipAddress,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'email': email,
      'time': time.toUtc().toIso8601String(),
      'ipAddress': ipAddress,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'email':
        email = value;
        return;
      case 'time':
        time = value;
        return;
      case 'ipAddress':
        ipAddress = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<EmailFailedSignIn>> find(
    Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailFailedSignIn?> findSingleRow(
    Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<EmailFailedSignIn?> findById(Session session, int id) async {
    return session.db.findById<EmailFailedSignIn>(id);
  }

  static Future<int> delete(
    Session session, {
    required EmailFailedSignInExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<EmailFailedSignIn>(
      where: where(EmailFailedSignIn.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    EmailFailedSignIn row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    EmailFailedSignIn row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    EmailFailedSignIn row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    EmailFailedSignInExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<EmailFailedSignIn>(
      where: where != null ? where(EmailFailedSignIn.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef EmailFailedSignInExpressionBuilder = Expression Function(
    EmailFailedSignInTable t);

class EmailFailedSignInTable extends Table {
  EmailFailedSignInTable() : super(tableName: 'serverpod_email_failed_sign_in');

  @override
  String tableName = 'serverpod_email_failed_sign_in';
  final id = ColumnInt('id');
  final email = ColumnString('email');
  final time = ColumnDateTime('time');
  final ipAddress = ColumnString('ipAddress');

  @override
  List<Column> get columns => [
        id,
        email,
        time,
        ipAddress,
      ];
}

@Deprecated('Use EmailFailedSignInTable.t instead.')
EmailFailedSignInTable tEmailFailedSignIn = EmailFailedSignInTable();

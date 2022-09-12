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

class GoogleRefreshToken extends TableRow {
  @override
  String get className => 'serverpod_auth_server.GoogleRefreshToken';
  @override
  String get tableName => 'serverpod_google_refresh_token';

  static final t = GoogleRefreshTokenTable();

  @override
  int? id;
  late int userId;
  late String refreshToken;

  GoogleRefreshToken({
    this.id,
    required this.userId,
    required this.refreshToken,
  });

  GoogleRefreshToken.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    refreshToken = _data['refreshToken']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'refreshToken': refreshToken,
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
      case 'refreshToken':
        refreshToken = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<GoogleRefreshToken>> find(
    Session session, {
    GoogleRefreshTokenExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<GoogleRefreshToken>(
      where: where != null ? where(GoogleRefreshToken.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<GoogleRefreshToken?> findSingleRow(
    Session session, {
    GoogleRefreshTokenExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<GoogleRefreshToken>(
      where: where != null ? where(GoogleRefreshToken.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<GoogleRefreshToken?> findById(Session session, int id) async {
    return session.db.findById<GoogleRefreshToken>(id);
  }

  static Future<int> delete(
    Session session, {
    required GoogleRefreshTokenExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<GoogleRefreshToken>(
      where: where(GoogleRefreshToken.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    GoogleRefreshToken row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    GoogleRefreshToken row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    GoogleRefreshToken row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    GoogleRefreshTokenExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<GoogleRefreshToken>(
      where: where != null ? where(GoogleRefreshToken.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef GoogleRefreshTokenExpressionBuilder = Expression Function(
    GoogleRefreshTokenTable t);

class GoogleRefreshTokenTable extends Table {
  GoogleRefreshTokenTable()
      : super(tableName: 'serverpod_google_refresh_token');

  @override
  String tableName = 'serverpod_google_refresh_token';
  final id = ColumnInt('id');
  final userId = ColumnInt('userId');
  final refreshToken = ColumnString('refreshToken');

  @override
  List<Column> get columns => [
        id,
        userId,
        refreshToken,
      ];
}

@Deprecated('Use GoogleRefreshTokenTable.t instead.')
GoogleRefreshTokenTable tGoogleRefreshToken = GoogleRefreshTokenTable();

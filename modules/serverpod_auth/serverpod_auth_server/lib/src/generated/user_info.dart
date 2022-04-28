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

class UserInfo extends TableRow {
  @override
  String get className => 'serverpod_auth_server.UserInfo';
  @override
  String get tableName => 'serverpod_user_info';

  static final UserInfoTable t = UserInfoTable();

  @override
  int? id;
  late String userIdentifier;
  late String userName;
  String? fullName;
  String? email;
  late DateTime created;
  String? imageUrl;
  late List<String> scopeNames;
  late bool active;
  late bool blocked;
  DateTime? suspendedUntil;

  UserInfo({
    this.id,
    required this.userIdentifier,
    required this.userName,
    this.fullName,
    this.email,
    required this.created,
    this.imageUrl,
    required this.scopeNames,
    required this.active,
    required this.blocked,
    this.suspendedUntil,
  });

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userIdentifier = _data['userIdentifier']!;
    userName = _data['userName']!;
    fullName = _data['fullName'];
    email = _data['email'];
    created = DateTime.tryParse(_data['created'])!;
    imageUrl = _data['imageUrl'];
    scopeNames = _data['scopeNames']!.cast<String>();
    active = _data['active']!;
    blocked = _data['blocked']!;
    suspendedUntil = _data['suspendedUntil'] != null
        ? DateTime.tryParse(_data['suspendedUntil'])
        : null;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil?.toUtc().toIso8601String(),
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil?.toUtc().toIso8601String(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'userIdentifier': userIdentifier,
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'created': created.toUtc().toIso8601String(),
      'imageUrl': imageUrl,
      'scopeNames': scopeNames,
      'active': active,
      'blocked': blocked,
      'suspendedUntil': suspendedUntil?.toUtc().toIso8601String(),
    });
  }

  @override
  void setColumn(String columnName, dynamic value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'userIdentifier':
        userIdentifier = value;
        return;
      case 'userName':
        userName = value;
        return;
      case 'fullName':
        fullName = value;
        return;
      case 'email':
        email = value;
        return;
      case 'created':
        created = value;
        return;
      case 'imageUrl':
        imageUrl = value;
        return;
      case 'scopeNames':
        scopeNames = value;
        return;
      case 'active':
        active = value;
        return;
      case 'blocked':
        blocked = value;
        return;
      case 'suspendedUntil':
        suspendedUntil = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<UserInfo>> find(
    Session session, {
    UserInfoExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserInfo?> findSingleRow(
    Session session, {
    UserInfoExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserInfo?> findById(Session session, int id) async {
    return session.db.findById<UserInfo>(id);
  }

  static Future<int> delete(
    Session session, {
    required UserInfoExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<UserInfo>(
      where: where(UserInfo.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    UserInfo row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    UserInfo row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    UserInfo row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    UserInfoExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<UserInfo>(
      where: where != null ? where(UserInfo.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef UserInfoExpressionBuilder = Expression Function(UserInfoTable t);

class UserInfoTable extends Table {
  UserInfoTable() : super(tableName: 'serverpod_user_info');

  @override
  String tableName = 'serverpod_user_info';
  final ColumnInt id = ColumnInt('id');
  final ColumnString userIdentifier = ColumnString('userIdentifier');
  final ColumnString userName = ColumnString('userName');
  final ColumnString fullName = ColumnString('fullName');
  final ColumnString email = ColumnString('email');
  final ColumnDateTime created = ColumnDateTime('created');
  final ColumnString imageUrl = ColumnString('imageUrl');
  final ColumnSerializable scopeNames = ColumnSerializable('scopeNames');
  final ColumnBool active = ColumnBool('active');
  final ColumnBool blocked = ColumnBool('blocked');
  final ColumnDateTime suspendedUntil = ColumnDateTime('suspendedUntil');

  @override
  List<Column> get columns => <Column>[
        id,
        userIdentifier,
        userName,
        fullName,
        email,
        created,
        imageUrl,
        scopeNames,
        active,
        blocked,
        suspendedUntil,
      ];
}

@Deprecated('Use UserInfoTable.t instead.')
UserInfoTable tUserInfo = UserInfoTable();

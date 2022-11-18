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

class UserImage extends TableRow {
  @override
  String get className => 'serverpod_auth_server.UserImage';
  @override
  String get tableName => 'serverpod_user_image';

  static final t = UserImageTable();

  @override
  int? id;
  late int userId;
  late int version;
  late String url;

  UserImage({
    this.id,
    required this.userId,
    required this.version,
    required this.url,
  });

  UserImage.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    userId = _data['userId']!;
    version = _data['version']!;
    url = _data['url']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'userId': userId,
      'version': version,
      'url': url,
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
      case 'version':
        version = value;
        return;
      case 'url':
        url = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<UserImage>> find(
    Session session, {
    UserImageExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserImage?> findSingleRow(
    Session session, {
    UserImageExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<UserImage?> findById(Session session, int id) async {
    return session.db.findById<UserImage>(id);
  }

  static Future<int> delete(
    Session session, {
    required UserImageExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<UserImage>(
      where: where(UserImage.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    UserImage row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    UserImage row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    UserImage row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    UserImageExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<UserImage>(
      where: where != null ? where(UserImage.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef UserImageExpressionBuilder = Expression Function(UserImageTable t);

class UserImageTable extends Table {
  UserImageTable() : super(tableName: 'serverpod_user_image');

  @override
  String tableName = 'serverpod_user_image';
  final id = ColumnInt('id');
  final userId = ColumnInt('userId');
  final version = ColumnInt('version');
  final url = ColumnString('url');

  @override
  List<Column> get columns => [
        id,
        userId,
        version,
        url,
      ];
}

@Deprecated('Use UserImageTable.t instead.')
UserImageTable tUserImage = UserImageTable();

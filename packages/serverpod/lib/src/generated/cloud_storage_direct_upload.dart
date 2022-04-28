/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import '../../serverpod.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class CloudStorageDirectUploadEntry extends TableRow {
  @override
  String get className => 'CloudStorageDirectUploadEntry';
  @override
  String get tableName => 'serverpod_cloud_storage_direct_upload';

  static final CloudStorageDirectUploadEntryTable t =
      CloudStorageDirectUploadEntryTable();

  @override
  int? id;
  late String storageId;
  late String path;
  late DateTime expiration;
  late String authKey;

  CloudStorageDirectUploadEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
  });

  CloudStorageDirectUploadEntry.fromSerialization(
      Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    storageId = _data['storageId']!;
    path = _data['path']!;
    expiration = DateTime.tryParse(_data['expiration'])!;
    authKey = _data['authKey']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toUtc().toIso8601String(),
      'authKey': authKey,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toUtc().toIso8601String(),
      'authKey': authKey,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toUtc().toIso8601String(),
      'authKey': authKey,
    });
  }

  @override
  void setColumn(String columnName, dynamic value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'storageId':
        storageId = value;
        return;
      case 'path':
        path = value;
        return;
      case 'expiration':
        expiration = value;
        return;
      case 'authKey':
        authKey = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<CloudStorageDirectUploadEntry>> find(
    Session session, {
    CloudStorageDirectUploadEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<CloudStorageDirectUploadEntry>(
      where: where != null ? where(CloudStorageDirectUploadEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<CloudStorageDirectUploadEntry?> findSingleRow(
    Session session, {
    CloudStorageDirectUploadEntryExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<CloudStorageDirectUploadEntry>(
      where: where != null ? where(CloudStorageDirectUploadEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<CloudStorageDirectUploadEntry?> findById(
      Session session, int id) async {
    return session.db.findById<CloudStorageDirectUploadEntry>(id);
  }

  static Future<int> delete(
    Session session, {
    required CloudStorageDirectUploadEntryExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageDirectUploadEntry>(
      where: where(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    CloudStorageDirectUploadEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    CloudStorageDirectUploadEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    CloudStorageDirectUploadEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    CloudStorageDirectUploadEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageDirectUploadEntry>(
      where: where != null ? where(CloudStorageDirectUploadEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef CloudStorageDirectUploadEntryExpressionBuilder = Expression Function(
    CloudStorageDirectUploadEntryTable t);

class CloudStorageDirectUploadEntryTable extends Table {
  CloudStorageDirectUploadEntryTable()
      : super(tableName: 'serverpod_cloud_storage_direct_upload');

  @override
  String tableName = 'serverpod_cloud_storage_direct_upload';
  final ColumnInt id = ColumnInt('id');
  final ColumnString storageId = ColumnString('storageId');
  final ColumnString path = ColumnString('path');
  final ColumnDateTime expiration = ColumnDateTime('expiration');
  final ColumnString authKey = ColumnString('authKey');

  @override
  List<Column> get columns => <Column>[
        id,
        storageId,
        path,
        expiration,
        authKey,
      ];
}

@Deprecated('Use CloudStorageDirectUploadEntryTable.t instead.')
CloudStorageDirectUploadEntryTable tCloudStorageDirectUploadEntry =
    CloudStorageDirectUploadEntryTable();

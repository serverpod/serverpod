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

class CloudStorageEntry extends TableRow {
  @override
  String get className => 'CloudStorageEntry';
  @override
  String get tableName => 'serverpod_cloud_storage';

  static final CloudStorageEntryTable t = CloudStorageEntryTable();

  @override
  int? id;
  late String storageId;
  late String path;
  late DateTime addedTime;
  DateTime? expiration;
  late ByteData byteData;
  late bool verified;

  CloudStorageEntry({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  });

  CloudStorageEntry.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    storageId = _data['storageId']!;
    path = _data['path']!;
    addedTime = DateTime.tryParse(_data['addedTime'])!;
    expiration = _data['expiration'] != null
        ? DateTime.tryParse(_data['expiration'])
        : null;
    byteData = _data['byteData'] is String
        ? (_data['byteData'] as String).base64DecodedByteData()!
        : ByteData.view((_data['byteData'] as Uint8List).buffer);
    verified = _data['verified']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toUtc().toIso8601String(),
      'expiration': expiration?.toUtc().toIso8601String(),
      'byteData': byteData.base64encodedString(),
      'verified': verified,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toUtc().toIso8601String(),
      'expiration': expiration?.toUtc().toIso8601String(),
      'byteData': byteData.base64encodedString(),
      'verified': verified,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toUtc().toIso8601String(),
      'expiration': expiration?.toUtc().toIso8601String(),
      'byteData': byteData.base64encodedString(),
      'verified': verified,
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
      case 'addedTime':
        addedTime = value;
        return;
      case 'expiration':
        expiration = value;
        return;
      case 'byteData':
        byteData = value;
        return;
      case 'verified':
        verified = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<CloudStorageEntry>> find(
    Session session, {
    CloudStorageEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<CloudStorageEntry>(
      where: where != null ? where(CloudStorageEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<CloudStorageEntry?> findSingleRow(
    Session session, {
    CloudStorageEntryExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<CloudStorageEntry>(
      where: where != null ? where(CloudStorageEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<CloudStorageEntry?> findById(Session session, int id) async {
    return session.db.findById<CloudStorageEntry>(id);
  }

  static Future<int> delete(
    Session session, {
    required CloudStorageEntryExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageEntry>(
      where: where(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    CloudStorageEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    CloudStorageEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    CloudStorageEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    CloudStorageEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageEntry>(
      where: where != null ? where(CloudStorageEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef CloudStorageEntryExpressionBuilder = Expression Function(
    CloudStorageEntryTable t);

class CloudStorageEntryTable extends Table {
  CloudStorageEntryTable() : super(tableName: 'serverpod_cloud_storage');

  @override
  String tableName = 'serverpod_cloud_storage';
  final ColumnInt id = ColumnInt('id');
  final ColumnString storageId = ColumnString('storageId');
  final ColumnString path = ColumnString('path');
  final ColumnDateTime addedTime = ColumnDateTime('addedTime');
  final ColumnDateTime expiration = ColumnDateTime('expiration');
  final ColumnByteData byteData = ColumnByteData('byteData');
  final ColumnBool verified = ColumnBool('verified');

  @override
  List<Column> get columns => <Column>[
        id,
        storageId,
        path,
        addedTime,
        expiration,
        byteData,
        verified,
      ];
}

@Deprecated('Use CloudStorageEntryTable.t instead.')
CloudStorageEntryTable tCloudStorageEntry = CloudStorageEntryTable();

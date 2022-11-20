/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;

class CloudStorageEntry extends _i1.TableRow {
  CloudStorageEntry({
    int? id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  }) : super(id);

  factory CloudStorageEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CloudStorageEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      storageId: serializationManager
          .deserialize<String>(jsonSerialization['storageId']),
      path: serializationManager.deserialize<String>(jsonSerialization['path']),
      addedTime: serializationManager
          .deserialize<DateTime>(jsonSerialization['addedTime']),
      expiration: serializationManager
          .deserialize<DateTime?>(jsonSerialization['expiration']),
      byteData: serializationManager
          .deserialize<_i2.ByteData>(jsonSerialization['byteData']),
      verified:
          serializationManager.deserialize<bool>(jsonSerialization['verified']),
    );
  }

  static final t = CloudStorageEntryTable();

  String storageId;

  String path;

  DateTime addedTime;

  DateTime? expiration;

  _i2.ByteData byteData;

  bool verified;

  @override
  String get tableName => 'serverpod_cloud_storage';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime,
      'expiration': expiration,
      'byteData': byteData,
      'verified': verified,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime,
      'expiration': expiration,
      'byteData': byteData,
      'verified': verified,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime,
      'expiration': expiration,
      'byteData': byteData,
      'verified': verified,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
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
    _i1.Session session, {
    CloudStorageEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CloudStorageEntry>(
      where: where != null ? where(CloudStorageEntry.t) : null,
      limit: limit,
      viewTable: false,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<CloudStorageEntry?> findSingleRow(
    _i1.Session session, {
    CloudStorageEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
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

  static Future<CloudStorageEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<CloudStorageEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required CloudStorageEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageEntry>(
      where: where(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    CloudStorageEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    CloudStorageEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    CloudStorageEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    CloudStorageEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageEntry>(
      where: where != null ? where(CloudStorageEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef CloudStorageEntryExpressionBuilder = _i1.Expression Function(
    CloudStorageEntryTable);

class CloudStorageEntryTable extends _i1.Table {
  CloudStorageEntryTable() : super(tableName: 'serverpod_cloud_storage');

  final id = _i1.ColumnInt('id');

  final storageId = _i1.ColumnString('storageId');

  final path = _i1.ColumnString('path');

  final addedTime = _i1.ColumnDateTime('addedTime');

  final expiration = _i1.ColumnDateTime('expiration');

  final byteData = _i1.ColumnByteData('byteData');

  final verified = _i1.ColumnBool('verified');

  @override
  List<_i1.Column> get columns => [
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

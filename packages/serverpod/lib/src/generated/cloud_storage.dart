/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:typed_data' as _i2;

typedef CloudStorageEntryExpressionBuilder = _i1.Expression Function(
    CloudStorageEntryTable);

/// An entry in the database for an uploaded file.
abstract class CloudStorageEntry extends _i1.TableRow {
  const CloudStorageEntry._();

  const factory CloudStorageEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _i2.ByteData byteData,
    required bool verified,
  }) = _CloudStorageEntry;

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

  static const t = CloudStorageEntryTable();

  CloudStorageEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? addedTime,
    DateTime? expiration,
    _i2.ByteData? byteData,
    bool? verified,
  });
  @override
  String get tableName => 'serverpod_cloud_storage';
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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<CloudStorageEntry> insert(
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

  /// The storageId, typically `public` or `private`.
  String get storageId;

  /// The path where the file is stored.
  String get path;

  /// The time when the file was added.
  DateTime get addedTime;

  /// The time at which the file expires and can be deleted.
  DateTime? get expiration;

  /// The actual data of the uploaded file.
  _i2.ByteData get byteData;

  /// True if the file has been verified as uploaded.
  bool get verified;
}

class _Undefined {}

/// An entry in the database for an uploaded file.
class _CloudStorageEntry extends CloudStorageEntry {
  const _CloudStorageEntry({
    int? id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  }) : super._();

  /// The storageId, typically `public` or `private`.
  @override
  final String storageId;

  /// The path where the file is stored.
  @override
  final String path;

  /// The time when the file was added.
  @override
  final DateTime addedTime;

  /// The time at which the file expires and can be deleted.
  @override
  final DateTime? expiration;

  /// The actual data of the uploaded file.
  @override
  final _i2.ByteData byteData;

  /// True if the file has been verified as uploaded.
  @override
  final bool verified;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is CloudStorageEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.storageId,
                  storageId,
                ) ||
                other.storageId == storageId) &&
            (identical(
                  other.path,
                  path,
                ) ||
                other.path == path) &&
            (identical(
                  other.addedTime,
                  addedTime,
                ) ||
                other.addedTime == addedTime) &&
            (identical(
                  other.expiration,
                  expiration,
                ) ||
                other.expiration == expiration) &&
            (identical(
                  other.byteData,
                  byteData,
                ) ||
                other.byteData == byteData) &&
            (identical(
                  other.verified,
                  verified,
                ) ||
                other.verified == verified));
  }

  @override
  int get hashCode => Object.hash(
        id,
        storageId,
        path,
        addedTime,
        expiration,
        byteData,
        verified,
      );

  @override
  CloudStorageEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? addedTime,
    Object? expiration = _Undefined,
    _i2.ByteData? byteData,
    bool? verified,
  }) {
    return CloudStorageEntry(
      id: id == _Undefined ? this.id : (id as int?),
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      addedTime: addedTime ?? this.addedTime,
      expiration: expiration == _Undefined
          ? this.expiration
          : (expiration as DateTime?),
      byteData: byteData ?? this.byteData,
      verified: verified ?? this.verified,
    );
  }
}

class CloudStorageEntryTable extends _i1.Table {
  const CloudStorageEntryTable() : super(tableName: 'serverpod_cloud_storage');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The storageId, typically `public` or `private`.
  final storageId = const _i1.ColumnString('storageId');

  /// The path where the file is stored.
  final path = const _i1.ColumnString('path');

  /// The time when the file was added.
  final addedTime = const _i1.ColumnDateTime('addedTime');

  /// The time at which the file expires and can be deleted.
  final expiration = const _i1.ColumnDateTime('expiration');

  /// The actual data of the uploaded file.
  final byteData = const _i1.ColumnByteData('byteData');

  /// True if the file has been verified as uploaded.
  final verified = const _i1.ColumnBool('verified');

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
CloudStorageEntryTable tCloudStorageEntry = const CloudStorageEntryTable();

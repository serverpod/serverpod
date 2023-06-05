/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef CloudStorageDirectUploadEntryExpressionBuilder = _i1.Expression
    Function(CloudStorageDirectUploadEntryTable);

/// Connects a table for handling uploading of files.
abstract class CloudStorageDirectUploadEntry extends _i1.TableRow {
  const CloudStorageDirectUploadEntry._();

  const factory CloudStorageDirectUploadEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
  }) = _CloudStorageDirectUploadEntry;

  factory CloudStorageDirectUploadEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return CloudStorageDirectUploadEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      storageId: serializationManager
          .deserialize<String>(jsonSerialization['storageId']),
      path: serializationManager.deserialize<String>(jsonSerialization['path']),
      expiration: serializationManager
          .deserialize<DateTime>(jsonSerialization['expiration']),
      authKey: serializationManager
          .deserialize<String>(jsonSerialization['authKey']),
    );
  }

  static const t = CloudStorageDirectUploadEntryTable();

  CloudStorageDirectUploadEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
  });
  @override
  String get tableName => 'serverpod_cloud_storage_direct_upload';
  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration,
      'authKey': authKey,
    };
  }

  static Future<List<CloudStorageDirectUploadEntry>> find(
    _i1.Session session, {
    CloudStorageDirectUploadEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
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
    _i1.Session session, {
    CloudStorageDirectUploadEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
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
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<CloudStorageDirectUploadEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required CloudStorageDirectUploadEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageDirectUploadEntry>(
      where: where(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    CloudStorageDirectUploadEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageDirectUploadEntry>(
      where: where != null ? where(CloudStorageDirectUploadEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  /// The storageId, typically `public` or `private`.
  String get storageId;

  /// The path where the file is stored.
  String get path;

  /// The expiration time of when the file can be uploaded.
  DateTime get expiration;

  /// Access key for retrieving a private file.
  String get authKey;
}

class _Undefined {}

/// Connects a table for handling uploading of files.
class _CloudStorageDirectUploadEntry extends CloudStorageDirectUploadEntry {
  const _CloudStorageDirectUploadEntry({
    int? id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
  }) : super._();

  /// The storageId, typically `public` or `private`.
  @override
  final String storageId;

  /// The path where the file is stored.
  @override
  final String path;

  /// The expiration time of when the file can be uploaded.
  @override
  final DateTime expiration;

  /// Access key for retrieving a private file.
  @override
  final String authKey;

  @override
  String get tableName => 'serverpod_cloud_storage_direct_upload';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration,
      'authKey': authKey,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is CloudStorageDirectUploadEntry &&
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
                  other.expiration,
                  expiration,
                ) ||
                other.expiration == expiration) &&
            (identical(
                  other.authKey,
                  authKey,
                ) ||
                other.authKey == authKey));
  }

  @override
  int get hashCode => Object.hash(
        id,
        storageId,
        path,
        expiration,
        authKey,
      );

  @override
  CloudStorageDirectUploadEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
  }) {
    return CloudStorageDirectUploadEntry(
      id: id == _Undefined ? this.id : (id as int?),
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      expiration: expiration ?? this.expiration,
      authKey: authKey ?? this.authKey,
    );
  }
}

class CloudStorageDirectUploadEntryTable extends _i1.Table {
  const CloudStorageDirectUploadEntryTable()
      : super(tableName: 'serverpod_cloud_storage_direct_upload');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The storageId, typically `public` or `private`.
  final storageId = const _i1.ColumnString('storageId');

  /// The path where the file is stored.
  final path = const _i1.ColumnString('path');

  /// The expiration time of when the file can be uploaded.
  final expiration = const _i1.ColumnDateTime('expiration');

  /// Access key for retrieving a private file.
  final authKey = const _i1.ColumnString('authKey');

  @override
  List<_i1.Column> get columns => [
        id,
        storageId,
        path,
        expiration,
        authKey,
      ];
}

@Deprecated('Use CloudStorageDirectUploadEntryTable.t instead.')
CloudStorageDirectUploadEntryTable tCloudStorageDirectUploadEntry =
    const CloudStorageDirectUploadEntryTable();

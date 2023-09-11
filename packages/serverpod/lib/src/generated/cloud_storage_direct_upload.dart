/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Connects a table for handling uploading of files.
abstract class CloudStorageDirectUploadEntry extends _i1.TableRow {
  CloudStorageDirectUploadEntry._({
    int? id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
  }) : super(id);

  factory CloudStorageDirectUploadEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
  }) = _CloudStorageDirectUploadEntryImpl;

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

  static final t = CloudStorageDirectUploadEntryTable();

  /// The storageId, typically `public` or `private`.
  String storageId;

  /// The path where the file is stored.
  String path;

  /// The expiration time of when the file can be uploaded.
  DateTime expiration;

  /// Access key for retrieving a private file.
  String authKey;

  @override
  String get tableName => 'serverpod_cloud_storage_direct_upload';
  CloudStorageDirectUploadEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
  });
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
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration,
      'authKey': authKey,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration,
      'authKey': authKey,
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

  static CloudStorageDirectUploadEntryInclude include() {
    return CloudStorageDirectUploadEntryInclude._();
  }
}

class _Undefined {}

class _CloudStorageDirectUploadEntryImpl extends CloudStorageDirectUploadEntry {
  _CloudStorageDirectUploadEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
  }) : super._(
          id: id,
          storageId: storageId,
          path: path,
          expiration: expiration,
          authKey: authKey,
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
      id: id is! int? ? this.id : id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      expiration: expiration ?? this.expiration,
      authKey: authKey ?? this.authKey,
    );
  }
}

typedef CloudStorageDirectUploadEntryExpressionBuilder = _i1.Expression
    Function(CloudStorageDirectUploadEntryTable);

class CloudStorageDirectUploadEntryTable extends _i1.Table {
  CloudStorageDirectUploadEntryTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_cloud_storage_direct_upload') {
    storageId = _i1.ColumnString(
      'storageId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    path = _i1.ColumnString(
      'path',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    expiration = _i1.ColumnDateTime(
      'expiration',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    authKey = _i1.ColumnString(
      'authKey',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The storageId, typically `public` or `private`.
  late final _i1.ColumnString storageId;

  /// The path where the file is stored.
  late final _i1.ColumnString path;

  /// The expiration time of when the file can be uploaded.
  late final _i1.ColumnDateTime expiration;

  /// Access key for retrieving a private file.
  late final _i1.ColumnString authKey;

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
    CloudStorageDirectUploadEntryTable();

class CloudStorageDirectUploadEntryInclude extends _i1.Include {
  CloudStorageDirectUploadEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => CloudStorageDirectUploadEntry.t;
}

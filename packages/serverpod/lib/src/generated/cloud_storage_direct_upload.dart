/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

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

  static const db = CloudStorageDirectUploadEntryRepository._();

  /// The storageId, typically `public` or `private`.
  String storageId;

  /// The path where the file is stored.
  String path;

  /// The expiration time of when the file can be uploaded.
  DateTime expiration;

  /// Access key for retrieving a private file.
  String authKey;

  @override
  _i1.Table get table => t;

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
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration,
      'authKey': authKey,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration,
      'authKey': authKey,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<CloudStorageDirectUploadEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<CloudStorageDirectUploadEntry?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
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

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<CloudStorageDirectUploadEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<CloudStorageDirectUploadEntry>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageDirectUploadEntry>(
      where: where(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
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

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
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

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
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

  static CloudStorageDirectUploadEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    CloudStorageDirectUploadEntryInclude? include,
  }) {
    return CloudStorageDirectUploadEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      include: include,
    );
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
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      expiration: expiration ?? this.expiration,
      authKey: authKey ?? this.authKey,
    );
  }
}

class CloudStorageDirectUploadEntryTable extends _i1.Table {
  CloudStorageDirectUploadEntryTable({super.tableRelation})
      : super(tableName: 'serverpod_cloud_storage_direct_upload') {
    storageId = _i1.ColumnString(
      'storageId',
      this,
    );
    path = _i1.ColumnString(
      'path',
      this,
    );
    expiration = _i1.ColumnDateTime(
      'expiration',
      this,
    );
    authKey = _i1.ColumnString(
      'authKey',
      this,
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

class CloudStorageDirectUploadEntryInclude extends _i1.IncludeObject {
  CloudStorageDirectUploadEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table get table => CloudStorageDirectUploadEntry.t;
}

class CloudStorageDirectUploadEntryIncludeList extends _i1.IncludeList {
  CloudStorageDirectUploadEntryIncludeList._({
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CloudStorageDirectUploadEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => CloudStorageDirectUploadEntry.t;
}

class CloudStorageDirectUploadEntryRepository {
  const CloudStorageDirectUploadEntryRepository._();

  Future<List<CloudStorageDirectUploadEntry>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<CloudStorageDirectUploadEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findFirstRow<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  Future<CloudStorageDirectUploadEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<CloudStorageDirectUploadEntry>(
      id,
      transaction: transaction,
    );
  }

  Future<List<CloudStorageDirectUploadEntry>> insert(
    _i1.Session session,
    List<CloudStorageDirectUploadEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<CloudStorageDirectUploadEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<CloudStorageDirectUploadEntry> insertRow(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<CloudStorageDirectUploadEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CloudStorageDirectUploadEntry>> update(
    _i1.Session session,
    List<CloudStorageDirectUploadEntry> rows, {
    _i1.ColumnSelections<CloudStorageDirectUploadEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<CloudStorageDirectUploadEntry>(
      rows,
      columns: columns?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  Future<CloudStorageDirectUploadEntry> updateRow(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.ColumnSelections<CloudStorageDirectUploadEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<CloudStorageDirectUploadEntry>(
      row,
      columns: columns?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<CloudStorageDirectUploadEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<CloudStorageDirectUploadEntry>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<CloudStorageDirectUploadEntry>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<CloudStorageDirectUploadEntry>(
      where: where(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

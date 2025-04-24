/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Connects a table for handling uploading of files.
abstract class CloudStorageDirectUploadEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CloudStorageDirectUploadEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
  });

  factory CloudStorageDirectUploadEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
  }) = _CloudStorageDirectUploadEntryImpl;

  factory CloudStorageDirectUploadEntry.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CloudStorageDirectUploadEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      expiration:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
      authKey: jsonSerialization['authKey'] as String,
    );
  }

  static final t = CloudStorageDirectUploadEntryTable();

  static const db = CloudStorageDirectUploadEntryRepository._();

  @override
  int? id;

  /// The storageId, typically `public` or `private`.
  String storageId;

  /// The path where the file is stored.
  String path;

  /// The expiration time of when the file can be uploaded.
  DateTime expiration;

  /// Access key for retrieving a private file.
  String authKey;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CloudStorageDirectUploadEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      'expiration': expiration.toJson(),
      'authKey': authKey,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
    };
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [CloudStorageDirectUploadEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

class CloudStorageDirectUploadEntryTable extends _i1.Table<int?> {
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

class CloudStorageDirectUploadEntryInclude extends _i1.IncludeObject {
  CloudStorageDirectUploadEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CloudStorageDirectUploadEntry.t;
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
  _i1.Table<int?> get table => CloudStorageDirectUploadEntry.t;
}

class CloudStorageDirectUploadEntryRepository {
  const CloudStorageDirectUploadEntryRepository._();

  /// Returns a list of [CloudStorageDirectUploadEntry]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
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
    return session.db.find<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CloudStorageDirectUploadEntry] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<CloudStorageDirectUploadEntry?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CloudStorageDirectUploadEntry] by its [id] or null if no such row exists.
  Future<CloudStorageDirectUploadEntry?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CloudStorageDirectUploadEntry>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CloudStorageDirectUploadEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [CloudStorageDirectUploadEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CloudStorageDirectUploadEntry>> insert(
    _i1.Session session,
    List<CloudStorageDirectUploadEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CloudStorageDirectUploadEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CloudStorageDirectUploadEntry] and returns the inserted row.
  ///
  /// The returned [CloudStorageDirectUploadEntry] will have its `id` field set.
  Future<CloudStorageDirectUploadEntry> insertRow(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CloudStorageDirectUploadEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CloudStorageDirectUploadEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CloudStorageDirectUploadEntry>> update(
    _i1.Session session,
    List<CloudStorageDirectUploadEntry> rows, {
    _i1.ColumnSelections<CloudStorageDirectUploadEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CloudStorageDirectUploadEntry>(
      rows,
      columns: columns?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CloudStorageDirectUploadEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CloudStorageDirectUploadEntry> updateRow(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.ColumnSelections<CloudStorageDirectUploadEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CloudStorageDirectUploadEntry>(
      row,
      columns: columns?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CloudStorageDirectUploadEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CloudStorageDirectUploadEntry>> delete(
    _i1.Session session,
    List<CloudStorageDirectUploadEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CloudStorageDirectUploadEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CloudStorageDirectUploadEntry].
  Future<CloudStorageDirectUploadEntry> deleteRow(
    _i1.Session session,
    CloudStorageDirectUploadEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CloudStorageDirectUploadEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CloudStorageDirectUploadEntry>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CloudStorageDirectUploadEntry>(
      where: where(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

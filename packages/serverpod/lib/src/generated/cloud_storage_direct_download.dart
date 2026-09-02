/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// Grants temporary download access to a database-backed stored file.
abstract class CloudStorageDirectDownloadEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CloudStorageDirectDownloadEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.expiration,
    required this.authKey,
    this.downloadFileName,
    this.contentType,
  });

  factory CloudStorageDirectDownloadEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
    String? downloadFileName,
    String? contentType,
  }) = _CloudStorageDirectDownloadEntryImpl;

  factory CloudStorageDirectDownloadEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CloudStorageDirectDownloadEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      expiration: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiration'],
      ),
      authKey: jsonSerialization['authKey'] as String,
      downloadFileName: jsonSerialization['downloadFileName'] as String?,
      contentType: jsonSerialization['contentType'] as String?,
    );
  }

  static final t = CloudStorageDirectDownloadEntryTable();

  static const db = CloudStorageDirectDownloadEntryRepository._();

  @override
  int? id;

  /// The storage containing the file.
  String storageId;

  /// The path of the file.
  String path;

  /// The expiration time of the temporary URL.
  DateTime expiration;

  /// Opaque access key carried by the temporary URL.
  String authKey;

  /// Optional filename presented to the downloader.
  String? downloadFileName;

  /// Optional response MIME type override.
  String? contentType;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CloudStorageDirectDownloadEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CloudStorageDirectDownloadEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
    String? downloadFileName,
    String? contentType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CloudStorageDirectDownloadEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
      if (downloadFileName != null) 'downloadFileName': downloadFileName,
      if (contentType != null) 'contentType': contentType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.CloudStorageDirectDownloadEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
      if (downloadFileName != null) 'downloadFileName': downloadFileName,
      if (contentType != null) 'contentType': contentType,
    };
  }

  static CloudStorageDirectDownloadEntryInclude include() {
    return CloudStorageDirectDownloadEntryInclude._();
  }

  static CloudStorageDirectDownloadEntryIncludeList includeList({
    _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectDownloadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectDownloadEntryTable>? orderByList,
    CloudStorageDirectDownloadEntryInclude? include,
  }) {
    return CloudStorageDirectDownloadEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageDirectDownloadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectDownloadEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CloudStorageDirectDownloadEntryImpl
    extends CloudStorageDirectDownloadEntry {
  _CloudStorageDirectDownloadEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime expiration,
    required String authKey,
    String? downloadFileName,
    String? contentType,
  }) : super._(
         id: id,
         storageId: storageId,
         path: path,
         expiration: expiration,
         authKey: authKey,
         downloadFileName: downloadFileName,
         contentType: contentType,
       );

  /// Returns a shallow copy of this [CloudStorageDirectDownloadEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CloudStorageDirectDownloadEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? expiration,
    String? authKey,
    Object? downloadFileName = _Undefined,
    Object? contentType = _Undefined,
  }) {
    return CloudStorageDirectDownloadEntry(
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      expiration: expiration ?? this.expiration,
      authKey: authKey ?? this.authKey,
      downloadFileName: downloadFileName is String?
          ? downloadFileName
          : this.downloadFileName,
      contentType: contentType is String? ? contentType : this.contentType,
    );
  }
}

class CloudStorageDirectDownloadEntryUpdateTable
    extends _is.UpdateTable<CloudStorageDirectDownloadEntryTable> {
  CloudStorageDirectDownloadEntryUpdateTable(super.table);

  _is.ColumnValue<String, String> storageId(String value) => _is.ColumnValue(
    table.storageId,
    value,
  );

  _is.ColumnValue<String, String> path(String value) => _is.ColumnValue(
    table.path,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiration(DateTime value) =>
      _is.ColumnValue(
        table.expiration,
        value,
      );

  _is.ColumnValue<String, String> authKey(String value) => _is.ColumnValue(
    table.authKey,
    value,
  );

  _is.ColumnValue<String, String> downloadFileName(String? value) =>
      _is.ColumnValue(
        table.downloadFileName,
        value,
      );

  _is.ColumnValue<String, String> contentType(String? value) => _is.ColumnValue(
    table.contentType,
    value,
  );
}

class CloudStorageDirectDownloadEntryTable extends _is.Table<int?> {
  CloudStorageDirectDownloadEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_cloud_storage_direct_download') {
    updateTable = CloudStorageDirectDownloadEntryUpdateTable(this);
    storageId = _is.ColumnString(
      'storageId',
      this,
    );
    path = _is.ColumnString(
      'path',
      this,
    );
    expiration = _is.ColumnDateTime(
      'expiration',
      this,
    );
    authKey = _is.ColumnString(
      'authKey',
      this,
    );
    downloadFileName = _is.ColumnString(
      'downloadFileName',
      this,
    );
    contentType = _is.ColumnString(
      'contentType',
      this,
    );
  }

  late final CloudStorageDirectDownloadEntryUpdateTable updateTable;

  /// The storage containing the file.
  late final _is.ColumnString storageId;

  /// The path of the file.
  late final _is.ColumnString path;

  /// The expiration time of the temporary URL.
  late final _is.ColumnDateTime expiration;

  /// Opaque access key carried by the temporary URL.
  late final _is.ColumnString authKey;

  /// Optional filename presented to the downloader.
  late final _is.ColumnString downloadFileName;

  /// Optional response MIME type override.
  late final _is.ColumnString contentType;

  @override
  List<_is.Column> get columns => [
    id,
    storageId,
    path,
    expiration,
    authKey,
    downloadFileName,
    contentType,
  ];
}

class CloudStorageDirectDownloadEntryInclude extends _is.IncludeObject {
  CloudStorageDirectDownloadEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CloudStorageDirectDownloadEntry.t;
}

class CloudStorageDirectDownloadEntryIncludeList extends _is.IncludeList {
  CloudStorageDirectDownloadEntryIncludeList._({
    _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CloudStorageDirectDownloadEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CloudStorageDirectDownloadEntry.t;
}

class CloudStorageDirectDownloadEntryRepository {
  const CloudStorageDirectDownloadEntryRepository._();

  /// Returns a list of [CloudStorageDirectDownloadEntry]s matching the given query parameters.
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
  Future<List<CloudStorageDirectDownloadEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectDownloadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectDownloadEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CloudStorageDirectDownloadEntry>(
      where: where?.call(CloudStorageDirectDownloadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectDownloadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectDownloadEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CloudStorageDirectDownloadEntry] matching the given query parameters.
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
  Future<CloudStorageDirectDownloadEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectDownloadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectDownloadEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CloudStorageDirectDownloadEntry>(
      where: where?.call(CloudStorageDirectDownloadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectDownloadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectDownloadEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CloudStorageDirectDownloadEntry] by its [id] or null if no such row exists.
  Future<CloudStorageDirectDownloadEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CloudStorageDirectDownloadEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CloudStorageDirectDownloadEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [CloudStorageDirectDownloadEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectDownloadEntry>> insert(
    _is.DatabaseSession session,
    List<CloudStorageDirectDownloadEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CloudStorageDirectDownloadEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CloudStorageDirectDownloadEntry] and returns the inserted row.
  ///
  /// The returned [CloudStorageDirectDownloadEntry] will have its `id` field set.
  Future<CloudStorageDirectDownloadEntry> insertRow(
    _is.DatabaseSession session,
    CloudStorageDirectDownloadEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CloudStorageDirectDownloadEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CloudStorageDirectDownloadEntry]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [CloudStorageDirectDownloadEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectDownloadEntry>> upsert(
    _is.DatabaseSession session,
    List<CloudStorageDirectDownloadEntry> rows, {
    required _is.ColumnSelections<CloudStorageDirectDownloadEntryTable>
    conflictColumns,
    _is.ColumnSelections<CloudStorageDirectDownloadEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CloudStorageDirectDownloadEntry>(
      rows,
      conflictColumns: conflictColumns(CloudStorageDirectDownloadEntry.t),
      updateColumns: updateColumns?.call(CloudStorageDirectDownloadEntry.t),
      updateWhere: updateWhere?.call(CloudStorageDirectDownloadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CloudStorageDirectDownloadEntry] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [CloudStorageDirectDownloadEntry] will have its `id` field set.
  Future<CloudStorageDirectDownloadEntry?> upsertRow(
    _is.DatabaseSession session,
    CloudStorageDirectDownloadEntry row, {
    required _is.ColumnSelections<CloudStorageDirectDownloadEntryTable>
    conflictColumns,
    _is.ColumnSelections<CloudStorageDirectDownloadEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CloudStorageDirectDownloadEntry>(
      row,
      conflictColumns: conflictColumns(CloudStorageDirectDownloadEntry.t),
      updateColumns: updateColumns?.call(CloudStorageDirectDownloadEntry.t),
      updateWhere: updateWhere?.call(CloudStorageDirectDownloadEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [CloudStorageDirectDownloadEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectDownloadEntry>> update(
    _is.DatabaseSession session,
    List<CloudStorageDirectDownloadEntry> rows, {
    _is.ColumnSelections<CloudStorageDirectDownloadEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CloudStorageDirectDownloadEntry>(
      rows,
      columns: columns?.call(CloudStorageDirectDownloadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CloudStorageDirectDownloadEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CloudStorageDirectDownloadEntry> updateRow(
    _is.DatabaseSession session,
    CloudStorageDirectDownloadEntry row, {
    _is.ColumnSelections<CloudStorageDirectDownloadEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CloudStorageDirectDownloadEntry>(
      row,
      columns: columns?.call(CloudStorageDirectDownloadEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CloudStorageDirectDownloadEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CloudStorageDirectDownloadEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      CloudStorageDirectDownloadEntryUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CloudStorageDirectDownloadEntry>(
      id,
      columnValues: columnValues(CloudStorageDirectDownloadEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CloudStorageDirectDownloadEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectDownloadEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      CloudStorageDirectDownloadEntryUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectDownloadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectDownloadEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CloudStorageDirectDownloadEntry>(
      columnValues: columnValues(CloudStorageDirectDownloadEntry.t.updateTable),
      where: where(CloudStorageDirectDownloadEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageDirectDownloadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectDownloadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CloudStorageDirectDownloadEntry]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectDownloadEntry>> delete(
    _is.DatabaseSession session,
    List<CloudStorageDirectDownloadEntry> rows, {
    _is.OrderByBuilder<CloudStorageDirectDownloadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectDownloadEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CloudStorageDirectDownloadEntry>(
      rows,
      orderBy: orderBy?.call(CloudStorageDirectDownloadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectDownloadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CloudStorageDirectDownloadEntry].
  Future<CloudStorageDirectDownloadEntry> deleteRow(
    _is.DatabaseSession session,
    CloudStorageDirectDownloadEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CloudStorageDirectDownloadEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectDownloadEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>
    where,
    _is.OrderByBuilder<CloudStorageDirectDownloadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectDownloadEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CloudStorageDirectDownloadEntry>(
      where: where(CloudStorageDirectDownloadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectDownloadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectDownloadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageDirectDownloadEntry>(
      where: where?.call(CloudStorageDirectDownloadEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CloudStorageDirectDownloadEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CloudStorageDirectDownloadEntryTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CloudStorageDirectDownloadEntry>(
      where: where(CloudStorageDirectDownloadEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

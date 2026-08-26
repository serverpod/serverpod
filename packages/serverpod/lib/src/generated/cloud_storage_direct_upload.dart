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

/// Connects a table for handling uploading of files.
abstract class CloudStorageDirectUploadEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    Map<String, dynamic> jsonSerialization,
  ) {
    return CloudStorageDirectUploadEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      expiration: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['expiration'],
      ),
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
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CloudStorageDirectUploadEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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
      '__className__': 'serverpod.CloudStorageDirectUploadEntry',
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
      '__className__': 'serverpod.CloudStorageDirectUploadEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'expiration': expiration.toJson(),
      'authKey': authKey,
    };
  }

  /// Builds a complete [CloudStorageDirectUploadEntryInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CloudStorageDirectUploadEntryInclude include() {
    return CloudStorageDirectUploadEntryInclude._();
  }

  /// Builds a complete [CloudStorageDirectUploadEntryIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CloudStorageDirectUploadEntryIncludeList includeList({
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    CloudStorageDirectUploadEntryInclude? include,
  }) {
    return CloudStorageDirectUploadEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [CloudStorageDirectUploadEntryJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static CloudStorageDirectUploadEntryJsonInclude includeJson({
    _is.SelectColumnsBuilder<CloudStorageDirectUploadEntryTable>? select,
  }) {
    return _CloudStorageDirectUploadEntryJsonInclude._(
      selectedColumns: select?.call(CloudStorageDirectUploadEntry.t),
    );
  }

  /// Builds a JSON-compatible [CloudStorageDirectUploadEntryJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static CloudStorageDirectUploadEntryJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    CloudStorageDirectUploadEntryJsonInclude? include,
    _is.SelectColumnsBuilder<CloudStorageDirectUploadEntryTable>? select,
  }) {
    return _CloudStorageDirectUploadEntryJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      include: include,
      selectedColumns: select?.call(CloudStorageDirectUploadEntry.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class CloudStorageDirectUploadEntryUpdateTable
    extends _is.UpdateTable<CloudStorageDirectUploadEntryTable> {
  CloudStorageDirectUploadEntryUpdateTable(super.table);

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
}

class CloudStorageDirectUploadEntryTable extends _is.Table<int?> {
  CloudStorageDirectUploadEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_cloud_storage_direct_upload') {
    updateTable = CloudStorageDirectUploadEntryUpdateTable(this);
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
  }

  late final CloudStorageDirectUploadEntryUpdateTable updateTable;

  /// The storageId, typically `public` or `private`.
  late final _is.ColumnString storageId;

  /// The path where the file is stored.
  late final _is.ColumnString path;

  /// The expiration time of when the file can be uploaded.
  late final _is.ColumnDateTime expiration;

  /// Access key for retrieving a private file.
  late final _is.ColumnString authKey;

  @override
  List<_is.Column> get columns => [
    id,
    storageId,
    path,
    expiration,
    authKey,
  ];
}

abstract interface class CloudStorageDirectUploadEntryJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class CloudStorageDirectUploadEntryJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class CloudStorageDirectUploadEntryInclude extends _is.IncludeObject
    implements CloudStorageDirectUploadEntryJsonInclude, _is.FullModelInclude {
  CloudStorageDirectUploadEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CloudStorageDirectUploadEntry.t;
}

final class CloudStorageDirectUploadEntryIncludeList extends _is.IncludeList
    implements
        CloudStorageDirectUploadEntryJsonIncludeList,
        _is.FullModelInclude {
  CloudStorageDirectUploadEntryIncludeList._({
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CloudStorageDirectUploadEntryInclude? super.include,
  }) {
    super.where = where?.call(CloudStorageDirectUploadEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CloudStorageDirectUploadEntry.t;
}

final class _CloudStorageDirectUploadEntryJsonInclude extends _is.IncludeObject
    implements CloudStorageDirectUploadEntryJsonInclude {
  _CloudStorageDirectUploadEntryJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CloudStorageDirectUploadEntry.t;
}

final class _CloudStorageDirectUploadEntryJsonIncludeList
    extends _is.IncludeList
    implements CloudStorageDirectUploadEntryJsonIncludeList {
  _CloudStorageDirectUploadEntryJsonIncludeList._({
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CloudStorageDirectUploadEntryJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(CloudStorageDirectUploadEntry.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CloudStorageDirectUploadEntry.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CloudStorageDirectUploadEntry] by its [id] or null if no such row exists.
  Future<CloudStorageDirectUploadEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CloudStorageDirectUploadEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `selectedColumns` will take precedence.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<CloudStorageDirectUploadEntryTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(CloudStorageDirectUploadEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `selectedColumns` will take precedence.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<CloudStorageDirectUploadEntryTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(CloudStorageDirectUploadEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `selectedColumns` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<CloudStorageDirectUploadEntryTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<CloudStorageDirectUploadEntry>(
      id,
      transaction: transaction,
      select: select?.call(CloudStorageDirectUploadEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CloudStorageDirectUploadEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [CloudStorageDirectUploadEntry]s will have their `id` fields set.
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
  Future<List<CloudStorageDirectUploadEntry>> insert(
    _is.DatabaseSession session,
    List<CloudStorageDirectUploadEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CloudStorageDirectUploadEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CloudStorageDirectUploadEntry] and returns the inserted row.
  ///
  /// The returned [CloudStorageDirectUploadEntry] will have its `id` field set.
  Future<CloudStorageDirectUploadEntry> insertRow(
    _is.DatabaseSession session,
    CloudStorageDirectUploadEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CloudStorageDirectUploadEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CloudStorageDirectUploadEntry]s in the list and returns the resulting rows.
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
  /// The returned [CloudStorageDirectUploadEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectUploadEntry>> upsert(
    _is.DatabaseSession session,
    List<CloudStorageDirectUploadEntry> rows, {
    required _is.ColumnSelections<CloudStorageDirectUploadEntryTable>
    conflictColumns,
    _is.ColumnSelections<CloudStorageDirectUploadEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CloudStorageDirectUploadEntry>(
      rows,
      conflictColumns: conflictColumns(CloudStorageDirectUploadEntry.t),
      updateColumns: updateColumns?.call(CloudStorageDirectUploadEntry.t),
      updateWhere: updateWhere?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CloudStorageDirectUploadEntry] and returns the resulting row.
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
  /// The returned [CloudStorageDirectUploadEntry] will have its `id` field set.
  Future<CloudStorageDirectUploadEntry?> upsertRow(
    _is.DatabaseSession session,
    CloudStorageDirectUploadEntry row, {
    required _is.ColumnSelections<CloudStorageDirectUploadEntryTable>
    conflictColumns,
    _is.ColumnSelections<CloudStorageDirectUploadEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CloudStorageDirectUploadEntry>(
      row,
      conflictColumns: conflictColumns(CloudStorageDirectUploadEntry.t),
      updateColumns: updateColumns?.call(CloudStorageDirectUploadEntry.t),
      updateWhere: updateWhere?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [CloudStorageDirectUploadEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectUploadEntry>> update(
    _is.DatabaseSession session,
    List<CloudStorageDirectUploadEntry> rows, {
    _is.ColumnSelections<CloudStorageDirectUploadEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CloudStorageDirectUploadEntry>(
      rows,
      columns: columns?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CloudStorageDirectUploadEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CloudStorageDirectUploadEntry> updateRow(
    _is.DatabaseSession session,
    CloudStorageDirectUploadEntry row, {
    _is.ColumnSelections<CloudStorageDirectUploadEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CloudStorageDirectUploadEntry>(
      row,
      columns: columns?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CloudStorageDirectUploadEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CloudStorageDirectUploadEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      CloudStorageDirectUploadEntryUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CloudStorageDirectUploadEntry>(
      id,
      columnValues: columnValues(CloudStorageDirectUploadEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CloudStorageDirectUploadEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageDirectUploadEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      CloudStorageDirectUploadEntryUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CloudStorageDirectUploadEntry>(
      columnValues: columnValues(CloudStorageDirectUploadEntry.t.updateTable),
      where: where(CloudStorageDirectUploadEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CloudStorageDirectUploadEntry]s in the list and returns the deleted rows.
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
  Future<List<CloudStorageDirectUploadEntry>> delete(
    _is.DatabaseSession session,
    List<CloudStorageDirectUploadEntry> rows, {
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CloudStorageDirectUploadEntry>(
      rows,
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CloudStorageDirectUploadEntry].
  Future<CloudStorageDirectUploadEntry> deleteRow(
    _is.DatabaseSession session,
    CloudStorageDirectUploadEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CloudStorageDirectUploadEntry>(
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
  Future<List<CloudStorageDirectUploadEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>
    where,
    _is.OrderByBuilder<CloudStorageDirectUploadEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageDirectUploadEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CloudStorageDirectUploadEntry>(
      where: where(CloudStorageDirectUploadEntry.t),
      orderBy: orderBy?.call(CloudStorageDirectUploadEntry.t),
      orderByList: orderByList?.call(CloudStorageDirectUploadEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageDirectUploadEntry>(
      where: where?.call(CloudStorageDirectUploadEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CloudStorageDirectUploadEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CloudStorageDirectUploadEntryTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CloudStorageDirectUploadEntry>(
      where: where(CloudStorageDirectUploadEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

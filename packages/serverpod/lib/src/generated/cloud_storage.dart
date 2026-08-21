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
import 'dart:typed_data' as _idt;
import 'package:serverpod/serverpod.dart' as _is;

/// An entry in the database for an uploaded file.
abstract class CloudStorageEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CloudStorageEntry._({
    this.id,
    required this.storageId,
    required this.path,
    required this.addedTime,
    this.expiration,
    required this.byteData,
    required this.verified,
  });

  factory CloudStorageEntry({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _idt.ByteData byteData,
    required bool verified,
  }) = _CloudStorageEntryImpl;

  factory CloudStorageEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return CloudStorageEntry(
      id: jsonSerialization['id'] as int?,
      storageId: jsonSerialization['storageId'] as String,
      path: jsonSerialization['path'] as String,
      addedTime: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['addedTime'],
      ),
      expiration: jsonSerialization['expiration'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['expiration']),
      byteData: _is.ByteDataJsonExtension.fromJson(
        jsonSerialization['byteData'],
      ),
      verified: _is.BoolJsonExtension.fromJson(jsonSerialization['verified']),
    );
  }

  static final t = CloudStorageEntryTable();

  static const db = CloudStorageEntryRepository._();

  @override
  int? id;

  /// The storageId, typically `public` or `private`.
  String storageId;

  /// The path where the file is stored.
  String path;

  /// The time when the file was added.
  DateTime addedTime;

  /// The time at which the file expires and can be deleted.
  DateTime? expiration;

  /// The actual data of the uploaded file.
  _idt.ByteData byteData;

  /// True if the file has been verified as uploaded.
  bool verified;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CloudStorageEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CloudStorageEntry copyWith({
    int? id,
    String? storageId,
    String? path,
    DateTime? addedTime,
    DateTime? expiration,
    _idt.ByteData? byteData,
    bool? verified,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.CloudStorageEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toJson(),
      if (expiration != null) 'expiration': expiration?.toJson(),
      'byteData': byteData.toJson(),
      'verified': verified,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.CloudStorageEntry',
      if (id != null) 'id': id,
      'storageId': storageId,
      'path': path,
      'addedTime': addedTime.toJson(),
      if (expiration != null) 'expiration': expiration?.toJson(),
      'byteData': byteData.toJson(),
      'verified': verified,
    };
  }

  static CloudStorageEntryInclude include() {
    return CloudStorageEntryInclude._();
  }

  static CloudStorageEntryIncludeList includeList({
    _is.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    CloudStorageEntryInclude? include,
  }) {
    return CloudStorageEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CloudStorageEntryImpl extends CloudStorageEntry {
  _CloudStorageEntryImpl({
    int? id,
    required String storageId,
    required String path,
    required DateTime addedTime,
    DateTime? expiration,
    required _idt.ByteData byteData,
    required bool verified,
  }) : super._(
         id: id,
         storageId: storageId,
         path: path,
         addedTime: addedTime,
         expiration: expiration,
         byteData: byteData,
         verified: verified,
       );

  /// Returns a shallow copy of this [CloudStorageEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CloudStorageEntry copyWith({
    Object? id = _Undefined,
    String? storageId,
    String? path,
    DateTime? addedTime,
    Object? expiration = _Undefined,
    _idt.ByteData? byteData,
    bool? verified,
  }) {
    return CloudStorageEntry(
      id: id is int? ? id : this.id,
      storageId: storageId ?? this.storageId,
      path: path ?? this.path,
      addedTime: addedTime ?? this.addedTime,
      expiration: expiration is DateTime? ? expiration : this.expiration,
      byteData: byteData ?? this.byteData.clone(),
      verified: verified ?? this.verified,
    );
  }
}

class CloudStorageEntryUpdateTable
    extends _is.UpdateTable<CloudStorageEntryTable> {
  CloudStorageEntryUpdateTable(super.table);

  _is.ColumnValue<String, String> storageId(String value) => _is.ColumnValue(
    table.storageId,
    value,
  );

  _is.ColumnValue<String, String> path(String value) => _is.ColumnValue(
    table.path,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> addedTime(DateTime value) =>
      _is.ColumnValue(
        table.addedTime,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> expiration(DateTime? value) =>
      _is.ColumnValue(
        table.expiration,
        value,
      );

  _is.ColumnValue<_idt.ByteData, _idt.ByteData> byteData(_idt.ByteData value) =>
      _is.ColumnValue(
        table.byteData,
        value,
      );

  _is.ColumnValue<bool, bool> verified(bool value) => _is.ColumnValue(
    table.verified,
    value,
  );
}

class CloudStorageEntryTable extends _is.Table<int?> {
  CloudStorageEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_cloud_storage') {
    updateTable = CloudStorageEntryUpdateTable(this);
    storageId = _is.ColumnString(
      'storageId',
      this,
    );
    path = _is.ColumnString(
      'path',
      this,
    );
    addedTime = _is.ColumnDateTime(
      'addedTime',
      this,
    );
    expiration = _is.ColumnDateTime(
      'expiration',
      this,
    );
    byteData = _is.ColumnByteData(
      'byteData',
      this,
    );
    verified = _is.ColumnBool(
      'verified',
      this,
    );
  }

  late final CloudStorageEntryUpdateTable updateTable;

  /// The storageId, typically `public` or `private`.
  late final _is.ColumnString storageId;

  /// The path where the file is stored.
  late final _is.ColumnString path;

  /// The time when the file was added.
  late final _is.ColumnDateTime addedTime;

  /// The time at which the file expires and can be deleted.
  late final _is.ColumnDateTime expiration;

  /// The actual data of the uploaded file.
  late final _is.ColumnByteData byteData;

  /// True if the file has been verified as uploaded.
  late final _is.ColumnBool verified;

  @override
  List<_is.Column> get columns => [
    id,
    storageId,
    path,
    addedTime,
    expiration,
    byteData,
    verified,
  ];
}

class CloudStorageEntryInclude extends _is.IncludeObject {
  CloudStorageEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CloudStorageEntry.t;
}

class CloudStorageEntryIncludeList extends _is.IncludeList {
  CloudStorageEntryIncludeList._({
    _is.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CloudStorageEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CloudStorageEntry.t;
}

class CloudStorageEntryRepository {
  const CloudStorageEntryRepository._();

  /// Returns a list of [CloudStorageEntry]s matching the given query parameters.
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
  Future<List<CloudStorageEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CloudStorageEntry>(
      where: where?.call(CloudStorageEntry.t),
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CloudStorageEntry] matching the given query parameters.
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
  Future<CloudStorageEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CloudStorageEntry>(
      where: where?.call(CloudStorageEntry.t),
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CloudStorageEntry] by its [id] or null if no such row exists.
  Future<CloudStorageEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CloudStorageEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CloudStorageEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [CloudStorageEntry]s will have their `id` fields set.
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
  Future<List<CloudStorageEntry>> insert(
    _is.DatabaseSession session,
    List<CloudStorageEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CloudStorageEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CloudStorageEntry] and returns the inserted row.
  ///
  /// The returned [CloudStorageEntry] will have its `id` field set.
  Future<CloudStorageEntry> insertRow(
    _is.DatabaseSession session,
    CloudStorageEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CloudStorageEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CloudStorageEntry]s in the list and returns the resulting rows.
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
  /// The returned [CloudStorageEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageEntry>> upsert(
    _is.DatabaseSession session,
    List<CloudStorageEntry> rows, {
    required _is.ColumnSelections<CloudStorageEntryTable> conflictColumns,
    _is.ColumnSelections<CloudStorageEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<CloudStorageEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CloudStorageEntry>(
      rows,
      conflictColumns: conflictColumns(CloudStorageEntry.t),
      updateColumns: updateColumns?.call(CloudStorageEntry.t),
      updateWhere: updateWhere?.call(CloudStorageEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CloudStorageEntry] and returns the resulting row.
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
  /// The returned [CloudStorageEntry] will have its `id` field set.
  Future<CloudStorageEntry?> upsertRow(
    _is.DatabaseSession session,
    CloudStorageEntry row, {
    required _is.ColumnSelections<CloudStorageEntryTable> conflictColumns,
    _is.ColumnSelections<CloudStorageEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<CloudStorageEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CloudStorageEntry>(
      row,
      conflictColumns: conflictColumns(CloudStorageEntry.t),
      updateColumns: updateColumns?.call(CloudStorageEntry.t),
      updateWhere: updateWhere?.call(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [CloudStorageEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageEntry>> update(
    _is.DatabaseSession session,
    List<CloudStorageEntry> rows, {
    _is.ColumnSelections<CloudStorageEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CloudStorageEntry>(
      rows,
      columns: columns?.call(CloudStorageEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CloudStorageEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CloudStorageEntry> updateRow(
    _is.DatabaseSession session,
    CloudStorageEntry row, {
    _is.ColumnSelections<CloudStorageEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CloudStorageEntry>(
      row,
      columns: columns?.call(CloudStorageEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CloudStorageEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CloudStorageEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CloudStorageEntryUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CloudStorageEntry>(
      id,
      columnValues: columnValues(CloudStorageEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CloudStorageEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CloudStorageEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CloudStorageEntryUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CloudStorageEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CloudStorageEntry>(
      columnValues: columnValues(CloudStorageEntry.t.updateTable),
      where: where(CloudStorageEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CloudStorageEntry]s in the list and returns the deleted rows.
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
  Future<List<CloudStorageEntry>> delete(
    _is.DatabaseSession session,
    List<CloudStorageEntry> rows, {
    _is.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CloudStorageEntry>(
      rows,
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CloudStorageEntry].
  Future<CloudStorageEntry> deleteRow(
    _is.DatabaseSession session,
    CloudStorageEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CloudStorageEntry>(
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
  Future<List<CloudStorageEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CloudStorageEntryTable> where,
    _is.OrderByBuilder<CloudStorageEntryTable>? orderBy,
    _is.OrderByListBuilder<CloudStorageEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CloudStorageEntry>(
      where: where(CloudStorageEntry.t),
      orderBy: orderBy?.call(CloudStorageEntry.t),
      orderByList: orderByList?.call(CloudStorageEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CloudStorageEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CloudStorageEntry>(
      where: where?.call(CloudStorageEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CloudStorageEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CloudStorageEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CloudStorageEntry>(
      where: where(CloudStorageEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

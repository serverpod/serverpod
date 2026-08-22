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
import 'package:serverpod_database/serverpod_database.dart' as _isd;

/// Represents a version of a database migration with a table.
abstract class DatabaseMigrationVersion
    extends _isd.DatabaseMigrationVersionModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DatabaseMigrationVersion._({
    this.id,
    required super.module,
    required super.version,
    super.timestamp,
  });

  factory DatabaseMigrationVersion({
    int? id,
    required String module,
    required String version,
    DateTime? timestamp,
  }) = _DatabaseMigrationVersionImpl;

  factory DatabaseMigrationVersion.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DatabaseMigrationVersion(
      id: jsonSerialization['id'] as int?,
      module: jsonSerialization['module'] as String,
      version: jsonSerialization['version'] as String,
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  static final t = DatabaseMigrationVersionTable();

  static const db = DatabaseMigrationVersionRepository._();

  @override
  int? id;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DatabaseMigrationVersion]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  DatabaseMigrationVersion copyWith({
    int? id,
    String? module,
    String? version,
    Object? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.DatabaseMigrationVersion',
      if (id != null) 'id': id,
      'module': module,
      'version': version,
      if (timestamp != null) 'timestamp': timestamp?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.DatabaseMigrationVersion',
      if (id != null) 'id': id,
      'module': module,
      'version': version,
      if (timestamp != null) 'timestamp': timestamp?.toJson(),
    };
  }

  static DatabaseMigrationVersionInclude include() {
    return DatabaseMigrationVersionInclude.internal_();
  }

  static DatabaseMigrationVersionIncludeList includeList({
    _is.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    _is.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    DatabaseMigrationVersionInclude? include,
  }) {
    return DatabaseMigrationVersionIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DatabaseMigrationVersionImpl extends DatabaseMigrationVersion {
  _DatabaseMigrationVersionImpl({
    int? id,
    required String module,
    required String version,
    DateTime? timestamp,
  }) : super._(
         id: id,
         module: module,
         version: version,
         timestamp: timestamp,
       );

  /// Returns a shallow copy of this [DatabaseMigrationVersion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DatabaseMigrationVersion copyWith({
    Object? id = _Undefined,
    String? module,
    String? version,
    Object? timestamp = _Undefined,
  }) {
    return DatabaseMigrationVersion(
      id: id is int? ? id : this.id,
      module: module ?? this.module,
      version: version ?? this.version,
      timestamp: timestamp is DateTime? ? timestamp : this.timestamp,
    );
  }
}

class DatabaseMigrationVersionUpdateTable
    extends _is.UpdateTable<DatabaseMigrationVersionTable> {
  DatabaseMigrationVersionUpdateTable(super.table);

  _is.ColumnValue<String, String> module(String value) => _is.ColumnValue(
    table.module,
    value,
  );

  _is.ColumnValue<String, String> version(String value) => _is.ColumnValue(
    table.version,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> timestamp(DateTime? value) =>
      _is.ColumnValue(
        table.timestamp,
        value,
      );
}

class DatabaseMigrationVersionTable extends _is.Table<int?> {
  DatabaseMigrationVersionTable({super.tableRelation})
    : super(tableName: 'serverpod_migrations') {
    updateTable = DatabaseMigrationVersionUpdateTable(this);
    module = _is.ColumnString(
      'module',
      this,
    );
    version = _is.ColumnString(
      'version',
      this,
    );
    timestamp = _is.ColumnDateTime(
      'timestamp',
      this,
    );
  }

  late final DatabaseMigrationVersionUpdateTable updateTable;

  /// The module the migration belongs to.
  late final _is.ColumnString module;

  /// The version of the migration.
  late final _is.ColumnString version;

  /// The timestamp of the migration. Only set if the migration is applied.
  late final _is.ColumnDateTime timestamp;

  @override
  List<_is.Column> get columns => [
    id,
    module,
    version,
    timestamp,
  ];
}

class DatabaseMigrationVersionInclude extends _is.IncludeObject {
  DatabaseMigrationVersionInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DatabaseMigrationVersion.t;
}

class DatabaseMigrationVersionIncludeList extends _is.IncludeList {
  DatabaseMigrationVersionIncludeList.internal_({
    _is.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(DatabaseMigrationVersion.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DatabaseMigrationVersion.t;
}

class DatabaseMigrationVersionRepository {
  const DatabaseMigrationVersionRepository._();

  /// Returns a list of [DatabaseMigrationVersion]s matching the given query parameters.
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
  Future<List<DatabaseMigrationVersion>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    _is.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DatabaseMigrationVersion] matching the given query parameters.
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
  Future<DatabaseMigrationVersion?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? offset,
    _is.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    _is.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DatabaseMigrationVersion] by its [id] or null if no such row exists.
  Future<DatabaseMigrationVersion?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DatabaseMigrationVersion>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DatabaseMigrationVersion]s in the list and returns the inserted rows.
  ///
  /// The returned [DatabaseMigrationVersion]s will have their `id` fields set.
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
  Future<List<DatabaseMigrationVersion>> insert(
    _is.DatabaseSession session,
    List<DatabaseMigrationVersion> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DatabaseMigrationVersion>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DatabaseMigrationVersion] and returns the inserted row.
  ///
  /// The returned [DatabaseMigrationVersion] will have its `id` field set.
  Future<DatabaseMigrationVersion> insertRow(
    _is.DatabaseSession session,
    DatabaseMigrationVersion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DatabaseMigrationVersion>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DatabaseMigrationVersion]s in the list and returns the resulting rows.
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
  /// The returned [DatabaseMigrationVersion]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DatabaseMigrationVersion>> upsert(
    _is.DatabaseSession session,
    List<DatabaseMigrationVersion> rows, {
    required _is.ColumnSelections<DatabaseMigrationVersionTable>
    conflictColumns,
    _is.ColumnSelections<DatabaseMigrationVersionTable>? updateColumns,
    _is.WhereExpressionBuilder<DatabaseMigrationVersionTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DatabaseMigrationVersion>(
      rows,
      conflictColumns: conflictColumns(DatabaseMigrationVersion.t),
      updateColumns: updateColumns?.call(DatabaseMigrationVersion.t),
      updateWhere: updateWhere?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DatabaseMigrationVersion] and returns the resulting row.
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
  /// The returned [DatabaseMigrationVersion] will have its `id` field set.
  Future<DatabaseMigrationVersion?> upsertRow(
    _is.DatabaseSession session,
    DatabaseMigrationVersion row, {
    required _is.ColumnSelections<DatabaseMigrationVersionTable>
    conflictColumns,
    _is.ColumnSelections<DatabaseMigrationVersionTable>? updateColumns,
    _is.WhereExpressionBuilder<DatabaseMigrationVersionTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DatabaseMigrationVersion>(
      row,
      conflictColumns: conflictColumns(DatabaseMigrationVersion.t),
      updateColumns: updateColumns?.call(DatabaseMigrationVersion.t),
      updateWhere: updateWhere?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
    );
  }

  /// Updates all [DatabaseMigrationVersion]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DatabaseMigrationVersion>> update(
    _is.DatabaseSession session,
    List<DatabaseMigrationVersion> rows, {
    _is.ColumnSelections<DatabaseMigrationVersionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DatabaseMigrationVersion>(
      rows,
      columns: columns?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DatabaseMigrationVersion]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DatabaseMigrationVersion> updateRow(
    _is.DatabaseSession session,
    DatabaseMigrationVersion row, {
    _is.ColumnSelections<DatabaseMigrationVersionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DatabaseMigrationVersion>(
      row,
      columns: columns?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DatabaseMigrationVersion] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DatabaseMigrationVersion?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DatabaseMigrationVersionUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DatabaseMigrationVersion>(
      id,
      columnValues: columnValues(DatabaseMigrationVersion.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DatabaseMigrationVersion]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DatabaseMigrationVersion>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DatabaseMigrationVersionUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DatabaseMigrationVersionTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    _is.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DatabaseMigrationVersion>(
      columnValues: columnValues(DatabaseMigrationVersion.t.updateTable),
      where: where(DatabaseMigrationVersion.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DatabaseMigrationVersion]s in the list and returns the deleted rows.
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
  Future<List<DatabaseMigrationVersion>> delete(
    _is.DatabaseSession session,
    List<DatabaseMigrationVersion> rows, {
    _is.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    _is.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DatabaseMigrationVersion>(
      rows,
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DatabaseMigrationVersion].
  Future<DatabaseMigrationVersion> deleteRow(
    _is.DatabaseSession session,
    DatabaseMigrationVersion row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DatabaseMigrationVersion>(
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
  Future<List<DatabaseMigrationVersion>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DatabaseMigrationVersionTable> where,
    _is.OrderByBuilder<DatabaseMigrationVersionTable>? orderBy,
    _is.OrderByListBuilder<DatabaseMigrationVersionTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DatabaseMigrationVersion>(
      where: where(DatabaseMigrationVersion.t),
      orderBy: orderBy?.call(DatabaseMigrationVersion.t),
      orderByList: orderByList?.call(DatabaseMigrationVersion.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DatabaseMigrationVersionTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DatabaseMigrationVersion>(
      where: where?.call(DatabaseMigrationVersion.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DatabaseMigrationVersion] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DatabaseMigrationVersionTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DatabaseMigrationVersion>(
      where: where(DatabaseMigrationVersion.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

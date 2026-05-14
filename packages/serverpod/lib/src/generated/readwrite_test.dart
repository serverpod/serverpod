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
import 'package:serverpod/serverpod.dart' as _i1;

/// Database mapping for a read/write test that is performed by the default
/// health checks.
abstract class ReadWriteTestEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReadWriteTestEntry._({
    this.id,
    required this.number,
  });

  factory ReadWriteTestEntry({
    int? id,
    required int number,
  }) = _ReadWriteTestEntryImpl;

  factory ReadWriteTestEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReadWriteTestEntry(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
    );
  }

  static final t = ReadWriteTestEntryTable();

  static const db = ReadWriteTestEntryRepository._();

  @override
  int? id;

  /// A random number, to verify that the write/read was performed correctly.
  int number;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReadWriteTestEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReadWriteTestEntry copyWith({
    int? id,
    int? number,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.ReadWriteTestEntry',
      if (id != null) 'id': id,
      'number': number,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.ReadWriteTestEntry',
      if (id != null) 'id': id,
      'number': number,
    };
  }

  static ReadWriteTestEntryInclude include() {
    return ReadWriteTestEntryInclude._();
  }

  static ReadWriteTestEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    ReadWriteTestEntryInclude? include,
  }) {
    return ReadWriteTestEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReadWriteTestEntryImpl extends ReadWriteTestEntry {
  _ReadWriteTestEntryImpl({
    int? id,
    required int number,
  }) : super._(
         id: id,
         number: number,
       );

  /// Returns a shallow copy of this [ReadWriteTestEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReadWriteTestEntry copyWith({
    Object? id = _Undefined,
    int? number,
  }) {
    return ReadWriteTestEntry(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
    );
  }
}

class ReadWriteTestEntryUpdateTable
    extends _i1.UpdateTable<ReadWriteTestEntryTable> {
  ReadWriteTestEntryUpdateTable(super.table);

  _i1.ColumnValue<int, int> number(int value) => _i1.ColumnValue(
    table.number,
    value,
  );
}

class ReadWriteTestEntryTable extends _i1.Table<int?> {
  ReadWriteTestEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_readwrite_test') {
    updateTable = ReadWriteTestEntryUpdateTable(this);
    number = _i1.ColumnInt(
      'number',
      this,
    );
  }

  late final ReadWriteTestEntryUpdateTable updateTable;

  /// A random number, to verify that the write/read was performed correctly.
  late final _i1.ColumnInt number;

  @override
  List<_i1.Column> get columns => [
    id,
    number,
  ];
}

class ReadWriteTestEntryInclude extends _i1.IncludeObject {
  ReadWriteTestEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReadWriteTestEntry.t;
}

class ReadWriteTestEntryIncludeList extends _i1.IncludeList {
  ReadWriteTestEntryIncludeList._({
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReadWriteTestEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReadWriteTestEntry.t;
}

class ReadWriteTestEntryRepository {
  const ReadWriteTestEntryRepository._();

  /// Returns a list of [ReadWriteTestEntry]s matching the given query parameters.
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
  Future<List<ReadWriteTestEntry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReadWriteTestEntry>(
      where: where?.call(ReadWriteTestEntry.t),
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReadWriteTestEntry] matching the given query parameters.
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
  Future<ReadWriteTestEntry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReadWriteTestEntry>(
      where: where?.call(ReadWriteTestEntry.t),
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReadWriteTestEntry] by its [id] or null if no such row exists.
  Future<ReadWriteTestEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReadWriteTestEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReadWriteTestEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [ReadWriteTestEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ReadWriteTestEntry>> insert(
    _i1.DatabaseSession session,
    List<ReadWriteTestEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ReadWriteTestEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ReadWriteTestEntry] and returns the inserted row.
  ///
  /// The returned [ReadWriteTestEntry] will have its `id` field set.
  Future<ReadWriteTestEntry> insertRow(
    _i1.DatabaseSession session,
    ReadWriteTestEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReadWriteTestEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ReadWriteTestEntry]s in the list and returns the resulting rows.
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
  /// The returned [ReadWriteTestEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  Future<List<ReadWriteTestEntry>> upsert(
    _i1.DatabaseSession session,
    List<ReadWriteTestEntry> rows, {
    required _i1.ColumnSelections<ReadWriteTestEntryTable> conflictColumns,
    _i1.ColumnSelections<ReadWriteTestEntryTable>? updateColumns,
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsert<ReadWriteTestEntry>(
      rows,
      conflictColumns: conflictColumns(ReadWriteTestEntry.t),
      updateColumns: updateColumns?.call(ReadWriteTestEntry.t),
      updateWhere: updateWhere?.call(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  /// Upserts a single [ReadWriteTestEntry] and returns the resulting row.
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
  /// The returned [ReadWriteTestEntry] will have its `id` field set.
  Future<ReadWriteTestEntry?> upsertRow(
    _i1.DatabaseSession session,
    ReadWriteTestEntry row, {
    required _i1.ColumnSelections<ReadWriteTestEntryTable> conflictColumns,
    _i1.ColumnSelections<ReadWriteTestEntryTable>? updateColumns,
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ReadWriteTestEntry>(
      row,
      conflictColumns: conflictColumns(ReadWriteTestEntry.t),
      updateColumns: updateColumns?.call(ReadWriteTestEntry.t),
      updateWhere: updateWhere?.call(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [ReadWriteTestEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReadWriteTestEntry>> update(
    _i1.DatabaseSession session,
    List<ReadWriteTestEntry> rows, {
    _i1.ColumnSelections<ReadWriteTestEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReadWriteTestEntry>(
      rows,
      columns: columns?.call(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReadWriteTestEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReadWriteTestEntry> updateRow(
    _i1.DatabaseSession session,
    ReadWriteTestEntry row, {
    _i1.ColumnSelections<ReadWriteTestEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReadWriteTestEntry>(
      row,
      columns: columns?.call(ReadWriteTestEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReadWriteTestEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReadWriteTestEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ReadWriteTestEntryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReadWriteTestEntry>(
      id,
      columnValues: columnValues(ReadWriteTestEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReadWriteTestEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReadWriteTestEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ReadWriteTestEntryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ReadWriteTestEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReadWriteTestEntry>(
      columnValues: columnValues(ReadWriteTestEntry.t.updateTable),
      where: where(ReadWriteTestEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReadWriteTestEntry]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReadWriteTestEntry>> delete(
    _i1.DatabaseSession session,
    List<ReadWriteTestEntry> rows, {
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReadWriteTestEntry>(
      rows,
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReadWriteTestEntry].
  Future<ReadWriteTestEntry> deleteRow(
    _i1.DatabaseSession session,
    ReadWriteTestEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReadWriteTestEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<ReadWriteTestEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReadWriteTestEntryTable> where,
    _i1.OrderByBuilder<ReadWriteTestEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReadWriteTestEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReadWriteTestEntry>(
      where: where(ReadWriteTestEntry.t),
      orderBy: orderBy?.call(ReadWriteTestEntry.t),
      orderByList: orderByList?.call(ReadWriteTestEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReadWriteTestEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReadWriteTestEntry>(
      where: where?.call(ReadWriteTestEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReadWriteTestEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReadWriteTestEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReadWriteTestEntry>(
      where: where(ReadWriteTestEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

/// Bindings to a future call claim entry in the database.
abstract class FutureCallClaimEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FutureCallClaimEntry._({
    this.id,
    this.futureCallId,
    required this.lastHeartbeatTime,
  });

  factory FutureCallClaimEntry({
    int? id,
    int? futureCallId,
    required DateTime lastHeartbeatTime,
  }) = _FutureCallClaimEntryImpl;

  factory FutureCallClaimEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return FutureCallClaimEntry(
      id: jsonSerialization['id'] as int?,
      futureCallId: jsonSerialization['futureCallId'] as int?,
      lastHeartbeatTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastHeartbeatTime'],
      ),
    );
  }

  static final t = FutureCallClaimEntryTable();

  static const db = FutureCallClaimEntryRepository._();

  @override
  int? id;

  /// The id of the future call this claim entry is associated with
  int? futureCallId;

  /// Last heartbeat timestamp for this claim entry.
  /// Used to detect stale claims that should be cleaned up.
  DateTime lastHeartbeatTime;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FutureCallClaimEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FutureCallClaimEntry copyWith({
    int? id,
    int? futureCallId,
    DateTime? lastHeartbeatTime,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.FutureCallClaimEntry',
      if (id != null) 'id': id,
      if (futureCallId != null) 'futureCallId': futureCallId,
      'lastHeartbeatTime': lastHeartbeatTime.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.FutureCallClaimEntry',
      if (id != null) 'id': id,
      if (futureCallId != null) 'futureCallId': futureCallId,
      'lastHeartbeatTime': lastHeartbeatTime.toJson(),
    };
  }

  static FutureCallClaimEntryInclude include() {
    return FutureCallClaimEntryInclude._();
  }

  static FutureCallClaimEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<FutureCallClaimEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FutureCallClaimEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FutureCallClaimEntryTable>? orderByList,
    FutureCallClaimEntryInclude? include,
  }) {
    return FutureCallClaimEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FutureCallClaimEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(FutureCallClaimEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FutureCallClaimEntryImpl extends FutureCallClaimEntry {
  _FutureCallClaimEntryImpl({
    int? id,
    int? futureCallId,
    required DateTime lastHeartbeatTime,
  }) : super._(
         id: id,
         futureCallId: futureCallId,
         lastHeartbeatTime: lastHeartbeatTime,
       );

  /// Returns a shallow copy of this [FutureCallClaimEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FutureCallClaimEntry copyWith({
    Object? id = _Undefined,
    Object? futureCallId = _Undefined,
    DateTime? lastHeartbeatTime,
  }) {
    return FutureCallClaimEntry(
      id: id is int? ? id : this.id,
      futureCallId: futureCallId is int? ? futureCallId : this.futureCallId,
      lastHeartbeatTime: lastHeartbeatTime ?? this.lastHeartbeatTime,
    );
  }
}

class FutureCallClaimEntryUpdateTable
    extends _i1.UpdateTable<FutureCallClaimEntryTable> {
  FutureCallClaimEntryUpdateTable(super.table);

  _i1.ColumnValue<int, int> futureCallId(int? value) => _i1.ColumnValue(
    table.futureCallId,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> lastHeartbeatTime(DateTime value) =>
      _i1.ColumnValue(
        table.lastHeartbeatTime,
        value,
      );
}

class FutureCallClaimEntryTable extends _i1.Table<int?> {
  FutureCallClaimEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_future_call_claim') {
    updateTable = FutureCallClaimEntryUpdateTable(this);
    futureCallId = _i1.ColumnInt(
      'futureCallId',
      this,
    );
    lastHeartbeatTime = _i1.ColumnDateTime(
      'lastHeartbeatTime',
      this,
    );
  }

  late final FutureCallClaimEntryUpdateTable updateTable;

  /// The id of the future call this claim entry is associated with
  late final _i1.ColumnInt futureCallId;

  /// Last heartbeat timestamp for this claim entry.
  /// Used to detect stale claims that should be cleaned up.
  late final _i1.ColumnDateTime lastHeartbeatTime;

  @override
  List<_i1.Column> get columns => [
    id,
    futureCallId,
    lastHeartbeatTime,
  ];
}

class FutureCallClaimEntryInclude extends _i1.IncludeObject {
  FutureCallClaimEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => FutureCallClaimEntry.t;
}

class FutureCallClaimEntryIncludeList extends _i1.IncludeList {
  FutureCallClaimEntryIncludeList._({
    _i1.WhereExpressionBuilder<FutureCallClaimEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FutureCallClaimEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FutureCallClaimEntry.t;
}

class FutureCallClaimEntryRepository {
  const FutureCallClaimEntryRepository._();

  /// Returns a list of [FutureCallClaimEntry]s matching the given query parameters.
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
  Future<List<FutureCallClaimEntry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FutureCallClaimEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FutureCallClaimEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FutureCallClaimEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FutureCallClaimEntry>(
      where: where?.call(FutureCallClaimEntry.t),
      orderBy: orderBy?.call(FutureCallClaimEntry.t),
      orderByList: orderByList?.call(FutureCallClaimEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FutureCallClaimEntry] matching the given query parameters.
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
  Future<FutureCallClaimEntry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FutureCallClaimEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<FutureCallClaimEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<FutureCallClaimEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FutureCallClaimEntry>(
      where: where?.call(FutureCallClaimEntry.t),
      orderBy: orderBy?.call(FutureCallClaimEntry.t),
      orderByList: orderByList?.call(FutureCallClaimEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FutureCallClaimEntry] by its [id] or null if no such row exists.
  Future<FutureCallClaimEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FutureCallClaimEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FutureCallClaimEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [FutureCallClaimEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<FutureCallClaimEntry>> insert(
    _i1.DatabaseSession session,
    List<FutureCallClaimEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<FutureCallClaimEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [FutureCallClaimEntry] and returns the inserted row.
  ///
  /// The returned [FutureCallClaimEntry] will have its `id` field set.
  Future<FutureCallClaimEntry> insertRow(
    _i1.DatabaseSession session,
    FutureCallClaimEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FutureCallClaimEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [FutureCallClaimEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<FutureCallClaimEntry>> update(
    _i1.DatabaseSession session,
    List<FutureCallClaimEntry> rows, {
    _i1.ColumnSelections<FutureCallClaimEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<FutureCallClaimEntry>(
      rows,
      columns: columns?.call(FutureCallClaimEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FutureCallClaimEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FutureCallClaimEntry> updateRow(
    _i1.DatabaseSession session,
    FutureCallClaimEntry row, {
    _i1.ColumnSelections<FutureCallClaimEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FutureCallClaimEntry>(
      row,
      columns: columns?.call(FutureCallClaimEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FutureCallClaimEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FutureCallClaimEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FutureCallClaimEntryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FutureCallClaimEntry>(
      id,
      columnValues: columnValues(FutureCallClaimEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FutureCallClaimEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<FutureCallClaimEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FutureCallClaimEntryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FutureCallClaimEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FutureCallClaimEntryTable>? orderBy,
    _i1.OrderByListBuilder<FutureCallClaimEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<FutureCallClaimEntry>(
      columnValues: columnValues(FutureCallClaimEntry.t.updateTable),
      where: where(FutureCallClaimEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FutureCallClaimEntry.t),
      orderByList: orderByList?.call(FutureCallClaimEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [FutureCallClaimEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<FutureCallClaimEntry>> delete(
    _i1.DatabaseSession session,
    List<FutureCallClaimEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<FutureCallClaimEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [FutureCallClaimEntry].
  Future<FutureCallClaimEntry> deleteRow(
    _i1.DatabaseSession session,
    FutureCallClaimEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FutureCallClaimEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<FutureCallClaimEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FutureCallClaimEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<FutureCallClaimEntry>(
      where: where(FutureCallClaimEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FutureCallClaimEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FutureCallClaimEntry>(
      where: where?.call(FutureCallClaimEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FutureCallClaimEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FutureCallClaimEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FutureCallClaimEntry>(
      where: where(FutureCallClaimEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

/// An entry in the reactive future call outbox, created by database
/// triggers when watched data changes.
abstract class ReactiveDatabaseCallEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ReactiveDatabaseCallEntry._({
    this.id,
    required this.handlerName,
    required this.sourceTable,
    required this.operation,
    required this.rowData,
    required this.createdAt,
    this.futureCallEntryId,
  });

  factory ReactiveDatabaseCallEntry({
    int? id,
    required String handlerName,
    required String sourceTable,
    required String operation,
    required String rowData,
    required DateTime createdAt,
    int? futureCallEntryId,
  }) = _ReactiveDatabaseCallEntryImpl;

  factory ReactiveDatabaseCallEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ReactiveDatabaseCallEntry(
      id: jsonSerialization['id'] as int?,
      handlerName: jsonSerialization['handlerName'] as String,
      sourceTable: jsonSerialization['sourceTable'] as String,
      operation: jsonSerialization['operation'] as String,
      rowData: jsonSerialization['rowData'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      futureCallEntryId: jsonSerialization['futureCallEntryId'] as int?,
    );
  }

  static final t = ReactiveDatabaseCallEntryTable();

  static const db = ReactiveDatabaseCallEntryRepository._();

  @override
  int? id;

  /// Name of the ReactiveFutureCall handler to invoke.
  String handlerName;

  /// Source table that was modified.
  String sourceTable;

  /// The operation that triggered the event (INSERT, UPDATE, or DELETE).
  String operation;

  /// The row data serialized as JSON via row_to_json().
  String rowData;

  /// When the trigger fired.
  DateTime createdAt;

  /// The id of the FutureCallEntry that has claimed this event for
  /// processing. Null means the event is unclaimed and available for pickup.
  int? futureCallEntryId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ReactiveDatabaseCallEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReactiveDatabaseCallEntry copyWith({
    int? id,
    String? handlerName,
    String? sourceTable,
    String? operation,
    String? rowData,
    DateTime? createdAt,
    int? futureCallEntryId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.ReactiveDatabaseCallEntry',
      if (id != null) 'id': id,
      'handlerName': handlerName,
      'sourceTable': sourceTable,
      'operation': operation,
      'rowData': rowData,
      'createdAt': createdAt.toJson(),
      if (futureCallEntryId != null) 'futureCallEntryId': futureCallEntryId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.ReactiveDatabaseCallEntry',
      if (id != null) 'id': id,
      'handlerName': handlerName,
      'sourceTable': sourceTable,
      'operation': operation,
      'rowData': rowData,
      'createdAt': createdAt.toJson(),
      if (futureCallEntryId != null) 'futureCallEntryId': futureCallEntryId,
    };
  }

  static ReactiveDatabaseCallEntryInclude include() {
    return ReactiveDatabaseCallEntryInclude._();
  }

  static ReactiveDatabaseCallEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReactiveDatabaseCallEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactiveDatabaseCallEntryTable>? orderByList,
    ReactiveDatabaseCallEntryInclude? include,
  }) {
    return ReactiveDatabaseCallEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReactiveDatabaseCallEntry.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ReactiveDatabaseCallEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReactiveDatabaseCallEntryImpl extends ReactiveDatabaseCallEntry {
  _ReactiveDatabaseCallEntryImpl({
    int? id,
    required String handlerName,
    required String sourceTable,
    required String operation,
    required String rowData,
    required DateTime createdAt,
    int? futureCallEntryId,
  }) : super._(
         id: id,
         handlerName: handlerName,
         sourceTable: sourceTable,
         operation: operation,
         rowData: rowData,
         createdAt: createdAt,
         futureCallEntryId: futureCallEntryId,
       );

  /// Returns a shallow copy of this [ReactiveDatabaseCallEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReactiveDatabaseCallEntry copyWith({
    Object? id = _Undefined,
    String? handlerName,
    String? sourceTable,
    String? operation,
    String? rowData,
    DateTime? createdAt,
    Object? futureCallEntryId = _Undefined,
  }) {
    return ReactiveDatabaseCallEntry(
      id: id is int? ? id : this.id,
      handlerName: handlerName ?? this.handlerName,
      sourceTable: sourceTable ?? this.sourceTable,
      operation: operation ?? this.operation,
      rowData: rowData ?? this.rowData,
      createdAt: createdAt ?? this.createdAt,
      futureCallEntryId: futureCallEntryId is int?
          ? futureCallEntryId
          : this.futureCallEntryId,
    );
  }
}

class ReactiveDatabaseCallEntryUpdateTable
    extends _i1.UpdateTable<ReactiveDatabaseCallEntryTable> {
  ReactiveDatabaseCallEntryUpdateTable(super.table);

  _i1.ColumnValue<String, String> handlerName(String value) => _i1.ColumnValue(
    table.handlerName,
    value,
  );

  _i1.ColumnValue<String, String> sourceTable(String value) => _i1.ColumnValue(
    table.sourceTable,
    value,
  );

  _i1.ColumnValue<String, String> operation(String value) => _i1.ColumnValue(
    table.operation,
    value,
  );

  _i1.ColumnValue<String, String> rowData(String value) => _i1.ColumnValue(
    table.rowData,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<int, int> futureCallEntryId(int? value) => _i1.ColumnValue(
    table.futureCallEntryId,
    value,
  );
}

class ReactiveDatabaseCallEntryTable extends _i1.Table<int?> {
  ReactiveDatabaseCallEntryTable({super.tableRelation})
    : super(tableName: 'serverpod_reactive_db_call') {
    updateTable = ReactiveDatabaseCallEntryUpdateTable(this);
    handlerName = _i1.ColumnString(
      'handlerName',
      this,
    );
    sourceTable = _i1.ColumnString(
      'sourceTable',
      this,
    );
    operation = _i1.ColumnString(
      'operation',
      this,
    );
    rowData = _i1.ColumnString(
      'rowData',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    futureCallEntryId = _i1.ColumnInt(
      'futureCallEntryId',
      this,
    );
  }

  late final ReactiveDatabaseCallEntryUpdateTable updateTable;

  /// Name of the ReactiveFutureCall handler to invoke.
  late final _i1.ColumnString handlerName;

  /// Source table that was modified.
  late final _i1.ColumnString sourceTable;

  /// The operation that triggered the event (INSERT, UPDATE, or DELETE).
  late final _i1.ColumnString operation;

  /// The row data serialized as JSON via row_to_json().
  late final _i1.ColumnString rowData;

  /// When the trigger fired.
  late final _i1.ColumnDateTime createdAt;

  /// The id of the FutureCallEntry that has claimed this event for
  /// processing. Null means the event is unclaimed and available for pickup.
  late final _i1.ColumnInt futureCallEntryId;

  @override
  List<_i1.Column> get columns => [
    id,
    handlerName,
    sourceTable,
    operation,
    rowData,
    createdAt,
    futureCallEntryId,
  ];
}

class ReactiveDatabaseCallEntryInclude extends _i1.IncludeObject {
  ReactiveDatabaseCallEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ReactiveDatabaseCallEntry.t;
}

class ReactiveDatabaseCallEntryIncludeList extends _i1.IncludeList {
  ReactiveDatabaseCallEntryIncludeList._({
    _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ReactiveDatabaseCallEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ReactiveDatabaseCallEntry.t;
}

class ReactiveDatabaseCallEntryRepository {
  const ReactiveDatabaseCallEntryRepository._();

  /// Returns a list of [ReactiveDatabaseCallEntry]s matching the given query parameters.
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
  Future<List<ReactiveDatabaseCallEntry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReactiveDatabaseCallEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactiveDatabaseCallEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ReactiveDatabaseCallEntry>(
      where: where?.call(ReactiveDatabaseCallEntry.t),
      orderBy: orderBy?.call(ReactiveDatabaseCallEntry.t),
      orderByList: orderByList?.call(ReactiveDatabaseCallEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ReactiveDatabaseCallEntry] matching the given query parameters.
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
  Future<ReactiveDatabaseCallEntry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<ReactiveDatabaseCallEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactiveDatabaseCallEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ReactiveDatabaseCallEntry>(
      where: where?.call(ReactiveDatabaseCallEntry.t),
      orderBy: orderBy?.call(ReactiveDatabaseCallEntry.t),
      orderByList: orderByList?.call(ReactiveDatabaseCallEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ReactiveDatabaseCallEntry] by its [id] or null if no such row exists.
  Future<ReactiveDatabaseCallEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ReactiveDatabaseCallEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ReactiveDatabaseCallEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [ReactiveDatabaseCallEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ReactiveDatabaseCallEntry>> insert(
    _i1.DatabaseSession session,
    List<ReactiveDatabaseCallEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ReactiveDatabaseCallEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ReactiveDatabaseCallEntry] and returns the inserted row.
  ///
  /// The returned [ReactiveDatabaseCallEntry] will have its `id` field set.
  Future<ReactiveDatabaseCallEntry> insertRow(
    _i1.DatabaseSession session,
    ReactiveDatabaseCallEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ReactiveDatabaseCallEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ReactiveDatabaseCallEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ReactiveDatabaseCallEntry>> update(
    _i1.DatabaseSession session,
    List<ReactiveDatabaseCallEntry> rows, {
    _i1.ColumnSelections<ReactiveDatabaseCallEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ReactiveDatabaseCallEntry>(
      rows,
      columns: columns?.call(ReactiveDatabaseCallEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReactiveDatabaseCallEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ReactiveDatabaseCallEntry> updateRow(
    _i1.DatabaseSession session,
    ReactiveDatabaseCallEntry row, {
    _i1.ColumnSelections<ReactiveDatabaseCallEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ReactiveDatabaseCallEntry>(
      row,
      columns: columns?.call(ReactiveDatabaseCallEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ReactiveDatabaseCallEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ReactiveDatabaseCallEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ReactiveDatabaseCallEntryUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ReactiveDatabaseCallEntry>(
      id,
      columnValues: columnValues(ReactiveDatabaseCallEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ReactiveDatabaseCallEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ReactiveDatabaseCallEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ReactiveDatabaseCallEntryUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ReactiveDatabaseCallEntryTable>? orderBy,
    _i1.OrderByListBuilder<ReactiveDatabaseCallEntryTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ReactiveDatabaseCallEntry>(
      columnValues: columnValues(ReactiveDatabaseCallEntry.t.updateTable),
      where: where(ReactiveDatabaseCallEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ReactiveDatabaseCallEntry.t),
      orderByList: orderByList?.call(ReactiveDatabaseCallEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ReactiveDatabaseCallEntry]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ReactiveDatabaseCallEntry>> delete(
    _i1.DatabaseSession session,
    List<ReactiveDatabaseCallEntry> rows, {
    _i1.OrderByBuilder<ReactiveDatabaseCallEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactiveDatabaseCallEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ReactiveDatabaseCallEntry>(
      rows,
      orderBy: orderBy?.call(ReactiveDatabaseCallEntry.t),
      orderByList: orderByList?.call(ReactiveDatabaseCallEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [ReactiveDatabaseCallEntry].
  Future<ReactiveDatabaseCallEntry> deleteRow(
    _i1.DatabaseSession session,
    ReactiveDatabaseCallEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ReactiveDatabaseCallEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<ReactiveDatabaseCallEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable> where,
    _i1.OrderByBuilder<ReactiveDatabaseCallEntryTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ReactiveDatabaseCallEntryTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ReactiveDatabaseCallEntry>(
      where: where(ReactiveDatabaseCallEntry.t),
      orderBy: orderBy?.call(ReactiveDatabaseCallEntry.t),
      orderByList: orderByList?.call(ReactiveDatabaseCallEntry.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ReactiveDatabaseCallEntry>(
      where: where?.call(ReactiveDatabaseCallEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ReactiveDatabaseCallEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ReactiveDatabaseCallEntry>(
      where: where(ReactiveDatabaseCallEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

abstract class ReactiveDatabaseCallEntryReactiveFutureCall
    extends _i1.ReactiveFutureCall<ReactiveDatabaseCallEntry> {
  @override
  String get tableName => 'serverpod_reactive_db_call';

  _i1.WhereExpressionBuilder<ReactiveDatabaseCallEntryTable> get where;
  @override
  _i1.Expression? get condition => where(ReactiveDatabaseCallEntry.t);
}

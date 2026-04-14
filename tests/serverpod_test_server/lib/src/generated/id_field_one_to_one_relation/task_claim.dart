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

abstract class TaskClaim
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TaskClaim._({
    this.id,
    required this.server,
  });

  factory TaskClaim({
    int? id,
    required String server,
  }) = _TaskClaimImpl;

  factory TaskClaim.fromJson(Map<String, dynamic> jsonSerialization) {
    return TaskClaim(
      id: jsonSerialization['id'] as int?,
      server: jsonSerialization['server'] as String,
    );
  }

  static final t = TaskClaimTable();

  static const db = TaskClaimRepository._();

  @override
  int? id;

  String server;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TaskClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TaskClaim copyWith({
    int? id,
    String? server,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TaskClaim',
      if (id != null) 'id': id,
      'server': server,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TaskClaim',
      if (id != null) 'id': id,
      'server': server,
    };
  }

  static TaskClaimInclude include() {
    return TaskClaimInclude._();
  }

  static TaskClaimIncludeList includeList({
    _i1.WhereExpressionBuilder<TaskClaimTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskClaimTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskClaimTable>? orderByList,
    TaskClaimInclude? include,
  }) {
    return TaskClaimIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskClaim.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TaskClaim.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskClaimImpl extends TaskClaim {
  _TaskClaimImpl({
    int? id,
    required String server,
  }) : super._(
         id: id,
         server: server,
       );

  /// Returns a shallow copy of this [TaskClaim]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TaskClaim copyWith({
    Object? id = _Undefined,
    String? server,
  }) {
    return TaskClaim(
      id: id is int? ? id : this.id,
      server: server ?? this.server,
    );
  }
}

class TaskClaimUpdateTable extends _i1.UpdateTable<TaskClaimTable> {
  TaskClaimUpdateTable(super.table);

  _i1.ColumnValue<String, String> server(String value) => _i1.ColumnValue(
    table.server,
    value,
  );
}

class TaskClaimTable extends _i1.Table<int?> {
  TaskClaimTable({super.tableRelation}) : super(tableName: 'task_claim') {
    updateTable = TaskClaimUpdateTable(this);
    server = _i1.ColumnString(
      'server',
      this,
    );
  }

  late final TaskClaimUpdateTable updateTable;

  late final _i1.ColumnString server;

  @override
  List<_i1.Column> get columns => [
    id,
    server,
  ];
}

class TaskClaimInclude extends _i1.IncludeObject {
  TaskClaimInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TaskClaim.t;
}

class TaskClaimIncludeList extends _i1.IncludeList {
  TaskClaimIncludeList._({
    _i1.WhereExpressionBuilder<TaskClaimTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TaskClaim.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TaskClaim.t;
}

class TaskClaimRepository {
  const TaskClaimRepository._();

  /// Returns a list of [TaskClaim]s matching the given query parameters.
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
  Future<List<TaskClaim>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TaskClaimTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskClaimTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskClaimTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TaskClaim>(
      where: where?.call(TaskClaim.t),
      orderBy: orderBy?.call(TaskClaim.t),
      orderByList: orderByList?.call(TaskClaim.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [TaskClaim] matching the given query parameters.
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
  Future<TaskClaim?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TaskClaimTable>? where,
    int? offset,
    _i1.OrderByBuilder<TaskClaimTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TaskClaimTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TaskClaim>(
      where: where?.call(TaskClaim.t),
      orderBy: orderBy?.call(TaskClaim.t),
      orderByList: orderByList?.call(TaskClaim.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TaskClaim] by its [id] or null if no such row exists.
  Future<TaskClaim?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TaskClaim>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TaskClaim]s in the list and returns the inserted rows.
  ///
  /// The returned [TaskClaim]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<TaskClaim>> insert(
    _i1.DatabaseSession session,
    List<TaskClaim> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<TaskClaim>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [TaskClaim] and returns the inserted row.
  ///
  /// The returned [TaskClaim] will have its `id` field set.
  Future<TaskClaim> insertRow(
    _i1.DatabaseSession session,
    TaskClaim row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TaskClaim>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TaskClaim]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TaskClaim>> update(
    _i1.DatabaseSession session,
    List<TaskClaim> rows, {
    _i1.ColumnSelections<TaskClaimTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TaskClaim>(
      rows,
      columns: columns?.call(TaskClaim.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskClaim]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TaskClaim> updateRow(
    _i1.DatabaseSession session,
    TaskClaim row, {
    _i1.ColumnSelections<TaskClaimTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TaskClaim>(
      row,
      columns: columns?.call(TaskClaim.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TaskClaim] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TaskClaim?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<TaskClaimUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TaskClaim>(
      id,
      columnValues: columnValues(TaskClaim.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TaskClaim]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TaskClaim>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<TaskClaimUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TaskClaimTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TaskClaimTable>? orderBy,
    _i1.OrderByListBuilder<TaskClaimTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TaskClaim>(
      columnValues: columnValues(TaskClaim.t.updateTable),
      where: where(TaskClaim.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TaskClaim.t),
      orderByList: orderByList?.call(TaskClaim.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TaskClaim]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TaskClaim>> delete(
    _i1.DatabaseSession session,
    List<TaskClaim> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TaskClaim>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TaskClaim].
  Future<TaskClaim> deleteRow(
    _i1.DatabaseSession session,
    TaskClaim row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TaskClaim>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TaskClaim>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TaskClaimTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TaskClaim>(
      where: where(TaskClaim.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<TaskClaimTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TaskClaim>(
      where: where?.call(TaskClaim.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TaskClaim] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<TaskClaimTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TaskClaim>(
      where: where(TaskClaim.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

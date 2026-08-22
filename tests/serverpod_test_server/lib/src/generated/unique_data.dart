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
import 'package:meta/meta.dart' as _i057hz1u;
import 'package:serverpod/serverpod.dart' as _is;

abstract class UniqueData
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UniqueData._({
    this.id,
    required this.number,
    required this.email,
  });

  factory UniqueData({
    int? id,
    required int number,
    required String email,
  }) = _UniqueDataImpl;

  factory UniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UniqueData(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
      email: jsonSerialization['email'] as String,
    );
  }

  static final t = UniqueDataTable();

  static const db = UniqueDataRepository._();

  @override
  int? id;

  int number;

  String email;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UniqueData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UniqueData copyWith({
    int? id,
    int? number,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UniqueData',
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UniqueData',
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }

  static UniqueDataInclude include() {
    return UniqueDataInclude.internal_();
  }

  static UniqueDataIncludeList includeList({
    _is.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UniqueDataTable>? orderBy,
    _is.OrderByListBuilder<UniqueDataTable>? orderByList,
    UniqueDataInclude? include,
  }) {
    return UniqueDataIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UniqueDataImpl extends UniqueData {
  _UniqueDataImpl({
    int? id,
    required int number,
    required String email,
  }) : super._(
         id: id,
         number: number,
         email: email,
       );

  /// Returns a shallow copy of this [UniqueData]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UniqueData copyWith({
    Object? id = _Undefined,
    int? number,
    String? email,
  }) {
    return UniqueData(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      email: email ?? this.email,
    );
  }
}

class UniqueDataUpdateTable extends _is.UpdateTable<UniqueDataTable> {
  UniqueDataUpdateTable(super.table);

  _is.ColumnValue<int, int> number(int value) => _is.ColumnValue(
    table.number,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );
}

class UniqueDataTable extends _is.Table<int?> {
  UniqueDataTable({super.tableRelation}) : super(tableName: 'unique_data') {
    updateTable = UniqueDataUpdateTable(this);
    number = _is.ColumnInt(
      'number',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
  }

  late final UniqueDataUpdateTable updateTable;

  late final _is.ColumnInt number;

  late final _is.ColumnString email;

  @override
  List<_is.Column> get columns => [
    id,
    number,
    email,
  ];
}

class UniqueDataInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  UniqueDataInclude.internal_({List<_is.Column>? this.selectedColumns}) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UniqueData.t;
}

class UniqueDataIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  UniqueDataIncludeList.internal_({
    _is.WhereExpressionBuilder<UniqueDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(UniqueData.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UniqueData.t;
}

class UniqueDataRepository {
  const UniqueDataRepository._();

  /// Returns a list of [UniqueData]s matching the given query parameters.
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
  Future<List<UniqueData>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UniqueDataTable>? orderBy,
    _is.OrderByListBuilder<UniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UniqueData] matching the given query parameters.
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
  Future<UniqueData?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UniqueDataTable>? where,
    int? offset,
    _is.OrderByBuilder<UniqueDataTable>? orderBy,
    _is.OrderByListBuilder<UniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UniqueData] by its [id] or null if no such row exists.
  Future<UniqueData?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UniqueData>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UniqueData]s in the list and returns the inserted rows.
  ///
  /// The returned [UniqueData]s will have their `id` fields set.
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
  Future<List<UniqueData>> insert(
    _is.DatabaseSession session,
    List<UniqueData> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UniqueData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UniqueData] and returns the inserted row.
  ///
  /// The returned [UniqueData] will have its `id` field set.
  Future<UniqueData> insertRow(
    _is.DatabaseSession session,
    UniqueData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UniqueData]s in the list and returns the resulting rows.
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
  /// The returned [UniqueData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UniqueData>> upsert(
    _is.DatabaseSession session,
    List<UniqueData> rows, {
    required _is.ColumnSelections<UniqueDataTable> conflictColumns,
    _is.ColumnSelections<UniqueDataTable>? updateColumns,
    _is.WhereExpressionBuilder<UniqueDataTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UniqueData>(
      rows,
      conflictColumns: conflictColumns(UniqueData.t),
      updateColumns: updateColumns?.call(UniqueData.t),
      updateWhere: updateWhere?.call(UniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UniqueData] and returns the resulting row.
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
  /// The returned [UniqueData] will have its `id` field set.
  Future<UniqueData?> upsertRow(
    _is.DatabaseSession session,
    UniqueData row, {
    required _is.ColumnSelections<UniqueDataTable> conflictColumns,
    _is.ColumnSelections<UniqueDataTable>? updateColumns,
    _is.WhereExpressionBuilder<UniqueDataTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UniqueData>(
      row,
      conflictColumns: conflictColumns(UniqueData.t),
      updateColumns: updateColumns?.call(UniqueData.t),
      updateWhere: updateWhere?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates all [UniqueData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UniqueData>> update(
    _is.DatabaseSession session,
    List<UniqueData> rows, {
    _is.ColumnSelections<UniqueDataTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UniqueData>(
      rows,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UniqueData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UniqueData> updateRow(
    _is.DatabaseSession session,
    UniqueData row, {
    _is.ColumnSelections<UniqueDataTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UniqueData>(
      row,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UniqueData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UniqueData?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UniqueDataUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UniqueData>(
      id,
      columnValues: columnValues(UniqueData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UniqueData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UniqueData>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UniqueDataUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UniqueDataTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UniqueDataTable>? orderBy,
    _is.OrderByListBuilder<UniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UniqueData>(
      columnValues: columnValues(UniqueData.t.updateTable),
      where: where(UniqueData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UniqueData]s in the list and returns the deleted rows.
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
  Future<List<UniqueData>> delete(
    _is.DatabaseSession session,
    List<UniqueData> rows, {
    _is.OrderByBuilder<UniqueDataTable>? orderBy,
    _is.OrderByListBuilder<UniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UniqueData>(
      rows,
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UniqueData].
  Future<UniqueData> deleteRow(
    _is.DatabaseSession session,
    UniqueData row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UniqueData>(
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
  Future<List<UniqueData>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UniqueDataTable> where,
    _is.OrderByBuilder<UniqueDataTable>? orderBy,
    _is.OrderByListBuilder<UniqueDataTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UniqueData>(
      where: where(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UniqueData>(
      where: where?.call(UniqueData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UniqueData] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UniqueDataTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UniqueData>(
      where: where(UniqueData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

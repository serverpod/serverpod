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

@_is.immutable
abstract class ImmutableObjectWithTable
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  const ImmutableObjectWithTable._({
    this.id,
    required this.variable,
  });

  const factory ImmutableObjectWithTable({
    int? id,
    required String variable,
  }) = _ImmutableObjectWithTableImpl;

  factory ImmutableObjectWithTable.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithTable(
      id: jsonSerialization['id'] as int?,
      variable: jsonSerialization['variable'] as String,
    );
  }

  static final t = ImmutableObjectWithTableTable();

  static const db = ImmutableObjectWithTableRepository._();

  @override
  final int? id;

  final String variable;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ImmutableObjectWithTable]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ImmutableObjectWithTable copyWith({
    int? id,
    String? variable,
  });
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithTable &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.variable,
                  variable,
                ) ||
                other.variable == variable);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      id,
      variable,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImmutableObjectWithTable',
      if (id != null) 'id': id,
      'variable': variable,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImmutableObjectWithTable',
      if (id != null) 'id': id,
      'variable': variable,
    };
  }

  static ImmutableObjectWithTableInclude include() {
    return ImmutableObjectWithTableInclude.internal_();
  }

  static ImmutableObjectWithTableIncludeList includeList({
    _is.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    _is.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    ImmutableObjectWithTableInclude? include,
  }) {
    return ImmutableObjectWithTableIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImmutableObjectWithTableImpl extends ImmutableObjectWithTable {
  const _ImmutableObjectWithTableImpl({
    int? id,
    required String variable,
  }) : super._(
         id: id,
         variable: variable,
       );

  /// Returns a shallow copy of this [ImmutableObjectWithTable]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ImmutableObjectWithTable copyWith({
    Object? id = _Undefined,
    String? variable,
  }) {
    return ImmutableObjectWithTable(
      id: id is int? ? id : this.id,
      variable: variable ?? this.variable,
    );
  }
}

class ImmutableObjectWithTableUpdateTable
    extends _is.UpdateTable<ImmutableObjectWithTableTable> {
  ImmutableObjectWithTableUpdateTable(super.table);

  _is.ColumnValue<String, String> variable(String value) => _is.ColumnValue(
    table.variable,
    value,
  );
}

class ImmutableObjectWithTableTable extends _is.Table<int?> {
  ImmutableObjectWithTableTable({super.tableRelation})
    : super(tableName: 'immutable_object_with_table') {
    updateTable = ImmutableObjectWithTableUpdateTable(this);
    variable = _is.ColumnString(
      'variable',
      this,
    );
  }

  late final ImmutableObjectWithTableUpdateTable updateTable;

  late final _is.ColumnString variable;

  @override
  List<_is.Column> get columns => [
    id,
    variable,
  ];
}

class ImmutableObjectWithTableInclude extends _is.IncludeObject {
  ImmutableObjectWithTableInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ImmutableObjectWithTable.t;
}

class ImmutableObjectWithTableIncludeList extends _is.IncludeList {
  ImmutableObjectWithTableIncludeList.internal_({
    _is.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ImmutableObjectWithTable.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ImmutableObjectWithTable.t;
}

class ImmutableObjectWithTableRepository {
  const ImmutableObjectWithTableRepository._();

  /// Returns a list of [ImmutableObjectWithTable]s matching the given query parameters.
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
  Future<List<ImmutableObjectWithTable>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    _is.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ImmutableObjectWithTable>(
      where: where?.call(ImmutableObjectWithTable.t),
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ImmutableObjectWithTable] matching the given query parameters.
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
  Future<ImmutableObjectWithTable?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? offset,
    _is.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    _is.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ImmutableObjectWithTable>(
      where: where?.call(ImmutableObjectWithTable.t),
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ImmutableObjectWithTable] by its [id] or null if no such row exists.
  Future<ImmutableObjectWithTable?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ImmutableObjectWithTable>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ImmutableObjectWithTable]s in the list and returns the inserted rows.
  ///
  /// The returned [ImmutableObjectWithTable]s will have their `id` fields set.
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
  Future<List<ImmutableObjectWithTable>> insert(
    _is.DatabaseSession session,
    List<ImmutableObjectWithTable> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ImmutableObjectWithTable>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ImmutableObjectWithTable] and returns the inserted row.
  ///
  /// The returned [ImmutableObjectWithTable] will have its `id` field set.
  Future<ImmutableObjectWithTable> insertRow(
    _is.DatabaseSession session,
    ImmutableObjectWithTable row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ImmutableObjectWithTable>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ImmutableObjectWithTable]s in the list and returns the resulting rows.
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
  /// The returned [ImmutableObjectWithTable]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImmutableObjectWithTable>> upsert(
    _is.DatabaseSession session,
    List<ImmutableObjectWithTable> rows, {
    required _is.ColumnSelections<ImmutableObjectWithTableTable>
    conflictColumns,
    _is.ColumnSelections<ImmutableObjectWithTableTable>? updateColumns,
    _is.WhereExpressionBuilder<ImmutableObjectWithTableTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ImmutableObjectWithTable>(
      rows,
      conflictColumns: conflictColumns(ImmutableObjectWithTable.t),
      updateColumns: updateColumns?.call(ImmutableObjectWithTable.t),
      updateWhere: updateWhere?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ImmutableObjectWithTable] and returns the resulting row.
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
  /// The returned [ImmutableObjectWithTable] will have its `id` field set.
  Future<ImmutableObjectWithTable?> upsertRow(
    _is.DatabaseSession session,
    ImmutableObjectWithTable row, {
    required _is.ColumnSelections<ImmutableObjectWithTableTable>
    conflictColumns,
    _is.ColumnSelections<ImmutableObjectWithTableTable>? updateColumns,
    _is.WhereExpressionBuilder<ImmutableObjectWithTableTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ImmutableObjectWithTable>(
      row,
      conflictColumns: conflictColumns(ImmutableObjectWithTable.t),
      updateColumns: updateColumns?.call(ImmutableObjectWithTable.t),
      updateWhere: updateWhere?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
    );
  }

  /// Updates all [ImmutableObjectWithTable]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImmutableObjectWithTable>> update(
    _is.DatabaseSession session,
    List<ImmutableObjectWithTable> rows, {
    _is.ColumnSelections<ImmutableObjectWithTableTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ImmutableObjectWithTable>(
      rows,
      columns: columns?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ImmutableObjectWithTable]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ImmutableObjectWithTable> updateRow(
    _is.DatabaseSession session,
    ImmutableObjectWithTable row, {
    _is.ColumnSelections<ImmutableObjectWithTableTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ImmutableObjectWithTable>(
      row,
      columns: columns?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ImmutableObjectWithTable] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ImmutableObjectWithTable?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ImmutableObjectWithTableUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ImmutableObjectWithTable>(
      id,
      columnValues: columnValues(ImmutableObjectWithTable.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ImmutableObjectWithTable]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImmutableObjectWithTable>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ImmutableObjectWithTableUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ImmutableObjectWithTableTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    _is.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ImmutableObjectWithTable>(
      columnValues: columnValues(ImmutableObjectWithTable.t.updateTable),
      where: where(ImmutableObjectWithTable.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ImmutableObjectWithTable]s in the list and returns the deleted rows.
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
  Future<List<ImmutableObjectWithTable>> delete(
    _is.DatabaseSession session,
    List<ImmutableObjectWithTable> rows, {
    _is.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    _is.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ImmutableObjectWithTable>(
      rows,
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ImmutableObjectWithTable].
  Future<ImmutableObjectWithTable> deleteRow(
    _is.DatabaseSession session,
    ImmutableObjectWithTable row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ImmutableObjectWithTable>(
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
  Future<List<ImmutableObjectWithTable>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ImmutableObjectWithTableTable> where,
    _is.OrderByBuilder<ImmutableObjectWithTableTable>? orderBy,
    _is.OrderByListBuilder<ImmutableObjectWithTableTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ImmutableObjectWithTable>(
      where: where(ImmutableObjectWithTable.t),
      orderBy: orderBy?.call(ImmutableObjectWithTable.t),
      orderByList: orderByList?.call(ImmutableObjectWithTable.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ImmutableObjectWithTableTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ImmutableObjectWithTable>(
      where: where?.call(ImmutableObjectWithTable.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ImmutableObjectWithTable] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ImmutableObjectWithTableTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ImmutableObjectWithTable>(
      where: where(ImmutableObjectWithTable.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

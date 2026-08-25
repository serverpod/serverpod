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

abstract class BoolDefault
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BoolDefault._({
    this.id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  }) : boolDefaultTrue = boolDefaultTrue ?? true,
       boolDefaultFalse = boolDefaultFalse ?? false,
       boolDefaultNullFalse = boolDefaultNullFalse ?? false;

  factory BoolDefault({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  }) = _BoolDefaultImpl;

  factory BoolDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoolDefault(
      id: jsonSerialization['id'] as int?,
      boolDefaultTrue: jsonSerialization['boolDefaultTrue'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['boolDefaultTrue'],
            ),
      boolDefaultFalse: jsonSerialization['boolDefaultFalse'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['boolDefaultFalse'],
            ),
      boolDefaultNullFalse: jsonSerialization['boolDefaultNullFalse'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(
              jsonSerialization['boolDefaultNullFalse'],
            ),
    );
  }

  static final t = BoolDefaultTable();

  static const db = BoolDefaultRepository._();

  @override
  int? id;

  bool boolDefaultTrue;

  bool boolDefaultFalse;

  bool? boolDefaultNullFalse;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoolDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BoolDefault copyWith({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BoolDefault',
      if (id != null) 'id': id,
      'boolDefaultTrue': boolDefaultTrue,
      'boolDefaultFalse': boolDefaultFalse,
      if (boolDefaultNullFalse != null)
        'boolDefaultNullFalse': boolDefaultNullFalse,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BoolDefault',
      if (id != null) 'id': id,
      'boolDefaultTrue': boolDefaultTrue,
      'boolDefaultFalse': boolDefaultFalse,
      if (boolDefaultNullFalse != null)
        'boolDefaultNullFalse': boolDefaultNullFalse,
    };
  }

  static BoolDefaultInclude include({
    _is.SelectColumnsBuilder<BoolDefaultTable>? select,
  }) {
    return BoolDefaultInclude._(selectedColumns: select?.call(BoolDefault.t));
  }

  static BoolDefaultIncludeList includeList({
    _is.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    BoolDefaultInclude? include,
    _is.SelectColumnsBuilder<BoolDefaultTable>? select,
  }) {
    return BoolDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      include: include,
      selectedColumns: select?.call(BoolDefault.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoolDefaultImpl extends BoolDefault {
  _BoolDefaultImpl({
    int? id,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    bool? boolDefaultNullFalse,
  }) : super._(
         id: id,
         boolDefaultTrue: boolDefaultTrue,
         boolDefaultFalse: boolDefaultFalse,
         boolDefaultNullFalse: boolDefaultNullFalse,
       );

  /// Returns a shallow copy of this [BoolDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BoolDefault copyWith({
    Object? id = _Undefined,
    bool? boolDefaultTrue,
    bool? boolDefaultFalse,
    Object? boolDefaultNullFalse = _Undefined,
  }) {
    return BoolDefault(
      id: id is int? ? id : this.id,
      boolDefaultTrue: boolDefaultTrue ?? this.boolDefaultTrue,
      boolDefaultFalse: boolDefaultFalse ?? this.boolDefaultFalse,
      boolDefaultNullFalse: boolDefaultNullFalse is bool?
          ? boolDefaultNullFalse
          : this.boolDefaultNullFalse,
    );
  }
}

class BoolDefaultUpdateTable extends _is.UpdateTable<BoolDefaultTable> {
  BoolDefaultUpdateTable(super.table);

  _is.ColumnValue<bool, bool> boolDefaultTrue(bool value) => _is.ColumnValue(
    table.boolDefaultTrue,
    value,
  );

  _is.ColumnValue<bool, bool> boolDefaultFalse(bool value) => _is.ColumnValue(
    table.boolDefaultFalse,
    value,
  );

  _is.ColumnValue<bool, bool> boolDefaultNullFalse(bool? value) =>
      _is.ColumnValue(
        table.boolDefaultNullFalse,
        value,
      );
}

class BoolDefaultTable extends _is.Table<int?> {
  BoolDefaultTable({super.tableRelation}) : super(tableName: 'bool_default') {
    updateTable = BoolDefaultUpdateTable(this);
    boolDefaultTrue = _is.ColumnBool(
      'boolDefaultTrue',
      this,
      hasDefault: true,
    );
    boolDefaultFalse = _is.ColumnBool(
      'boolDefaultFalse',
      this,
      hasDefault: true,
    );
    boolDefaultNullFalse = _is.ColumnBool(
      'boolDefaultNullFalse',
      this,
      hasDefault: true,
    );
  }

  late final BoolDefaultUpdateTable updateTable;

  late final _is.ColumnBool boolDefaultTrue;

  late final _is.ColumnBool boolDefaultFalse;

  late final _is.ColumnBool boolDefaultNullFalse;

  @override
  List<_is.Column> get columns => [
    id,
    boolDefaultTrue,
    boolDefaultFalse,
    boolDefaultNullFalse,
  ];
}

class BoolDefaultInclude extends _is.IncludeObject {
  BoolDefaultInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BoolDefault.t;
}

class BoolDefaultIncludeList extends _is.IncludeList {
  BoolDefaultIncludeList._({
    _is.WhereExpressionBuilder<BoolDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(BoolDefault.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BoolDefault.t;
}

class BoolDefaultRepository {
  const BoolDefaultRepository._();

  /// Returns a list of [BoolDefault]s matching the given query parameters.
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
  Future<List<BoolDefault>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BoolDefault>(
      where: where?.call(BoolDefault.t),
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BoolDefault] matching the given query parameters.
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
  Future<BoolDefault?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BoolDefault>(
      where: where?.call(BoolDefault.t),
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BoolDefault] by its [id] or null if no such row exists.
  Future<BoolDefault?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BoolDefault>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BoolDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<BoolDefault>(
      where: where?.call(BoolDefault.t),
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(BoolDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BoolDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<BoolDefault>(
      where: where?.call(BoolDefault.t),
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(BoolDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BoolDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<BoolDefault>(
      id,
      transaction: transaction,
      select: select?.call(BoolDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BoolDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [BoolDefault]s will have their `id` fields set.
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
  Future<List<BoolDefault>> insert(
    _is.DatabaseSession session,
    List<BoolDefault> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BoolDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BoolDefault] and returns the inserted row.
  ///
  /// The returned [BoolDefault] will have its `id` field set.
  Future<BoolDefault> insertRow(
    _is.DatabaseSession session,
    BoolDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoolDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BoolDefault]s in the list and returns the resulting rows.
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
  /// The returned [BoolDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BoolDefault>> upsert(
    _is.DatabaseSession session,
    List<BoolDefault> rows, {
    required _is.ColumnSelections<BoolDefaultTable> conflictColumns,
    _is.ColumnSelections<BoolDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<BoolDefaultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BoolDefault>(
      rows,
      conflictColumns: conflictColumns(BoolDefault.t),
      updateColumns: updateColumns?.call(BoolDefault.t),
      updateWhere: updateWhere?.call(BoolDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BoolDefault] and returns the resulting row.
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
  /// The returned [BoolDefault] will have its `id` field set.
  Future<BoolDefault?> upsertRow(
    _is.DatabaseSession session,
    BoolDefault row, {
    required _is.ColumnSelections<BoolDefaultTable> conflictColumns,
    _is.ColumnSelections<BoolDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<BoolDefaultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BoolDefault>(
      row,
      conflictColumns: conflictColumns(BoolDefault.t),
      updateColumns: updateColumns?.call(BoolDefault.t),
      updateWhere: updateWhere?.call(BoolDefault.t),
      transaction: transaction,
    );
  }

  /// Updates all [BoolDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BoolDefault>> update(
    _is.DatabaseSession session,
    List<BoolDefault> rows, {
    _is.ColumnSelections<BoolDefaultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BoolDefault>(
      rows,
      columns: columns?.call(BoolDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BoolDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoolDefault> updateRow(
    _is.DatabaseSession session,
    BoolDefault row, {
    _is.ColumnSelections<BoolDefaultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoolDefault>(
      row,
      columns: columns?.call(BoolDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoolDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BoolDefault?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BoolDefaultUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BoolDefault>(
      id,
      columnValues: columnValues(BoolDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BoolDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BoolDefault>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BoolDefaultUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BoolDefaultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BoolDefault>(
      columnValues: columnValues(BoolDefault.t.updateTable),
      where: where(BoolDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BoolDefault]s in the list and returns the deleted rows.
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
  Future<List<BoolDefault>> delete(
    _is.DatabaseSession session,
    List<BoolDefault> rows, {
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BoolDefault>(
      rows,
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BoolDefault].
  Future<BoolDefault> deleteRow(
    _is.DatabaseSession session,
    BoolDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoolDefault>(
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
  Future<List<BoolDefault>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BoolDefaultTable> where,
    _is.OrderByBuilder<BoolDefaultTable>? orderBy,
    _is.OrderByListBuilder<BoolDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BoolDefault>(
      where: where(BoolDefault.t),
      orderBy: orderBy?.call(BoolDefault.t),
      orderByList: orderByList?.call(BoolDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BoolDefaultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BoolDefault>(
      where: where?.call(BoolDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BoolDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BoolDefaultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BoolDefault>(
      where: where(BoolDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

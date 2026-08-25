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

abstract class BigIntDefaultModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BigIntDefaultModel._({
    this.id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  }) : bigIntDefaultModelStr =
           bigIntDefaultModelStr ??
           BigInt.parse('1234567890123456789099999999'),
       bigIntDefaultModelStrNull =
           bigIntDefaultModelStrNull ??
           BigInt.parse('-1234567890123456789099999999');

  factory BigIntDefaultModel({
    int? id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  }) = _BigIntDefaultModelImpl;

  factory BigIntDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return BigIntDefaultModel(
      id: jsonSerialization['id'] as int?,
      bigIntDefaultModelStr: jsonSerialization['bigIntDefaultModelStr'] == null
          ? null
          : _is.BigIntJsonExtension.fromJson(
              jsonSerialization['bigIntDefaultModelStr'],
            ),
      bigIntDefaultModelStrNull:
          jsonSerialization['bigIntDefaultModelStrNull'] == null
          ? null
          : _is.BigIntJsonExtension.fromJson(
              jsonSerialization['bigIntDefaultModelStrNull'],
            ),
    );
  }

  static final t = BigIntDefaultModelTable();

  static const db = BigIntDefaultModelRepository._();

  @override
  int? id;

  BigInt bigIntDefaultModelStr;

  BigInt? bigIntDefaultModelStrNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BigIntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BigIntDefaultModel copyWith({
    int? id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BigIntDefaultModel',
      if (id != null) 'id': id,
      'bigIntDefaultModelStr': bigIntDefaultModelStr.toJson(),
      if (bigIntDefaultModelStrNull != null)
        'bigIntDefaultModelStrNull': bigIntDefaultModelStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BigIntDefaultModel',
      if (id != null) 'id': id,
      'bigIntDefaultModelStr': bigIntDefaultModelStr.toJson(),
      if (bigIntDefaultModelStrNull != null)
        'bigIntDefaultModelStrNull': bigIntDefaultModelStrNull?.toJson(),
    };
  }

  static BigIntDefaultModelInclude include({
    _is.SelectColumnsBuilder<BigIntDefaultModelTable>? select,
  }) {
    return BigIntDefaultModelInclude._(
      selectedColumns: select?.call(BigIntDefaultModel.t),
    );
  }

  static BigIntDefaultModelIncludeList includeList({
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    BigIntDefaultModelInclude? include,
    _is.SelectColumnsBuilder<BigIntDefaultModelTable>? select,
  }) {
    return BigIntDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      include: include,
      selectedColumns: select?.call(BigIntDefaultModel.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultModelImpl extends BigIntDefaultModel {
  _BigIntDefaultModelImpl({
    int? id,
    BigInt? bigIntDefaultModelStr,
    BigInt? bigIntDefaultModelStrNull,
  }) : super._(
         id: id,
         bigIntDefaultModelStr: bigIntDefaultModelStr,
         bigIntDefaultModelStrNull: bigIntDefaultModelStrNull,
       );

  /// Returns a shallow copy of this [BigIntDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BigIntDefaultModel copyWith({
    Object? id = _Undefined,
    BigInt? bigIntDefaultModelStr,
    Object? bigIntDefaultModelStrNull = _Undefined,
  }) {
    return BigIntDefaultModel(
      id: id is int? ? id : this.id,
      bigIntDefaultModelStr:
          bigIntDefaultModelStr ?? this.bigIntDefaultModelStr,
      bigIntDefaultModelStrNull: bigIntDefaultModelStrNull is BigInt?
          ? bigIntDefaultModelStrNull
          : this.bigIntDefaultModelStrNull,
    );
  }
}

class BigIntDefaultModelUpdateTable
    extends _is.UpdateTable<BigIntDefaultModelTable> {
  BigIntDefaultModelUpdateTable(super.table);

  _is.ColumnValue<BigInt, BigInt> bigIntDefaultModelStr(BigInt value) =>
      _is.ColumnValue(
        table.bigIntDefaultModelStr,
        value,
      );

  _is.ColumnValue<BigInt, BigInt> bigIntDefaultModelStrNull(BigInt? value) =>
      _is.ColumnValue(
        table.bigIntDefaultModelStrNull,
        value,
      );
}

class BigIntDefaultModelTable extends _is.Table<int?> {
  BigIntDefaultModelTable({super.tableRelation})
    : super(tableName: 'bigint_default_model') {
    updateTable = BigIntDefaultModelUpdateTable(this);
    bigIntDefaultModelStr = _is.ColumnBigInt(
      'bigIntDefaultModelStr',
      this,
    );
    bigIntDefaultModelStrNull = _is.ColumnBigInt(
      'bigIntDefaultModelStrNull',
      this,
    );
  }

  late final BigIntDefaultModelUpdateTable updateTable;

  late final _is.ColumnBigInt bigIntDefaultModelStr;

  late final _is.ColumnBigInt bigIntDefaultModelStrNull;

  @override
  List<_is.Column> get columns => [
    id,
    bigIntDefaultModelStr,
    bigIntDefaultModelStrNull,
  ];
}

class BigIntDefaultModelInclude extends _is.IncludeObject {
  BigIntDefaultModelInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BigIntDefaultModel.t;
}

class BigIntDefaultModelIncludeList extends _is.IncludeList {
  BigIntDefaultModelIncludeList._({
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(BigIntDefaultModel.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BigIntDefaultModel.t;
}

class BigIntDefaultModelRepository {
  const BigIntDefaultModelRepository._();

  /// Returns a list of [BigIntDefaultModel]s matching the given query parameters.
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
  Future<List<BigIntDefaultModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BigIntDefaultModel>(
      where: where?.call(BigIntDefaultModel.t),
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BigIntDefaultModel] matching the given query parameters.
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
  Future<BigIntDefaultModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BigIntDefaultModel>(
      where: where?.call(BigIntDefaultModel.t),
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BigIntDefaultModel] by its [id] or null if no such row exists.
  Future<BigIntDefaultModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BigIntDefaultModel>(
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
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BigIntDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<BigIntDefaultModel>(
      where: where?.call(BigIntDefaultModel.t),
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(BigIntDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BigIntDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<BigIntDefaultModel>(
      where: where?.call(BigIntDefaultModel.t),
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(BigIntDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BigIntDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<BigIntDefaultModel>(
      id,
      transaction: transaction,
      select: select?.call(BigIntDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BigIntDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [BigIntDefaultModel]s will have their `id` fields set.
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
  Future<List<BigIntDefaultModel>> insert(
    _is.DatabaseSession session,
    List<BigIntDefaultModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BigIntDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BigIntDefaultModel] and returns the inserted row.
  ///
  /// The returned [BigIntDefaultModel] will have its `id` field set.
  Future<BigIntDefaultModel> insertRow(
    _is.DatabaseSession session,
    BigIntDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BigIntDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BigIntDefaultModel]s in the list and returns the resulting rows.
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
  /// The returned [BigIntDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BigIntDefaultModel>> upsert(
    _is.DatabaseSession session,
    List<BigIntDefaultModel> rows, {
    required _is.ColumnSelections<BigIntDefaultModelTable> conflictColumns,
    _is.ColumnSelections<BigIntDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BigIntDefaultModel>(
      rows,
      conflictColumns: conflictColumns(BigIntDefaultModel.t),
      updateColumns: updateColumns?.call(BigIntDefaultModel.t),
      updateWhere: updateWhere?.call(BigIntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BigIntDefaultModel] and returns the resulting row.
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
  /// The returned [BigIntDefaultModel] will have its `id` field set.
  Future<BigIntDefaultModel?> upsertRow(
    _is.DatabaseSession session,
    BigIntDefaultModel row, {
    required _is.ColumnSelections<BigIntDefaultModelTable> conflictColumns,
    _is.ColumnSelections<BigIntDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BigIntDefaultModel>(
      row,
      conflictColumns: conflictColumns(BigIntDefaultModel.t),
      updateColumns: updateColumns?.call(BigIntDefaultModel.t),
      updateWhere: updateWhere?.call(BigIntDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [BigIntDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BigIntDefaultModel>> update(
    _is.DatabaseSession session,
    List<BigIntDefaultModel> rows, {
    _is.ColumnSelections<BigIntDefaultModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BigIntDefaultModel>(
      rows,
      columns: columns?.call(BigIntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BigIntDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BigIntDefaultModel> updateRow(
    _is.DatabaseSession session,
    BigIntDefaultModel row, {
    _is.ColumnSelections<BigIntDefaultModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BigIntDefaultModel>(
      row,
      columns: columns?.call(BigIntDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BigIntDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BigIntDefaultModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BigIntDefaultModelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BigIntDefaultModel>(
      id,
      columnValues: columnValues(BigIntDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BigIntDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BigIntDefaultModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BigIntDefaultModelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<BigIntDefaultModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BigIntDefaultModel>(
      columnValues: columnValues(BigIntDefaultModel.t.updateTable),
      where: where(BigIntDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BigIntDefaultModel]s in the list and returns the deleted rows.
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
  Future<List<BigIntDefaultModel>> delete(
    _is.DatabaseSession session,
    List<BigIntDefaultModel> rows, {
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BigIntDefaultModel>(
      rows,
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BigIntDefaultModel].
  Future<BigIntDefaultModel> deleteRow(
    _is.DatabaseSession session,
    BigIntDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BigIntDefaultModel>(
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
  Future<List<BigIntDefaultModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BigIntDefaultModelTable> where,
    _is.OrderByBuilder<BigIntDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BigIntDefaultModel>(
      where: where(BigIntDefaultModel.t),
      orderBy: orderBy?.call(BigIntDefaultModel.t),
      orderByList: orderByList?.call(BigIntDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BigIntDefaultModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BigIntDefaultModel>(
      where: where?.call(BigIntDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BigIntDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BigIntDefaultModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BigIntDefaultModel>(
      where: where(BigIntDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

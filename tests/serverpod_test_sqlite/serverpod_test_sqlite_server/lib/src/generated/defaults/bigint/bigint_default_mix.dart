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

abstract class BigIntDefaultMix
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BigIntDefaultMix._({
    this.id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) : bigIntDefaultAndDefaultModel =
           bigIntDefaultAndDefaultModel ?? BigInt.parse('2'),
       bigIntDefaultAndDefaultPersist =
           bigIntDefaultAndDefaultPersist ??
           BigInt.parse('-12345678901234567890'),
       bigIntDefaultModelAndDefaultPersist =
           bigIntDefaultModelAndDefaultPersist ??
           BigInt.parse('1234567890123456789099999999');

  factory BigIntDefaultMix({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) = _BigIntDefaultMixImpl;

  factory BigIntDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return BigIntDefaultMix(
      id: jsonSerialization['id'] as int?,
      bigIntDefaultAndDefaultModel:
          jsonSerialization['bigIntDefaultAndDefaultModel'] == null
          ? null
          : _is.BigIntJsonExtension.fromJson(
              jsonSerialization['bigIntDefaultAndDefaultModel'],
            ),
      bigIntDefaultAndDefaultPersist:
          jsonSerialization['bigIntDefaultAndDefaultPersist'] == null
          ? null
          : _is.BigIntJsonExtension.fromJson(
              jsonSerialization['bigIntDefaultAndDefaultPersist'],
            ),
      bigIntDefaultModelAndDefaultPersist:
          jsonSerialization['bigIntDefaultModelAndDefaultPersist'] == null
          ? null
          : _is.BigIntJsonExtension.fromJson(
              jsonSerialization['bigIntDefaultModelAndDefaultPersist'],
            ),
    );
  }

  static final t = BigIntDefaultMixTable();

  static const db = BigIntDefaultMixRepository._();

  @override
  int? id;

  BigInt bigIntDefaultAndDefaultModel;

  BigInt bigIntDefaultAndDefaultPersist;

  BigInt bigIntDefaultModelAndDefaultPersist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BigIntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BigIntDefaultMix copyWith({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BigIntDefaultMix',
      if (id != null) 'id': id,
      'bigIntDefaultAndDefaultModel': bigIntDefaultAndDefaultModel.toJson(),
      'bigIntDefaultAndDefaultPersist': bigIntDefaultAndDefaultPersist.toJson(),
      'bigIntDefaultModelAndDefaultPersist': bigIntDefaultModelAndDefaultPersist
          .toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BigIntDefaultMix',
      if (id != null) 'id': id,
      'bigIntDefaultAndDefaultModel': bigIntDefaultAndDefaultModel.toJson(),
      'bigIntDefaultAndDefaultPersist': bigIntDefaultAndDefaultPersist.toJson(),
      'bigIntDefaultModelAndDefaultPersist': bigIntDefaultModelAndDefaultPersist
          .toJson(),
    };
  }

  static BigIntDefaultMixInclude include({
    _is.SelectColumnsBuilder<BigIntDefaultMixTable>? select,
  }) {
    return BigIntDefaultMixInclude._(
      selectedColumns: select?.call(BigIntDefaultMix.t),
    );
  }

  static BigIntDefaultMixIncludeList includeList({
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    BigIntDefaultMixInclude? include,
    _is.SelectColumnsBuilder<BigIntDefaultMixTable>? select,
  }) {
    return BigIntDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      include: include,
      selectedColumns: select?.call(BigIntDefaultMix.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BigIntDefaultMixImpl extends BigIntDefaultMix {
  _BigIntDefaultMixImpl({
    int? id,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         bigIntDefaultAndDefaultModel: bigIntDefaultAndDefaultModel,
         bigIntDefaultAndDefaultPersist: bigIntDefaultAndDefaultPersist,
         bigIntDefaultModelAndDefaultPersist:
             bigIntDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [BigIntDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BigIntDefaultMix copyWith({
    Object? id = _Undefined,
    BigInt? bigIntDefaultAndDefaultModel,
    BigInt? bigIntDefaultAndDefaultPersist,
    BigInt? bigIntDefaultModelAndDefaultPersist,
  }) {
    return BigIntDefaultMix(
      id: id is int? ? id : this.id,
      bigIntDefaultAndDefaultModel:
          bigIntDefaultAndDefaultModel ?? this.bigIntDefaultAndDefaultModel,
      bigIntDefaultAndDefaultPersist:
          bigIntDefaultAndDefaultPersist ?? this.bigIntDefaultAndDefaultPersist,
      bigIntDefaultModelAndDefaultPersist:
          bigIntDefaultModelAndDefaultPersist ??
          this.bigIntDefaultModelAndDefaultPersist,
    );
  }
}

class BigIntDefaultMixUpdateTable
    extends _is.UpdateTable<BigIntDefaultMixTable> {
  BigIntDefaultMixUpdateTable(super.table);

  _is.ColumnValue<BigInt, BigInt> bigIntDefaultAndDefaultModel(BigInt value) =>
      _is.ColumnValue(
        table.bigIntDefaultAndDefaultModel,
        value,
      );

  _is.ColumnValue<BigInt, BigInt> bigIntDefaultAndDefaultPersist(
    BigInt value,
  ) => _is.ColumnValue(
    table.bigIntDefaultAndDefaultPersist,
    value,
  );

  _is.ColumnValue<BigInt, BigInt> bigIntDefaultModelAndDefaultPersist(
    BigInt value,
  ) => _is.ColumnValue(
    table.bigIntDefaultModelAndDefaultPersist,
    value,
  );
}

class BigIntDefaultMixTable extends _is.Table<int?> {
  BigIntDefaultMixTable({super.tableRelation})
    : super(tableName: 'bigint_default_mix') {
    updateTable = BigIntDefaultMixUpdateTable(this);
    bigIntDefaultAndDefaultModel = _is.ColumnBigInt(
      'bigIntDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    bigIntDefaultAndDefaultPersist = _is.ColumnBigInt(
      'bigIntDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    bigIntDefaultModelAndDefaultPersist = _is.ColumnBigInt(
      'bigIntDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final BigIntDefaultMixUpdateTable updateTable;

  late final _is.ColumnBigInt bigIntDefaultAndDefaultModel;

  late final _is.ColumnBigInt bigIntDefaultAndDefaultPersist;

  late final _is.ColumnBigInt bigIntDefaultModelAndDefaultPersist;

  @override
  List<_is.Column> get columns => [
    id,
    bigIntDefaultAndDefaultModel,
    bigIntDefaultAndDefaultPersist,
    bigIntDefaultModelAndDefaultPersist,
  ];
}

class BigIntDefaultMixInclude extends _is.IncludeObject {
  BigIntDefaultMixInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BigIntDefaultMix.t;
}

class BigIntDefaultMixIncludeList extends _is.IncludeList {
  BigIntDefaultMixIncludeList._({
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(BigIntDefaultMix.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BigIntDefaultMix.t;
}

class BigIntDefaultMixRepository {
  const BigIntDefaultMixRepository._();

  /// Returns a list of [BigIntDefaultMix]s matching the given query parameters.
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
  Future<List<BigIntDefaultMix>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BigIntDefaultMix] matching the given query parameters.
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
  Future<BigIntDefaultMix?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BigIntDefaultMix] by its [id] or null if no such row exists.
  Future<BigIntDefaultMix?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BigIntDefaultMix>(
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
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BigIntDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(BigIntDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<BigIntDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(BigIntDefaultMix.t),
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
    _is.SelectColumnsBuilder<BigIntDefaultMixTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<BigIntDefaultMix>(
      id,
      transaction: transaction,
      select: select?.call(BigIntDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BigIntDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [BigIntDefaultMix]s will have their `id` fields set.
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
  Future<List<BigIntDefaultMix>> insert(
    _is.DatabaseSession session,
    List<BigIntDefaultMix> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BigIntDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BigIntDefaultMix] and returns the inserted row.
  ///
  /// The returned [BigIntDefaultMix] will have its `id` field set.
  Future<BigIntDefaultMix> insertRow(
    _is.DatabaseSession session,
    BigIntDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BigIntDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BigIntDefaultMix]s in the list and returns the resulting rows.
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
  /// The returned [BigIntDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BigIntDefaultMix>> upsert(
    _is.DatabaseSession session,
    List<BigIntDefaultMix> rows, {
    required _is.ColumnSelections<BigIntDefaultMixTable> conflictColumns,
    _is.ColumnSelections<BigIntDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BigIntDefaultMix>(
      rows,
      conflictColumns: conflictColumns(BigIntDefaultMix.t),
      updateColumns: updateColumns?.call(BigIntDefaultMix.t),
      updateWhere: updateWhere?.call(BigIntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BigIntDefaultMix] and returns the resulting row.
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
  /// The returned [BigIntDefaultMix] will have its `id` field set.
  Future<BigIntDefaultMix?> upsertRow(
    _is.DatabaseSession session,
    BigIntDefaultMix row, {
    required _is.ColumnSelections<BigIntDefaultMixTable> conflictColumns,
    _is.ColumnSelections<BigIntDefaultMixTable>? updateColumns,
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BigIntDefaultMix>(
      row,
      conflictColumns: conflictColumns(BigIntDefaultMix.t),
      updateColumns: updateColumns?.call(BigIntDefaultMix.t),
      updateWhere: updateWhere?.call(BigIntDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates all [BigIntDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BigIntDefaultMix>> update(
    _is.DatabaseSession session,
    List<BigIntDefaultMix> rows, {
    _is.ColumnSelections<BigIntDefaultMixTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BigIntDefaultMix>(
      rows,
      columns: columns?.call(BigIntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BigIntDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BigIntDefaultMix> updateRow(
    _is.DatabaseSession session,
    BigIntDefaultMix row, {
    _is.ColumnSelections<BigIntDefaultMixTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BigIntDefaultMix>(
      row,
      columns: columns?.call(BigIntDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BigIntDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BigIntDefaultMix?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BigIntDefaultMixUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BigIntDefaultMix>(
      id,
      columnValues: columnValues(BigIntDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BigIntDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BigIntDefaultMix>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BigIntDefaultMixUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<BigIntDefaultMixTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BigIntDefaultMix>(
      columnValues: columnValues(BigIntDefaultMix.t.updateTable),
      where: where(BigIntDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BigIntDefaultMix]s in the list and returns the deleted rows.
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
  Future<List<BigIntDefaultMix>> delete(
    _is.DatabaseSession session,
    List<BigIntDefaultMix> rows, {
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BigIntDefaultMix>(
      rows,
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BigIntDefaultMix].
  Future<BigIntDefaultMix> deleteRow(
    _is.DatabaseSession session,
    BigIntDefaultMix row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BigIntDefaultMix>(
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
  Future<List<BigIntDefaultMix>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BigIntDefaultMixTable> where,
    _is.OrderByBuilder<BigIntDefaultMixTable>? orderBy,
    _is.OrderByListBuilder<BigIntDefaultMixTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BigIntDefaultMix>(
      where: where(BigIntDefaultMix.t),
      orderBy: orderBy?.call(BigIntDefaultMix.t),
      orderByList: orderByList?.call(BigIntDefaultMix.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BigIntDefaultMixTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BigIntDefaultMix>(
      where: where?.call(BigIntDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BigIntDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BigIntDefaultMixTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BigIntDefaultMix>(
      where: where(BigIntDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

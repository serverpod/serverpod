/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../../../models_with_relations/self_relation/many_to_many/member.dart'
    as _iubhvl5a;

abstract class Blocking
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Blocking._({
    this.id,
    required this.blockedId,
    this.blocked,
    required this.blockedById,
    this.blockedBy,
  });

  factory Blocking({
    int? id,
    required int blockedId,
    _iubhvl5a.Member? blocked,
    required int blockedById,
    _iubhvl5a.Member? blockedBy,
  }) = _BlockingImpl;

  factory Blocking.fromJson(Map<String, dynamic> jsonSerialization) {
    return Blocking(
      id: jsonSerialization['id'] as int?,
      blockedId: jsonSerialization['blockedId'] as int,
      blocked: jsonSerialization['blocked'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iubhvl5a.Member>(
              jsonSerialization['blocked'],
            ),
      blockedById: jsonSerialization['blockedById'] as int,
      blockedBy: jsonSerialization['blockedBy'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iubhvl5a.Member>(
              jsonSerialization['blockedBy'],
            ),
    );
  }

  static final t = BlockingTable();

  static const db = BlockingRepository._();

  @override
  int? id;

  int blockedId;

  _iubhvl5a.Member? blocked;

  int blockedById;

  _iubhvl5a.Member? blockedBy;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Blocking]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Blocking copyWith({
    int? id,
    int? blockedId,
    _iubhvl5a.Member? blocked,
    int? blockedById,
    _iubhvl5a.Member? blockedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Blocking',
      if (id != null) 'id': id,
      'blockedId': blockedId,
      if (blocked != null) 'blocked': blocked?.toJson(),
      'blockedById': blockedById,
      if (blockedBy != null) 'blockedBy': blockedBy?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Blocking',
      if (id != null) 'id': id,
      'blockedId': blockedId,
      if (blocked != null) 'blocked': blocked?.toJsonForProtocol(),
      'blockedById': blockedById,
      if (blockedBy != null) 'blockedBy': blockedBy?.toJsonForProtocol(),
    };
  }

  static BlockingInclude include({
    _iubhvl5a.MemberInclude? blocked,
    _iubhvl5a.MemberInclude? blockedBy,
    _is.SelectColumnsBuilder<BlockingTable>? select,
  }) {
    return BlockingInclude._(
      blocked: blocked,
      blockedBy: blockedBy,
      selectedColumns: select?.call(Blocking.t),
    );
  }

  static BlockingIncludeList includeList({
    _is.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    BlockingInclude? include,
    _is.SelectColumnsBuilder<BlockingTable>? select,
  }) {
    return BlockingIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      include: include,
      selectedColumns: select?.call(Blocking.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BlockingImpl extends Blocking {
  _BlockingImpl({
    int? id,
    required int blockedId,
    _iubhvl5a.Member? blocked,
    required int blockedById,
    _iubhvl5a.Member? blockedBy,
  }) : super._(
         id: id,
         blockedId: blockedId,
         blocked: blocked,
         blockedById: blockedById,
         blockedBy: blockedBy,
       );

  /// Returns a shallow copy of this [Blocking]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Blocking copyWith({
    Object? id = _Undefined,
    int? blockedId,
    Object? blocked = _Undefined,
    int? blockedById,
    Object? blockedBy = _Undefined,
  }) {
    return Blocking(
      id: id is int? ? id : this.id,
      blockedId: blockedId ?? this.blockedId,
      blocked: blocked is _iubhvl5a.Member?
          ? blocked
          : this.blocked?.copyWith(),
      blockedById: blockedById ?? this.blockedById,
      blockedBy: blockedBy is _iubhvl5a.Member?
          ? blockedBy
          : this.blockedBy?.copyWith(),
    );
  }
}

class BlockingUpdateTable extends _is.UpdateTable<BlockingTable> {
  BlockingUpdateTable(super.table);

  _is.ColumnValue<int, int> blockedId(int value) => _is.ColumnValue(
    table.blockedId,
    value,
  );

  _is.ColumnValue<int, int> blockedById(int value) => _is.ColumnValue(
    table.blockedById,
    value,
  );
}

class BlockingTable extends _is.Table<int?> {
  BlockingTable({super.tableRelation}) : super(tableName: 'blocking') {
    updateTable = BlockingUpdateTable(this);
    blockedId = _is.ColumnInt(
      'blockedId',
      this,
    );
    blockedById = _is.ColumnInt(
      'blockedById',
      this,
    );
  }

  late final BlockingUpdateTable updateTable;

  late final _is.ColumnInt blockedId;

  _iubhvl5a.MemberTable? _blocked;

  late final _is.ColumnInt blockedById;

  _iubhvl5a.MemberTable? _blockedBy;

  _iubhvl5a.MemberTable get blocked {
    if (_blocked != null) return _blocked!;
    _blocked = _is.createRelationTable(
      relationFieldName: 'blocked',
      field: Blocking.t.blockedId,
      foreignField: _iubhvl5a.Member.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iubhvl5a.MemberTable(tableRelation: foreignTableRelation),
    );
    return _blocked!;
  }

  _iubhvl5a.MemberTable get blockedBy {
    if (_blockedBy != null) return _blockedBy!;
    _blockedBy = _is.createRelationTable(
      relationFieldName: 'blockedBy',
      field: Blocking.t.blockedById,
      foreignField: _iubhvl5a.Member.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iubhvl5a.MemberTable(tableRelation: foreignTableRelation),
    );
    return _blockedBy!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    blockedId,
    blockedById,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'blocked') {
      return blocked;
    }
    if (relationField == 'blockedBy') {
      return blockedBy;
    }
    return null;
  }
}

class BlockingInclude extends _is.IncludeObject {
  BlockingInclude._({
    _iubhvl5a.MemberInclude? blocked,
    _iubhvl5a.MemberInclude? blockedBy,
    this.selectedColumns,
  }) {
    _blocked = blocked;
    _blockedBy = blockedBy;
  }

  _iubhvl5a.MemberInclude? _blocked;

  _iubhvl5a.MemberInclude? _blockedBy;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'blocked': _blocked,
    'blockedBy': _blockedBy,
  };

  @override
  _is.Table<int?> get table => Blocking.t;
}

class BlockingIncludeList extends _is.IncludeList {
  BlockingIncludeList._({
    _is.WhereExpressionBuilder<BlockingTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Blocking.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Blocking.t;
}

class BlockingRepository {
  const BlockingRepository._();

  final attachRow = const BlockingAttachRowRepository._();

  /// Returns a list of [Blocking]s matching the given query parameters.
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
  Future<List<Blocking>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    _is.Transaction? transaction,
    BlockingInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Blocking>(
      where: where?.call(Blocking.t),
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Blocking] matching the given query parameters.
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
  Future<Blocking?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BlockingTable>? where,
    int? offset,
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    _is.Transaction? transaction,
    BlockingInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Blocking>(
      where: where?.call(Blocking.t),
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Blocking] by its [id] or null if no such row exists.
  Future<Blocking?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    BlockingInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Blocking>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    _is.Transaction? transaction,
    BlockingInclude? include,
    _is.SelectColumnsBuilder<BlockingTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Blocking>(
      where: where?.call(Blocking.t),
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Blocking.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BlockingTable>? where,
    int? offset,
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    _is.Transaction? transaction,
    BlockingInclude? include,
    _is.SelectColumnsBuilder<BlockingTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Blocking>(
      where: where?.call(Blocking.t),
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Blocking.t),
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
    BlockingInclude? include,
    _is.SelectColumnsBuilder<BlockingTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Blocking>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Blocking.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Blocking]s in the list and returns the inserted rows.
  ///
  /// The returned [Blocking]s will have their `id` fields set.
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
  Future<List<Blocking>> insert(
    _is.DatabaseSession session,
    List<Blocking> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Blocking>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Blocking] and returns the inserted row.
  ///
  /// The returned [Blocking] will have its `id` field set.
  Future<Blocking> insertRow(
    _is.DatabaseSession session,
    Blocking row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Blocking>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Blocking]s in the list and returns the resulting rows.
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
  /// The returned [Blocking]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Blocking>> upsert(
    _is.DatabaseSession session,
    List<Blocking> rows, {
    required _is.ColumnSelections<BlockingTable> conflictColumns,
    _is.ColumnSelections<BlockingTable>? updateColumns,
    _is.WhereExpressionBuilder<BlockingTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Blocking>(
      rows,
      conflictColumns: conflictColumns(Blocking.t),
      updateColumns: updateColumns?.call(Blocking.t),
      updateWhere: updateWhere?.call(Blocking.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Blocking] and returns the resulting row.
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
  /// The returned [Blocking] will have its `id` field set.
  Future<Blocking?> upsertRow(
    _is.DatabaseSession session,
    Blocking row, {
    required _is.ColumnSelections<BlockingTable> conflictColumns,
    _is.ColumnSelections<BlockingTable>? updateColumns,
    _is.WhereExpressionBuilder<BlockingTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Blocking>(
      row,
      conflictColumns: conflictColumns(Blocking.t),
      updateColumns: updateColumns?.call(Blocking.t),
      updateWhere: updateWhere?.call(Blocking.t),
      transaction: transaction,
    );
  }

  /// Updates all [Blocking]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Blocking>> update(
    _is.DatabaseSession session,
    List<Blocking> rows, {
    _is.ColumnSelections<BlockingTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Blocking>(
      rows,
      columns: columns?.call(Blocking.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Blocking]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Blocking> updateRow(
    _is.DatabaseSession session,
    Blocking row, {
    _is.ColumnSelections<BlockingTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Blocking>(
      row,
      columns: columns?.call(Blocking.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Blocking] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Blocking?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BlockingUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Blocking>(
      id,
      columnValues: columnValues(Blocking.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Blocking]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Blocking>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BlockingUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BlockingTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Blocking>(
      columnValues: columnValues(Blocking.t.updateTable),
      where: where(Blocking.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Blocking]s in the list and returns the deleted rows.
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
  Future<List<Blocking>> delete(
    _is.DatabaseSession session,
    List<Blocking> rows, {
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Blocking>(
      rows,
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Blocking].
  Future<Blocking> deleteRow(
    _is.DatabaseSession session,
    Blocking row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Blocking>(
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
  Future<List<Blocking>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BlockingTable> where,
    _is.OrderByBuilder<BlockingTable>? orderBy,
    _is.OrderByListBuilder<BlockingTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Blocking>(
      where: where(Blocking.t),
      orderBy: orderBy?.call(Blocking.t),
      orderByList: orderByList?.call(Blocking.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BlockingTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Blocking>(
      where: where?.call(Blocking.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Blocking] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BlockingTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Blocking>(
      where: where(Blocking.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class BlockingAttachRowRepository {
  const BlockingAttachRowRepository._();

  /// Creates a relation between the given [Blocking] and [Member]
  /// by setting the [Blocking]'s foreign key `blockedId` to refer to the [Member].
  Future<void> blocked(
    _is.DatabaseSession session,
    Blocking blocking,
    _iubhvl5a.Member blocked, {
    _is.Transaction? transaction,
  }) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (blocked.id == null) {
      throw ArgumentError.notNull('blocked.id');
    }

    var $blocking = blocking.copyWith(blockedId: blocked.id);
    await session.db.updateRow<Blocking>(
      $blocking,
      columns: [Blocking.t.blockedId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Blocking] and [Member]
  /// by setting the [Blocking]'s foreign key `blockedById` to refer to the [Member].
  Future<void> blockedBy(
    _is.DatabaseSession session,
    Blocking blocking,
    _iubhvl5a.Member blockedBy, {
    _is.Transaction? transaction,
  }) async {
    if (blocking.id == null) {
      throw ArgumentError.notNull('blocking.id');
    }
    if (blockedBy.id == null) {
      throw ArgumentError.notNull('blockedBy.id');
    }

    var $blocking = blocking.copyWith(blockedById: blockedBy.id);
    await session.db.updateRow<Blocking>(
      $blocking,
      columns: [Blocking.t.blockedById],
      transaction: transaction,
    );
  }
}

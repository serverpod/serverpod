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

abstract class ObjectWithIndex
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithIndex._({
    this.id,
    required this.indexed,
    required this.indexed2,
  });

  factory ObjectWithIndex({
    int? id,
    required int indexed,
    required int indexed2,
  }) = _ObjectWithIndexImpl;

  factory ObjectWithIndex.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithIndex(
      id: jsonSerialization['id'] as int?,
      indexed: jsonSerialization['indexed'] as int,
      indexed2: jsonSerialization['indexed2'] as int,
    );
  }

  static final t = ObjectWithIndexTable();

  static const db = ObjectWithIndexRepository._();

  @override
  int? id;

  int indexed;

  int indexed2;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithIndex]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithIndex copyWith({
    int? id,
    int? indexed,
    int? indexed2,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithIndex',
      if (id != null) 'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithIndex',
      if (id != null) 'id': id,
      'indexed': indexed,
      'indexed2': indexed2,
    };
  }

  static ObjectWithIndexInclude include() {
    return ObjectWithIndexInclude.internal_();
  }

  static ObjectWithIndexIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    ObjectWithIndexInclude? include,
  }) {
    return ObjectWithIndexIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithIndexImpl extends ObjectWithIndex {
  _ObjectWithIndexImpl({
    int? id,
    required int indexed,
    required int indexed2,
  }) : super._(
         id: id,
         indexed: indexed,
         indexed2: indexed2,
       );

  /// Returns a shallow copy of this [ObjectWithIndex]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithIndex copyWith({
    Object? id = _Undefined,
    int? indexed,
    int? indexed2,
  }) {
    return ObjectWithIndex(
      id: id is int? ? id : this.id,
      indexed: indexed ?? this.indexed,
      indexed2: indexed2 ?? this.indexed2,
    );
  }
}

class ObjectWithIndexUpdateTable extends _is.UpdateTable<ObjectWithIndexTable> {
  ObjectWithIndexUpdateTable(super.table);

  _is.ColumnValue<int, int> indexed(int value) => _is.ColumnValue(
    table.indexed,
    value,
  );

  _is.ColumnValue<int, int> indexed2(int value) => _is.ColumnValue(
    table.indexed2,
    value,
  );
}

class ObjectWithIndexTable extends _is.Table<int?> {
  ObjectWithIndexTable({super.tableRelation})
    : super(tableName: 'object_with_index') {
    updateTable = ObjectWithIndexUpdateTable(this);
    indexed = _is.ColumnInt(
      'indexed',
      this,
    );
    indexed2 = _is.ColumnInt(
      'indexed2',
      this,
    );
  }

  late final ObjectWithIndexUpdateTable updateTable;

  late final _is.ColumnInt indexed;

  late final _is.ColumnInt indexed2;

  @override
  List<_is.Column> get columns => [
    id,
    indexed,
    indexed2,
  ];
}

class ObjectWithIndexInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  ObjectWithIndexInclude.internal_({List<_is.Column>? this.selectedColumns}) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithIndex.t;
}

class ObjectWithIndexIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  ObjectWithIndexIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithIndex.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithIndex.t;
}

class ObjectWithIndexRepository {
  const ObjectWithIndexRepository._();

  /// Returns a list of [ObjectWithIndex]s matching the given query parameters.
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
  Future<List<ObjectWithIndex>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithIndex>(
      where: where?.call(ObjectWithIndex.t),
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithIndex] matching the given query parameters.
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
  Future<ObjectWithIndex?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithIndex>(
      where: where?.call(ObjectWithIndex.t),
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithIndex] by its [id] or null if no such row exists.
  Future<ObjectWithIndex?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithIndex>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithIndex]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithIndex]s will have their `id` fields set.
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
  Future<List<ObjectWithIndex>> insert(
    _is.DatabaseSession session,
    List<ObjectWithIndex> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithIndex>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithIndex] and returns the inserted row.
  ///
  /// The returned [ObjectWithIndex] will have its `id` field set.
  Future<ObjectWithIndex> insertRow(
    _is.DatabaseSession session,
    ObjectWithIndex row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithIndex>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithIndex]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithIndex]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithIndex>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithIndex> rows, {
    required _is.ColumnSelections<ObjectWithIndexTable> conflictColumns,
    _is.ColumnSelections<ObjectWithIndexTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithIndexTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithIndex>(
      rows,
      conflictColumns: conflictColumns(ObjectWithIndex.t),
      updateColumns: updateColumns?.call(ObjectWithIndex.t),
      updateWhere: updateWhere?.call(ObjectWithIndex.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithIndex] and returns the resulting row.
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
  /// The returned [ObjectWithIndex] will have its `id` field set.
  Future<ObjectWithIndex?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithIndex row, {
    required _is.ColumnSelections<ObjectWithIndexTable> conflictColumns,
    _is.ColumnSelections<ObjectWithIndexTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithIndexTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithIndex>(
      row,
      conflictColumns: conflictColumns(ObjectWithIndex.t),
      updateColumns: updateColumns?.call(ObjectWithIndex.t),
      updateWhere: updateWhere?.call(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithIndex]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithIndex>> update(
    _is.DatabaseSession session,
    List<ObjectWithIndex> rows, {
    _is.ColumnSelections<ObjectWithIndexTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithIndex>(
      rows,
      columns: columns?.call(ObjectWithIndex.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithIndex]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithIndex> updateRow(
    _is.DatabaseSession session,
    ObjectWithIndex row, {
    _is.ColumnSelections<ObjectWithIndexTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithIndex>(
      row,
      columns: columns?.call(ObjectWithIndex.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithIndex] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithIndex?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithIndexUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithIndex>(
      id,
      columnValues: columnValues(ObjectWithIndex.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithIndex]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithIndex>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithIndexUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithIndexTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithIndex>(
      columnValues: columnValues(ObjectWithIndex.t.updateTable),
      where: where(ObjectWithIndex.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithIndex]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithIndex>> delete(
    _is.DatabaseSession session,
    List<ObjectWithIndex> rows, {
    _is.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithIndex>(
      rows,
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithIndex].
  Future<ObjectWithIndex> deleteRow(
    _is.DatabaseSession session,
    ObjectWithIndex row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithIndex>(
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
  Future<List<ObjectWithIndex>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithIndexTable> where,
    _is.OrderByBuilder<ObjectWithIndexTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithIndexTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithIndex>(
      where: where(ObjectWithIndex.t),
      orderBy: orderBy?.call(ObjectWithIndex.t),
      orderByList: orderByList?.call(ObjectWithIndex.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithIndexTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithIndex>(
      where: where?.call(ObjectWithIndex.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithIndex] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithIndexTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithIndex>(
      where: where(ObjectWithIndex.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

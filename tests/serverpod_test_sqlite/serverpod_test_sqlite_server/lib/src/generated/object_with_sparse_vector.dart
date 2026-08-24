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

abstract class ObjectWithSparseVector
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithSparseVector._({
    this.id,
    required this.sparseVector,
    this.sparseVectorNullable,
    required this.sparseVectorIndexedHnsw,
    required this.sparseVectorIndexedHnswWithParams,
  });

  factory ObjectWithSparseVector({
    int? id,
    required _is.SparseVector sparseVector,
    _is.SparseVector? sparseVectorNullable,
    required _is.SparseVector sparseVectorIndexedHnsw,
    required _is.SparseVector sparseVectorIndexedHnswWithParams,
  }) = _ObjectWithSparseVectorImpl;

  factory ObjectWithSparseVector.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithSparseVector(
      id: jsonSerialization['id'] as int?,
      sparseVector: _is.SparseVectorJsonExtension.fromJson(
        jsonSerialization['sparseVector'],
      ),
      sparseVectorNullable: jsonSerialization['sparseVectorNullable'] == null
          ? null
          : _is.SparseVectorJsonExtension.fromJson(
              jsonSerialization['sparseVectorNullable'],
            ),
      sparseVectorIndexedHnsw: _is.SparseVectorJsonExtension.fromJson(
        jsonSerialization['sparseVectorIndexedHnsw'],
      ),
      sparseVectorIndexedHnswWithParams: _is.SparseVectorJsonExtension.fromJson(
        jsonSerialization['sparseVectorIndexedHnswWithParams'],
      ),
    );
  }

  static final t = ObjectWithSparseVectorTable();

  static const db = ObjectWithSparseVectorRepository._();

  @override
  int? id;

  _is.SparseVector sparseVector;

  _is.SparseVector? sparseVectorNullable;

  _is.SparseVector sparseVectorIndexedHnsw;

  _is.SparseVector sparseVectorIndexedHnswWithParams;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithSparseVector copyWith({
    int? id,
    _is.SparseVector? sparseVector,
    _is.SparseVector? sparseVectorNullable,
    _is.SparseVector? sparseVectorIndexedHnsw,
    _is.SparseVector? sparseVectorIndexedHnswWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithSparseVector',
      if (id != null) 'id': id,
      'sparseVector': sparseVector.toJson(),
      if (sparseVectorNullable != null)
        'sparseVectorNullable': sparseVectorNullable?.toJson(),
      'sparseVectorIndexedHnsw': sparseVectorIndexedHnsw.toJson(),
      'sparseVectorIndexedHnswWithParams': sparseVectorIndexedHnswWithParams
          .toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithSparseVector',
      if (id != null) 'id': id,
      'sparseVector': sparseVector.toJson(),
      if (sparseVectorNullable != null)
        'sparseVectorNullable': sparseVectorNullable?.toJson(),
      'sparseVectorIndexedHnsw': sparseVectorIndexedHnsw.toJson(),
      'sparseVectorIndexedHnswWithParams': sparseVectorIndexedHnswWithParams
          .toJson(),
    };
  }

  static ObjectWithSparseVectorInclude include({
    _is.SelectColumnsBuilder<ObjectWithSparseVectorTable>? select,
  }) {
    return ObjectWithSparseVectorInclude.internal_(
      selectedColumns: select?.call(ObjectWithSparseVector.t),
    );
  }

  static ObjectWithSparseVectorIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    ObjectWithSparseVectorInclude? include,
    _is.SelectColumnsBuilder<ObjectWithSparseVectorTable>? select,
  }) {
    return ObjectWithSparseVectorIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      include: include,
      selectedColumns: select?.call(ObjectWithSparseVector.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSparseVectorImpl extends ObjectWithSparseVector {
  _ObjectWithSparseVectorImpl({
    int? id,
    required _is.SparseVector sparseVector,
    _is.SparseVector? sparseVectorNullable,
    required _is.SparseVector sparseVectorIndexedHnsw,
    required _is.SparseVector sparseVectorIndexedHnswWithParams,
  }) : super._(
         id: id,
         sparseVector: sparseVector,
         sparseVectorNullable: sparseVectorNullable,
         sparseVectorIndexedHnsw: sparseVectorIndexedHnsw,
         sparseVectorIndexedHnswWithParams: sparseVectorIndexedHnswWithParams,
       );

  /// Returns a shallow copy of this [ObjectWithSparseVector]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithSparseVector copyWith({
    Object? id = _Undefined,
    _is.SparseVector? sparseVector,
    Object? sparseVectorNullable = _Undefined,
    _is.SparseVector? sparseVectorIndexedHnsw,
    _is.SparseVector? sparseVectorIndexedHnswWithParams,
  }) {
    return ObjectWithSparseVector(
      id: id is int? ? id : this.id,
      sparseVector: sparseVector ?? this.sparseVector.clone(),
      sparseVectorNullable: sparseVectorNullable is _is.SparseVector?
          ? sparseVectorNullable
          : this.sparseVectorNullable?.clone(),
      sparseVectorIndexedHnsw:
          sparseVectorIndexedHnsw ?? this.sparseVectorIndexedHnsw.clone(),
      sparseVectorIndexedHnswWithParams:
          sparseVectorIndexedHnswWithParams ??
          this.sparseVectorIndexedHnswWithParams.clone(),
    );
  }
}

class ObjectWithSparseVectorUpdateTable
    extends _is.UpdateTable<ObjectWithSparseVectorTable> {
  ObjectWithSparseVectorUpdateTable(super.table);

  _is.ColumnValue<_is.SparseVector, _is.SparseVector> sparseVector(
    _is.SparseVector value,
  ) => _is.ColumnValue(
    table.sparseVector,
    value,
  );

  _is.ColumnValue<_is.SparseVector, _is.SparseVector> sparseVectorNullable(
    _is.SparseVector? value,
  ) => _is.ColumnValue(
    table.sparseVectorNullable,
    value,
  );

  _is.ColumnValue<_is.SparseVector, _is.SparseVector> sparseVectorIndexedHnsw(
    _is.SparseVector value,
  ) => _is.ColumnValue(
    table.sparseVectorIndexedHnsw,
    value,
  );

  _is.ColumnValue<_is.SparseVector, _is.SparseVector>
  sparseVectorIndexedHnswWithParams(_is.SparseVector value) => _is.ColumnValue(
    table.sparseVectorIndexedHnswWithParams,
    value,
  );
}

class ObjectWithSparseVectorTable extends _is.Table<int?> {
  ObjectWithSparseVectorTable({super.tableRelation})
    : super(tableName: 'object_with_sparse_vector') {
    updateTable = ObjectWithSparseVectorUpdateTable(this);
    sparseVector = _is.ColumnSparseVector(
      'sparseVector',
      this,
      dimension: 512,
    );
    sparseVectorNullable = _is.ColumnSparseVector(
      'sparseVectorNullable',
      this,
      dimension: 512,
    );
    sparseVectorIndexedHnsw = _is.ColumnSparseVector(
      'sparseVectorIndexedHnsw',
      this,
      dimension: 512,
    );
    sparseVectorIndexedHnswWithParams = _is.ColumnSparseVector(
      'sparseVectorIndexedHnswWithParams',
      this,
      dimension: 512,
    );
  }

  late final ObjectWithSparseVectorUpdateTable updateTable;

  late final _is.ColumnSparseVector sparseVector;

  late final _is.ColumnSparseVector sparseVectorNullable;

  late final _is.ColumnSparseVector sparseVectorIndexedHnsw;

  late final _is.ColumnSparseVector sparseVectorIndexedHnswWithParams;

  @override
  List<_is.Column> get columns => [
    id,
    sparseVector,
    sparseVectorNullable,
    sparseVectorIndexedHnsw,
    sparseVectorIndexedHnswWithParams,
  ];
}

class ObjectWithSparseVectorInclude extends _is.IncludeObject {
  ObjectWithSparseVectorInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithSparseVector.t;
}

class ObjectWithSparseVectorIncludeList extends _is.IncludeList {
  ObjectWithSparseVectorIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithSparseVector.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithSparseVector.t;
}

class ObjectWithSparseVectorRepository {
  const ObjectWithSparseVectorRepository._();

  /// Returns a list of [ObjectWithSparseVector]s matching the given query parameters.
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
  Future<List<ObjectWithSparseVector>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithSparseVector>(
      where: where?.call(ObjectWithSparseVector.t),
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithSparseVector] matching the given query parameters.
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
  Future<ObjectWithSparseVector?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithSparseVector>(
      where: where?.call(ObjectWithSparseVector.t),
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithSparseVector] by its [id] or null if no such row exists.
  Future<ObjectWithSparseVector?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithSparseVector>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithSparseVector]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithSparseVector]s will have their `id` fields set.
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
  Future<List<ObjectWithSparseVector>> insert(
    _is.DatabaseSession session,
    List<ObjectWithSparseVector> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithSparseVector>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithSparseVector] and returns the inserted row.
  ///
  /// The returned [ObjectWithSparseVector] will have its `id` field set.
  Future<ObjectWithSparseVector> insertRow(
    _is.DatabaseSession session,
    ObjectWithSparseVector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithSparseVector>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithSparseVector]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithSparseVector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithSparseVector>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithSparseVector> rows, {
    required _is.ColumnSelections<ObjectWithSparseVectorTable> conflictColumns,
    _is.ColumnSelections<ObjectWithSparseVectorTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithSparseVectorTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithSparseVector>(
      rows,
      conflictColumns: conflictColumns(ObjectWithSparseVector.t),
      updateColumns: updateColumns?.call(ObjectWithSparseVector.t),
      updateWhere: updateWhere?.call(ObjectWithSparseVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithSparseVector] and returns the resulting row.
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
  /// The returned [ObjectWithSparseVector] will have its `id` field set.
  Future<ObjectWithSparseVector?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithSparseVector row, {
    required _is.ColumnSelections<ObjectWithSparseVectorTable> conflictColumns,
    _is.ColumnSelections<ObjectWithSparseVectorTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithSparseVectorTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithSparseVector>(
      row,
      conflictColumns: conflictColumns(ObjectWithSparseVector.t),
      updateColumns: updateColumns?.call(ObjectWithSparseVector.t),
      updateWhere: updateWhere?.call(ObjectWithSparseVector.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithSparseVector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithSparseVector>> update(
    _is.DatabaseSession session,
    List<ObjectWithSparseVector> rows, {
    _is.ColumnSelections<ObjectWithSparseVectorTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithSparseVector>(
      rows,
      columns: columns?.call(ObjectWithSparseVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithSparseVector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithSparseVector> updateRow(
    _is.DatabaseSession session,
    ObjectWithSparseVector row, {
    _is.ColumnSelections<ObjectWithSparseVectorTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithSparseVector>(
      row,
      columns: columns?.call(ObjectWithSparseVector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithSparseVector] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithSparseVector?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithSparseVectorUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithSparseVector>(
      id,
      columnValues: columnValues(ObjectWithSparseVector.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithSparseVector]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithSparseVector>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithSparseVectorUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithSparseVectorTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithSparseVector>(
      columnValues: columnValues(ObjectWithSparseVector.t.updateTable),
      where: where(ObjectWithSparseVector.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithSparseVector]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithSparseVector>> delete(
    _is.DatabaseSession session,
    List<ObjectWithSparseVector> rows, {
    _is.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithSparseVector>(
      rows,
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithSparseVector].
  Future<ObjectWithSparseVector> deleteRow(
    _is.DatabaseSession session,
    ObjectWithSparseVector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithSparseVector>(
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
  Future<List<ObjectWithSparseVector>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithSparseVectorTable> where,
    _is.OrderByBuilder<ObjectWithSparseVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithSparseVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithSparseVector>(
      where: where(ObjectWithSparseVector.t),
      orderBy: orderBy?.call(ObjectWithSparseVector.t),
      orderByList: orderByList?.call(ObjectWithSparseVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithSparseVectorTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithSparseVector>(
      where: where?.call(ObjectWithSparseVector.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithSparseVector] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithSparseVectorTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithSparseVector>(
      where: where(ObjectWithSparseVector.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

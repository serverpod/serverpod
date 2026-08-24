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

abstract class ObjectWithVector
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithVector._({
    this.id,
    required this.vector,
    this.vectorNullable,
    required this.vectorIndexedHnsw,
    required this.vectorIndexedHnswWithParams,
    required this.vectorIndexedIvfflat,
    required this.vectorIndexedIvfflatWithParams,
  });

  factory ObjectWithVector({
    int? id,
    required _is.Vector vector,
    _is.Vector? vectorNullable,
    required _is.Vector vectorIndexedHnsw,
    required _is.Vector vectorIndexedHnswWithParams,
    required _is.Vector vectorIndexedIvfflat,
    required _is.Vector vectorIndexedIvfflatWithParams,
  }) = _ObjectWithVectorImpl;

  factory ObjectWithVector.fromJson(Map<String, dynamic> jsonSerialization) {
    return ObjectWithVector(
      id: jsonSerialization['id'] as int?,
      vector: _is.VectorJsonExtension.fromJson(jsonSerialization['vector']),
      vectorNullable: jsonSerialization['vectorNullable'] == null
          ? null
          : _is.VectorJsonExtension.fromJson(
              jsonSerialization['vectorNullable'],
            ),
      vectorIndexedHnsw: _is.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedHnsw'],
      ),
      vectorIndexedHnswWithParams: _is.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedHnswWithParams'],
      ),
      vectorIndexedIvfflat: _is.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedIvfflat'],
      ),
      vectorIndexedIvfflatWithParams: _is.VectorJsonExtension.fromJson(
        jsonSerialization['vectorIndexedIvfflatWithParams'],
      ),
    );
  }

  static final t = ObjectWithVectorTable();

  static const db = ObjectWithVectorRepository._();

  @override
  int? id;

  _is.Vector vector;

  _is.Vector? vectorNullable;

  _is.Vector vectorIndexedHnsw;

  _is.Vector vectorIndexedHnswWithParams;

  _is.Vector vectorIndexedIvfflat;

  _is.Vector vectorIndexedIvfflatWithParams;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithVector copyWith({
    int? id,
    _is.Vector? vector,
    _is.Vector? vectorNullable,
    _is.Vector? vectorIndexedHnsw,
    _is.Vector? vectorIndexedHnswWithParams,
    _is.Vector? vectorIndexedIvfflat,
    _is.Vector? vectorIndexedIvfflatWithParams,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithVector',
      if (id != null) 'id': id,
      'vector': vector.toJson(),
      if (vectorNullable != null) 'vectorNullable': vectorNullable?.toJson(),
      'vectorIndexedHnsw': vectorIndexedHnsw.toJson(),
      'vectorIndexedHnswWithParams': vectorIndexedHnswWithParams.toJson(),
      'vectorIndexedIvfflat': vectorIndexedIvfflat.toJson(),
      'vectorIndexedIvfflatWithParams': vectorIndexedIvfflatWithParams.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithVector',
      if (id != null) 'id': id,
      'vector': vector.toJson(),
      if (vectorNullable != null) 'vectorNullable': vectorNullable?.toJson(),
      'vectorIndexedHnsw': vectorIndexedHnsw.toJson(),
      'vectorIndexedHnswWithParams': vectorIndexedHnswWithParams.toJson(),
      'vectorIndexedIvfflat': vectorIndexedIvfflat.toJson(),
      'vectorIndexedIvfflatWithParams': vectorIndexedIvfflatWithParams.toJson(),
    };
  }

  static ObjectWithVectorInclude include({
    _is.SelectColumnsBuilder<ObjectWithVectorTable>? select,
  }) {
    return ObjectWithVectorInclude.internal_(
      selectedColumns: select?.call(ObjectWithVector.t),
    );
  }

  static ObjectWithVectorIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    ObjectWithVectorInclude? include,
    _is.SelectColumnsBuilder<ObjectWithVectorTable>? select,
  }) {
    return ObjectWithVectorIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      include: include,
      selectedColumns: select?.call(ObjectWithVector.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithVectorImpl extends ObjectWithVector {
  _ObjectWithVectorImpl({
    int? id,
    required _is.Vector vector,
    _is.Vector? vectorNullable,
    required _is.Vector vectorIndexedHnsw,
    required _is.Vector vectorIndexedHnswWithParams,
    required _is.Vector vectorIndexedIvfflat,
    required _is.Vector vectorIndexedIvfflatWithParams,
  }) : super._(
         id: id,
         vector: vector,
         vectorNullable: vectorNullable,
         vectorIndexedHnsw: vectorIndexedHnsw,
         vectorIndexedHnswWithParams: vectorIndexedHnswWithParams,
         vectorIndexedIvfflat: vectorIndexedIvfflat,
         vectorIndexedIvfflatWithParams: vectorIndexedIvfflatWithParams,
       );

  /// Returns a shallow copy of this [ObjectWithVector]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithVector copyWith({
    Object? id = _Undefined,
    _is.Vector? vector,
    Object? vectorNullable = _Undefined,
    _is.Vector? vectorIndexedHnsw,
    _is.Vector? vectorIndexedHnswWithParams,
    _is.Vector? vectorIndexedIvfflat,
    _is.Vector? vectorIndexedIvfflatWithParams,
  }) {
    return ObjectWithVector(
      id: id is int? ? id : this.id,
      vector: vector ?? this.vector.clone(),
      vectorNullable: vectorNullable is _is.Vector?
          ? vectorNullable
          : this.vectorNullable?.clone(),
      vectorIndexedHnsw: vectorIndexedHnsw ?? this.vectorIndexedHnsw.clone(),
      vectorIndexedHnswWithParams:
          vectorIndexedHnswWithParams ??
          this.vectorIndexedHnswWithParams.clone(),
      vectorIndexedIvfflat:
          vectorIndexedIvfflat ?? this.vectorIndexedIvfflat.clone(),
      vectorIndexedIvfflatWithParams:
          vectorIndexedIvfflatWithParams ??
          this.vectorIndexedIvfflatWithParams.clone(),
    );
  }
}

class ObjectWithVectorUpdateTable
    extends _is.UpdateTable<ObjectWithVectorTable> {
  ObjectWithVectorUpdateTable(super.table);

  _is.ColumnValue<_is.Vector, _is.Vector> vector(_is.Vector value) =>
      _is.ColumnValue(
        table.vector,
        value,
      );

  _is.ColumnValue<_is.Vector, _is.Vector> vectorNullable(_is.Vector? value) =>
      _is.ColumnValue(
        table.vectorNullable,
        value,
      );

  _is.ColumnValue<_is.Vector, _is.Vector> vectorIndexedHnsw(_is.Vector value) =>
      _is.ColumnValue(
        table.vectorIndexedHnsw,
        value,
      );

  _is.ColumnValue<_is.Vector, _is.Vector> vectorIndexedHnswWithParams(
    _is.Vector value,
  ) => _is.ColumnValue(
    table.vectorIndexedHnswWithParams,
    value,
  );

  _is.ColumnValue<_is.Vector, _is.Vector> vectorIndexedIvfflat(
    _is.Vector value,
  ) => _is.ColumnValue(
    table.vectorIndexedIvfflat,
    value,
  );

  _is.ColumnValue<_is.Vector, _is.Vector> vectorIndexedIvfflatWithParams(
    _is.Vector value,
  ) => _is.ColumnValue(
    table.vectorIndexedIvfflatWithParams,
    value,
  );
}

class ObjectWithVectorTable extends _is.Table<int?> {
  ObjectWithVectorTable({super.tableRelation})
    : super(tableName: 'object_with_vector') {
    updateTable = ObjectWithVectorUpdateTable(this);
    vector = _is.ColumnVector(
      'vector',
      this,
      dimension: 512,
    );
    vectorNullable = _is.ColumnVector(
      'vectorNullable',
      this,
      dimension: 512,
    );
    vectorIndexedHnsw = _is.ColumnVector(
      'vectorIndexedHnsw',
      this,
      dimension: 512,
    );
    vectorIndexedHnswWithParams = _is.ColumnVector(
      'vectorIndexedHnswWithParams',
      this,
      dimension: 512,
    );
    vectorIndexedIvfflat = _is.ColumnVector(
      'vectorIndexedIvfflat',
      this,
      dimension: 512,
    );
    vectorIndexedIvfflatWithParams = _is.ColumnVector(
      'vectorIndexedIvfflatWithParams',
      this,
      dimension: 512,
    );
  }

  late final ObjectWithVectorUpdateTable updateTable;

  late final _is.ColumnVector vector;

  late final _is.ColumnVector vectorNullable;

  late final _is.ColumnVector vectorIndexedHnsw;

  late final _is.ColumnVector vectorIndexedHnswWithParams;

  late final _is.ColumnVector vectorIndexedIvfflat;

  late final _is.ColumnVector vectorIndexedIvfflatWithParams;

  @override
  List<_is.Column> get columns => [
    id,
    vector,
    vectorNullable,
    vectorIndexedHnsw,
    vectorIndexedHnswWithParams,
    vectorIndexedIvfflat,
    vectorIndexedIvfflatWithParams,
  ];
}

class ObjectWithVectorInclude extends _is.IncludeObject {
  ObjectWithVectorInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithVector.t;
}

class ObjectWithVectorIncludeList extends _is.IncludeList {
  ObjectWithVectorIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithVector.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithVector.t;
}

class ObjectWithVectorRepository {
  const ObjectWithVectorRepository._();

  /// Returns a list of [ObjectWithVector]s matching the given query parameters.
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
  Future<List<ObjectWithVector>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithVector>(
      where: where?.call(ObjectWithVector.t),
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithVector] matching the given query parameters.
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
  Future<ObjectWithVector?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithVector>(
      where: where?.call(ObjectWithVector.t),
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithVector] by its [id] or null if no such row exists.
  Future<ObjectWithVector?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithVector>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithVector]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithVector]s will have their `id` fields set.
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
  Future<List<ObjectWithVector>> insert(
    _is.DatabaseSession session,
    List<ObjectWithVector> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithVector>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithVector] and returns the inserted row.
  ///
  /// The returned [ObjectWithVector] will have its `id` field set.
  Future<ObjectWithVector> insertRow(
    _is.DatabaseSession session,
    ObjectWithVector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithVector>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithVector]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithVector]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithVector>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithVector> rows, {
    required _is.ColumnSelections<ObjectWithVectorTable> conflictColumns,
    _is.ColumnSelections<ObjectWithVectorTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithVectorTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithVector>(
      rows,
      conflictColumns: conflictColumns(ObjectWithVector.t),
      updateColumns: updateColumns?.call(ObjectWithVector.t),
      updateWhere: updateWhere?.call(ObjectWithVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithVector] and returns the resulting row.
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
  /// The returned [ObjectWithVector] will have its `id` field set.
  Future<ObjectWithVector?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithVector row, {
    required _is.ColumnSelections<ObjectWithVectorTable> conflictColumns,
    _is.ColumnSelections<ObjectWithVectorTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithVectorTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithVector>(
      row,
      conflictColumns: conflictColumns(ObjectWithVector.t),
      updateColumns: updateColumns?.call(ObjectWithVector.t),
      updateWhere: updateWhere?.call(ObjectWithVector.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithVector]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithVector>> update(
    _is.DatabaseSession session,
    List<ObjectWithVector> rows, {
    _is.ColumnSelections<ObjectWithVectorTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithVector>(
      rows,
      columns: columns?.call(ObjectWithVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithVector]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithVector> updateRow(
    _is.DatabaseSession session,
    ObjectWithVector row, {
    _is.ColumnSelections<ObjectWithVectorTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithVector>(
      row,
      columns: columns?.call(ObjectWithVector.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithVector] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithVector?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithVectorUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithVector>(
      id,
      columnValues: columnValues(ObjectWithVector.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithVector]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithVector>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithVectorUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithVectorTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithVector>(
      columnValues: columnValues(ObjectWithVector.t.updateTable),
      where: where(ObjectWithVector.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithVector]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithVector>> delete(
    _is.DatabaseSession session,
    List<ObjectWithVector> rows, {
    _is.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithVector>(
      rows,
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithVector].
  Future<ObjectWithVector> deleteRow(
    _is.DatabaseSession session,
    ObjectWithVector row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithVector>(
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
  Future<List<ObjectWithVector>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithVectorTable> where,
    _is.OrderByBuilder<ObjectWithVectorTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithVectorTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithVector>(
      where: where(ObjectWithVector.t),
      orderBy: orderBy?.call(ObjectWithVector.t),
      orderByList: orderByList?.call(ObjectWithVector.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithVectorTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithVector>(
      where: where?.call(ObjectWithVector.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithVector] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithVectorTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithVector>(
      where: where(ObjectWithVector.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

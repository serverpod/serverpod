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

abstract class ObjectWithGeographyIndex
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithGeographyIndex._({
    this.id,
    required this.point,
    required this.pointIndexedGist,
    required this.pointIndexedSpgist,
  });

  factory ObjectWithGeographyIndex({
    int? id,
    required _i1.GeographyPoint point,
    required _i1.GeographyPoint pointIndexedGist,
    required _i1.GeographyPoint pointIndexedSpgist,
  }) = _ObjectWithGeographyIndexImpl;

  factory ObjectWithGeographyIndex.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyIndex(
      id: jsonSerialization['id'] as int?,
      point: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['point'],
      ),
      pointIndexedGist: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['pointIndexedGist'],
      ),
      pointIndexedSpgist: _i1.GeographyPointJsonExtension.fromJson(
        jsonSerialization['pointIndexedSpgist'],
      ),
    );
  }

  static final t = ObjectWithGeographyIndexTable();

  static const db = ObjectWithGeographyIndexRepository._();

  @override
  int? id;

  _i1.GeographyPoint point;

  _i1.GeographyPoint pointIndexedGist;

  _i1.GeographyPoint pointIndexedSpgist;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyIndex]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyIndex copyWith({
    int? id,
    _i1.GeographyPoint? point,
    _i1.GeographyPoint? pointIndexedGist,
    _i1.GeographyPoint? pointIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyIndex',
      if (id != null) 'id': id,
      'point': point.toJson(),
      'pointIndexedGist': pointIndexedGist.toJson(),
      'pointIndexedSpgist': pointIndexedSpgist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyIndex',
      if (id != null) 'id': id,
      'point': point.toJson(),
      'pointIndexedGist': pointIndexedGist.toJson(),
      'pointIndexedSpgist': pointIndexedSpgist.toJson(),
    };
  }

  static ObjectWithGeographyIndexInclude include() {
    return ObjectWithGeographyIndexInclude._();
  }

  static ObjectWithGeographyIndexIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyIndexTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyIndexTable>? orderByList,
    ObjectWithGeographyIndexInclude? include,
  }) {
    return ObjectWithGeographyIndexIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyIndex.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ObjectWithGeographyIndex.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyIndexImpl extends ObjectWithGeographyIndex {
  _ObjectWithGeographyIndexImpl({
    int? id,
    required _i1.GeographyPoint point,
    required _i1.GeographyPoint pointIndexedGist,
    required _i1.GeographyPoint pointIndexedSpgist,
  }) : super._(
         id: id,
         point: point,
         pointIndexedGist: pointIndexedGist,
         pointIndexedSpgist: pointIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyIndex]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyIndex copyWith({
    Object? id = _Undefined,
    _i1.GeographyPoint? point,
    _i1.GeographyPoint? pointIndexedGist,
    _i1.GeographyPoint? pointIndexedSpgist,
  }) {
    return ObjectWithGeographyIndex(
      id: id is int? ? id : this.id,
      point: point ?? this.point,
      pointIndexedGist: pointIndexedGist ?? this.pointIndexedGist,
      pointIndexedSpgist: pointIndexedSpgist ?? this.pointIndexedSpgist,
    );
  }
}

class ObjectWithGeographyIndexUpdateTable
    extends _i1.UpdateTable<ObjectWithGeographyIndexTable> {
  ObjectWithGeographyIndexUpdateTable(super.table);

  _i1.ColumnValue<_i1.GeographyPoint, _i1.GeographyPoint> point(
    _i1.GeographyPoint value,
  ) => _i1.ColumnValue(
    table.point,
    value,
  );

  _i1.ColumnValue<_i1.GeographyPoint, _i1.GeographyPoint> pointIndexedGist(
    _i1.GeographyPoint value,
  ) => _i1.ColumnValue(
    table.pointIndexedGist,
    value,
  );

  _i1.ColumnValue<_i1.GeographyPoint, _i1.GeographyPoint> pointIndexedSpgist(
    _i1.GeographyPoint value,
  ) => _i1.ColumnValue(
    table.pointIndexedSpgist,
    value,
  );
}

class ObjectWithGeographyIndexTable extends _i1.Table<int?> {
  ObjectWithGeographyIndexTable({super.tableRelation})
    : super(tableName: 'object_with_geography_index') {
    updateTable = ObjectWithGeographyIndexUpdateTable(this);
    point = _i1.ColumnGeographyPoint(
      'point',
      this,
    );
    pointIndexedGist = _i1.ColumnGeographyPoint(
      'pointIndexedGist',
      this,
    );
    pointIndexedSpgist = _i1.ColumnGeographyPoint(
      'pointIndexedSpgist',
      this,
    );
  }

  late final ObjectWithGeographyIndexUpdateTable updateTable;

  late final _i1.ColumnGeographyPoint point;

  late final _i1.ColumnGeographyPoint pointIndexedGist;

  late final _i1.ColumnGeographyPoint pointIndexedSpgist;

  @override
  List<_i1.Column> get columns => [
    id,
    point,
    pointIndexedGist,
    pointIndexedSpgist,
  ];
}

class ObjectWithGeographyIndexInclude extends _i1.IncludeObject {
  ObjectWithGeographyIndexInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyIndex.t;
}

class ObjectWithGeographyIndexIncludeList extends _i1.IncludeList {
  ObjectWithGeographyIndexIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithGeographyIndex.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyIndex.t;
}

class ObjectWithGeographyIndexRepository {
  const ObjectWithGeographyIndexRepository._();

  /// Returns a list of [ObjectWithGeographyIndex]s matching the given query parameters.
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
  Future<List<ObjectWithGeographyIndex>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyIndexTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyIndexTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithGeographyIndex>(
      where: where?.call(ObjectWithGeographyIndex.t),
      orderBy: orderBy?.call(ObjectWithGeographyIndex.t),
      orderByList: orderByList?.call(ObjectWithGeographyIndex.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithGeographyIndex] matching the given query parameters.
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
  Future<ObjectWithGeographyIndex?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyIndexTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyIndexTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithGeographyIndex>(
      where: where?.call(ObjectWithGeographyIndex.t),
      orderBy: orderBy?.call(ObjectWithGeographyIndex.t),
      orderByList: orderByList?.call(ObjectWithGeographyIndex.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithGeographyIndex] by its [id] or null if no such row exists.
  Future<ObjectWithGeographyIndex?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithGeographyIndex>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithGeographyIndex]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithGeographyIndex]s will have their `id` fields set.
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
  Future<List<ObjectWithGeographyIndex>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyIndex> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithGeographyIndex>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithGeographyIndex] and returns the inserted row.
  ///
  /// The returned [ObjectWithGeographyIndex] will have its `id` field set.
  Future<ObjectWithGeographyIndex> insertRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithGeographyIndex>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithGeographyIndex]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithGeographyIndex]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyIndex>> upsert(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyIndex> rows, {
    required _i1.ColumnSelections<ObjectWithGeographyIndexTable>
    conflictColumns,
    _i1.ColumnSelections<ObjectWithGeographyIndexTable>? updateColumns,
    _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithGeographyIndex>(
      rows,
      conflictColumns: conflictColumns(ObjectWithGeographyIndex.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyIndex.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyIndex.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithGeographyIndex] and returns the resulting row.
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
  /// The returned [ObjectWithGeographyIndex] will have its `id` field set.
  Future<ObjectWithGeographyIndex?> upsertRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyIndex row, {
    required _i1.ColumnSelections<ObjectWithGeographyIndexTable>
    conflictColumns,
    _i1.ColumnSelections<ObjectWithGeographyIndexTable>? updateColumns,
    _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithGeographyIndex>(
      row,
      conflictColumns: conflictColumns(ObjectWithGeographyIndex.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyIndex.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyIndex.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyIndex]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyIndex>> update(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyIndex> rows, {
    _i1.ColumnSelections<ObjectWithGeographyIndexTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithGeographyIndex>(
      rows,
      columns: columns?.call(ObjectWithGeographyIndex.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithGeographyIndex]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithGeographyIndex> updateRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyIndex row, {
    _i1.ColumnSelections<ObjectWithGeographyIndexTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithGeographyIndex>(
      row,
      columns: columns?.call(ObjectWithGeographyIndex.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyIndex] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithGeographyIndex?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ObjectWithGeographyIndexUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithGeographyIndex>(
      id,
      columnValues: columnValues(ObjectWithGeographyIndex.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyIndex]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyIndex>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ObjectWithGeographyIndexUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyIndexTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyIndexTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithGeographyIndex>(
      columnValues: columnValues(ObjectWithGeographyIndex.t.updateTable),
      where: where(ObjectWithGeographyIndex.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyIndex.t),
      orderByList: orderByList?.call(ObjectWithGeographyIndex.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithGeographyIndex]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithGeographyIndex>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyIndex> rows, {
    _i1.OrderByBuilder<ObjectWithGeographyIndexTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyIndexTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithGeographyIndex>(
      rows,
      orderBy: orderBy?.call(ObjectWithGeographyIndex.t),
      orderByList: orderByList?.call(ObjectWithGeographyIndex.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithGeographyIndex].
  Future<ObjectWithGeographyIndex> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyIndex row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithGeographyIndex>(
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
  Future<List<ObjectWithGeographyIndex>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable> where,
    _i1.OrderByBuilder<ObjectWithGeographyIndexTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ObjectWithGeographyIndexTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithGeographyIndex>(
      where: where(ObjectWithGeographyIndex.t),
      orderBy: orderBy?.call(ObjectWithGeographyIndex.t),
      orderByList: orderByList?.call(ObjectWithGeographyIndex.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyIndex>(
      where: where?.call(ObjectWithGeographyIndex.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyIndex] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyIndexTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyIndex>(
      where: where(ObjectWithGeographyIndex.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

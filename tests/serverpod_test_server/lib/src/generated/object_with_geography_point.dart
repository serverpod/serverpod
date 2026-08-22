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

abstract class ObjectWithGeographyPoint
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithGeographyPoint._({
    this.id,
    required this.point,
    required this.pointIndexedGist,
    required this.pointIndexedSpgist,
  });

  factory ObjectWithGeographyPoint({
    int? id,
    required _is.GeographyPoint point,
    required _is.GeographyPoint pointIndexedGist,
    required _is.GeographyPoint pointIndexedSpgist,
  }) = _ObjectWithGeographyPointImpl;

  factory ObjectWithGeographyPoint.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyPoint(
      id: jsonSerialization['id'] as int?,
      point: _is.GeographyPointJsonExtension.fromJson(
        jsonSerialization['point'],
      ),
      pointIndexedGist: _is.GeographyPointJsonExtension.fromJson(
        jsonSerialization['pointIndexedGist'],
      ),
      pointIndexedSpgist: _is.GeographyPointJsonExtension.fromJson(
        jsonSerialization['pointIndexedSpgist'],
      ),
    );
  }

  static final t = ObjectWithGeographyPointTable();

  static const db = ObjectWithGeographyPointRepository._();

  @override
  int? id;

  _is.GeographyPoint point;

  _is.GeographyPoint pointIndexedGist;

  _is.GeographyPoint pointIndexedSpgist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithGeographyPoint copyWith({
    int? id,
    _is.GeographyPoint? point,
    _is.GeographyPoint? pointIndexedGist,
    _is.GeographyPoint? pointIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyPoint',
      if (id != null) 'id': id,
      'point': point.toJson(),
      'pointIndexedGist': pointIndexedGist.toJson(),
      'pointIndexedSpgist': pointIndexedSpgist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyPoint',
      if (id != null) 'id': id,
      'point': point.toJson(),
      'pointIndexedGist': pointIndexedGist.toJson(),
      'pointIndexedSpgist': pointIndexedSpgist.toJson(),
    };
  }

  static ObjectWithGeographyPointInclude include() {
    return ObjectWithGeographyPointInclude.internal_();
  }

  static ObjectWithGeographyPointIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    ObjectWithGeographyPointInclude? include,
  }) {
    return ObjectWithGeographyPointIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyPointImpl extends ObjectWithGeographyPoint {
  _ObjectWithGeographyPointImpl({
    int? id,
    required _is.GeographyPoint point,
    required _is.GeographyPoint pointIndexedGist,
    required _is.GeographyPoint pointIndexedSpgist,
  }) : super._(
         id: id,
         point: point,
         pointIndexedGist: pointIndexedGist,
         pointIndexedSpgist: pointIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyPoint]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithGeographyPoint copyWith({
    Object? id = _Undefined,
    _is.GeographyPoint? point,
    _is.GeographyPoint? pointIndexedGist,
    _is.GeographyPoint? pointIndexedSpgist,
  }) {
    return ObjectWithGeographyPoint(
      id: id is int? ? id : this.id,
      point: point ?? this.point,
      pointIndexedGist: pointIndexedGist ?? this.pointIndexedGist,
      pointIndexedSpgist: pointIndexedSpgist ?? this.pointIndexedSpgist,
    );
  }
}

class ObjectWithGeographyPointUpdateTable
    extends _is.UpdateTable<ObjectWithGeographyPointTable> {
  ObjectWithGeographyPointUpdateTable(super.table);

  _is.ColumnValue<_is.GeographyPoint, _is.GeographyPoint> point(
    _is.GeographyPoint value,
  ) => _is.ColumnValue(
    table.point,
    value,
  );

  _is.ColumnValue<_is.GeographyPoint, _is.GeographyPoint> pointIndexedGist(
    _is.GeographyPoint value,
  ) => _is.ColumnValue(
    table.pointIndexedGist,
    value,
  );

  _is.ColumnValue<_is.GeographyPoint, _is.GeographyPoint> pointIndexedSpgist(
    _is.GeographyPoint value,
  ) => _is.ColumnValue(
    table.pointIndexedSpgist,
    value,
  );
}

class ObjectWithGeographyPointTable extends _is.Table<int?> {
  ObjectWithGeographyPointTable({super.tableRelation})
    : super(tableName: 'object_with_geography_point') {
    updateTable = ObjectWithGeographyPointUpdateTable(this);
    point = _is.ColumnGeographyPoint(
      'point',
      this,
    );
    pointIndexedGist = _is.ColumnGeographyPoint(
      'pointIndexedGist',
      this,
    );
    pointIndexedSpgist = _is.ColumnGeographyPoint(
      'pointIndexedSpgist',
      this,
    );
  }

  late final ObjectWithGeographyPointUpdateTable updateTable;

  late final _is.ColumnGeographyPoint point;

  late final _is.ColumnGeographyPoint pointIndexedGist;

  late final _is.ColumnGeographyPoint pointIndexedSpgist;

  @override
  List<_is.Column> get columns => [
    id,
    point,
    pointIndexedGist,
    pointIndexedSpgist,
  ];
}

class ObjectWithGeographyPointInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  ObjectWithGeographyPointInclude.internal_({
    List<_is.Column>? this.selectedColumns,
  }) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyPoint.t;
}

class ObjectWithGeographyPointIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  ObjectWithGeographyPointIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithGeographyPoint.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyPoint.t;
}

class ObjectWithGeographyPointRepository {
  const ObjectWithGeographyPointRepository._();

  /// Returns a list of [ObjectWithGeographyPoint]s matching the given query parameters.
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
  Future<List<ObjectWithGeographyPoint>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithGeographyPoint>(
      where: where?.call(ObjectWithGeographyPoint.t),
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithGeographyPoint] matching the given query parameters.
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
  Future<ObjectWithGeographyPoint?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithGeographyPoint>(
      where: where?.call(ObjectWithGeographyPoint.t),
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithGeographyPoint] by its [id] or null if no such row exists.
  Future<ObjectWithGeographyPoint?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithGeographyPoint>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithGeographyPoint]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithGeographyPoint]s will have their `id` fields set.
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
  Future<List<ObjectWithGeographyPoint>> insert(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPoint> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithGeographyPoint>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithGeographyPoint] and returns the inserted row.
  ///
  /// The returned [ObjectWithGeographyPoint] will have its `id` field set.
  Future<ObjectWithGeographyPoint> insertRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithGeographyPoint>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithGeographyPoint]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithGeographyPoint]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyPoint>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPoint> rows, {
    required _is.ColumnSelections<ObjectWithGeographyPointTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyPointTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyPointTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithGeographyPoint>(
      rows,
      conflictColumns: conflictColumns(ObjectWithGeographyPoint.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyPoint.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithGeographyPoint] and returns the resulting row.
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
  /// The returned [ObjectWithGeographyPoint] will have its `id` field set.
  Future<ObjectWithGeographyPoint?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPoint row, {
    required _is.ColumnSelections<ObjectWithGeographyPointTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyPointTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyPointTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithGeographyPoint>(
      row,
      conflictColumns: conflictColumns(ObjectWithGeographyPoint.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyPoint.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPoint]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyPoint>> update(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPoint> rows, {
    _is.ColumnSelections<ObjectWithGeographyPointTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithGeographyPoint>(
      rows,
      columns: columns?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithGeographyPoint]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithGeographyPoint> updateRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPoint row, {
    _is.ColumnSelections<ObjectWithGeographyPointTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithGeographyPoint>(
      row,
      columns: columns?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyPoint] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithGeographyPoint?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithGeographyPointUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithGeographyPoint>(
      id,
      columnValues: columnValues(ObjectWithGeographyPoint.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPoint]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyPoint>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithGeographyPointUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithGeographyPointTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithGeographyPoint>(
      columnValues: columnValues(ObjectWithGeographyPoint.t.updateTable),
      where: where(ObjectWithGeographyPoint.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithGeographyPoint]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithGeographyPoint>> delete(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPoint> rows, {
    _is.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithGeographyPoint>(
      rows,
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithGeographyPoint].
  Future<ObjectWithGeographyPoint> deleteRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPoint row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithGeographyPoint>(
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
  Future<List<ObjectWithGeographyPoint>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithGeographyPointTable> where,
    _is.OrderByBuilder<ObjectWithGeographyPointTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPointTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithGeographyPoint>(
      where: where(ObjectWithGeographyPoint.t),
      orderBy: orderBy?.call(ObjectWithGeographyPoint.t),
      orderByList: orderByList?.call(ObjectWithGeographyPoint.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyPointTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyPoint>(
      where: where?.call(ObjectWithGeographyPoint.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyPoint] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithGeographyPointTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyPoint>(
      where: where(ObjectWithGeographyPoint.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

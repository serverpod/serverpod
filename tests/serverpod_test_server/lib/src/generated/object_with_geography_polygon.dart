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

abstract class ObjectWithGeographyPolygon
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithGeographyPolygon._({
    this.id,
    required this.polygon,
    required this.polygonIndexedGist,
    required this.polygonIndexedSpgist,
  });

  factory ObjectWithGeographyPolygon({
    int? id,
    required _is.GeographyPolygon polygon,
    required _is.GeographyPolygon polygonIndexedGist,
    required _is.GeographyPolygon polygonIndexedSpgist,
  }) = _ObjectWithGeographyPolygonImpl;

  factory ObjectWithGeographyPolygon.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyPolygon(
      id: jsonSerialization['id'] as int?,
      polygon: _is.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygon'],
      ),
      polygonIndexedGist: _is.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygonIndexedGist'],
      ),
      polygonIndexedSpgist: _is.GeographyPolygonJsonExtension.fromJson(
        jsonSerialization['polygonIndexedSpgist'],
      ),
    );
  }

  static final t = ObjectWithGeographyPolygonTable();

  static const db = ObjectWithGeographyPolygonRepository._();

  @override
  int? id;

  _is.GeographyPolygon polygon;

  _is.GeographyPolygon polygonIndexedGist;

  _is.GeographyPolygon polygonIndexedSpgist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithGeographyPolygon copyWith({
    int? id,
    _is.GeographyPolygon? polygon,
    _is.GeographyPolygon? polygonIndexedGist,
    _is.GeographyPolygon? polygonIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyPolygon',
      if (id != null) 'id': id,
      'polygon': polygon.toJson(),
      'polygonIndexedGist': polygonIndexedGist.toJson(),
      'polygonIndexedSpgist': polygonIndexedSpgist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyPolygon',
      if (id != null) 'id': id,
      'polygon': polygon.toJson(),
      'polygonIndexedGist': polygonIndexedGist.toJson(),
      'polygonIndexedSpgist': polygonIndexedSpgist.toJson(),
    };
  }

  static ObjectWithGeographyPolygonInclude include({
    _is.SelectColumnsBuilder<ObjectWithGeographyPolygonTable>? select,
  }) {
    return ObjectWithGeographyPolygonInclude._(
      selectedColumns: select?.call(ObjectWithGeographyPolygon.t),
    );
  }

  static ObjectWithGeographyPolygonIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    ObjectWithGeographyPolygonInclude? include,
    _is.SelectColumnsBuilder<ObjectWithGeographyPolygonTable>? select,
  }) {
    return ObjectWithGeographyPolygonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      include: include,
      selectedColumns: select?.call(ObjectWithGeographyPolygon.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyPolygonImpl extends ObjectWithGeographyPolygon {
  _ObjectWithGeographyPolygonImpl({
    int? id,
    required _is.GeographyPolygon polygon,
    required _is.GeographyPolygon polygonIndexedGist,
    required _is.GeographyPolygon polygonIndexedSpgist,
  }) : super._(
         id: id,
         polygon: polygon,
         polygonIndexedGist: polygonIndexedGist,
         polygonIndexedSpgist: polygonIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyPolygon]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithGeographyPolygon copyWith({
    Object? id = _Undefined,
    _is.GeographyPolygon? polygon,
    _is.GeographyPolygon? polygonIndexedGist,
    _is.GeographyPolygon? polygonIndexedSpgist,
  }) {
    return ObjectWithGeographyPolygon(
      id: id is int? ? id : this.id,
      polygon: polygon ?? this.polygon,
      polygonIndexedGist: polygonIndexedGist ?? this.polygonIndexedGist,
      polygonIndexedSpgist: polygonIndexedSpgist ?? this.polygonIndexedSpgist,
    );
  }
}

class ObjectWithGeographyPolygonUpdateTable
    extends _is.UpdateTable<ObjectWithGeographyPolygonTable> {
  ObjectWithGeographyPolygonUpdateTable(super.table);

  _is.ColumnValue<_is.GeographyPolygon, _is.GeographyPolygon> polygon(
    _is.GeographyPolygon value,
  ) => _is.ColumnValue(
    table.polygon,
    value,
  );

  _is.ColumnValue<_is.GeographyPolygon, _is.GeographyPolygon>
  polygonIndexedGist(_is.GeographyPolygon value) => _is.ColumnValue(
    table.polygonIndexedGist,
    value,
  );

  _is.ColumnValue<_is.GeographyPolygon, _is.GeographyPolygon>
  polygonIndexedSpgist(_is.GeographyPolygon value) => _is.ColumnValue(
    table.polygonIndexedSpgist,
    value,
  );
}

class ObjectWithGeographyPolygonTable extends _is.Table<int?> {
  ObjectWithGeographyPolygonTable({super.tableRelation})
    : super(tableName: 'object_with_geography_polygon') {
    updateTable = ObjectWithGeographyPolygonUpdateTable(this);
    polygon = _is.ColumnGeographyPolygon(
      'polygon',
      this,
    );
    polygonIndexedGist = _is.ColumnGeographyPolygon(
      'polygonIndexedGist',
      this,
    );
    polygonIndexedSpgist = _is.ColumnGeographyPolygon(
      'polygonIndexedSpgist',
      this,
    );
  }

  late final ObjectWithGeographyPolygonUpdateTable updateTable;

  late final _is.ColumnGeographyPolygon polygon;

  late final _is.ColumnGeographyPolygon polygonIndexedGist;

  late final _is.ColumnGeographyPolygon polygonIndexedSpgist;

  @override
  List<_is.Column> get columns => [
    id,
    polygon,
    polygonIndexedGist,
    polygonIndexedSpgist,
  ];
}

class ObjectWithGeographyPolygonInclude extends _is.IncludeObject {
  ObjectWithGeographyPolygonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyPolygon.t;
}

class ObjectWithGeographyPolygonIncludeList extends _is.IncludeList {
  ObjectWithGeographyPolygonIncludeList._({
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithGeographyPolygon.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyPolygon.t;
}

class ObjectWithGeographyPolygonRepository {
  const ObjectWithGeographyPolygonRepository._();

  /// Returns a list of [ObjectWithGeographyPolygon]s matching the given query parameters.
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
  Future<List<ObjectWithGeographyPolygon>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithGeographyPolygon] matching the given query parameters.
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
  Future<ObjectWithGeographyPolygon?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithGeographyPolygon] by its [id] or null if no such row exists.
  Future<ObjectWithGeographyPolygon?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithGeographyPolygon>(
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
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithGeographyPolygonTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithGeographyPolygon.t),
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
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ObjectWithGeographyPolygonTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ObjectWithGeographyPolygon.t),
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
    _is.SelectColumnsBuilder<ObjectWithGeographyPolygonTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ObjectWithGeographyPolygon>(
      id,
      transaction: transaction,
      select: select?.call(ObjectWithGeographyPolygon.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithGeographyPolygon]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithGeographyPolygon]s will have their `id` fields set.
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
  Future<List<ObjectWithGeographyPolygon>> insert(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPolygon> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithGeographyPolygon>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithGeographyPolygon] and returns the inserted row.
  ///
  /// The returned [ObjectWithGeographyPolygon] will have its `id` field set.
  Future<ObjectWithGeographyPolygon> insertRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPolygon row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithGeographyPolygon>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithGeographyPolygon]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithGeographyPolygon]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyPolygon>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPolygon> rows, {
    required _is.ColumnSelections<ObjectWithGeographyPolygonTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyPolygonTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithGeographyPolygon>(
      rows,
      conflictColumns: conflictColumns(ObjectWithGeographyPolygon.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyPolygon.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithGeographyPolygon] and returns the resulting row.
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
  /// The returned [ObjectWithGeographyPolygon] will have its `id` field set.
  Future<ObjectWithGeographyPolygon?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPolygon row, {
    required _is.ColumnSelections<ObjectWithGeographyPolygonTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyPolygonTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithGeographyPolygon>(
      row,
      conflictColumns: conflictColumns(ObjectWithGeographyPolygon.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyPolygon.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPolygon]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyPolygon>> update(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPolygon> rows, {
    _is.ColumnSelections<ObjectWithGeographyPolygonTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithGeographyPolygon>(
      rows,
      columns: columns?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithGeographyPolygon]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithGeographyPolygon> updateRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPolygon row, {
    _is.ColumnSelections<ObjectWithGeographyPolygonTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithGeographyPolygon>(
      row,
      columns: columns?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyPolygon] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithGeographyPolygon?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ObjectWithGeographyPolygonUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithGeographyPolygon>(
      id,
      columnValues: columnValues(ObjectWithGeographyPolygon.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyPolygon]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyPolygon>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ObjectWithGeographyPolygonUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithGeographyPolygon>(
      columnValues: columnValues(ObjectWithGeographyPolygon.t.updateTable),
      where: where(ObjectWithGeographyPolygon.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithGeographyPolygon]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithGeographyPolygon>> delete(
    _is.DatabaseSession session,
    List<ObjectWithGeographyPolygon> rows, {
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithGeographyPolygon>(
      rows,
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithGeographyPolygon].
  Future<ObjectWithGeographyPolygon> deleteRow(
    _is.DatabaseSession session,
    ObjectWithGeographyPolygon row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithGeographyPolygon>(
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
  Future<List<ObjectWithGeographyPolygon>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable> where,
    _is.OrderByBuilder<ObjectWithGeographyPolygonTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyPolygonTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithGeographyPolygon>(
      where: where(ObjectWithGeographyPolygon.t),
      orderBy: orderBy?.call(ObjectWithGeographyPolygon.t),
      orderByList: orderByList?.call(ObjectWithGeographyPolygon.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyPolygon>(
      where: where?.call(ObjectWithGeographyPolygon.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyPolygon] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithGeographyPolygonTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyPolygon>(
      where: where(ObjectWithGeographyPolygon.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

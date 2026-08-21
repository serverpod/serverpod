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

abstract class ObjectWithGeographyGeometryCollection
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithGeographyGeometryCollection._({
    this.id,
    required this.geometryCollection,
    required this.geometryCollectionIndexedGist,
    required this.geometryCollectionIndexedSpgist,
  });

  factory ObjectWithGeographyGeometryCollection({
    int? id,
    required _is.GeographyGeometryCollection geometryCollection,
    required _is.GeographyGeometryCollection geometryCollectionIndexedGist,
    required _is.GeographyGeometryCollection geometryCollectionIndexedSpgist,
  }) = _ObjectWithGeographyGeometryCollectionImpl;

  factory ObjectWithGeographyGeometryCollection.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyGeometryCollection(
      id: jsonSerialization['id'] as int?,
      geometryCollection: _is.GeographyGeometryCollectionJsonExtension.fromJson(
        jsonSerialization['geometryCollection'],
      ),
      geometryCollectionIndexedGist:
          _is.GeographyGeometryCollectionJsonExtension.fromJson(
            jsonSerialization['geometryCollectionIndexedGist'],
          ),
      geometryCollectionIndexedSpgist:
          _is.GeographyGeometryCollectionJsonExtension.fromJson(
            jsonSerialization['geometryCollectionIndexedSpgist'],
          ),
    );
  }

  static final t = ObjectWithGeographyGeometryCollectionTable();

  static const db = ObjectWithGeographyGeometryCollectionRepository._();

  @override
  int? id;

  _is.GeographyGeometryCollection geometryCollection;

  _is.GeographyGeometryCollection geometryCollectionIndexedGist;

  _is.GeographyGeometryCollection geometryCollectionIndexedSpgist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyGeometryCollection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithGeographyGeometryCollection copyWith({
    int? id,
    _is.GeographyGeometryCollection? geometryCollection,
    _is.GeographyGeometryCollection? geometryCollectionIndexedGist,
    _is.GeographyGeometryCollection? geometryCollectionIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyGeometryCollection',
      if (id != null) 'id': id,
      'geometryCollection': geometryCollection.toJson(),
      'geometryCollectionIndexedGist': geometryCollectionIndexedGist.toJson(),
      'geometryCollectionIndexedSpgist': geometryCollectionIndexedSpgist
          .toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyGeometryCollection',
      if (id != null) 'id': id,
      'geometryCollection': geometryCollection.toJson(),
      'geometryCollectionIndexedGist': geometryCollectionIndexedGist.toJson(),
      'geometryCollectionIndexedSpgist': geometryCollectionIndexedSpgist
          .toJson(),
    };
  }

  static ObjectWithGeographyGeometryCollectionInclude include() {
    return ObjectWithGeographyGeometryCollectionInclude._();
  }

  static ObjectWithGeographyGeometryCollectionIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithGeographyGeometryCollectionTable>?
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyGeometryCollectionTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyGeometryCollectionTable>?
    orderByList,
    ObjectWithGeographyGeometryCollectionInclude? include,
  }) {
    return ObjectWithGeographyGeometryCollectionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyGeometryCollection.t),
      orderByList: orderByList?.call(ObjectWithGeographyGeometryCollection.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyGeometryCollectionImpl
    extends ObjectWithGeographyGeometryCollection {
  _ObjectWithGeographyGeometryCollectionImpl({
    int? id,
    required _is.GeographyGeometryCollection geometryCollection,
    required _is.GeographyGeometryCollection geometryCollectionIndexedGist,
    required _is.GeographyGeometryCollection geometryCollectionIndexedSpgist,
  }) : super._(
         id: id,
         geometryCollection: geometryCollection,
         geometryCollectionIndexedGist: geometryCollectionIndexedGist,
         geometryCollectionIndexedSpgist: geometryCollectionIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyGeometryCollection]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithGeographyGeometryCollection copyWith({
    Object? id = _Undefined,
    _is.GeographyGeometryCollection? geometryCollection,
    _is.GeographyGeometryCollection? geometryCollectionIndexedGist,
    _is.GeographyGeometryCollection? geometryCollectionIndexedSpgist,
  }) {
    return ObjectWithGeographyGeometryCollection(
      id: id is int? ? id : this.id,
      geometryCollection: geometryCollection ?? this.geometryCollection,
      geometryCollectionIndexedGist:
          geometryCollectionIndexedGist ?? this.geometryCollectionIndexedGist,
      geometryCollectionIndexedSpgist:
          geometryCollectionIndexedSpgist ??
          this.geometryCollectionIndexedSpgist,
    );
  }
}

class ObjectWithGeographyGeometryCollectionUpdateTable
    extends _is.UpdateTable<ObjectWithGeographyGeometryCollectionTable> {
  ObjectWithGeographyGeometryCollectionUpdateTable(super.table);

  _is.ColumnValue<
    _is.GeographyGeometryCollection,
    _is.GeographyGeometryCollection
  >
  geometryCollection(_is.GeographyGeometryCollection value) => _is.ColumnValue(
    table.geometryCollection,
    value,
  );

  _is.ColumnValue<
    _is.GeographyGeometryCollection,
    _is.GeographyGeometryCollection
  >
  geometryCollectionIndexedGist(_is.GeographyGeometryCollection value) =>
      _is.ColumnValue(
        table.geometryCollectionIndexedGist,
        value,
      );

  _is.ColumnValue<
    _is.GeographyGeometryCollection,
    _is.GeographyGeometryCollection
  >
  geometryCollectionIndexedSpgist(_is.GeographyGeometryCollection value) =>
      _is.ColumnValue(
        table.geometryCollectionIndexedSpgist,
        value,
      );
}

class ObjectWithGeographyGeometryCollectionTable extends _is.Table<int?> {
  ObjectWithGeographyGeometryCollectionTable({super.tableRelation})
    : super(tableName: 'object_with_geography_geometry_collection') {
    updateTable = ObjectWithGeographyGeometryCollectionUpdateTable(this);
    geometryCollection = _is.ColumnGeographyGeometryCollection(
      'geometryCollection',
      this,
    );
    geometryCollectionIndexedGist = _is.ColumnGeographyGeometryCollection(
      'geometryCollectionIndexedGist',
      this,
    );
    geometryCollectionIndexedSpgist = _is.ColumnGeographyGeometryCollection(
      'geometryCollectionIndexedSpgist',
      this,
    );
  }

  late final ObjectWithGeographyGeometryCollectionUpdateTable updateTable;

  late final _is.ColumnGeographyGeometryCollection geometryCollection;

  late final _is.ColumnGeographyGeometryCollection
  geometryCollectionIndexedGist;

  late final _is.ColumnGeographyGeometryCollection
  geometryCollectionIndexedSpgist;

  @override
  List<_is.Column> get columns => [
    id,
    geometryCollection,
    geometryCollectionIndexedGist,
    geometryCollectionIndexedSpgist,
  ];
}

class ObjectWithGeographyGeometryCollectionInclude extends _is.IncludeObject {
  ObjectWithGeographyGeometryCollectionInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyGeometryCollection.t;
}

class ObjectWithGeographyGeometryCollectionIncludeList extends _is.IncludeList {
  ObjectWithGeographyGeometryCollectionIncludeList._({
    _is.WhereExpressionBuilder<ObjectWithGeographyGeometryCollectionTable>?
    where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithGeographyGeometryCollection.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyGeometryCollection.t;
}

class ObjectWithGeographyGeometryCollectionRepository {
  const ObjectWithGeographyGeometryCollectionRepository._();

  /// Returns a list of [ObjectWithGeographyGeometryCollection]s matching the given query parameters.
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
  Future<List<ObjectWithGeographyGeometryCollection>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyGeometryCollectionTable>?
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyGeometryCollectionTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyGeometryCollectionTable>?
    orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithGeographyGeometryCollection>(
      where: where?.call(ObjectWithGeographyGeometryCollection.t),
      orderBy: orderBy?.call(ObjectWithGeographyGeometryCollection.t),
      orderByList: orderByList?.call(ObjectWithGeographyGeometryCollection.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithGeographyGeometryCollection] matching the given query parameters.
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
  Future<ObjectWithGeographyGeometryCollection?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyGeometryCollectionTable>?
    where,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyGeometryCollectionTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyGeometryCollectionTable>?
    orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithGeographyGeometryCollection>(
      where: where?.call(ObjectWithGeographyGeometryCollection.t),
      orderBy: orderBy?.call(ObjectWithGeographyGeometryCollection.t),
      orderByList: orderByList?.call(ObjectWithGeographyGeometryCollection.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithGeographyGeometryCollection] by its [id] or null if no such row exists.
  Future<ObjectWithGeographyGeometryCollection?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithGeographyGeometryCollection>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithGeographyGeometryCollection]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithGeographyGeometryCollection]s will have their `id` fields set.
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
  Future<List<ObjectWithGeographyGeometryCollection>> insert(
    _is.DatabaseSession session,
    List<ObjectWithGeographyGeometryCollection> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithGeographyGeometryCollection>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithGeographyGeometryCollection] and returns the inserted row.
  ///
  /// The returned [ObjectWithGeographyGeometryCollection] will have its `id` field set.
  Future<ObjectWithGeographyGeometryCollection> insertRow(
    _is.DatabaseSession session,
    ObjectWithGeographyGeometryCollection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithGeographyGeometryCollection>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithGeographyGeometryCollection]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithGeographyGeometryCollection]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyGeometryCollection>> upsert(
    _is.DatabaseSession session,
    List<ObjectWithGeographyGeometryCollection> rows, {
    required _is.ColumnSelections<ObjectWithGeographyGeometryCollectionTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyGeometryCollectionTable>?
    updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyGeometryCollectionTable>?
    updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithGeographyGeometryCollection>(
      rows,
      conflictColumns: conflictColumns(ObjectWithGeographyGeometryCollection.t),
      updateColumns: updateColumns?.call(
        ObjectWithGeographyGeometryCollection.t,
      ),
      updateWhere: updateWhere?.call(ObjectWithGeographyGeometryCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithGeographyGeometryCollection] and returns the resulting row.
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
  /// The returned [ObjectWithGeographyGeometryCollection] will have its `id` field set.
  Future<ObjectWithGeographyGeometryCollection?> upsertRow(
    _is.DatabaseSession session,
    ObjectWithGeographyGeometryCollection row, {
    required _is.ColumnSelections<ObjectWithGeographyGeometryCollectionTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyGeometryCollectionTable>?
    updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyGeometryCollectionTable>?
    updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithGeographyGeometryCollection>(
      row,
      conflictColumns: conflictColumns(ObjectWithGeographyGeometryCollection.t),
      updateColumns: updateColumns?.call(
        ObjectWithGeographyGeometryCollection.t,
      ),
      updateWhere: updateWhere?.call(ObjectWithGeographyGeometryCollection.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyGeometryCollection]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyGeometryCollection>> update(
    _is.DatabaseSession session,
    List<ObjectWithGeographyGeometryCollection> rows, {
    _is.ColumnSelections<ObjectWithGeographyGeometryCollectionTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithGeographyGeometryCollection>(
      rows,
      columns: columns?.call(ObjectWithGeographyGeometryCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithGeographyGeometryCollection]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithGeographyGeometryCollection> updateRow(
    _is.DatabaseSession session,
    ObjectWithGeographyGeometryCollection row, {
    _is.ColumnSelections<ObjectWithGeographyGeometryCollectionTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithGeographyGeometryCollection>(
      row,
      columns: columns?.call(ObjectWithGeographyGeometryCollection.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyGeometryCollection] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithGeographyGeometryCollection?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      ObjectWithGeographyGeometryCollectionUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithGeographyGeometryCollection>(
      id,
      columnValues: columnValues(
        ObjectWithGeographyGeometryCollection.t.updateTable,
      ),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyGeometryCollection]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyGeometryCollection>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      ObjectWithGeographyGeometryCollectionUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<
      ObjectWithGeographyGeometryCollectionTable
    >
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyGeometryCollectionTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyGeometryCollectionTable>?
    orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithGeographyGeometryCollection>(
      columnValues: columnValues(
        ObjectWithGeographyGeometryCollection.t.updateTable,
      ),
      where: where(ObjectWithGeographyGeometryCollection.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyGeometryCollection.t),
      orderByList: orderByList?.call(ObjectWithGeographyGeometryCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithGeographyGeometryCollection]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithGeographyGeometryCollection>> delete(
    _is.DatabaseSession session,
    List<ObjectWithGeographyGeometryCollection> rows, {
    _is.OrderByBuilder<ObjectWithGeographyGeometryCollectionTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyGeometryCollectionTable>?
    orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithGeographyGeometryCollection>(
      rows,
      orderBy: orderBy?.call(ObjectWithGeographyGeometryCollection.t),
      orderByList: orderByList?.call(ObjectWithGeographyGeometryCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithGeographyGeometryCollection].
  Future<ObjectWithGeographyGeometryCollection> deleteRow(
    _is.DatabaseSession session,
    ObjectWithGeographyGeometryCollection row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithGeographyGeometryCollection>(
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
  Future<List<ObjectWithGeographyGeometryCollection>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<
      ObjectWithGeographyGeometryCollectionTable
    >
    where,
    _is.OrderByBuilder<ObjectWithGeographyGeometryCollectionTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyGeometryCollectionTable>?
    orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithGeographyGeometryCollection>(
      where: where(ObjectWithGeographyGeometryCollection.t),
      orderBy: orderBy?.call(ObjectWithGeographyGeometryCollection.t),
      orderByList: orderByList?.call(ObjectWithGeographyGeometryCollection.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyGeometryCollectionTable>?
    where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyGeometryCollection>(
      where: where?.call(ObjectWithGeographyGeometryCollection.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyGeometryCollection] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<
      ObjectWithGeographyGeometryCollectionTable
    >
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyGeometryCollection>(
      where: where(ObjectWithGeographyGeometryCollection.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

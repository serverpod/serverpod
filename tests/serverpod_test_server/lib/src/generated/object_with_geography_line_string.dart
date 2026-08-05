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

abstract class ObjectWithGeographyLineString
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ObjectWithGeographyLineString._({
    this.id,
    required this.lineString,
    required this.lineStringIndexedGist,
    required this.lineStringIndexedSpgist,
  });

  factory ObjectWithGeographyLineString({
    int? id,
    required _i1.GeographyLineString lineString,
    required _i1.GeographyLineString lineStringIndexedGist,
    required _i1.GeographyLineString lineStringIndexedSpgist,
  }) = _ObjectWithGeographyLineStringImpl;

  factory ObjectWithGeographyLineString.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyLineString(
      id: jsonSerialization['id'] as int?,
      lineString: _i1.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineString'],
      ),
      lineStringIndexedGist: _i1.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineStringIndexedGist'],
      ),
      lineStringIndexedSpgist: _i1.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineStringIndexedSpgist'],
      ),
    );
  }

  static final t = ObjectWithGeographyLineStringTable();

  static const db = ObjectWithGeographyLineStringRepository._();

  @override
  int? id;

  _i1.GeographyLineString lineString;

  _i1.GeographyLineString lineStringIndexedGist;

  _i1.GeographyLineString lineStringIndexedSpgist;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithGeographyLineString copyWith({
    int? id,
    _i1.GeographyLineString? lineString,
    _i1.GeographyLineString? lineStringIndexedGist,
    _i1.GeographyLineString? lineStringIndexedSpgist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithGeographyLineString',
      if (id != null) 'id': id,
      'lineString': lineString.toJson(),
      'lineStringIndexedGist': lineStringIndexedGist.toJson(),
      'lineStringIndexedSpgist': lineStringIndexedSpgist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithGeographyLineString',
      if (id != null) 'id': id,
      'lineString': lineString.toJson(),
      'lineStringIndexedGist': lineStringIndexedGist.toJson(),
      'lineStringIndexedSpgist': lineStringIndexedSpgist.toJson(),
    };
  }

  static ObjectWithGeographyLineStringInclude include() {
    return ObjectWithGeographyLineStringInclude._();
  }

  static ObjectWithGeographyLineStringIncludeList includeList({
    _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    ObjectWithGeographyLineStringInclude? include,
  }) {
    return ObjectWithGeographyLineStringIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyLineString.t),
      orderByList: orderByList?.call(ObjectWithGeographyLineString.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyLineStringImpl extends ObjectWithGeographyLineString {
  _ObjectWithGeographyLineStringImpl({
    int? id,
    required _i1.GeographyLineString lineString,
    required _i1.GeographyLineString lineStringIndexedGist,
    required _i1.GeographyLineString lineStringIndexedSpgist,
  }) : super._(
         id: id,
         lineString: lineString,
         lineStringIndexedGist: lineStringIndexedGist,
         lineStringIndexedSpgist: lineStringIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithGeographyLineString copyWith({
    Object? id = _Undefined,
    _i1.GeographyLineString? lineString,
    _i1.GeographyLineString? lineStringIndexedGist,
    _i1.GeographyLineString? lineStringIndexedSpgist,
  }) {
    return ObjectWithGeographyLineString(
      id: id is int? ? id : this.id,
      lineString: lineString ?? this.lineString,
      lineStringIndexedGist:
          lineStringIndexedGist ?? this.lineStringIndexedGist,
      lineStringIndexedSpgist:
          lineStringIndexedSpgist ?? this.lineStringIndexedSpgist,
    );
  }
}

class ObjectWithGeographyLineStringUpdateTable
    extends _i1.UpdateTable<ObjectWithGeographyLineStringTable> {
  ObjectWithGeographyLineStringUpdateTable(super.table);

  _i1.ColumnValue<_i1.GeographyLineString, _i1.GeographyLineString> lineString(
    _i1.GeographyLineString value,
  ) => _i1.ColumnValue(
    table.lineString,
    value,
  );

  _i1.ColumnValue<_i1.GeographyLineString, _i1.GeographyLineString>
  lineStringIndexedGist(_i1.GeographyLineString value) => _i1.ColumnValue(
    table.lineStringIndexedGist,
    value,
  );

  _i1.ColumnValue<_i1.GeographyLineString, _i1.GeographyLineString>
  lineStringIndexedSpgist(_i1.GeographyLineString value) => _i1.ColumnValue(
    table.lineStringIndexedSpgist,
    value,
  );
}

class ObjectWithGeographyLineStringTable extends _i1.Table<int?> {
  ObjectWithGeographyLineStringTable({super.tableRelation})
    : super(tableName: 'object_with_geography_line_string') {
    updateTable = ObjectWithGeographyLineStringUpdateTable(this);
    lineString = _i1.ColumnGeographyLineString(
      'lineString',
      this,
    );
    lineStringIndexedGist = _i1.ColumnGeographyLineString(
      'lineStringIndexedGist',
      this,
    );
    lineStringIndexedSpgist = _i1.ColumnGeographyLineString(
      'lineStringIndexedSpgist',
      this,
    );
  }

  late final ObjectWithGeographyLineStringUpdateTable updateTable;

  late final _i1.ColumnGeographyLineString lineString;

  late final _i1.ColumnGeographyLineString lineStringIndexedGist;

  late final _i1.ColumnGeographyLineString lineStringIndexedSpgist;

  @override
  List<_i1.Column> get columns => [
    id,
    lineString,
    lineStringIndexedGist,
    lineStringIndexedSpgist,
  ];
}

class ObjectWithGeographyLineStringInclude extends _i1.IncludeObject {
  ObjectWithGeographyLineStringInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyLineString.t;
}

class ObjectWithGeographyLineStringIncludeList extends _i1.IncludeList {
  ObjectWithGeographyLineStringIncludeList._({
    _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ObjectWithGeographyLineString.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ObjectWithGeographyLineString.t;
}

class ObjectWithGeographyLineStringRepository {
  const ObjectWithGeographyLineStringRepository._();

  /// Returns a list of [ObjectWithGeographyLineString]s matching the given query parameters.
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
  Future<List<ObjectWithGeographyLineString>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ObjectWithGeographyLineString>(
      where: where?.call(ObjectWithGeographyLineString.t),
      orderBy: orderBy?.call(ObjectWithGeographyLineString.t),
      orderByList: orderByList?.call(ObjectWithGeographyLineString.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ObjectWithGeographyLineString] matching the given query parameters.
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
  Future<ObjectWithGeographyLineString?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ObjectWithGeographyLineString>(
      where: where?.call(ObjectWithGeographyLineString.t),
      orderBy: orderBy?.call(ObjectWithGeographyLineString.t),
      orderByList: orderByList?.call(ObjectWithGeographyLineString.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ObjectWithGeographyLineString] by its [id] or null if no such row exists.
  Future<ObjectWithGeographyLineString?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ObjectWithGeographyLineString>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ObjectWithGeographyLineString]s in the list and returns the inserted rows.
  ///
  /// The returned [ObjectWithGeographyLineString]s will have their `id` fields set.
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
  Future<List<ObjectWithGeographyLineString>> insert(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ObjectWithGeographyLineString>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ObjectWithGeographyLineString] and returns the inserted row.
  ///
  /// The returned [ObjectWithGeographyLineString] will have its `id` field set.
  Future<ObjectWithGeographyLineString> insertRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ObjectWithGeographyLineString>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ObjectWithGeographyLineString]s in the list and returns the resulting rows.
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
  /// The returned [ObjectWithGeographyLineString]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyLineString>> upsert(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    required _i1.ColumnSelections<ObjectWithGeographyLineStringTable>
    conflictColumns,
    _i1.ColumnSelections<ObjectWithGeographyLineStringTable>? updateColumns,
    _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ObjectWithGeographyLineString>(
      rows,
      conflictColumns: conflictColumns(ObjectWithGeographyLineString.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyLineString.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyLineString.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ObjectWithGeographyLineString] and returns the resulting row.
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
  /// The returned [ObjectWithGeographyLineString] will have its `id` field set.
  Future<ObjectWithGeographyLineString?> upsertRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    required _i1.ColumnSelections<ObjectWithGeographyLineStringTable>
    conflictColumns,
    _i1.ColumnSelections<ObjectWithGeographyLineStringTable>? updateColumns,
    _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ObjectWithGeographyLineString>(
      row,
      conflictColumns: conflictColumns(ObjectWithGeographyLineString.t),
      updateColumns: updateColumns?.call(ObjectWithGeographyLineString.t),
      updateWhere: updateWhere?.call(ObjectWithGeographyLineString.t),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyLineString]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyLineString>> update(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    _i1.ColumnSelections<ObjectWithGeographyLineStringTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ObjectWithGeographyLineString>(
      rows,
      columns: columns?.call(ObjectWithGeographyLineString.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ObjectWithGeographyLineString]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ObjectWithGeographyLineString> updateRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    _i1.ColumnSelections<ObjectWithGeographyLineStringTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ObjectWithGeographyLineString>(
      row,
      columns: columns?.call(ObjectWithGeographyLineString.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ObjectWithGeographyLineString] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ObjectWithGeographyLineString?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<
      ObjectWithGeographyLineStringUpdateTable
    >
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ObjectWithGeographyLineString>(
      id,
      columnValues: columnValues(ObjectWithGeographyLineString.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ObjectWithGeographyLineString]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ObjectWithGeographyLineString>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<
      ObjectWithGeographyLineStringUpdateTable
    >
    columnValues,
    required _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>
    where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ObjectWithGeographyLineString>(
      columnValues: columnValues(ObjectWithGeographyLineString.t.updateTable),
      where: where(ObjectWithGeographyLineString.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyLineString.t),
      orderByList: orderByList?.call(ObjectWithGeographyLineString.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ObjectWithGeographyLineString]s in the list and returns the deleted rows.
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
  Future<List<ObjectWithGeographyLineString>> delete(
    _i1.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    _i1.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ObjectWithGeographyLineString>(
      rows,
      orderBy: orderBy?.call(ObjectWithGeographyLineString.t),
      orderByList: orderByList?.call(ObjectWithGeographyLineString.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ObjectWithGeographyLineString].
  Future<ObjectWithGeographyLineString> deleteRow(
    _i1.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ObjectWithGeographyLineString>(
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
  Future<List<ObjectWithGeographyLineString>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>
    where,
    _i1.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _i1.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ObjectWithGeographyLineString>(
      where: where(ObjectWithGeographyLineString.t),
      orderBy: orderBy?.call(ObjectWithGeographyLineString.t),
      orderByList: orderByList?.call(ObjectWithGeographyLineString.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyLineString>(
      where: where?.call(ObjectWithGeographyLineString.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyLineString] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>
    where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyLineString>(
      where: where(ObjectWithGeographyLineString.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

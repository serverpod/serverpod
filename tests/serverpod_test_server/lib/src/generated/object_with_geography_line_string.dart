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

abstract class ObjectWithGeographyLineString
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ObjectWithGeographyLineString._({
    this.id,
    required this.lineString,
    required this.lineStringIndexedGist,
    required this.lineStringIndexedSpgist,
  });

  factory ObjectWithGeographyLineString({
    int? id,
    required _is.GeographyLineString lineString,
    required _is.GeographyLineString lineStringIndexedGist,
    required _is.GeographyLineString lineStringIndexedSpgist,
  }) = _ObjectWithGeographyLineStringImpl;

  factory ObjectWithGeographyLineString.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithGeographyLineString(
      id: jsonSerialization['id'] as int?,
      lineString: _is.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineString'],
      ),
      lineStringIndexedGist: _is.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineStringIndexedGist'],
      ),
      lineStringIndexedSpgist: _is.GeographyLineStringJsonExtension.fromJson(
        jsonSerialization['lineStringIndexedSpgist'],
      ),
    );
  }

  static final t = ObjectWithGeographyLineStringTable();

  static const db = ObjectWithGeographyLineStringRepository._();

  @override
  int? id;

  _is.GeographyLineString lineString;

  _is.GeographyLineString lineStringIndexedGist;

  _is.GeographyLineString lineStringIndexedSpgist;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithGeographyLineString copyWith({
    int? id,
    _is.GeographyLineString? lineString,
    _is.GeographyLineString? lineStringIndexedGist,
    _is.GeographyLineString? lineStringIndexedSpgist,
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

  static ObjectWithGeographyLineStringInclude include({
    _is.SelectColumnsBuilder<ObjectWithGeographyLineStringTable>? select,
  }) {
    return ObjectWithGeographyLineStringInclude.internal_(
      selectedColumns: select?.call(ObjectWithGeographyLineString.t),
    );
  }

  static ObjectWithGeographyLineStringIncludeList includeList({
    _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    ObjectWithGeographyLineStringInclude? include,
    _is.SelectColumnsBuilder<ObjectWithGeographyLineStringTable>? select,
  }) {
    return ObjectWithGeographyLineStringIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ObjectWithGeographyLineString.t),
      orderByList: orderByList?.call(ObjectWithGeographyLineString.t),
      include: include,
      selectedColumns: select?.call(ObjectWithGeographyLineString.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithGeographyLineStringImpl extends ObjectWithGeographyLineString {
  _ObjectWithGeographyLineStringImpl({
    int? id,
    required _is.GeographyLineString lineString,
    required _is.GeographyLineString lineStringIndexedGist,
    required _is.GeographyLineString lineStringIndexedSpgist,
  }) : super._(
         id: id,
         lineString: lineString,
         lineStringIndexedGist: lineStringIndexedGist,
         lineStringIndexedSpgist: lineStringIndexedSpgist,
       );

  /// Returns a shallow copy of this [ObjectWithGeographyLineString]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithGeographyLineString copyWith({
    Object? id = _Undefined,
    _is.GeographyLineString? lineString,
    _is.GeographyLineString? lineStringIndexedGist,
    _is.GeographyLineString? lineStringIndexedSpgist,
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
    extends _is.UpdateTable<ObjectWithGeographyLineStringTable> {
  ObjectWithGeographyLineStringUpdateTable(super.table);

  _is.ColumnValue<_is.GeographyLineString, _is.GeographyLineString> lineString(
    _is.GeographyLineString value,
  ) => _is.ColumnValue(
    table.lineString,
    value,
  );

  _is.ColumnValue<_is.GeographyLineString, _is.GeographyLineString>
  lineStringIndexedGist(_is.GeographyLineString value) => _is.ColumnValue(
    table.lineStringIndexedGist,
    value,
  );

  _is.ColumnValue<_is.GeographyLineString, _is.GeographyLineString>
  lineStringIndexedSpgist(_is.GeographyLineString value) => _is.ColumnValue(
    table.lineStringIndexedSpgist,
    value,
  );
}

class ObjectWithGeographyLineStringTable extends _is.Table<int?> {
  ObjectWithGeographyLineStringTable({super.tableRelation})
    : super(tableName: 'object_with_geography_line_string') {
    updateTable = ObjectWithGeographyLineStringUpdateTable(this);
    lineString = _is.ColumnGeographyLineString(
      'lineString',
      this,
    );
    lineStringIndexedGist = _is.ColumnGeographyLineString(
      'lineStringIndexedGist',
      this,
    );
    lineStringIndexedSpgist = _is.ColumnGeographyLineString(
      'lineStringIndexedSpgist',
      this,
    );
  }

  late final ObjectWithGeographyLineStringUpdateTable updateTable;

  late final _is.ColumnGeographyLineString lineString;

  late final _is.ColumnGeographyLineString lineStringIndexedGist;

  late final _is.ColumnGeographyLineString lineStringIndexedSpgist;

  @override
  List<_is.Column> get columns => [
    id,
    lineString,
    lineStringIndexedGist,
    lineStringIndexedSpgist,
  ];
}

class ObjectWithGeographyLineStringInclude extends _is.IncludeObject {
  ObjectWithGeographyLineStringInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyLineString.t;
}

class ObjectWithGeographyLineStringIncludeList extends _is.IncludeList {
  ObjectWithGeographyLineStringIncludeList.internal_({
    _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ObjectWithGeographyLineString.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ObjectWithGeographyLineString.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    required _is.ColumnSelections<ObjectWithGeographyLineStringTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyLineStringTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    required _is.ColumnSelections<ObjectWithGeographyLineStringTable>
    conflictColumns,
    _is.ColumnSelections<ObjectWithGeographyLineStringTable>? updateColumns,
    _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    _is.ColumnSelections<ObjectWithGeographyLineStringTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    _is.ColumnSelections<ObjectWithGeographyLineStringTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      ObjectWithGeographyLineStringUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      ObjectWithGeographyLineStringUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<ObjectWithGeographyLineString> rows, {
    _is.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    ObjectWithGeographyLineString row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>
    where,
    _is.OrderByBuilder<ObjectWithGeographyLineStringTable>? orderBy,
    _is.OrderByListBuilder<ObjectWithGeographyLineStringTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ObjectWithGeographyLineString>(
      where: where?.call(ObjectWithGeographyLineString.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ObjectWithGeographyLineString] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ObjectWithGeographyLineStringTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ObjectWithGeographyLineString>(
      where: where(ObjectWithGeographyLineString.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class MaxFieldName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MaxFieldName._({
    this.id,
    required this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  });

  factory MaxFieldName({
    int? id,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) = _MaxFieldNameImpl;

  factory MaxFieldName.fromJson(Map<String, dynamic> jsonSerialization) {
    return MaxFieldName(
      id: jsonSerialization['id'] as int?,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          jsonSerialization['thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo']
              as String,
    );
  }

  static final t = MaxFieldNameTable();

  static const db = MaxFieldNameRepository._();

  @override
  int? id;

  String thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MaxFieldName copyWith({
    int? id,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MaxFieldName',
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MaxFieldName',
      if (id != null) 'id': id,
      'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo':
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    };
  }

  /// Builds a complete [MaxFieldNameInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static MaxFieldNameInclude include() {
    return MaxFieldNameInclude._();
  }

  /// Builds a complete [MaxFieldNameIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static MaxFieldNameIncludeList includeList({
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    MaxFieldNameInclude? include,
  }) {
    return MaxFieldNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [MaxFieldNameJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static MaxFieldNameJsonInclude includeJson({
    _is.SelectColumnsBuilder<MaxFieldNameTable>? select,
  }) {
    return _MaxFieldNameJsonInclude._(
      selectedColumns: select?.call(MaxFieldName.t),
    );
  }

  /// Builds a JSON-compatible [MaxFieldNameJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static MaxFieldNameJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    MaxFieldNameJsonInclude? include,
    _is.SelectColumnsBuilder<MaxFieldNameTable>? select,
  }) {
    return _MaxFieldNameJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      include: include,
      selectedColumns: select?.call(MaxFieldName.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MaxFieldNameImpl extends MaxFieldName {
  _MaxFieldNameImpl({
    int? id,
    required String
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) : super._(
         id: id,
         thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
             thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
       );

  /// Returns a shallow copy of this [MaxFieldName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MaxFieldName copyWith({
    Object? id = _Undefined,
    String? thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  }) {
    return MaxFieldName(
      id: id is int? ? id : this.id,
      thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo:
          thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo ??
          this.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
    );
  }
}

class MaxFieldNameUpdateTable extends _is.UpdateTable<MaxFieldNameTable> {
  MaxFieldNameUpdateTable(super.table);

  _is.ColumnValue<String, String>
  thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo(String value) =>
      _is.ColumnValue(
        table.thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
        value,
      );
}

class MaxFieldNameTable extends _is.Table<int?> {
  MaxFieldNameTable({super.tableRelation})
    : super(tableName: 'max_field_name') {
    updateTable = MaxFieldNameUpdateTable(this);
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo =
        _is.ColumnString(
          'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
          this,
        );
  }

  late final MaxFieldNameUpdateTable updateTable;

  late final _is.ColumnString
  thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo;

  @override
  List<_is.Column> get columns => [
    id,
    thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo,
  ];
}

abstract interface class MaxFieldNameJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class MaxFieldNameJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class MaxFieldNameInclude extends _is.IncludeObject
    implements MaxFieldNameJsonInclude, _is.FullModelInclude {
  MaxFieldNameInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MaxFieldName.t;
}

final class MaxFieldNameIncludeList extends _is.IncludeList
    implements MaxFieldNameJsonIncludeList, _is.FullModelInclude {
  MaxFieldNameIncludeList._({
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    MaxFieldNameInclude? super.include,
  }) {
    super.where = where?.call(MaxFieldName.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MaxFieldName.t;
}

final class _MaxFieldNameJsonInclude extends _is.IncludeObject
    implements MaxFieldNameJsonInclude {
  _MaxFieldNameJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MaxFieldName.t;
}

final class _MaxFieldNameJsonIncludeList extends _is.IncludeList
    implements MaxFieldNameJsonIncludeList {
  _MaxFieldNameJsonIncludeList._({
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    MaxFieldNameJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(MaxFieldName.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MaxFieldName.t;
}

class MaxFieldNameRepository {
  const MaxFieldNameRepository._();

  /// Returns a list of [MaxFieldName]s matching the given query parameters.
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
  Future<List<MaxFieldName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MaxFieldName] matching the given query parameters.
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
  Future<MaxFieldName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? offset,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MaxFieldName] by its [id] or null if no such row exists.
  Future<MaxFieldName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MaxFieldName>(
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
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<MaxFieldNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(MaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? offset,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<MaxFieldNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(MaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<MaxFieldNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<MaxFieldName>(
      id,
      transaction: transaction,
      select: select?.call(MaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MaxFieldName]s in the list and returns the inserted rows.
  ///
  /// The returned [MaxFieldName]s will have their `id` fields set.
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
  Future<List<MaxFieldName>> insert(
    _is.DatabaseSession session,
    List<MaxFieldName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MaxFieldName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MaxFieldName] and returns the inserted row.
  ///
  /// The returned [MaxFieldName] will have its `id` field set.
  Future<MaxFieldName> insertRow(
    _is.DatabaseSession session,
    MaxFieldName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MaxFieldName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MaxFieldName]s in the list and returns the resulting rows.
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
  /// The returned [MaxFieldName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MaxFieldName>> upsert(
    _is.DatabaseSession session,
    List<MaxFieldName> rows, {
    required _is.ColumnSelections<MaxFieldNameTable> conflictColumns,
    _is.ColumnSelections<MaxFieldNameTable>? updateColumns,
    _is.WhereExpressionBuilder<MaxFieldNameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MaxFieldName>(
      rows,
      conflictColumns: conflictColumns(MaxFieldName.t),
      updateColumns: updateColumns?.call(MaxFieldName.t),
      updateWhere: updateWhere?.call(MaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MaxFieldName] and returns the resulting row.
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
  /// The returned [MaxFieldName] will have its `id` field set.
  Future<MaxFieldName?> upsertRow(
    _is.DatabaseSession session,
    MaxFieldName row, {
    required _is.ColumnSelections<MaxFieldNameTable> conflictColumns,
    _is.ColumnSelections<MaxFieldNameTable>? updateColumns,
    _is.WhereExpressionBuilder<MaxFieldNameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MaxFieldName>(
      row,
      conflictColumns: conflictColumns(MaxFieldName.t),
      updateColumns: updateColumns?.call(MaxFieldName.t),
      updateWhere: updateWhere?.call(MaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates all [MaxFieldName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MaxFieldName>> update(
    _is.DatabaseSession session,
    List<MaxFieldName> rows, {
    _is.ColumnSelections<MaxFieldNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MaxFieldName>(
      rows,
      columns: columns?.call(MaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MaxFieldName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MaxFieldName> updateRow(
    _is.DatabaseSession session,
    MaxFieldName row, {
    _is.ColumnSelections<MaxFieldNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MaxFieldName>(
      row,
      columns: columns?.call(MaxFieldName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MaxFieldName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MaxFieldName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MaxFieldNameUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MaxFieldName>(
      id,
      columnValues: columnValues(MaxFieldName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MaxFieldName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MaxFieldName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MaxFieldNameUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MaxFieldNameTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MaxFieldName>(
      columnValues: columnValues(MaxFieldName.t.updateTable),
      where: where(MaxFieldName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MaxFieldName]s in the list and returns the deleted rows.
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
  Future<List<MaxFieldName>> delete(
    _is.DatabaseSession session,
    List<MaxFieldName> rows, {
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MaxFieldName>(
      rows,
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MaxFieldName].
  Future<MaxFieldName> deleteRow(
    _is.DatabaseSession session,
    MaxFieldName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MaxFieldName>(
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
  Future<List<MaxFieldName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MaxFieldNameTable> where,
    _is.OrderByBuilder<MaxFieldNameTable>? orderBy,
    _is.OrderByListBuilder<MaxFieldNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MaxFieldName>(
      where: where(MaxFieldName.t),
      orderBy: orderBy?.call(MaxFieldName.t),
      orderByList: orderByList?.call(MaxFieldName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MaxFieldNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MaxFieldName>(
      where: where?.call(MaxFieldName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MaxFieldName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MaxFieldNameTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MaxFieldName>(
      where: where(MaxFieldName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

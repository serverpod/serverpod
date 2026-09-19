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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;

abstract class Chapter
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Chapter._({
    this.id,
    required this.title,
  }) : _bookChaptersBookId = null;

  factory Chapter({
    int? id,
    required String title,
  }) = _ChapterImpl;

  factory Chapter.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChapterImplicit._(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      $_bookChaptersBookId: jsonSerialization['_bookChaptersBookId'] as int?,
    );
  }

  static final t = ChapterTable();

  static const db = ChapterRepository._();

  @override
  int? id;

  String title;

  final int? _bookChaptersBookId;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Chapter copyWith({
    int? id,
    String? title,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Chapter',
      if (id != null) 'id': id,
      'title': title,
      if (_bookChaptersBookId != null)
        '_bookChaptersBookId': _bookChaptersBookId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Chapter',
      if (id != null) 'id': id,
      'title': title,
    };
  }

  /// Builds a complete [ChapterInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ChapterInclude include() {
    return ChapterInclude._();
  }

  /// Builds a complete [ChapterIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ChapterIncludeList includeList({
    _isd.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    ChapterInclude? include,
  }) {
    return ChapterIncludeList._(
      where: where?.call(Chapter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ChapterJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ChapterJsonInclude includeJson({
    _isd.SelectColumnsBuilder<ChapterTable>? select,
  }) {
    return _ChapterJsonInclude._(selectedColumns: select?.call(Chapter.t));
  }

  /// Builds a JSON-compatible [ChapterJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ChapterJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    ChapterJsonInclude? include,
    _isd.SelectColumnsBuilder<ChapterTable>? select,
  }) {
    return _ChapterJsonIncludeList._(
      where: where?.call(Chapter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      include: include,
      selectedColumns: select?.call(Chapter.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChapterImpl extends Chapter {
  _ChapterImpl({
    int? id,
    required String title,
  }) : super._(
         id: id,
         title: title,
       );

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Chapter copyWith({
    Object? id = _Undefined,
    String? title,
  }) {
    return ChapterImplicit._(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      $_bookChaptersBookId: this._bookChaptersBookId,
    );
  }
}

class ChapterImplicit extends _ChapterImpl {
  ChapterImplicit._({
    int? id,
    required String title,
    int? $_bookChaptersBookId,
  }) : _bookChaptersBookId = $_bookChaptersBookId,
       super(
         id: id,
         title: title,
       );

  factory ChapterImplicit(
    Chapter chapter, {
    int? $_bookChaptersBookId,
  }) {
    return ChapterImplicit._(
      id: chapter.id,
      title: chapter.title,
      $_bookChaptersBookId: $_bookChaptersBookId,
    );
  }

  @override
  final int? _bookChaptersBookId;
}

class ChapterUpdateTable extends _isd.UpdateTable<ChapterTable> {
  ChapterUpdateTable(super.table);

  _isd.ColumnValue<String, String> title(String value) => _isd.ColumnValue(
    table.title,
    value,
  );

  _isd.ColumnValue<int, int> $_bookChaptersBookId(int? value) =>
      _isd.ColumnValue(
        table.$_bookChaptersBookId,
        value,
      );
}

class ChapterTable extends _isd.Table<int?> {
  ChapterTable({super.tableRelation}) : super(tableName: 'chapter') {
    updateTable = ChapterUpdateTable(this);
    title = _isd.ColumnString(
      'title',
      this,
    );
    $_bookChaptersBookId = _isd.ColumnInt(
      '_bookChaptersBookId',
      this,
    );
  }

  late final ChapterUpdateTable updateTable;

  late final _isd.ColumnString title;

  late final _isd.ColumnInt $_bookChaptersBookId;

  @override
  List<_isd.Column> get columns => [
    id,
    title,
    $_bookChaptersBookId,
  ];

  @override
  List<_isd.Column> get managedColumns => [
    id,
    title,
  ];
}

abstract interface class ChapterJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class ChapterJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class ChapterInclude extends _isd.IncludeObject
    implements ChapterJsonInclude, _isd.FullModelInclude {
  ChapterInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => Chapter.t;
}

final class ChapterIncludeList extends _isd.IncludeList
    implements ChapterJsonIncludeList, _isd.FullModelInclude {
  ChapterIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ChapterInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Chapter.t;
}

final class _ChapterJsonInclude extends _isd.IncludeObject
    implements ChapterJsonInclude {
  _ChapterJsonInclude._({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => Chapter.t;
}

final class _ChapterJsonIncludeList extends _isd.IncludeList
    implements ChapterJsonIncludeList {
  _ChapterJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ChapterJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Chapter.t;
}

class ChapterRepository {
  const ChapterRepository._();

  /// Returns a list of [Chapter]s matching the given query parameters.
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
  Future<List<Chapter>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Chapter>(
      where: where?.call(Chapter.t),
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Chapter] matching the given query parameters.
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
  Future<Chapter?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ChapterTable>? where,
    int? offset,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Chapter>(
      where: where?.call(Chapter.t),
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Chapter] by its [id] or null if no such row exists.
  Future<Chapter?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Chapter>(
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<ChapterTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Chapter>(
      where: where?.call(Chapter.t),
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(Chapter.t),
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ChapterTable>? where,
    int? offset,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<ChapterTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Chapter>(
      where: where?.call(Chapter.t),
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(Chapter.t),
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
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<ChapterTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Chapter>(
      id,
      transaction: transaction,
      select: select?.call(Chapter.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Chapter]s in the list and returns the inserted rows.
  ///
  /// The returned [Chapter]s will have their `id` fields set.
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
  Future<List<Chapter>> insert(
    _isd.DatabaseSession session,
    List<Chapter> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Chapter>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Chapter] and returns the inserted row.
  ///
  /// The returned [Chapter] will have its `id` field set.
  Future<Chapter> insertRow(
    _isd.DatabaseSession session,
    Chapter row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Chapter>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Chapter]s in the list and returns the resulting rows.
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
  /// The returned [Chapter]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Chapter>> upsert(
    _isd.DatabaseSession session,
    List<Chapter> rows, {
    required _isd.ColumnSelections<ChapterTable> conflictColumns,
    _isd.ColumnSelections<ChapterTable>? updateColumns,
    _isd.WhereExpressionBuilder<ChapterTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Chapter>(
      rows,
      conflictColumns: conflictColumns(Chapter.t),
      updateColumns: updateColumns?.call(Chapter.t),
      updateWhere: updateWhere?.call(Chapter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Chapter] and returns the resulting row.
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
  /// The returned [Chapter] will have its `id` field set.
  Future<Chapter?> upsertRow(
    _isd.DatabaseSession session,
    Chapter row, {
    required _isd.ColumnSelections<ChapterTable> conflictColumns,
    _isd.ColumnSelections<ChapterTable>? updateColumns,
    _isd.WhereExpressionBuilder<ChapterTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Chapter>(
      row,
      conflictColumns: conflictColumns(Chapter.t),
      updateColumns: updateColumns?.call(Chapter.t),
      updateWhere: updateWhere?.call(Chapter.t),
      transaction: transaction,
    );
  }

  /// Updates all [Chapter]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Chapter>> update(
    _isd.DatabaseSession session,
    List<Chapter> rows, {
    _isd.ColumnSelections<ChapterTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Chapter>(
      rows,
      columns: columns?.call(Chapter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Chapter]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Chapter> updateRow(
    _isd.DatabaseSession session,
    Chapter row, {
    _isd.ColumnSelections<ChapterTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Chapter>(
      row,
      columns: columns?.call(Chapter.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Chapter] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Chapter?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<ChapterUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Chapter>(
      id,
      columnValues: columnValues(Chapter.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Chapter]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Chapter>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<ChapterUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<ChapterTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Chapter>(
      columnValues: columnValues(Chapter.t.updateTable),
      where: where(Chapter.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Chapter]s in the list and returns the deleted rows.
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
  Future<List<Chapter>> delete(
    _isd.DatabaseSession session,
    List<Chapter> rows, {
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Chapter>(
      rows,
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Chapter].
  Future<Chapter> deleteRow(
    _isd.DatabaseSession session,
    Chapter row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Chapter>(
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
  Future<List<Chapter>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<ChapterTable> where,
    _isd.OrderByBuilder<ChapterTable>? orderBy,
    _isd.OrderByListBuilder<ChapterTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Chapter>(
      where: where(Chapter.t),
      orderBy: orderBy?.call(Chapter.t),
      orderByList: orderByList?.call(Chapter.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<ChapterTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Chapter>(
      where: where?.call(Chapter.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Chapter] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<ChapterTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Chapter>(
      where: where(Chapter.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

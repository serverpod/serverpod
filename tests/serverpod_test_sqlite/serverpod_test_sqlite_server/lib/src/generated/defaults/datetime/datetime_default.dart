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

abstract class DateTimeDefault
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DateTimeDefault._({
    this.id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  }) : dateTimeDefaultNow = dateTimeDefaultNow ?? DateTime.now(),
       dateTimeDefaultStr =
           dateTimeDefaultStr ?? DateTime.parse('2024-05-24T22:00:00.000Z'),
       dateTimeDefaultStrNull =
           dateTimeDefaultStrNull ?? DateTime.parse('2024-05-24T22:00:00.000Z');

  factory DateTimeDefault({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  }) = _DateTimeDefaultImpl;

  factory DateTimeDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DateTimeDefault(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultNow: jsonSerialization['dateTimeDefaultNow'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultNow'],
            ),
      dateTimeDefaultStr: jsonSerialization['dateTimeDefaultStr'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultStr'],
            ),
      dateTimeDefaultStrNull:
          jsonSerialization['dateTimeDefaultStrNull'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultStrNull'],
            ),
    );
  }

  static final t = DateTimeDefaultTable();

  static const db = DateTimeDefaultRepository._();

  @override
  int? id;

  DateTime dateTimeDefaultNow;

  DateTime dateTimeDefaultStr;

  DateTime? dateTimeDefaultStrNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DateTimeDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DateTimeDefault copyWith({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DateTimeDefault',
      if (id != null) 'id': id,
      'dateTimeDefaultNow': dateTimeDefaultNow.toJson(),
      'dateTimeDefaultStr': dateTimeDefaultStr.toJson(),
      if (dateTimeDefaultStrNull != null)
        'dateTimeDefaultStrNull': dateTimeDefaultStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DateTimeDefault',
      if (id != null) 'id': id,
      'dateTimeDefaultNow': dateTimeDefaultNow.toJson(),
      'dateTimeDefaultStr': dateTimeDefaultStr.toJson(),
      if (dateTimeDefaultStrNull != null)
        'dateTimeDefaultStrNull': dateTimeDefaultStrNull?.toJson(),
    };
  }

  /// Builds a complete [DateTimeDefaultInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DateTimeDefaultInclude include() {
    return DateTimeDefaultInclude._();
  }

  /// Builds a complete [DateTimeDefaultIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DateTimeDefaultIncludeList includeList({
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    DateTimeDefaultInclude? include,
  }) {
    return DateTimeDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [DateTimeDefaultJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static DateTimeDefaultJsonInclude includeJson({
    _is.SelectColumnsBuilder<DateTimeDefaultTable>? select,
  }) {
    return _DateTimeDefaultJsonInclude._(
      selectedColumns: select?.call(DateTimeDefault.t),
    );
  }

  /// Builds a JSON-compatible [DateTimeDefaultJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static DateTimeDefaultJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    DateTimeDefaultJsonInclude? include,
    _is.SelectColumnsBuilder<DateTimeDefaultTable>? select,
  }) {
    return _DateTimeDefaultJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      include: include,
      selectedColumns: select?.call(DateTimeDefault.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultImpl extends DateTimeDefault {
  _DateTimeDefaultImpl({
    int? id,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    DateTime? dateTimeDefaultStrNull,
  }) : super._(
         id: id,
         dateTimeDefaultNow: dateTimeDefaultNow,
         dateTimeDefaultStr: dateTimeDefaultStr,
         dateTimeDefaultStrNull: dateTimeDefaultStrNull,
       );

  /// Returns a shallow copy of this [DateTimeDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DateTimeDefault copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultNow,
    DateTime? dateTimeDefaultStr,
    Object? dateTimeDefaultStrNull = _Undefined,
  }) {
    return DateTimeDefault(
      id: id is int? ? id : this.id,
      dateTimeDefaultNow: dateTimeDefaultNow ?? this.dateTimeDefaultNow,
      dateTimeDefaultStr: dateTimeDefaultStr ?? this.dateTimeDefaultStr,
      dateTimeDefaultStrNull: dateTimeDefaultStrNull is DateTime?
          ? dateTimeDefaultStrNull
          : this.dateTimeDefaultStrNull,
    );
  }
}

class DateTimeDefaultUpdateTable extends _is.UpdateTable<DateTimeDefaultTable> {
  DateTimeDefaultUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultNow(DateTime value) =>
      _is.ColumnValue(
        table.dateTimeDefaultNow,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultStr(DateTime value) =>
      _is.ColumnValue(
        table.dateTimeDefaultStr,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultStrNull(DateTime? value) =>
      _is.ColumnValue(
        table.dateTimeDefaultStrNull,
        value,
      );
}

class DateTimeDefaultTable extends _is.Table<int?> {
  DateTimeDefaultTable({super.tableRelation})
    : super(tableName: 'datetime_default') {
    updateTable = DateTimeDefaultUpdateTable(this);
    dateTimeDefaultNow = _is.ColumnDateTime(
      'dateTimeDefaultNow',
      this,
      hasDefault: true,
    );
    dateTimeDefaultStr = _is.ColumnDateTime(
      'dateTimeDefaultStr',
      this,
      hasDefault: true,
    );
    dateTimeDefaultStrNull = _is.ColumnDateTime(
      'dateTimeDefaultStrNull',
      this,
      hasDefault: true,
    );
  }

  late final DateTimeDefaultUpdateTable updateTable;

  late final _is.ColumnDateTime dateTimeDefaultNow;

  late final _is.ColumnDateTime dateTimeDefaultStr;

  late final _is.ColumnDateTime dateTimeDefaultStrNull;

  @override
  List<_is.Column> get columns => [
    id,
    dateTimeDefaultNow,
    dateTimeDefaultStr,
    dateTimeDefaultStrNull,
  ];
}

abstract interface class DateTimeDefaultJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class DateTimeDefaultJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class DateTimeDefaultInclude extends _is.IncludeObject
    implements DateTimeDefaultJsonInclude, _is.FullModelInclude {
  DateTimeDefaultInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DateTimeDefault.t;
}

final class DateTimeDefaultIncludeList extends _is.IncludeList
    implements DateTimeDefaultJsonIncludeList, _is.FullModelInclude {
  DateTimeDefaultIncludeList._({
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DateTimeDefaultInclude? super.include,
  }) {
    super.where = where?.call(DateTimeDefault.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DateTimeDefault.t;
}

final class _DateTimeDefaultJsonInclude extends _is.IncludeObject
    implements DateTimeDefaultJsonInclude {
  _DateTimeDefaultJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DateTimeDefault.t;
}

final class _DateTimeDefaultJsonIncludeList extends _is.IncludeList
    implements DateTimeDefaultJsonIncludeList {
  _DateTimeDefaultJsonIncludeList._({
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DateTimeDefaultJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(DateTimeDefault.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DateTimeDefault.t;
}

class DateTimeDefaultRepository {
  const DateTimeDefaultRepository._();

  /// Returns a list of [DateTimeDefault]s matching the given query parameters.
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
  Future<List<DateTimeDefault>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DateTimeDefault] matching the given query parameters.
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
  Future<DateTimeDefault?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DateTimeDefault] by its [id] or null if no such row exists.
  Future<DateTimeDefault?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DateTimeDefault>(
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
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DateTimeDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(DateTimeDefault.t),
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
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DateTimeDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(DateTimeDefault.t),
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
    _is.SelectColumnsBuilder<DateTimeDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<DateTimeDefault>(
      id,
      transaction: transaction,
      select: select?.call(DateTimeDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DateTimeDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [DateTimeDefault]s will have their `id` fields set.
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
  Future<List<DateTimeDefault>> insert(
    _is.DatabaseSession session,
    List<DateTimeDefault> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DateTimeDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DateTimeDefault] and returns the inserted row.
  ///
  /// The returned [DateTimeDefault] will have its `id` field set.
  Future<DateTimeDefault> insertRow(
    _is.DatabaseSession session,
    DateTimeDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DateTimeDefault]s in the list and returns the resulting rows.
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
  /// The returned [DateTimeDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefault>> upsert(
    _is.DatabaseSession session,
    List<DateTimeDefault> rows, {
    required _is.ColumnSelections<DateTimeDefaultTable> conflictColumns,
    _is.ColumnSelections<DateTimeDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DateTimeDefault>(
      rows,
      conflictColumns: conflictColumns(DateTimeDefault.t),
      updateColumns: updateColumns?.call(DateTimeDefault.t),
      updateWhere: updateWhere?.call(DateTimeDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DateTimeDefault] and returns the resulting row.
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
  /// The returned [DateTimeDefault] will have its `id` field set.
  Future<DateTimeDefault?> upsertRow(
    _is.DatabaseSession session,
    DateTimeDefault row, {
    required _is.ColumnSelections<DateTimeDefaultTable> conflictColumns,
    _is.ColumnSelections<DateTimeDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DateTimeDefault>(
      row,
      conflictColumns: conflictColumns(DateTimeDefault.t),
      updateColumns: updateColumns?.call(DateTimeDefault.t),
      updateWhere: updateWhere?.call(DateTimeDefault.t),
      transaction: transaction,
    );
  }

  /// Updates all [DateTimeDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefault>> update(
    _is.DatabaseSession session,
    List<DateTimeDefault> rows, {
    _is.ColumnSelections<DateTimeDefaultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DateTimeDefault>(
      rows,
      columns: columns?.call(DateTimeDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DateTimeDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DateTimeDefault> updateRow(
    _is.DatabaseSession session,
    DateTimeDefault row, {
    _is.ColumnSelections<DateTimeDefaultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefault>(
      row,
      columns: columns?.call(DateTimeDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DateTimeDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DateTimeDefault?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DateTimeDefaultUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DateTimeDefault>(
      id,
      columnValues: columnValues(DateTimeDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DateTimeDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefault>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DateTimeDefaultUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DateTimeDefaultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DateTimeDefault>(
      columnValues: columnValues(DateTimeDefault.t.updateTable),
      where: where(DateTimeDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DateTimeDefault]s in the list and returns the deleted rows.
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
  Future<List<DateTimeDefault>> delete(
    _is.DatabaseSession session,
    List<DateTimeDefault> rows, {
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DateTimeDefault>(
      rows,
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DateTimeDefault].
  Future<DateTimeDefault> deleteRow(
    _is.DatabaseSession session,
    DateTimeDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefault>(
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
  Future<List<DateTimeDefault>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DateTimeDefaultTable> where,
    _is.OrderByBuilder<DateTimeDefaultTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DateTimeDefault>(
      where: where(DateTimeDefault.t),
      orderBy: orderBy?.call(DateTimeDefault.t),
      orderByList: orderByList?.call(DateTimeDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefault>(
      where: where?.call(DateTimeDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DateTimeDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DateTimeDefaultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DateTimeDefault>(
      where: where(DateTimeDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

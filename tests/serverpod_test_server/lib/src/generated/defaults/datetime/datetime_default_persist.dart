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

abstract class DateTimeDefaultPersist
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DateTimeDefaultPersist._({
    this.id,
    this.dateTimeDefaultPersistNow,
    this.dateTimeDefaultPersistStr,
  });

  factory DateTimeDefaultPersist({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  }) = _DateTimeDefaultPersistImpl;

  factory DateTimeDefaultPersist.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DateTimeDefaultPersist(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultPersistNow:
          jsonSerialization['dateTimeDefaultPersistNow'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultPersistNow'],
            ),
      dateTimeDefaultPersistStr:
          jsonSerialization['dateTimeDefaultPersistStr'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultPersistStr'],
            ),
    );
  }

  static final t = DateTimeDefaultPersistTable();

  static const db = DateTimeDefaultPersistRepository._();

  @override
  int? id;

  DateTime? dateTimeDefaultPersistNow;

  DateTime? dateTimeDefaultPersistStr;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DateTimeDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DateTimeDefaultPersist copyWith({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DateTimeDefaultPersist',
      if (id != null) 'id': id,
      if (dateTimeDefaultPersistNow != null)
        'dateTimeDefaultPersistNow': dateTimeDefaultPersistNow?.toJson(),
      if (dateTimeDefaultPersistStr != null)
        'dateTimeDefaultPersistStr': dateTimeDefaultPersistStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DateTimeDefaultPersist',
      if (id != null) 'id': id,
      if (dateTimeDefaultPersistNow != null)
        'dateTimeDefaultPersistNow': dateTimeDefaultPersistNow?.toJson(),
      if (dateTimeDefaultPersistStr != null)
        'dateTimeDefaultPersistStr': dateTimeDefaultPersistStr?.toJson(),
    };
  }

  /// Builds a complete [DateTimeDefaultPersistInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DateTimeDefaultPersistInclude include() {
    return DateTimeDefaultPersistInclude._();
  }

  /// Builds a complete [DateTimeDefaultPersistIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DateTimeDefaultPersistIncludeList includeList({
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    DateTimeDefaultPersistInclude? include,
  }) {
    return DateTimeDefaultPersistIncludeList._(
      where: where?.call(DateTimeDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [DateTimeDefaultPersistJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static DateTimeDefaultPersistJsonInclude includeJson({
    _is.SelectColumnsBuilder<DateTimeDefaultPersistTable>? select,
  }) {
    return _DateTimeDefaultPersistJsonInclude._(
      selectedColumns: select?.call(DateTimeDefaultPersist.t),
    );
  }

  /// Builds a JSON-compatible [DateTimeDefaultPersistJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static DateTimeDefaultPersistJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    DateTimeDefaultPersistJsonInclude? include,
    _is.SelectColumnsBuilder<DateTimeDefaultPersistTable>? select,
  }) {
    return _DateTimeDefaultPersistJsonIncludeList._(
      where: where?.call(DateTimeDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      include: include,
      selectedColumns: select?.call(DateTimeDefaultPersist.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultPersistImpl extends DateTimeDefaultPersist {
  _DateTimeDefaultPersistImpl({
    int? id,
    DateTime? dateTimeDefaultPersistNow,
    DateTime? dateTimeDefaultPersistStr,
  }) : super._(
         id: id,
         dateTimeDefaultPersistNow: dateTimeDefaultPersistNow,
         dateTimeDefaultPersistStr: dateTimeDefaultPersistStr,
       );

  /// Returns a shallow copy of this [DateTimeDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DateTimeDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? dateTimeDefaultPersistNow = _Undefined,
    Object? dateTimeDefaultPersistStr = _Undefined,
  }) {
    return DateTimeDefaultPersist(
      id: id is int? ? id : this.id,
      dateTimeDefaultPersistNow: dateTimeDefaultPersistNow is DateTime?
          ? dateTimeDefaultPersistNow
          : this.dateTimeDefaultPersistNow,
      dateTimeDefaultPersistStr: dateTimeDefaultPersistStr is DateTime?
          ? dateTimeDefaultPersistStr
          : this.dateTimeDefaultPersistStr,
    );
  }
}

class DateTimeDefaultPersistUpdateTable
    extends _is.UpdateTable<DateTimeDefaultPersistTable> {
  DateTimeDefaultPersistUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultPersistNow(
    DateTime? value,
  ) => _is.ColumnValue(
    table.dateTimeDefaultPersistNow,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultPersistStr(
    DateTime? value,
  ) => _is.ColumnValue(
    table.dateTimeDefaultPersistStr,
    value,
  );
}

class DateTimeDefaultPersistTable extends _is.Table<int?> {
  DateTimeDefaultPersistTable({super.tableRelation})
    : super(tableName: 'datetime_default_persist') {
    updateTable = DateTimeDefaultPersistUpdateTable(this);
    dateTimeDefaultPersistNow = _is.ColumnDateTime(
      'dateTimeDefaultPersistNow',
      this,
      hasDefault: true,
    );
    dateTimeDefaultPersistStr = _is.ColumnDateTime(
      'dateTimeDefaultPersistStr',
      this,
      hasDefault: true,
    );
  }

  late final DateTimeDefaultPersistUpdateTable updateTable;

  late final _is.ColumnDateTime dateTimeDefaultPersistNow;

  late final _is.ColumnDateTime dateTimeDefaultPersistStr;

  @override
  List<_is.Column> get columns => [
    id,
    dateTimeDefaultPersistNow,
    dateTimeDefaultPersistStr,
  ];
}

abstract interface class DateTimeDefaultPersistJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class DateTimeDefaultPersistJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class DateTimeDefaultPersistInclude extends _is.IncludeObject
    implements DateTimeDefaultPersistJsonInclude, _is.FullModelInclude {
  DateTimeDefaultPersistInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DateTimeDefaultPersist.t;
}

final class DateTimeDefaultPersistIncludeList extends _is.IncludeList
    implements DateTimeDefaultPersistJsonIncludeList, _is.FullModelInclude {
  DateTimeDefaultPersistIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DateTimeDefaultPersistInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DateTimeDefaultPersist.t;
}

final class _DateTimeDefaultPersistJsonInclude extends _is.IncludeObject
    implements DateTimeDefaultPersistJsonInclude {
  _DateTimeDefaultPersistJsonInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DateTimeDefaultPersist.t;
}

final class _DateTimeDefaultPersistJsonIncludeList extends _is.IncludeList
    implements DateTimeDefaultPersistJsonIncludeList {
  _DateTimeDefaultPersistJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DateTimeDefaultPersistJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DateTimeDefaultPersist.t;
}

class DateTimeDefaultPersistRepository {
  const DateTimeDefaultPersistRepository._();

  /// Returns a list of [DateTimeDefaultPersist]s matching the given query parameters.
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
  Future<List<DateTimeDefaultPersist>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DateTimeDefaultPersist] matching the given query parameters.
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
  Future<DateTimeDefaultPersist?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DateTimeDefaultPersist] by its [id] or null if no such row exists.
  Future<DateTimeDefaultPersist?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DateTimeDefaultPersist>(
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
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DateTimeDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(DateTimeDefaultPersist.t),
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
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DateTimeDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(DateTimeDefaultPersist.t),
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
    _is.SelectColumnsBuilder<DateTimeDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<DateTimeDefaultPersist>(
      id,
      transaction: transaction,
      select: select?.call(DateTimeDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DateTimeDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [DateTimeDefaultPersist]s will have their `id` fields set.
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
  Future<List<DateTimeDefaultPersist>> insert(
    _is.DatabaseSession session,
    List<DateTimeDefaultPersist> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DateTimeDefaultPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DateTimeDefaultPersist] and returns the inserted row.
  ///
  /// The returned [DateTimeDefaultPersist] will have its `id` field set.
  Future<DateTimeDefaultPersist> insertRow(
    _is.DatabaseSession session,
    DateTimeDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DateTimeDefaultPersist]s in the list and returns the resulting rows.
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
  /// The returned [DateTimeDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefaultPersist>> upsert(
    _is.DatabaseSession session,
    List<DateTimeDefaultPersist> rows, {
    required _is.ColumnSelections<DateTimeDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<DateTimeDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DateTimeDefaultPersist>(
      rows,
      conflictColumns: conflictColumns(DateTimeDefaultPersist.t),
      updateColumns: updateColumns?.call(DateTimeDefaultPersist.t),
      updateWhere: updateWhere?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DateTimeDefaultPersist] and returns the resulting row.
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
  /// The returned [DateTimeDefaultPersist] will have its `id` field set.
  Future<DateTimeDefaultPersist?> upsertRow(
    _is.DatabaseSession session,
    DateTimeDefaultPersist row, {
    required _is.ColumnSelections<DateTimeDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<DateTimeDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DateTimeDefaultPersist>(
      row,
      conflictColumns: conflictColumns(DateTimeDefaultPersist.t),
      updateColumns: updateColumns?.call(DateTimeDefaultPersist.t),
      updateWhere: updateWhere?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates all [DateTimeDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefaultPersist>> update(
    _is.DatabaseSession session,
    List<DateTimeDefaultPersist> rows, {
    _is.ColumnSelections<DateTimeDefaultPersistTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DateTimeDefaultPersist>(
      rows,
      columns: columns?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DateTimeDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DateTimeDefaultPersist> updateRow(
    _is.DatabaseSession session,
    DateTimeDefaultPersist row, {
    _is.ColumnSelections<DateTimeDefaultPersistTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefaultPersist>(
      row,
      columns: columns?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DateTimeDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DateTimeDefaultPersist?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DateTimeDefaultPersistUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DateTimeDefaultPersist>(
      id,
      columnValues: columnValues(DateTimeDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DateTimeDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefaultPersist>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DateTimeDefaultPersistUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DateTimeDefaultPersistTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DateTimeDefaultPersist>(
      columnValues: columnValues(DateTimeDefaultPersist.t.updateTable),
      where: where(DateTimeDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DateTimeDefaultPersist]s in the list and returns the deleted rows.
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
  Future<List<DateTimeDefaultPersist>> delete(
    _is.DatabaseSession session,
    List<DateTimeDefaultPersist> rows, {
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DateTimeDefaultPersist>(
      rows,
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DateTimeDefaultPersist].
  Future<DateTimeDefaultPersist> deleteRow(
    _is.DatabaseSession session,
    DateTimeDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefaultPersist>(
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
  Future<List<DateTimeDefaultPersist>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DateTimeDefaultPersistTable> where,
    _is.OrderByBuilder<DateTimeDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DateTimeDefaultPersist>(
      where: where(DateTimeDefaultPersist.t),
      orderBy: orderBy?.call(DateTimeDefaultPersist.t),
      orderByList: orderByList?.call(DateTimeDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultPersistTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefaultPersist>(
      where: where?.call(DateTimeDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DateTimeDefaultPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DateTimeDefaultPersistTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DateTimeDefaultPersist>(
      where: where(DateTimeDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

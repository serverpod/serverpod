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

abstract class DateTimeDefaultModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DateTimeDefaultModel._({
    this.id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  }) : dateTimeDefaultModelNow = dateTimeDefaultModelNow ?? DateTime.now(),
       dateTimeDefaultModelStr =
           dateTimeDefaultModelStr ??
           DateTime.parse('2024-05-24T22:00:00.000Z'),
       dateTimeDefaultModelStrNull =
           dateTimeDefaultModelStrNull ??
           DateTime.parse('2024-05-24T22:00:00.000Z');

  factory DateTimeDefaultModel({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  }) = _DateTimeDefaultModelImpl;

  factory DateTimeDefaultModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DateTimeDefaultModel(
      id: jsonSerialization['id'] as int?,
      dateTimeDefaultModelNow:
          jsonSerialization['dateTimeDefaultModelNow'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultModelNow'],
            ),
      dateTimeDefaultModelStr:
          jsonSerialization['dateTimeDefaultModelStr'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultModelStr'],
            ),
      dateTimeDefaultModelStrNull:
          jsonSerialization['dateTimeDefaultModelStrNull'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['dateTimeDefaultModelStrNull'],
            ),
    );
  }

  static final t = DateTimeDefaultModelTable();

  static const db = DateTimeDefaultModelRepository._();

  @override
  int? id;

  DateTime dateTimeDefaultModelNow;

  DateTime dateTimeDefaultModelStr;

  DateTime? dateTimeDefaultModelStrNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DateTimeDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DateTimeDefaultModel copyWith({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DateTimeDefaultModel',
      if (id != null) 'id': id,
      'dateTimeDefaultModelNow': dateTimeDefaultModelNow.toJson(),
      'dateTimeDefaultModelStr': dateTimeDefaultModelStr.toJson(),
      if (dateTimeDefaultModelStrNull != null)
        'dateTimeDefaultModelStrNull': dateTimeDefaultModelStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DateTimeDefaultModel',
      if (id != null) 'id': id,
      'dateTimeDefaultModelNow': dateTimeDefaultModelNow.toJson(),
      'dateTimeDefaultModelStr': dateTimeDefaultModelStr.toJson(),
      if (dateTimeDefaultModelStrNull != null)
        'dateTimeDefaultModelStrNull': dateTimeDefaultModelStrNull?.toJson(),
    };
  }

  static DateTimeDefaultModelInclude include({
    _is.SelectColumnsBuilder<DateTimeDefaultModelTable>? select,
  }) {
    return DateTimeDefaultModelInclude._(
      selectedColumns: select?.call(DateTimeDefaultModel.t),
    );
  }

  static DateTimeDefaultModelIncludeList includeList({
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    DateTimeDefaultModelInclude? include,
    _is.SelectColumnsBuilder<DateTimeDefaultModelTable>? select,
  }) {
    return DateTimeDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      include: include,
      selectedColumns: select?.call(DateTimeDefaultModel.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DateTimeDefaultModelImpl extends DateTimeDefaultModel {
  _DateTimeDefaultModelImpl({
    int? id,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    DateTime? dateTimeDefaultModelStrNull,
  }) : super._(
         id: id,
         dateTimeDefaultModelNow: dateTimeDefaultModelNow,
         dateTimeDefaultModelStr: dateTimeDefaultModelStr,
         dateTimeDefaultModelStrNull: dateTimeDefaultModelStrNull,
       );

  /// Returns a shallow copy of this [DateTimeDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DateTimeDefaultModel copyWith({
    Object? id = _Undefined,
    DateTime? dateTimeDefaultModelNow,
    DateTime? dateTimeDefaultModelStr,
    Object? dateTimeDefaultModelStrNull = _Undefined,
  }) {
    return DateTimeDefaultModel(
      id: id is int? ? id : this.id,
      dateTimeDefaultModelNow:
          dateTimeDefaultModelNow ?? this.dateTimeDefaultModelNow,
      dateTimeDefaultModelStr:
          dateTimeDefaultModelStr ?? this.dateTimeDefaultModelStr,
      dateTimeDefaultModelStrNull: dateTimeDefaultModelStrNull is DateTime?
          ? dateTimeDefaultModelStrNull
          : this.dateTimeDefaultModelStrNull,
    );
  }
}

class DateTimeDefaultModelUpdateTable
    extends _is.UpdateTable<DateTimeDefaultModelTable> {
  DateTimeDefaultModelUpdateTable(super.table);

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultModelNow(DateTime value) =>
      _is.ColumnValue(
        table.dateTimeDefaultModelNow,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultModelStr(DateTime value) =>
      _is.ColumnValue(
        table.dateTimeDefaultModelStr,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> dateTimeDefaultModelStrNull(
    DateTime? value,
  ) => _is.ColumnValue(
    table.dateTimeDefaultModelStrNull,
    value,
  );
}

class DateTimeDefaultModelTable extends _is.Table<int?> {
  DateTimeDefaultModelTable({super.tableRelation})
    : super(tableName: 'datetime_default_model') {
    updateTable = DateTimeDefaultModelUpdateTable(this);
    dateTimeDefaultModelNow = _is.ColumnDateTime(
      'dateTimeDefaultModelNow',
      this,
    );
    dateTimeDefaultModelStr = _is.ColumnDateTime(
      'dateTimeDefaultModelStr',
      this,
    );
    dateTimeDefaultModelStrNull = _is.ColumnDateTime(
      'dateTimeDefaultModelStrNull',
      this,
    );
  }

  late final DateTimeDefaultModelUpdateTable updateTable;

  late final _is.ColumnDateTime dateTimeDefaultModelNow;

  late final _is.ColumnDateTime dateTimeDefaultModelStr;

  late final _is.ColumnDateTime dateTimeDefaultModelStrNull;

  @override
  List<_is.Column> get columns => [
    id,
    dateTimeDefaultModelNow,
    dateTimeDefaultModelStr,
    dateTimeDefaultModelStrNull,
  ];
}

class DateTimeDefaultModelInclude extends _is.IncludeObject {
  DateTimeDefaultModelInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DateTimeDefaultModel.t;
}

class DateTimeDefaultModelIncludeList extends _is.IncludeList {
  DateTimeDefaultModelIncludeList._({
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(DateTimeDefaultModel.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DateTimeDefaultModel.t;
}

class DateTimeDefaultModelRepository {
  const DateTimeDefaultModelRepository._();

  /// Returns a list of [DateTimeDefaultModel]s matching the given query parameters.
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
  Future<List<DateTimeDefaultModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DateTimeDefaultModel] matching the given query parameters.
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
  Future<DateTimeDefaultModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DateTimeDefaultModel] by its [id] or null if no such row exists.
  Future<DateTimeDefaultModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DateTimeDefaultModel>(
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
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DateTimeDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(DateTimeDefaultModel.t),
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
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<DateTimeDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(DateTimeDefaultModel.t),
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
    _is.SelectColumnsBuilder<DateTimeDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<DateTimeDefaultModel>(
      id,
      transaction: transaction,
      select: select?.call(DateTimeDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DateTimeDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [DateTimeDefaultModel]s will have their `id` fields set.
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
  Future<List<DateTimeDefaultModel>> insert(
    _is.DatabaseSession session,
    List<DateTimeDefaultModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DateTimeDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DateTimeDefaultModel] and returns the inserted row.
  ///
  /// The returned [DateTimeDefaultModel] will have its `id` field set.
  Future<DateTimeDefaultModel> insertRow(
    _is.DatabaseSession session,
    DateTimeDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DateTimeDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DateTimeDefaultModel]s in the list and returns the resulting rows.
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
  /// The returned [DateTimeDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefaultModel>> upsert(
    _is.DatabaseSession session,
    List<DateTimeDefaultModel> rows, {
    required _is.ColumnSelections<DateTimeDefaultModelTable> conflictColumns,
    _is.ColumnSelections<DateTimeDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DateTimeDefaultModel>(
      rows,
      conflictColumns: conflictColumns(DateTimeDefaultModel.t),
      updateColumns: updateColumns?.call(DateTimeDefaultModel.t),
      updateWhere: updateWhere?.call(DateTimeDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DateTimeDefaultModel] and returns the resulting row.
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
  /// The returned [DateTimeDefaultModel] will have its `id` field set.
  Future<DateTimeDefaultModel?> upsertRow(
    _is.DatabaseSession session,
    DateTimeDefaultModel row, {
    required _is.ColumnSelections<DateTimeDefaultModelTable> conflictColumns,
    _is.ColumnSelections<DateTimeDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DateTimeDefaultModel>(
      row,
      conflictColumns: conflictColumns(DateTimeDefaultModel.t),
      updateColumns: updateColumns?.call(DateTimeDefaultModel.t),
      updateWhere: updateWhere?.call(DateTimeDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [DateTimeDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefaultModel>> update(
    _is.DatabaseSession session,
    List<DateTimeDefaultModel> rows, {
    _is.ColumnSelections<DateTimeDefaultModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DateTimeDefaultModel>(
      rows,
      columns: columns?.call(DateTimeDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DateTimeDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DateTimeDefaultModel> updateRow(
    _is.DatabaseSession session,
    DateTimeDefaultModel row, {
    _is.ColumnSelections<DateTimeDefaultModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DateTimeDefaultModel>(
      row,
      columns: columns?.call(DateTimeDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DateTimeDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DateTimeDefaultModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DateTimeDefaultModelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DateTimeDefaultModel>(
      id,
      columnValues: columnValues(DateTimeDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DateTimeDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DateTimeDefaultModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DateTimeDefaultModelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<DateTimeDefaultModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DateTimeDefaultModel>(
      columnValues: columnValues(DateTimeDefaultModel.t.updateTable),
      where: where(DateTimeDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DateTimeDefaultModel]s in the list and returns the deleted rows.
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
  Future<List<DateTimeDefaultModel>> delete(
    _is.DatabaseSession session,
    List<DateTimeDefaultModel> rows, {
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DateTimeDefaultModel>(
      rows,
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DateTimeDefaultModel].
  Future<DateTimeDefaultModel> deleteRow(
    _is.DatabaseSession session,
    DateTimeDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DateTimeDefaultModel>(
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
  Future<List<DateTimeDefaultModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DateTimeDefaultModelTable> where,
    _is.OrderByBuilder<DateTimeDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<DateTimeDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DateTimeDefaultModel>(
      where: where(DateTimeDefaultModel.t),
      orderBy: orderBy?.call(DateTimeDefaultModel.t),
      orderByList: orderByList?.call(DateTimeDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DateTimeDefaultModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DateTimeDefaultModel>(
      where: where?.call(DateTimeDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DateTimeDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DateTimeDefaultModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DateTimeDefaultModel>(
      where: where(DateTimeDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class StringDefault
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  StringDefault._({
    this.id,
    String? stringDefault,
    String? stringDefaultNull,
  }) : stringDefault = stringDefault ?? 'This is a default value',
       stringDefaultNull = stringDefaultNull ?? 'This is a default null value';

  factory StringDefault({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) = _StringDefaultImpl;

  factory StringDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefault(
      id: jsonSerialization['id'] as int?,
      stringDefault: jsonSerialization['stringDefault'] as String?,
      stringDefaultNull: jsonSerialization['stringDefaultNull'] as String?,
    );
  }

  static final t = StringDefaultTable();

  static const db = StringDefaultRepository._();

  @override
  int? id;

  String stringDefault;

  String? stringDefaultNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  StringDefault copyWith({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'StringDefault',
      if (id != null) 'id': id,
      'stringDefault': stringDefault,
      if (stringDefaultNull != null) 'stringDefaultNull': stringDefaultNull,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'StringDefault',
      if (id != null) 'id': id,
      'stringDefault': stringDefault,
      if (stringDefaultNull != null) 'stringDefaultNull': stringDefaultNull,
    };
  }

  static StringDefaultInclude include({
    _is.SelectColumnsBuilder<StringDefaultTable>? select,
  }) {
    return StringDefaultInclude._(
      selectedColumns: select?.call(StringDefault.t),
    );
  }

  static StringDefaultIncludeList includeList({
    _is.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    StringDefaultInclude? include,
    _is.SelectColumnsBuilder<StringDefaultTable>? select,
  }) {
    return StringDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      include: include,
      selectedColumns: select?.call(StringDefault.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultImpl extends StringDefault {
  _StringDefaultImpl({
    int? id,
    String? stringDefault,
    String? stringDefaultNull,
  }) : super._(
         id: id,
         stringDefault: stringDefault,
         stringDefaultNull: stringDefaultNull,
       );

  /// Returns a shallow copy of this [StringDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  StringDefault copyWith({
    Object? id = _Undefined,
    String? stringDefault,
    Object? stringDefaultNull = _Undefined,
  }) {
    return StringDefault(
      id: id is int? ? id : this.id,
      stringDefault: stringDefault ?? this.stringDefault,
      stringDefaultNull: stringDefaultNull is String?
          ? stringDefaultNull
          : this.stringDefaultNull,
    );
  }
}

class StringDefaultUpdateTable extends _is.UpdateTable<StringDefaultTable> {
  StringDefaultUpdateTable(super.table);

  _is.ColumnValue<String, String> stringDefault(String value) =>
      _is.ColumnValue(
        table.stringDefault,
        value,
      );

  _is.ColumnValue<String, String> stringDefaultNull(String? value) =>
      _is.ColumnValue(
        table.stringDefaultNull,
        value,
      );
}

class StringDefaultTable extends _is.Table<int?> {
  StringDefaultTable({super.tableRelation})
    : super(tableName: 'string_default') {
    updateTable = StringDefaultUpdateTable(this);
    stringDefault = _is.ColumnString(
      'stringDefault',
      this,
      hasDefault: true,
    );
    stringDefaultNull = _is.ColumnString(
      'stringDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final StringDefaultUpdateTable updateTable;

  late final _is.ColumnString stringDefault;

  late final _is.ColumnString stringDefaultNull;

  @override
  List<_is.Column> get columns => [
    id,
    stringDefault,
    stringDefaultNull,
  ];
}

class StringDefaultInclude extends _is.IncludeObject {
  StringDefaultInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => StringDefault.t;
}

class StringDefaultIncludeList extends _is.IncludeList {
  StringDefaultIncludeList._({
    _is.WhereExpressionBuilder<StringDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(StringDefault.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => StringDefault.t;
}

class StringDefaultRepository {
  const StringDefaultRepository._();

  /// Returns a list of [StringDefault]s matching the given query parameters.
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
  Future<List<StringDefault>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [StringDefault] matching the given query parameters.
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
  Future<StringDefault?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [StringDefault] by its [id] or null if no such row exists.
  Future<StringDefault?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<StringDefault>(
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
    _is.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefault.t),
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
    _is.WhereExpressionBuilder<StringDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<StringDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<StringDefault>(
      where: where?.call(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(StringDefault.t),
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
    _is.SelectColumnsBuilder<StringDefaultTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<StringDefault>(
      id,
      transaction: transaction,
      select: select?.call(StringDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [StringDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [StringDefault]s will have their `id` fields set.
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
  Future<List<StringDefault>> insert(
    _is.DatabaseSession session,
    List<StringDefault> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<StringDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [StringDefault] and returns the inserted row.
  ///
  /// The returned [StringDefault] will have its `id` field set.
  Future<StringDefault> insertRow(
    _is.DatabaseSession session,
    StringDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<StringDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [StringDefault]s in the list and returns the resulting rows.
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
  /// The returned [StringDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefault>> upsert(
    _is.DatabaseSession session,
    List<StringDefault> rows, {
    required _is.ColumnSelections<StringDefaultTable> conflictColumns,
    _is.ColumnSelections<StringDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<StringDefault>(
      rows,
      conflictColumns: conflictColumns(StringDefault.t),
      updateColumns: updateColumns?.call(StringDefault.t),
      updateWhere: updateWhere?.call(StringDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [StringDefault] and returns the resulting row.
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
  /// The returned [StringDefault] will have its `id` field set.
  Future<StringDefault?> upsertRow(
    _is.DatabaseSession session,
    StringDefault row, {
    required _is.ColumnSelections<StringDefaultTable> conflictColumns,
    _is.ColumnSelections<StringDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<StringDefaultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<StringDefault>(
      row,
      conflictColumns: conflictColumns(StringDefault.t),
      updateColumns: updateColumns?.call(StringDefault.t),
      updateWhere: updateWhere?.call(StringDefault.t),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefault>> update(
    _is.DatabaseSession session,
    List<StringDefault> rows, {
    _is.ColumnSelections<StringDefaultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<StringDefault>(
      rows,
      columns: columns?.call(StringDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [StringDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<StringDefault> updateRow(
    _is.DatabaseSession session,
    StringDefault row, {
    _is.ColumnSelections<StringDefaultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<StringDefault>(
      row,
      columns: columns?.call(StringDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [StringDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<StringDefault?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<StringDefaultUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<StringDefault>(
      id,
      columnValues: columnValues(StringDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [StringDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<StringDefault>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<StringDefaultUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<StringDefaultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<StringDefault>(
      columnValues: columnValues(StringDefault.t.updateTable),
      where: where(StringDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [StringDefault]s in the list and returns the deleted rows.
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
  Future<List<StringDefault>> delete(
    _is.DatabaseSession session,
    List<StringDefault> rows, {
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<StringDefault>(
      rows,
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [StringDefault].
  Future<StringDefault> deleteRow(
    _is.DatabaseSession session,
    StringDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<StringDefault>(
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
  Future<List<StringDefault>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultTable> where,
    _is.OrderByBuilder<StringDefaultTable>? orderBy,
    _is.OrderByListBuilder<StringDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<StringDefault>(
      where: where(StringDefault.t),
      orderBy: orderBy?.call(StringDefault.t),
      orderByList: orderByList?.call(StringDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<StringDefaultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<StringDefault>(
      where: where?.call(StringDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [StringDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<StringDefaultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<StringDefault>(
      where: where(StringDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

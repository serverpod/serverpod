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

/// Child model used to reproduce the include column-alias collision in
/// https://github.com/serverpod/serverpod/issues/5287
///
/// It has an `int` primary key (`id`) and a `String` column (`bleedingText`).
/// When two long-named relations point at this table, the truncated column
/// alias of one relation's `id` collides with the other relation's
/// `bleedingText`, bleeding the string into the int field on deserialization.
abstract class BleedChild
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BleedChild._({
    this.id,
    this.bleedingText,
  });

  factory BleedChild({
    int? id,
    String? bleedingText,
  }) = _BleedChildImpl;

  factory BleedChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return BleedChild(
      id: jsonSerialization['id'] as int?,
      bleedingText: jsonSerialization['bleedingText'] as String?,
    );
  }

  static final t = BleedChildTable();

  static const db = BleedChildRepository._();

  @override
  int? id;

  String? bleedingText;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BleedChild]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BleedChild copyWith({
    int? id,
    String? bleedingText,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BleedChild',
      if (id != null) 'id': id,
      if (bleedingText != null) 'bleedingText': bleedingText,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BleedChild',
      if (id != null) 'id': id,
      if (bleedingText != null) 'bleedingText': bleedingText,
    };
  }

  static BleedChildInclude include({
    _is.SelectColumnsBuilder<BleedChildTable>? select,
  }) {
    return BleedChildInclude.internal_(
      selectedColumns: select?.call(BleedChild.t),
    );
  }

  static BleedChildIncludeList includeList({
    _is.WhereExpressionBuilder<BleedChildTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BleedChildTable>? orderBy,
    _is.OrderByListBuilder<BleedChildTable>? orderByList,
    BleedChildInclude? include,
    _is.SelectColumnsBuilder<BleedChildTable>? select,
  }) {
    return BleedChildIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BleedChild.t),
      orderByList: orderByList?.call(BleedChild.t),
      include: include,
      selectedColumns: select?.call(BleedChild.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BleedChildImpl extends BleedChild {
  _BleedChildImpl({
    int? id,
    String? bleedingText,
  }) : super._(
         id: id,
         bleedingText: bleedingText,
       );

  /// Returns a shallow copy of this [BleedChild]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BleedChild copyWith({
    Object? id = _Undefined,
    Object? bleedingText = _Undefined,
  }) {
    return BleedChild(
      id: id is int? ? id : this.id,
      bleedingText: bleedingText is String? ? bleedingText : this.bleedingText,
    );
  }
}

class BleedChildUpdateTable extends _is.UpdateTable<BleedChildTable> {
  BleedChildUpdateTable(super.table);

  _is.ColumnValue<String, String> bleedingText(String? value) =>
      _is.ColumnValue(
        table.bleedingText,
        value,
      );
}

class BleedChildTable extends _is.Table<int?> {
  BleedChildTable({super.tableRelation}) : super(tableName: 'bleed_child') {
    updateTable = BleedChildUpdateTable(this);
    bleedingText = _is.ColumnString(
      'bleedingText',
      this,
    );
  }

  late final BleedChildUpdateTable updateTable;

  late final _is.ColumnString bleedingText;

  @override
  List<_is.Column> get columns => [
    id,
    bleedingText,
  ];
}

class BleedChildInclude extends _is.IncludeObject {
  BleedChildInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BleedChild.t;
}

class BleedChildIncludeList extends _is.IncludeList {
  BleedChildIncludeList.internal_({
    _is.WhereExpressionBuilder<BleedChildTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(BleedChild.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BleedChild.t;
}

class BleedChildRepository {
  const BleedChildRepository._();

  /// Returns a list of [BleedChild]s matching the given query parameters.
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
  Future<List<BleedChild>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BleedChildTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BleedChildTable>? orderBy,
    _is.OrderByListBuilder<BleedChildTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BleedChild>(
      where: where?.call(BleedChild.t),
      orderBy: orderBy?.call(BleedChild.t),
      orderByList: orderByList?.call(BleedChild.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BleedChild] matching the given query parameters.
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
  Future<BleedChild?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BleedChildTable>? where,
    int? offset,
    _is.OrderByBuilder<BleedChildTable>? orderBy,
    _is.OrderByListBuilder<BleedChildTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BleedChild>(
      where: where?.call(BleedChild.t),
      orderBy: orderBy?.call(BleedChild.t),
      orderByList: orderByList?.call(BleedChild.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BleedChild] by its [id] or null if no such row exists.
  Future<BleedChild?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BleedChild>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BleedChild]s in the list and returns the inserted rows.
  ///
  /// The returned [BleedChild]s will have their `id` fields set.
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
  Future<List<BleedChild>> insert(
    _is.DatabaseSession session,
    List<BleedChild> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BleedChild>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BleedChild] and returns the inserted row.
  ///
  /// The returned [BleedChild] will have its `id` field set.
  Future<BleedChild> insertRow(
    _is.DatabaseSession session,
    BleedChild row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BleedChild>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BleedChild]s in the list and returns the resulting rows.
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
  /// The returned [BleedChild]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BleedChild>> upsert(
    _is.DatabaseSession session,
    List<BleedChild> rows, {
    required _is.ColumnSelections<BleedChildTable> conflictColumns,
    _is.ColumnSelections<BleedChildTable>? updateColumns,
    _is.WhereExpressionBuilder<BleedChildTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BleedChild>(
      rows,
      conflictColumns: conflictColumns(BleedChild.t),
      updateColumns: updateColumns?.call(BleedChild.t),
      updateWhere: updateWhere?.call(BleedChild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BleedChild] and returns the resulting row.
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
  /// The returned [BleedChild] will have its `id` field set.
  Future<BleedChild?> upsertRow(
    _is.DatabaseSession session,
    BleedChild row, {
    required _is.ColumnSelections<BleedChildTable> conflictColumns,
    _is.ColumnSelections<BleedChildTable>? updateColumns,
    _is.WhereExpressionBuilder<BleedChildTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BleedChild>(
      row,
      conflictColumns: conflictColumns(BleedChild.t),
      updateColumns: updateColumns?.call(BleedChild.t),
      updateWhere: updateWhere?.call(BleedChild.t),
      transaction: transaction,
    );
  }

  /// Updates all [BleedChild]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BleedChild>> update(
    _is.DatabaseSession session,
    List<BleedChild> rows, {
    _is.ColumnSelections<BleedChildTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BleedChild>(
      rows,
      columns: columns?.call(BleedChild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BleedChild]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BleedChild> updateRow(
    _is.DatabaseSession session,
    BleedChild row, {
    _is.ColumnSelections<BleedChildTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BleedChild>(
      row,
      columns: columns?.call(BleedChild.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BleedChild] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BleedChild?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BleedChildUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BleedChild>(
      id,
      columnValues: columnValues(BleedChild.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BleedChild]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BleedChild>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BleedChildUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BleedChildTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BleedChildTable>? orderBy,
    _is.OrderByListBuilder<BleedChildTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BleedChild>(
      columnValues: columnValues(BleedChild.t.updateTable),
      where: where(BleedChild.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BleedChild.t),
      orderByList: orderByList?.call(BleedChild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BleedChild]s in the list and returns the deleted rows.
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
  Future<List<BleedChild>> delete(
    _is.DatabaseSession session,
    List<BleedChild> rows, {
    _is.OrderByBuilder<BleedChildTable>? orderBy,
    _is.OrderByListBuilder<BleedChildTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BleedChild>(
      rows,
      orderBy: orderBy?.call(BleedChild.t),
      orderByList: orderByList?.call(BleedChild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BleedChild].
  Future<BleedChild> deleteRow(
    _is.DatabaseSession session,
    BleedChild row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BleedChild>(
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
  Future<List<BleedChild>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BleedChildTable> where,
    _is.OrderByBuilder<BleedChildTable>? orderBy,
    _is.OrderByListBuilder<BleedChildTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BleedChild>(
      where: where(BleedChild.t),
      orderBy: orderBy?.call(BleedChild.t),
      orderByList: orderByList?.call(BleedChild.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BleedChildTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BleedChild>(
      where: where?.call(BleedChild.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BleedChild] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BleedChildTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BleedChild>(
      where: where(BleedChild.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

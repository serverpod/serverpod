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

/// Child model used to reproduce the include column-alias collision in
/// https://github.com/serverpod/serverpod/issues/5287
///
/// It has an `int` primary key (`id`) and a `String` column (`bleedingText`).
/// When two long-named relations point at this table, the truncated column
/// alias of one relation's `id` collides with the other relation's
/// `bleedingText`, bleeding the string into the int field on deserialization.
abstract class BleedChild
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BleedChild]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  static BleedChildInclude include() {
    return BleedChildInclude._();
  }

  static BleedChildIncludeList includeList({
    _i1.WhereExpressionBuilder<BleedChildTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BleedChildTable>? orderBy,
    _i1.OrderByListBuilder<BleedChildTable>? orderByList,
    BleedChildInclude? include,
  }) {
    return BleedChildIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BleedChild.t),
      orderByList: orderByList?.call(BleedChild.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
  @_i1.useResult
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

class BleedChildUpdateTable extends _i1.UpdateTable<BleedChildTable> {
  BleedChildUpdateTable(super.table);

  _i1.ColumnValue<String, String> bleedingText(String? value) =>
      _i1.ColumnValue(
        table.bleedingText,
        value,
      );
}

class BleedChildTable extends _i1.Table<int?> {
  BleedChildTable({super.tableRelation}) : super(tableName: 'bleed_child') {
    updateTable = BleedChildUpdateTable(this);
    bleedingText = _i1.ColumnString(
      'bleedingText',
      this,
    );
  }

  late final BleedChildUpdateTable updateTable;

  late final _i1.ColumnString bleedingText;

  @override
  List<_i1.Column> get columns => [
    id,
    bleedingText,
  ];
}

class BleedChildInclude extends _i1.IncludeObject {
  BleedChildInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BleedChild.t;
}

class BleedChildIncludeList extends _i1.IncludeList {
  BleedChildIncludeList._({
    _i1.WhereExpressionBuilder<BleedChildTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BleedChild.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BleedChild.t;
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BleedChildTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BleedChildTable>? orderBy,
    _i1.OrderByListBuilder<BleedChildTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BleedChildTable>? where,
    int? offset,
    _i1.OrderByBuilder<BleedChildTable>? orderBy,
    _i1.OrderByListBuilder<BleedChildTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
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
    _i1.DatabaseSession session,
    List<BleedChild> rows, {
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    BleedChild row, {
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    List<BleedChild> rows, {
    required _i1.ColumnSelections<BleedChildTable> conflictColumns,
    _i1.ColumnSelections<BleedChildTable>? updateColumns,
    _i1.WhereExpressionBuilder<BleedChildTable>? updateWhere,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    BleedChild row, {
    required _i1.ColumnSelections<BleedChildTable> conflictColumns,
    _i1.ColumnSelections<BleedChildTable>? updateColumns,
    _i1.WhereExpressionBuilder<BleedChildTable>? updateWhere,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    List<BleedChild> rows, {
    _i1.ColumnSelections<BleedChildTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    BleedChild row, {
    _i1.ColumnSelections<BleedChildTable>? columns,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<BleedChildUpdateTable> columnValues,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<BleedChildUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BleedChildTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BleedChildTable>? orderBy,
    _i1.OrderByListBuilder<BleedChildTable>? orderByList,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    List<BleedChild> rows, {
    _i1.OrderByBuilder<BleedChildTable>? orderBy,
    _i1.OrderByListBuilder<BleedChildTable>? orderByList,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session,
    BleedChild row, {
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BleedChildTable> where,
    _i1.OrderByBuilder<BleedChildTable>? orderBy,
    _i1.OrderByListBuilder<BleedChildTable>? orderByList,
    _i1.Transaction? transaction,
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
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<BleedChildTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BleedChild>(
      where: where?.call(BleedChild.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BleedChild] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<BleedChildTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BleedChild>(
      where: where(BleedChild.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

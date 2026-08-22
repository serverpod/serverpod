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

abstract class ModifiedColumnName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ModifiedColumnName._({
    this.id,
    required this.originalColumn,
    required this.modifiedColumn,
  });

  factory ModifiedColumnName({
    int? id,
    required String originalColumn,
    required String modifiedColumn,
  }) = _ModifiedColumnNameImpl;

  factory ModifiedColumnName.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModifiedColumnName(
      id: jsonSerialization['id'] as int?,
      originalColumn: jsonSerialization['originalColumn'] as String,
      modifiedColumn: jsonSerialization['modifiedColumn'] as String,
    );
  }

  static final t = ModifiedColumnNameTable();

  static const db = ModifiedColumnNameRepository._();

  @override
  int? id;

  String originalColumn;

  String modifiedColumn;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ModifiedColumnName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ModifiedColumnName copyWith({
    int? id,
    String? originalColumn,
    String? modifiedColumn,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModifiedColumnName',
      if (id != null) 'id': id,
      'originalColumn': originalColumn,
      'modifiedColumn': modifiedColumn,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModifiedColumnName',
      if (id != null) 'id': id,
      'originalColumn': originalColumn,
      'modifiedColumn': modifiedColumn,
    };
  }

  static ModifiedColumnNameInclude include() {
    return ModifiedColumnNameInclude.internal_();
  }

  static ModifiedColumnNameIncludeList includeList({
    _is.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    _is.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    ModifiedColumnNameInclude? include,
  }) {
    return ModifiedColumnNameIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModifiedColumnNameImpl extends ModifiedColumnName {
  _ModifiedColumnNameImpl({
    int? id,
    required String originalColumn,
    required String modifiedColumn,
  }) : super._(
         id: id,
         originalColumn: originalColumn,
         modifiedColumn: modifiedColumn,
       );

  /// Returns a shallow copy of this [ModifiedColumnName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ModifiedColumnName copyWith({
    Object? id = _Undefined,
    String? originalColumn,
    String? modifiedColumn,
  }) {
    return ModifiedColumnName(
      id: id is int? ? id : this.id,
      originalColumn: originalColumn ?? this.originalColumn,
      modifiedColumn: modifiedColumn ?? this.modifiedColumn,
    );
  }
}

class ModifiedColumnNameUpdateTable
    extends _is.UpdateTable<ModifiedColumnNameTable> {
  ModifiedColumnNameUpdateTable(super.table);

  _is.ColumnValue<String, String> originalColumn(String value) =>
      _is.ColumnValue(
        table.originalColumn,
        value,
      );

  _is.ColumnValue<String, String> modifiedColumn(String value) =>
      _is.ColumnValue(
        table.modifiedColumn,
        value,
      );
}

class ModifiedColumnNameTable extends _is.Table<int?> {
  ModifiedColumnNameTable({super.tableRelation})
    : super(tableName: 'modified_column_name') {
    updateTable = ModifiedColumnNameUpdateTable(this);
    originalColumn = _is.ColumnString(
      'originalColumn',
      this,
    );
    modifiedColumn = _is.ColumnString(
      'modified_column',
      this,
      fieldName: 'modifiedColumn',
    );
  }

  late final ModifiedColumnNameUpdateTable updateTable;

  late final _is.ColumnString originalColumn;

  late final _is.ColumnString modifiedColumn;

  @override
  List<_is.Column> get columns => [
    id,
    originalColumn,
    modifiedColumn,
  ];
}

class ModifiedColumnNameInclude extends _is.IncludeObject {
  ModifiedColumnNameInclude.internal_({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ModifiedColumnName.t;
}

class ModifiedColumnNameIncludeList extends _is.IncludeList {
  ModifiedColumnNameIncludeList.internal_({
    _is.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ModifiedColumnName.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ModifiedColumnName.t;
}

class ModifiedColumnNameRepository {
  const ModifiedColumnNameRepository._();

  /// Returns a list of [ModifiedColumnName]s matching the given query parameters.
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
  Future<List<ModifiedColumnName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    _is.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ModifiedColumnName>(
      where: where?.call(ModifiedColumnName.t),
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ModifiedColumnName] matching the given query parameters.
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
  Future<ModifiedColumnName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? offset,
    _is.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    _is.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ModifiedColumnName>(
      where: where?.call(ModifiedColumnName.t),
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ModifiedColumnName] by its [id] or null if no such row exists.
  Future<ModifiedColumnName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ModifiedColumnName>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ModifiedColumnName]s in the list and returns the inserted rows.
  ///
  /// The returned [ModifiedColumnName]s will have their `id` fields set.
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
  Future<List<ModifiedColumnName>> insert(
    _is.DatabaseSession session,
    List<ModifiedColumnName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ModifiedColumnName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ModifiedColumnName] and returns the inserted row.
  ///
  /// The returned [ModifiedColumnName] will have its `id` field set.
  Future<ModifiedColumnName> insertRow(
    _is.DatabaseSession session,
    ModifiedColumnName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ModifiedColumnName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ModifiedColumnName]s in the list and returns the resulting rows.
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
  /// The returned [ModifiedColumnName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModifiedColumnName>> upsert(
    _is.DatabaseSession session,
    List<ModifiedColumnName> rows, {
    required _is.ColumnSelections<ModifiedColumnNameTable> conflictColumns,
    _is.ColumnSelections<ModifiedColumnNameTable>? updateColumns,
    _is.WhereExpressionBuilder<ModifiedColumnNameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ModifiedColumnName>(
      rows,
      conflictColumns: conflictColumns(ModifiedColumnName.t),
      updateColumns: updateColumns?.call(ModifiedColumnName.t),
      updateWhere: updateWhere?.call(ModifiedColumnName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ModifiedColumnName] and returns the resulting row.
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
  /// The returned [ModifiedColumnName] will have its `id` field set.
  Future<ModifiedColumnName?> upsertRow(
    _is.DatabaseSession session,
    ModifiedColumnName row, {
    required _is.ColumnSelections<ModifiedColumnNameTable> conflictColumns,
    _is.ColumnSelections<ModifiedColumnNameTable>? updateColumns,
    _is.WhereExpressionBuilder<ModifiedColumnNameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ModifiedColumnName>(
      row,
      conflictColumns: conflictColumns(ModifiedColumnName.t),
      updateColumns: updateColumns?.call(ModifiedColumnName.t),
      updateWhere: updateWhere?.call(ModifiedColumnName.t),
      transaction: transaction,
    );
  }

  /// Updates all [ModifiedColumnName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModifiedColumnName>> update(
    _is.DatabaseSession session,
    List<ModifiedColumnName> rows, {
    _is.ColumnSelections<ModifiedColumnNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ModifiedColumnName>(
      rows,
      columns: columns?.call(ModifiedColumnName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ModifiedColumnName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ModifiedColumnName> updateRow(
    _is.DatabaseSession session,
    ModifiedColumnName row, {
    _is.ColumnSelections<ModifiedColumnNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ModifiedColumnName>(
      row,
      columns: columns?.call(ModifiedColumnName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ModifiedColumnName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ModifiedColumnName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ModifiedColumnNameUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ModifiedColumnName>(
      id,
      columnValues: columnValues(ModifiedColumnName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ModifiedColumnName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ModifiedColumnName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ModifiedColumnNameUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ModifiedColumnNameTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    _is.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ModifiedColumnName>(
      columnValues: columnValues(ModifiedColumnName.t.updateTable),
      where: where(ModifiedColumnName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ModifiedColumnName]s in the list and returns the deleted rows.
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
  Future<List<ModifiedColumnName>> delete(
    _is.DatabaseSession session,
    List<ModifiedColumnName> rows, {
    _is.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    _is.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ModifiedColumnName>(
      rows,
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ModifiedColumnName].
  Future<ModifiedColumnName> deleteRow(
    _is.DatabaseSession session,
    ModifiedColumnName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ModifiedColumnName>(
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
  Future<List<ModifiedColumnName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ModifiedColumnNameTable> where,
    _is.OrderByBuilder<ModifiedColumnNameTable>? orderBy,
    _is.OrderByListBuilder<ModifiedColumnNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ModifiedColumnName>(
      where: where(ModifiedColumnName.t),
      orderBy: orderBy?.call(ModifiedColumnName.t),
      orderByList: orderByList?.call(ModifiedColumnName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ModifiedColumnNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ModifiedColumnName>(
      where: where?.call(ModifiedColumnName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ModifiedColumnName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ModifiedColumnNameTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ModifiedColumnName>(
      where: where(ModifiedColumnName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

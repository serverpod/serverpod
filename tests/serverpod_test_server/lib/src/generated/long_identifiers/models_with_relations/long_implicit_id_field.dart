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
import 'package:meta/meta.dart' as _i057hz1u;
import 'package:serverpod/serverpod.dart' as _is;

abstract class LongImplicitIdField
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  LongImplicitIdField._({
    this.id,
    required this.name,
  }) : _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id = null;

  factory LongImplicitIdField({
    int? id,
    required String name,
  }) = _LongImplicitIdFieldImpl;

  factory LongImplicitIdField.fromJson(Map<String, dynamic> jsonSerialization) {
    return LongImplicitIdFieldImplicit._(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
          jsonSerialization['_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id']
              as int?,
    );
  }

  static final t = LongImplicitIdFieldTable();

  static const db = LongImplicitIdFieldRepository._();

  @override
  int? id;

  String name;

  final int? _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [LongImplicitIdField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  LongImplicitIdField copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'LongImplicitIdField',
      if (id != null) 'id': id,
      'name': name,
      if (_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id !=
          null)
        '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id':
            _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'LongImplicitIdField',
      if (id != null) 'id': id,
      'name': name,
    };
  }

  static LongImplicitIdFieldInclude include() {
    return LongImplicitIdFieldInclude.internal_();
  }

  static LongImplicitIdFieldIncludeList includeList({
    _is.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    _is.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    LongImplicitIdFieldInclude? include,
  }) {
    return LongImplicitIdFieldIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LongImplicitIdFieldImpl extends LongImplicitIdField {
  _LongImplicitIdFieldImpl({
    int? id,
    required String name,
  }) : super._(
         id: id,
         name: name,
       );

  /// Returns a shallow copy of this [LongImplicitIdField]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  LongImplicitIdField copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return LongImplicitIdFieldImplicit._(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
          this._longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
    );
  }
}

class LongImplicitIdFieldImplicit extends _LongImplicitIdFieldImpl {
  LongImplicitIdFieldImplicit._({
    int? id,
    required String name,
    int? $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
  }) : _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id =
           $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
       super(
         id: id,
         name: name,
       );

  factory LongImplicitIdFieldImplicit(
    LongImplicitIdField longImplicitIdField, {
    int? $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
  }) {
    return LongImplicitIdFieldImplicit._(
      id: longImplicitIdField.id,
      name: longImplicitIdField.name,
      $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id:
          $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
    );
  }

  @override
  final int? _longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id;
}

class LongImplicitIdFieldUpdateTable
    extends _is.UpdateTable<LongImplicitIdFieldTable> {
  LongImplicitIdFieldUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int>
  $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id(
    int? value,
  ) => _is.ColumnValue(
    table.$_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
    value,
  );
}

class LongImplicitIdFieldTable extends _is.Table<int?> {
  LongImplicitIdFieldTable({super.tableRelation})
    : super(tableName: 'long_implicit_id_field') {
    updateTable = LongImplicitIdFieldUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id =
        _is.ColumnInt(
          '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id',
          this,
        );
  }

  late final LongImplicitIdFieldUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt
  $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    $_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id,
  ];

  @override
  List<_is.Column> get managedColumns => [
    id,
    name,
  ];
}

class LongImplicitIdFieldInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  LongImplicitIdFieldInclude.internal_({
    List<_is.Column>? this.selectedColumns,
  }) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => LongImplicitIdField.t;
}

class LongImplicitIdFieldIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  LongImplicitIdFieldIncludeList.internal_({
    _is.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(LongImplicitIdField.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => LongImplicitIdField.t;
}

class LongImplicitIdFieldRepository {
  const LongImplicitIdFieldRepository._();

  /// Returns a list of [LongImplicitIdField]s matching the given query parameters.
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
  Future<List<LongImplicitIdField>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    _is.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<LongImplicitIdField>(
      where: where?.call(LongImplicitIdField.t),
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [LongImplicitIdField] matching the given query parameters.
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
  Future<LongImplicitIdField?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? offset,
    _is.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    _is.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<LongImplicitIdField>(
      where: where?.call(LongImplicitIdField.t),
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [LongImplicitIdField] by its [id] or null if no such row exists.
  Future<LongImplicitIdField?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<LongImplicitIdField>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [LongImplicitIdField]s in the list and returns the inserted rows.
  ///
  /// The returned [LongImplicitIdField]s will have their `id` fields set.
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
  Future<List<LongImplicitIdField>> insert(
    _is.DatabaseSession session,
    List<LongImplicitIdField> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<LongImplicitIdField>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [LongImplicitIdField] and returns the inserted row.
  ///
  /// The returned [LongImplicitIdField] will have its `id` field set.
  Future<LongImplicitIdField> insertRow(
    _is.DatabaseSession session,
    LongImplicitIdField row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<LongImplicitIdField>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [LongImplicitIdField]s in the list and returns the resulting rows.
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
  /// The returned [LongImplicitIdField]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LongImplicitIdField>> upsert(
    _is.DatabaseSession session,
    List<LongImplicitIdField> rows, {
    required _is.ColumnSelections<LongImplicitIdFieldTable> conflictColumns,
    _is.ColumnSelections<LongImplicitIdFieldTable>? updateColumns,
    _is.WhereExpressionBuilder<LongImplicitIdFieldTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<LongImplicitIdField>(
      rows,
      conflictColumns: conflictColumns(LongImplicitIdField.t),
      updateColumns: updateColumns?.call(LongImplicitIdField.t),
      updateWhere: updateWhere?.call(LongImplicitIdField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [LongImplicitIdField] and returns the resulting row.
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
  /// The returned [LongImplicitIdField] will have its `id` field set.
  Future<LongImplicitIdField?> upsertRow(
    _is.DatabaseSession session,
    LongImplicitIdField row, {
    required _is.ColumnSelections<LongImplicitIdFieldTable> conflictColumns,
    _is.ColumnSelections<LongImplicitIdFieldTable>? updateColumns,
    _is.WhereExpressionBuilder<LongImplicitIdFieldTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<LongImplicitIdField>(
      row,
      conflictColumns: conflictColumns(LongImplicitIdField.t),
      updateColumns: updateColumns?.call(LongImplicitIdField.t),
      updateWhere: updateWhere?.call(LongImplicitIdField.t),
      transaction: transaction,
    );
  }

  /// Updates all [LongImplicitIdField]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LongImplicitIdField>> update(
    _is.DatabaseSession session,
    List<LongImplicitIdField> rows, {
    _is.ColumnSelections<LongImplicitIdFieldTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<LongImplicitIdField>(
      rows,
      columns: columns?.call(LongImplicitIdField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [LongImplicitIdField]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LongImplicitIdField> updateRow(
    _is.DatabaseSession session,
    LongImplicitIdField row, {
    _is.ColumnSelections<LongImplicitIdFieldTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<LongImplicitIdField>(
      row,
      columns: columns?.call(LongImplicitIdField.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LongImplicitIdField] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<LongImplicitIdField?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<LongImplicitIdFieldUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<LongImplicitIdField>(
      id,
      columnValues: columnValues(LongImplicitIdField.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [LongImplicitIdField]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<LongImplicitIdField>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<LongImplicitIdFieldUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<LongImplicitIdFieldTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    _is.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<LongImplicitIdField>(
      columnValues: columnValues(LongImplicitIdField.t.updateTable),
      where: where(LongImplicitIdField.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [LongImplicitIdField]s in the list and returns the deleted rows.
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
  Future<List<LongImplicitIdField>> delete(
    _is.DatabaseSession session,
    List<LongImplicitIdField> rows, {
    _is.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    _is.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<LongImplicitIdField>(
      rows,
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [LongImplicitIdField].
  Future<LongImplicitIdField> deleteRow(
    _is.DatabaseSession session,
    LongImplicitIdField row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LongImplicitIdField>(
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
  Future<List<LongImplicitIdField>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LongImplicitIdFieldTable> where,
    _is.OrderByBuilder<LongImplicitIdFieldTable>? orderBy,
    _is.OrderByListBuilder<LongImplicitIdFieldTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<LongImplicitIdField>(
      where: where(LongImplicitIdField.t),
      orderBy: orderBy?.call(LongImplicitIdField.t),
      orderByList: orderByList?.call(LongImplicitIdField.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<LongImplicitIdFieldTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<LongImplicitIdField>(
      where: where?.call(LongImplicitIdField.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [LongImplicitIdField] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<LongImplicitIdFieldTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<LongImplicitIdField>(
      where: where(LongImplicitIdField.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

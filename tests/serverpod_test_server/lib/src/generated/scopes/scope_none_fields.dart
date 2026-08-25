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
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../simple_data.dart' as _ibunj3w2;

abstract class ScopeNoneFields
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ScopeNoneFields._({this.id}) : _name = null, _object = null;

  factory ScopeNoneFields({int? id}) = _ScopeNoneFieldsImpl;

  factory ScopeNoneFields.fromJson(Map<String, dynamic> jsonSerialization) {
    return ScopeNoneFieldsImplicit._(
      id: jsonSerialization['id'] as int?,
      $name: jsonSerialization['name'] as String?,
      $object: jsonSerialization['object'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ibunj3w2.SimpleData>(
              jsonSerialization['object'],
            ),
    );
  }

  static final t = ScopeNoneFieldsTable();

  static const db = ScopeNoneFieldsRepository._();

  @override
  int? id;

  final String? _name;

  final _ibunj3w2.SimpleData? _object;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ScopeNoneFields]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ScopeNoneFields copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ScopeNoneFields',
      if (id != null) 'id': id,
      if (_name != null) 'name': _name,
      if (_object != null) 'object': _object.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ScopeNoneFields',
      if (id != null) 'id': id,
    };
  }

  static ScopeNoneFieldsInclude include({
    _is.SelectColumnsBuilder<ScopeNoneFieldsTable>? select,
  }) {
    return ScopeNoneFieldsInclude._(
      selectedColumns: select?.call(ScopeNoneFields.t),
    );
  }

  static ScopeNoneFieldsIncludeList includeList({
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    ScopeNoneFieldsInclude? include,
    _is.SelectColumnsBuilder<ScopeNoneFieldsTable>? select,
  }) {
    return ScopeNoneFieldsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      include: include,
      selectedColumns: select?.call(ScopeNoneFields.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ScopeNoneFieldsImpl extends ScopeNoneFields {
  _ScopeNoneFieldsImpl({int? id}) : super._(id: id);

  /// Returns a shallow copy of this [ScopeNoneFields]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ScopeNoneFields copyWith({Object? id = _Undefined}) {
    return ScopeNoneFieldsImplicit._(
      id: id is int? ? id : this.id,
      $name: this._name,
      $object: this._object?.copyWith(),
    );
  }
}

class ScopeNoneFieldsImplicit extends _ScopeNoneFieldsImpl {
  ScopeNoneFieldsImplicit._({
    int? id,
    String? $name,
    _ibunj3w2.SimpleData? $object,
  }) : _name = $name,
       _object = $object,
       super(id: id);

  factory ScopeNoneFieldsImplicit(
    ScopeNoneFields scopeNoneFields, {
    String? $name,
    _ibunj3w2.SimpleData? $object,
  }) {
    return ScopeNoneFieldsImplicit._(
      id: scopeNoneFields.id,
      $name: $name,
      $object: $object,
    );
  }

  @override
  final String? _name;

  @override
  final _ibunj3w2.SimpleData? _object;
}

class ScopeNoneFieldsUpdateTable extends _is.UpdateTable<ScopeNoneFieldsTable> {
  ScopeNoneFieldsUpdateTable(super.table);

  _is.ColumnValue<String, String> $name(String? value) => _is.ColumnValue(
    table.$name,
    value,
  );

  _is.ColumnValue<_ibunj3w2.SimpleData, _ibunj3w2.SimpleData> $object(
    _ibunj3w2.SimpleData? value,
  ) => _is.ColumnValue(
    table.$object,
    value,
  );
}

class ScopeNoneFieldsTable extends _is.Table<int?> {
  ScopeNoneFieldsTable({super.tableRelation})
    : super(tableName: 'scope_none_fields') {
    updateTable = ScopeNoneFieldsUpdateTable(this);
    $name = _is.ColumnString(
      'name',
      this,
    );
    $object = _is.ColumnSerializable<_ibunj3w2.SimpleData>(
      'object',
      this,
    );
  }

  late final ScopeNoneFieldsUpdateTable updateTable;

  late final _is.ColumnString $name;

  late final _is.ColumnSerializable<_ibunj3w2.SimpleData> $object;

  @override
  List<_is.Column> get columns => [
    id,
    $name,
    $object,
  ];

  @override
  List<_is.Column> get managedColumns => [id];
}

class ScopeNoneFieldsInclude extends _is.IncludeObject {
  ScopeNoneFieldsInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ScopeNoneFields.t;
}

class ScopeNoneFieldsIncludeList extends _is.IncludeList {
  ScopeNoneFieldsIncludeList._({
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ScopeNoneFields.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ScopeNoneFields.t;
}

class ScopeNoneFieldsRepository {
  const ScopeNoneFieldsRepository._();

  /// Returns a list of [ScopeNoneFields]s matching the given query parameters.
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
  Future<List<ScopeNoneFields>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ScopeNoneFields] matching the given query parameters.
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
  Future<ScopeNoneFields?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? offset,
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ScopeNoneFields] by its [id] or null if no such row exists.
  Future<ScopeNoneFields?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ScopeNoneFields>(
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
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ScopeNoneFieldsTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ScopeNoneFields.t),
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
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? offset,
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ScopeNoneFieldsTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ScopeNoneFields.t),
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
    _is.SelectColumnsBuilder<ScopeNoneFieldsTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ScopeNoneFields>(
      id,
      transaction: transaction,
      select: select?.call(ScopeNoneFields.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ScopeNoneFields]s in the list and returns the inserted rows.
  ///
  /// The returned [ScopeNoneFields]s will have their `id` fields set.
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
  Future<List<ScopeNoneFields>> insert(
    _is.DatabaseSession session,
    List<ScopeNoneFields> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ScopeNoneFields>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ScopeNoneFields] and returns the inserted row.
  ///
  /// The returned [ScopeNoneFields] will have its `id` field set.
  Future<ScopeNoneFields> insertRow(
    _is.DatabaseSession session,
    ScopeNoneFields row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ScopeNoneFields>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ScopeNoneFields]s in the list and returns the resulting rows.
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
  /// The returned [ScopeNoneFields]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScopeNoneFields>> upsert(
    _is.DatabaseSession session,
    List<ScopeNoneFields> rows, {
    required _is.ColumnSelections<ScopeNoneFieldsTable> conflictColumns,
    _is.ColumnSelections<ScopeNoneFieldsTable>? updateColumns,
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ScopeNoneFields>(
      rows,
      conflictColumns: conflictColumns(ScopeNoneFields.t),
      updateColumns: updateColumns?.call(ScopeNoneFields.t),
      updateWhere: updateWhere?.call(ScopeNoneFields.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ScopeNoneFields] and returns the resulting row.
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
  /// The returned [ScopeNoneFields] will have its `id` field set.
  Future<ScopeNoneFields?> upsertRow(
    _is.DatabaseSession session,
    ScopeNoneFields row, {
    required _is.ColumnSelections<ScopeNoneFieldsTable> conflictColumns,
    _is.ColumnSelections<ScopeNoneFieldsTable>? updateColumns,
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ScopeNoneFields>(
      row,
      conflictColumns: conflictColumns(ScopeNoneFields.t),
      updateColumns: updateColumns?.call(ScopeNoneFields.t),
      updateWhere: updateWhere?.call(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  /// Updates all [ScopeNoneFields]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScopeNoneFields>> update(
    _is.DatabaseSession session,
    List<ScopeNoneFields> rows, {
    _is.ColumnSelections<ScopeNoneFieldsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ScopeNoneFields>(
      rows,
      columns: columns?.call(ScopeNoneFields.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ScopeNoneFields]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ScopeNoneFields> updateRow(
    _is.DatabaseSession session,
    ScopeNoneFields row, {
    _is.ColumnSelections<ScopeNoneFieldsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ScopeNoneFields>(
      row,
      columns: columns?.call(ScopeNoneFields.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ScopeNoneFields] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ScopeNoneFields?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ScopeNoneFieldsUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ScopeNoneFields>(
      id,
      columnValues: columnValues(ScopeNoneFields.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ScopeNoneFields]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ScopeNoneFields>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ScopeNoneFieldsUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ScopeNoneFields>(
      columnValues: columnValues(ScopeNoneFields.t.updateTable),
      where: where(ScopeNoneFields.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ScopeNoneFields]s in the list and returns the deleted rows.
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
  Future<List<ScopeNoneFields>> delete(
    _is.DatabaseSession session,
    List<ScopeNoneFields> rows, {
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ScopeNoneFields>(
      rows,
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ScopeNoneFields].
  Future<ScopeNoneFields> deleteRow(
    _is.DatabaseSession session,
    ScopeNoneFields row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ScopeNoneFields>(
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
  Future<List<ScopeNoneFields>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    _is.OrderByBuilder<ScopeNoneFieldsTable>? orderBy,
    _is.OrderByListBuilder<ScopeNoneFieldsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ScopeNoneFields>(
      where: where(ScopeNoneFields.t),
      orderBy: orderBy?.call(ScopeNoneFields.t),
      orderByList: orderByList?.call(ScopeNoneFields.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ScopeNoneFieldsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ScopeNoneFields>(
      where: where?.call(ScopeNoneFields.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ScopeNoneFields] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ScopeNoneFieldsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ScopeNoneFields>(
      where: where(ScopeNoneFields.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

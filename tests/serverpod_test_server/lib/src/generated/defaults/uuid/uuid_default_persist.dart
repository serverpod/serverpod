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

abstract class UuidDefaultPersist
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UuidDefaultPersist._({
    this.id,
    this.uuidDefaultPersistRandom,
    this.uuidDefaultPersistRandomV7,
    this.uuidDefaultPersistStr,
  });

  factory UuidDefaultPersist({
    int? id,
    _is.UuidValue? uuidDefaultPersistRandom,
    _is.UuidValue? uuidDefaultPersistRandomV7,
    _is.UuidValue? uuidDefaultPersistStr,
  }) = _UuidDefaultPersistImpl;

  factory UuidDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultPersist(
      id: jsonSerialization['id'] as int?,
      uuidDefaultPersistRandom:
          jsonSerialization['uuidDefaultPersistRandom'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistRandom'],
            ),
      uuidDefaultPersistRandomV7:
          jsonSerialization['uuidDefaultPersistRandomV7'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistRandomV7'],
            ),
      uuidDefaultPersistStr: jsonSerialization['uuidDefaultPersistStr'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultPersistStr'],
            ),
    );
  }

  static final t = UuidDefaultPersistTable();

  static const db = UuidDefaultPersistRepository._();

  @override
  int? id;

  _is.UuidValue? uuidDefaultPersistRandom;

  _is.UuidValue? uuidDefaultPersistRandomV7;

  _is.UuidValue? uuidDefaultPersistStr;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UuidDefaultPersist copyWith({
    int? id,
    _is.UuidValue? uuidDefaultPersistRandom,
    _is.UuidValue? uuidDefaultPersistRandomV7,
    _is.UuidValue? uuidDefaultPersistStr,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UuidDefaultPersist',
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistRandomV7 != null)
        'uuidDefaultPersistRandomV7': uuidDefaultPersistRandomV7?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UuidDefaultPersist',
      if (id != null) 'id': id,
      if (uuidDefaultPersistRandom != null)
        'uuidDefaultPersistRandom': uuidDefaultPersistRandom?.toJson(),
      if (uuidDefaultPersistRandomV7 != null)
        'uuidDefaultPersistRandomV7': uuidDefaultPersistRandomV7?.toJson(),
      if (uuidDefaultPersistStr != null)
        'uuidDefaultPersistStr': uuidDefaultPersistStr?.toJson(),
    };
  }

  static UuidDefaultPersistInclude include({
    _is.SelectColumnsBuilder<UuidDefaultPersistTable>? select,
  }) {
    return UuidDefaultPersistInclude._(
      selectedColumns: select?.call(UuidDefaultPersist.t),
    );
  }

  static UuidDefaultPersistIncludeList includeList({
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    UuidDefaultPersistInclude? include,
    _is.SelectColumnsBuilder<UuidDefaultPersistTable>? select,
  }) {
    return UuidDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      include: include,
      selectedColumns: select?.call(UuidDefaultPersist.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultPersistImpl extends UuidDefaultPersist {
  _UuidDefaultPersistImpl({
    int? id,
    _is.UuidValue? uuidDefaultPersistRandom,
    _is.UuidValue? uuidDefaultPersistRandomV7,
    _is.UuidValue? uuidDefaultPersistStr,
  }) : super._(
         id: id,
         uuidDefaultPersistRandom: uuidDefaultPersistRandom,
         uuidDefaultPersistRandomV7: uuidDefaultPersistRandomV7,
         uuidDefaultPersistStr: uuidDefaultPersistStr,
       );

  /// Returns a shallow copy of this [UuidDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UuidDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? uuidDefaultPersistRandom = _Undefined,
    Object? uuidDefaultPersistRandomV7 = _Undefined,
    Object? uuidDefaultPersistStr = _Undefined,
  }) {
    return UuidDefaultPersist(
      id: id is int? ? id : this.id,
      uuidDefaultPersistRandom: uuidDefaultPersistRandom is _is.UuidValue?
          ? uuidDefaultPersistRandom
          : this.uuidDefaultPersistRandom,
      uuidDefaultPersistRandomV7: uuidDefaultPersistRandomV7 is _is.UuidValue?
          ? uuidDefaultPersistRandomV7
          : this.uuidDefaultPersistRandomV7,
      uuidDefaultPersistStr: uuidDefaultPersistStr is _is.UuidValue?
          ? uuidDefaultPersistStr
          : this.uuidDefaultPersistStr,
    );
  }
}

class UuidDefaultPersistUpdateTable
    extends _is.UpdateTable<UuidDefaultPersistTable> {
  UuidDefaultPersistUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultPersistRandom(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidDefaultPersistRandom,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultPersistRandomV7(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidDefaultPersistRandomV7,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultPersistStr(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidDefaultPersistStr,
    value,
  );
}

class UuidDefaultPersistTable extends _is.Table<int?> {
  UuidDefaultPersistTable({super.tableRelation})
    : super(tableName: 'uuid_default_persist') {
    updateTable = UuidDefaultPersistUpdateTable(this);
    uuidDefaultPersistRandom = _is.ColumnUuid(
      'uuidDefaultPersistRandom',
      this,
      hasDefault: true,
    );
    uuidDefaultPersistRandomV7 = _is.ColumnUuid(
      'uuidDefaultPersistRandomV7',
      this,
      hasDefault: true,
    );
    uuidDefaultPersistStr = _is.ColumnUuid(
      'uuidDefaultPersistStr',
      this,
      hasDefault: true,
    );
  }

  late final UuidDefaultPersistUpdateTable updateTable;

  late final _is.ColumnUuid uuidDefaultPersistRandom;

  late final _is.ColumnUuid uuidDefaultPersistRandomV7;

  late final _is.ColumnUuid uuidDefaultPersistStr;

  @override
  List<_is.Column> get columns => [
    id,
    uuidDefaultPersistRandom,
    uuidDefaultPersistRandomV7,
    uuidDefaultPersistStr,
  ];
}

class UuidDefaultPersistInclude extends _is.IncludeObject {
  UuidDefaultPersistInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UuidDefaultPersist.t;
}

class UuidDefaultPersistIncludeList extends _is.IncludeList {
  UuidDefaultPersistIncludeList._({
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UuidDefaultPersist.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UuidDefaultPersist.t;
}

class UuidDefaultPersistRepository {
  const UuidDefaultPersistRepository._();

  /// Returns a list of [UuidDefaultPersist]s matching the given query parameters.
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
  Future<List<UuidDefaultPersist>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UuidDefaultPersist] matching the given query parameters.
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
  Future<UuidDefaultPersist?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UuidDefaultPersist] by its [id] or null if no such row exists.
  Future<UuidDefaultPersist?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UuidDefaultPersist>(
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
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UuidDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(UuidDefaultPersist.t),
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
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? offset,
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UuidDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(UuidDefaultPersist.t),
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
    _is.SelectColumnsBuilder<UuidDefaultPersistTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UuidDefaultPersist>(
      id,
      transaction: transaction,
      select: select?.call(UuidDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UuidDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [UuidDefaultPersist]s will have their `id` fields set.
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
  Future<List<UuidDefaultPersist>> insert(
    _is.DatabaseSession session,
    List<UuidDefaultPersist> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UuidDefaultPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UuidDefaultPersist] and returns the inserted row.
  ///
  /// The returned [UuidDefaultPersist] will have its `id` field set.
  Future<UuidDefaultPersist> insertRow(
    _is.DatabaseSession session,
    UuidDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UuidDefaultPersist]s in the list and returns the resulting rows.
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
  /// The returned [UuidDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefaultPersist>> upsert(
    _is.DatabaseSession session,
    List<UuidDefaultPersist> rows, {
    required _is.ColumnSelections<UuidDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<UuidDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UuidDefaultPersist>(
      rows,
      conflictColumns: conflictColumns(UuidDefaultPersist.t),
      updateColumns: updateColumns?.call(UuidDefaultPersist.t),
      updateWhere: updateWhere?.call(UuidDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UuidDefaultPersist] and returns the resulting row.
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
  /// The returned [UuidDefaultPersist] will have its `id` field set.
  Future<UuidDefaultPersist?> upsertRow(
    _is.DatabaseSession session,
    UuidDefaultPersist row, {
    required _is.ColumnSelections<UuidDefaultPersistTable> conflictColumns,
    _is.ColumnSelections<UuidDefaultPersistTable>? updateColumns,
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UuidDefaultPersist>(
      row,
      conflictColumns: conflictColumns(UuidDefaultPersist.t),
      updateColumns: updateColumns?.call(UuidDefaultPersist.t),
      updateWhere: updateWhere?.call(UuidDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefaultPersist>> update(
    _is.DatabaseSession session,
    List<UuidDefaultPersist> rows, {
    _is.ColumnSelections<UuidDefaultPersistTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UuidDefaultPersist>(
      rows,
      columns: columns?.call(UuidDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UuidDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UuidDefaultPersist> updateRow(
    _is.DatabaseSession session,
    UuidDefaultPersist row, {
    _is.ColumnSelections<UuidDefaultPersistTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefaultPersist>(
      row,
      columns: columns?.call(UuidDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UuidDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UuidDefaultPersist?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UuidDefaultPersistUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UuidDefaultPersist>(
      id,
      columnValues: columnValues(UuidDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefaultPersist>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UuidDefaultPersistUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UuidDefaultPersistTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UuidDefaultPersist>(
      columnValues: columnValues(UuidDefaultPersist.t.updateTable),
      where: where(UuidDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UuidDefaultPersist]s in the list and returns the deleted rows.
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
  Future<List<UuidDefaultPersist>> delete(
    _is.DatabaseSession session,
    List<UuidDefaultPersist> rows, {
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UuidDefaultPersist>(
      rows,
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UuidDefaultPersist].
  Future<UuidDefaultPersist> deleteRow(
    _is.DatabaseSession session,
    UuidDefaultPersist row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefaultPersist>(
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
  Future<List<UuidDefaultPersist>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UuidDefaultPersistTable> where,
    _is.OrderByBuilder<UuidDefaultPersistTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultPersistTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UuidDefaultPersist>(
      where: where(UuidDefaultPersist.t),
      orderBy: orderBy?.call(UuidDefaultPersist.t),
      orderByList: orderByList?.call(UuidDefaultPersist.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultPersistTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefaultPersist>(
      where: where?.call(UuidDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UuidDefaultPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UuidDefaultPersistTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UuidDefaultPersist>(
      where: where(UuidDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

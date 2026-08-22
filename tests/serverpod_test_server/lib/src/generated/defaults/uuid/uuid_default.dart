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

abstract class UuidDefault
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UuidDefault._({
    this.id,
    _is.UuidValue? uuidDefaultRandom,
    _is.UuidValue? uuidDefaultRandomV7,
    _is.UuidValue? uuidDefaultRandomNull,
    _is.UuidValue? uuidDefaultStr,
    _is.UuidValue? uuidDefaultStrNull,
  }) : uuidDefaultRandom = uuidDefaultRandom ?? const _is.Uuid().v4obj(),
       uuidDefaultRandomV7 = uuidDefaultRandomV7 ?? const _is.Uuid().v7obj(),
       uuidDefaultRandomNull =
           uuidDefaultRandomNull ?? const _is.Uuid().v4obj(),
       uuidDefaultStr =
           uuidDefaultStr ??
           _is.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
       uuidDefaultStrNull =
           uuidDefaultStrNull ??
           _is.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefault({
    int? id,
    _is.UuidValue? uuidDefaultRandom,
    _is.UuidValue? uuidDefaultRandomV7,
    _is.UuidValue? uuidDefaultRandomNull,
    _is.UuidValue? uuidDefaultStr,
    _is.UuidValue? uuidDefaultStrNull,
  }) = _UuidDefaultImpl;

  factory UuidDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefault(
      id: jsonSerialization['id'] as int?,
      uuidDefaultRandom: jsonSerialization['uuidDefaultRandom'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandom'],
            ),
      uuidDefaultRandomV7: jsonSerialization['uuidDefaultRandomV7'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandomV7'],
            ),
      uuidDefaultRandomNull: jsonSerialization['uuidDefaultRandomNull'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultRandomNull'],
            ),
      uuidDefaultStr: jsonSerialization['uuidDefaultStr'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultStr'],
            ),
      uuidDefaultStrNull: jsonSerialization['uuidDefaultStrNull'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultStrNull'],
            ),
    );
  }

  static final t = UuidDefaultTable();

  static const db = UuidDefaultRepository._();

  @override
  int? id;

  _is.UuidValue uuidDefaultRandom;

  _is.UuidValue uuidDefaultRandomV7;

  _is.UuidValue? uuidDefaultRandomNull;

  _is.UuidValue uuidDefaultStr;

  _is.UuidValue? uuidDefaultStrNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UuidDefault copyWith({
    int? id,
    _is.UuidValue? uuidDefaultRandom,
    _is.UuidValue? uuidDefaultRandomV7,
    _is.UuidValue? uuidDefaultRandomNull,
    _is.UuidValue? uuidDefaultStr,
    _is.UuidValue? uuidDefaultStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UuidDefault',
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      'uuidDefaultRandomV7': uuidDefaultRandomV7.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UuidDefault',
      if (id != null) 'id': id,
      'uuidDefaultRandom': uuidDefaultRandom.toJson(),
      'uuidDefaultRandomV7': uuidDefaultRandomV7.toJson(),
      if (uuidDefaultRandomNull != null)
        'uuidDefaultRandomNull': uuidDefaultRandomNull?.toJson(),
      'uuidDefaultStr': uuidDefaultStr.toJson(),
      if (uuidDefaultStrNull != null)
        'uuidDefaultStrNull': uuidDefaultStrNull?.toJson(),
    };
  }

  static UuidDefaultInclude include() {
    return UuidDefaultInclude.internal_();
  }

  static UuidDefaultIncludeList includeList({
    _is.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultTable>? orderByList,
    UuidDefaultInclude? include,
  }) {
    return UuidDefaultIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultImpl extends UuidDefault {
  _UuidDefaultImpl({
    int? id,
    _is.UuidValue? uuidDefaultRandom,
    _is.UuidValue? uuidDefaultRandomV7,
    _is.UuidValue? uuidDefaultRandomNull,
    _is.UuidValue? uuidDefaultStr,
    _is.UuidValue? uuidDefaultStrNull,
  }) : super._(
         id: id,
         uuidDefaultRandom: uuidDefaultRandom,
         uuidDefaultRandomV7: uuidDefaultRandomV7,
         uuidDefaultRandomNull: uuidDefaultRandomNull,
         uuidDefaultStr: uuidDefaultStr,
         uuidDefaultStrNull: uuidDefaultStrNull,
       );

  /// Returns a shallow copy of this [UuidDefault]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UuidDefault copyWith({
    Object? id = _Undefined,
    _is.UuidValue? uuidDefaultRandom,
    _is.UuidValue? uuidDefaultRandomV7,
    Object? uuidDefaultRandomNull = _Undefined,
    _is.UuidValue? uuidDefaultStr,
    Object? uuidDefaultStrNull = _Undefined,
  }) {
    return UuidDefault(
      id: id is int? ? id : this.id,
      uuidDefaultRandom: uuidDefaultRandom ?? this.uuidDefaultRandom,
      uuidDefaultRandomV7: uuidDefaultRandomV7 ?? this.uuidDefaultRandomV7,
      uuidDefaultRandomNull: uuidDefaultRandomNull is _is.UuidValue?
          ? uuidDefaultRandomNull
          : this.uuidDefaultRandomNull,
      uuidDefaultStr: uuidDefaultStr ?? this.uuidDefaultStr,
      uuidDefaultStrNull: uuidDefaultStrNull is _is.UuidValue?
          ? uuidDefaultStrNull
          : this.uuidDefaultStrNull,
    );
  }
}

class UuidDefaultUpdateTable extends _is.UpdateTable<UuidDefaultTable> {
  UuidDefaultUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultRandom(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uuidDefaultRandom,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultRandomV7(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uuidDefaultRandomV7,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultRandomNull(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidDefaultRandomNull,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultStr(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uuidDefaultStr,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultStrNull(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidDefaultStrNull,
    value,
  );
}

class UuidDefaultTable extends _is.Table<int?> {
  UuidDefaultTable({super.tableRelation}) : super(tableName: 'uuid_default') {
    updateTable = UuidDefaultUpdateTable(this);
    uuidDefaultRandom = _is.ColumnUuid(
      'uuidDefaultRandom',
      this,
      hasDefault: true,
    );
    uuidDefaultRandomV7 = _is.ColumnUuid(
      'uuidDefaultRandomV7',
      this,
      hasDefault: true,
    );
    uuidDefaultRandomNull = _is.ColumnUuid(
      'uuidDefaultRandomNull',
      this,
      hasDefault: true,
    );
    uuidDefaultStr = _is.ColumnUuid(
      'uuidDefaultStr',
      this,
      hasDefault: true,
    );
    uuidDefaultStrNull = _is.ColumnUuid(
      'uuidDefaultStrNull',
      this,
      hasDefault: true,
    );
  }

  late final UuidDefaultUpdateTable updateTable;

  late final _is.ColumnUuid uuidDefaultRandom;

  late final _is.ColumnUuid uuidDefaultRandomV7;

  late final _is.ColumnUuid uuidDefaultRandomNull;

  late final _is.ColumnUuid uuidDefaultStr;

  late final _is.ColumnUuid uuidDefaultStrNull;

  @override
  List<_is.Column> get columns => [
    id,
    uuidDefaultRandom,
    uuidDefaultRandomV7,
    uuidDefaultRandomNull,
    uuidDefaultStr,
    uuidDefaultStrNull,
  ];
}

class UuidDefaultInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  UuidDefaultInclude.internal_({List<_is.Column>? this.selectedColumns}) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UuidDefault.t;
}

class UuidDefaultIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  UuidDefaultIncludeList.internal_({
    _is.WhereExpressionBuilder<UuidDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(UuidDefault.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UuidDefault.t;
}

class UuidDefaultRepository {
  const UuidDefaultRepository._();

  /// Returns a list of [UuidDefault]s matching the given query parameters.
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
  Future<List<UuidDefault>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UuidDefault>(
      where: where?.call(UuidDefault.t),
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UuidDefault] matching the given query parameters.
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
  Future<UuidDefault?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? offset,
    _is.OrderByBuilder<UuidDefaultTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UuidDefault>(
      where: where?.call(UuidDefault.t),
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UuidDefault] by its [id] or null if no such row exists.
  Future<UuidDefault?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UuidDefault>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UuidDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [UuidDefault]s will have their `id` fields set.
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
  Future<List<UuidDefault>> insert(
    _is.DatabaseSession session,
    List<UuidDefault> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UuidDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UuidDefault] and returns the inserted row.
  ///
  /// The returned [UuidDefault] will have its `id` field set.
  Future<UuidDefault> insertRow(
    _is.DatabaseSession session,
    UuidDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UuidDefault]s in the list and returns the resulting rows.
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
  /// The returned [UuidDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefault>> upsert(
    _is.DatabaseSession session,
    List<UuidDefault> rows, {
    required _is.ColumnSelections<UuidDefaultTable> conflictColumns,
    _is.ColumnSelections<UuidDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<UuidDefaultTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UuidDefault>(
      rows,
      conflictColumns: conflictColumns(UuidDefault.t),
      updateColumns: updateColumns?.call(UuidDefault.t),
      updateWhere: updateWhere?.call(UuidDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UuidDefault] and returns the resulting row.
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
  /// The returned [UuidDefault] will have its `id` field set.
  Future<UuidDefault?> upsertRow(
    _is.DatabaseSession session,
    UuidDefault row, {
    required _is.ColumnSelections<UuidDefaultTable> conflictColumns,
    _is.ColumnSelections<UuidDefaultTable>? updateColumns,
    _is.WhereExpressionBuilder<UuidDefaultTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UuidDefault>(
      row,
      conflictColumns: conflictColumns(UuidDefault.t),
      updateColumns: updateColumns?.call(UuidDefault.t),
      updateWhere: updateWhere?.call(UuidDefault.t),
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefault>> update(
    _is.DatabaseSession session,
    List<UuidDefault> rows, {
    _is.ColumnSelections<UuidDefaultTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UuidDefault>(
      rows,
      columns: columns?.call(UuidDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UuidDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UuidDefault> updateRow(
    _is.DatabaseSession session,
    UuidDefault row, {
    _is.ColumnSelections<UuidDefaultTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefault>(
      row,
      columns: columns?.call(UuidDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UuidDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UuidDefault?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UuidDefaultUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UuidDefault>(
      id,
      columnValues: columnValues(UuidDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefault>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UuidDefaultUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UuidDefaultTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UuidDefault>(
      columnValues: columnValues(UuidDefault.t.updateTable),
      where: where(UuidDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UuidDefault]s in the list and returns the deleted rows.
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
  Future<List<UuidDefault>> delete(
    _is.DatabaseSession session,
    List<UuidDefault> rows, {
    _is.OrderByBuilder<UuidDefaultTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UuidDefault>(
      rows,
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UuidDefault].
  Future<UuidDefault> deleteRow(
    _is.DatabaseSession session,
    UuidDefault row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefault>(
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
  Future<List<UuidDefault>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UuidDefaultTable> where,
    _is.OrderByBuilder<UuidDefaultTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UuidDefault>(
      where: where(UuidDefault.t),
      orderBy: orderBy?.call(UuidDefault.t),
      orderByList: orderByList?.call(UuidDefault.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefault>(
      where: where?.call(UuidDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UuidDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UuidDefaultTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UuidDefault>(
      where: where(UuidDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

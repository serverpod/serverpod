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

abstract class UuidDefaultModel
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UuidDefaultModel._({
    this.id,
    _is.UuidValue? uuidDefaultModelRandom,
    _is.UuidValue? uuidDefaultModelRandomV7,
    _is.UuidValue? uuidDefaultModelRandomNull,
    _is.UuidValue? uuidDefaultModelStr,
    _is.UuidValue? uuidDefaultModelStrNull,
  }) : uuidDefaultModelRandom =
           uuidDefaultModelRandom ?? const _is.Uuid().v4obj(),
       uuidDefaultModelRandomV7 =
           uuidDefaultModelRandomV7 ?? const _is.Uuid().v7obj(),
       uuidDefaultModelRandomNull =
           uuidDefaultModelRandomNull ?? const _is.Uuid().v4obj(),
       uuidDefaultModelStr =
           uuidDefaultModelStr ??
           _is.UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
       uuidDefaultModelStrNull =
           uuidDefaultModelStrNull ??
           _is.UuidValue.fromString('3f2504e0-4f89-11d3-9a0c-0305e82c3301');

  factory UuidDefaultModel({
    int? id,
    _is.UuidValue? uuidDefaultModelRandom,
    _is.UuidValue? uuidDefaultModelRandomV7,
    _is.UuidValue? uuidDefaultModelRandomNull,
    _is.UuidValue? uuidDefaultModelStr,
    _is.UuidValue? uuidDefaultModelStrNull,
  }) = _UuidDefaultModelImpl;

  factory UuidDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UuidDefaultModel(
      id: jsonSerialization['id'] as int?,
      uuidDefaultModelRandom:
          jsonSerialization['uuidDefaultModelRandom'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultModelRandom'],
            ),
      uuidDefaultModelRandomV7:
          jsonSerialization['uuidDefaultModelRandomV7'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultModelRandomV7'],
            ),
      uuidDefaultModelRandomNull:
          jsonSerialization['uuidDefaultModelRandomNull'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultModelRandomNull'],
            ),
      uuidDefaultModelStr: jsonSerialization['uuidDefaultModelStr'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultModelStr'],
            ),
      uuidDefaultModelStrNull:
          jsonSerialization['uuidDefaultModelStrNull'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['uuidDefaultModelStrNull'],
            ),
    );
  }

  static final t = UuidDefaultModelTable();

  static const db = UuidDefaultModelRepository._();

  @override
  int? id;

  _is.UuidValue uuidDefaultModelRandom;

  _is.UuidValue uuidDefaultModelRandomV7;

  _is.UuidValue? uuidDefaultModelRandomNull;

  _is.UuidValue uuidDefaultModelStr;

  _is.UuidValue? uuidDefaultModelStrNull;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UuidDefaultModel copyWith({
    int? id,
    _is.UuidValue? uuidDefaultModelRandom,
    _is.UuidValue? uuidDefaultModelRandomV7,
    _is.UuidValue? uuidDefaultModelRandomNull,
    _is.UuidValue? uuidDefaultModelStr,
    _is.UuidValue? uuidDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UuidDefaultModel',
      if (id != null) 'id': id,
      'uuidDefaultModelRandom': uuidDefaultModelRandom.toJson(),
      'uuidDefaultModelRandomV7': uuidDefaultModelRandomV7.toJson(),
      if (uuidDefaultModelRandomNull != null)
        'uuidDefaultModelRandomNull': uuidDefaultModelRandomNull?.toJson(),
      'uuidDefaultModelStr': uuidDefaultModelStr.toJson(),
      if (uuidDefaultModelStrNull != null)
        'uuidDefaultModelStrNull': uuidDefaultModelStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UuidDefaultModel',
      if (id != null) 'id': id,
      'uuidDefaultModelRandom': uuidDefaultModelRandom.toJson(),
      'uuidDefaultModelRandomV7': uuidDefaultModelRandomV7.toJson(),
      if (uuidDefaultModelRandomNull != null)
        'uuidDefaultModelRandomNull': uuidDefaultModelRandomNull?.toJson(),
      'uuidDefaultModelStr': uuidDefaultModelStr.toJson(),
      if (uuidDefaultModelStrNull != null)
        'uuidDefaultModelStrNull': uuidDefaultModelStrNull?.toJson(),
    };
  }

  static UuidDefaultModelInclude include({
    _is.SelectColumnsBuilder<UuidDefaultModelTable>? select,
  }) {
    return UuidDefaultModelInclude._(
      selectedColumns: select?.call(UuidDefaultModel.t),
    );
  }

  static UuidDefaultModelIncludeList includeList({
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    UuidDefaultModelInclude? include,
    _is.SelectColumnsBuilder<UuidDefaultModelTable>? select,
  }) {
    return UuidDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      include: include,
      selectedColumns: select?.call(UuidDefaultModel.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UuidDefaultModelImpl extends UuidDefaultModel {
  _UuidDefaultModelImpl({
    int? id,
    _is.UuidValue? uuidDefaultModelRandom,
    _is.UuidValue? uuidDefaultModelRandomV7,
    _is.UuidValue? uuidDefaultModelRandomNull,
    _is.UuidValue? uuidDefaultModelStr,
    _is.UuidValue? uuidDefaultModelStrNull,
  }) : super._(
         id: id,
         uuidDefaultModelRandom: uuidDefaultModelRandom,
         uuidDefaultModelRandomV7: uuidDefaultModelRandomV7,
         uuidDefaultModelRandomNull: uuidDefaultModelRandomNull,
         uuidDefaultModelStr: uuidDefaultModelStr,
         uuidDefaultModelStrNull: uuidDefaultModelStrNull,
       );

  /// Returns a shallow copy of this [UuidDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UuidDefaultModel copyWith({
    Object? id = _Undefined,
    _is.UuidValue? uuidDefaultModelRandom,
    _is.UuidValue? uuidDefaultModelRandomV7,
    Object? uuidDefaultModelRandomNull = _Undefined,
    _is.UuidValue? uuidDefaultModelStr,
    Object? uuidDefaultModelStrNull = _Undefined,
  }) {
    return UuidDefaultModel(
      id: id is int? ? id : this.id,
      uuidDefaultModelRandom:
          uuidDefaultModelRandom ?? this.uuidDefaultModelRandom,
      uuidDefaultModelRandomV7:
          uuidDefaultModelRandomV7 ?? this.uuidDefaultModelRandomV7,
      uuidDefaultModelRandomNull: uuidDefaultModelRandomNull is _is.UuidValue?
          ? uuidDefaultModelRandomNull
          : this.uuidDefaultModelRandomNull,
      uuidDefaultModelStr: uuidDefaultModelStr ?? this.uuidDefaultModelStr,
      uuidDefaultModelStrNull: uuidDefaultModelStrNull is _is.UuidValue?
          ? uuidDefaultModelStrNull
          : this.uuidDefaultModelStrNull,
    );
  }
}

class UuidDefaultModelUpdateTable
    extends _is.UpdateTable<UuidDefaultModelTable> {
  UuidDefaultModelUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultModelRandom(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uuidDefaultModelRandom,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultModelRandomV7(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uuidDefaultModelRandomV7,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultModelRandomNull(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidDefaultModelRandomNull,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultModelStr(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.uuidDefaultModelStr,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> uuidDefaultModelStrNull(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.uuidDefaultModelStrNull,
    value,
  );
}

class UuidDefaultModelTable extends _is.Table<int?> {
  UuidDefaultModelTable({super.tableRelation})
    : super(tableName: 'uuid_default_model') {
    updateTable = UuidDefaultModelUpdateTable(this);
    uuidDefaultModelRandom = _is.ColumnUuid(
      'uuidDefaultModelRandom',
      this,
    );
    uuidDefaultModelRandomV7 = _is.ColumnUuid(
      'uuidDefaultModelRandomV7',
      this,
    );
    uuidDefaultModelRandomNull = _is.ColumnUuid(
      'uuidDefaultModelRandomNull',
      this,
    );
    uuidDefaultModelStr = _is.ColumnUuid(
      'uuidDefaultModelStr',
      this,
    );
    uuidDefaultModelStrNull = _is.ColumnUuid(
      'uuidDefaultModelStrNull',
      this,
    );
  }

  late final UuidDefaultModelUpdateTable updateTable;

  late final _is.ColumnUuid uuidDefaultModelRandom;

  late final _is.ColumnUuid uuidDefaultModelRandomV7;

  late final _is.ColumnUuid uuidDefaultModelRandomNull;

  late final _is.ColumnUuid uuidDefaultModelStr;

  late final _is.ColumnUuid uuidDefaultModelStrNull;

  @override
  List<_is.Column> get columns => [
    id,
    uuidDefaultModelRandom,
    uuidDefaultModelRandomV7,
    uuidDefaultModelRandomNull,
    uuidDefaultModelStr,
    uuidDefaultModelStrNull,
  ];
}

class UuidDefaultModelInclude extends _is.IncludeObject {
  UuidDefaultModelInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UuidDefaultModel.t;
}

class UuidDefaultModelIncludeList extends _is.IncludeList {
  UuidDefaultModelIncludeList._({
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(UuidDefaultModel.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UuidDefaultModel.t;
}

class UuidDefaultModelRepository {
  const UuidDefaultModelRepository._();

  /// Returns a list of [UuidDefaultModel]s matching the given query parameters.
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
  Future<List<UuidDefaultModel>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UuidDefaultModel] matching the given query parameters.
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
  Future<UuidDefaultModel?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UuidDefaultModel] by its [id] or null if no such row exists.
  Future<UuidDefaultModel?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UuidDefaultModel>(
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
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UuidDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(UuidDefaultModel.t),
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
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? offset,
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<UuidDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(UuidDefaultModel.t),
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
    _is.SelectColumnsBuilder<UuidDefaultModelTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<UuidDefaultModel>(
      id,
      transaction: transaction,
      select: select?.call(UuidDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UuidDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [UuidDefaultModel]s will have their `id` fields set.
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
  Future<List<UuidDefaultModel>> insert(
    _is.DatabaseSession session,
    List<UuidDefaultModel> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UuidDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UuidDefaultModel] and returns the inserted row.
  ///
  /// The returned [UuidDefaultModel] will have its `id` field set.
  Future<UuidDefaultModel> insertRow(
    _is.DatabaseSession session,
    UuidDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UuidDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UuidDefaultModel]s in the list and returns the resulting rows.
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
  /// The returned [UuidDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefaultModel>> upsert(
    _is.DatabaseSession session,
    List<UuidDefaultModel> rows, {
    required _is.ColumnSelections<UuidDefaultModelTable> conflictColumns,
    _is.ColumnSelections<UuidDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UuidDefaultModel>(
      rows,
      conflictColumns: conflictColumns(UuidDefaultModel.t),
      updateColumns: updateColumns?.call(UuidDefaultModel.t),
      updateWhere: updateWhere?.call(UuidDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UuidDefaultModel] and returns the resulting row.
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
  /// The returned [UuidDefaultModel] will have its `id` field set.
  Future<UuidDefaultModel?> upsertRow(
    _is.DatabaseSession session,
    UuidDefaultModel row, {
    required _is.ColumnSelections<UuidDefaultModelTable> conflictColumns,
    _is.ColumnSelections<UuidDefaultModelTable>? updateColumns,
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UuidDefaultModel>(
      row,
      conflictColumns: conflictColumns(UuidDefaultModel.t),
      updateColumns: updateColumns?.call(UuidDefaultModel.t),
      updateWhere: updateWhere?.call(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefaultModel>> update(
    _is.DatabaseSession session,
    List<UuidDefaultModel> rows, {
    _is.ColumnSelections<UuidDefaultModelTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UuidDefaultModel>(
      rows,
      columns: columns?.call(UuidDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UuidDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UuidDefaultModel> updateRow(
    _is.DatabaseSession session,
    UuidDefaultModel row, {
    _is.ColumnSelections<UuidDefaultModelTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UuidDefaultModel>(
      row,
      columns: columns?.call(UuidDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UuidDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UuidDefaultModel?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UuidDefaultModelUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UuidDefaultModel>(
      id,
      columnValues: columnValues(UuidDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UuidDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UuidDefaultModel>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UuidDefaultModelUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UuidDefaultModelTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UuidDefaultModel>(
      columnValues: columnValues(UuidDefaultModel.t.updateTable),
      where: where(UuidDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UuidDefaultModel]s in the list and returns the deleted rows.
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
  Future<List<UuidDefaultModel>> delete(
    _is.DatabaseSession session,
    List<UuidDefaultModel> rows, {
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UuidDefaultModel>(
      rows,
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UuidDefaultModel].
  Future<UuidDefaultModel> deleteRow(
    _is.DatabaseSession session,
    UuidDefaultModel row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UuidDefaultModel>(
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
  Future<List<UuidDefaultModel>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UuidDefaultModelTable> where,
    _is.OrderByBuilder<UuidDefaultModelTable>? orderBy,
    _is.OrderByListBuilder<UuidDefaultModelTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UuidDefaultModel>(
      where: where(UuidDefaultModel.t),
      orderBy: orderBy?.call(UuidDefaultModel.t),
      orderByList: orderByList?.call(UuidDefaultModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UuidDefaultModelTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UuidDefaultModel>(
      where: where?.call(UuidDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UuidDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UuidDefaultModelTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UuidDefaultModel>(
      where: where(UuidDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

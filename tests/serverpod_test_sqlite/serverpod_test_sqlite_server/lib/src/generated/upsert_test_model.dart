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

abstract class UpsertTestModel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UpsertTestModel._({
    this.id,
    required this.code,
    required this.category,
    required this.value,
  });

  factory UpsertTestModel({
    int? id,
    required String code,
    required String category,
    required int value,
  }) = _UpsertTestModelImpl;

  factory UpsertTestModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return UpsertTestModel(
      id: jsonSerialization['id'] as int?,
      code: jsonSerialization['code'] as String,
      category: jsonSerialization['category'] as String,
      value: jsonSerialization['value'] as int,
    );
  }

  static final t = UpsertTestModelTable();

  static const db = UpsertTestModelRepository._();

  @override
  int? id;

  String code;

  String category;

  int value;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UpsertTestModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UpsertTestModel copyWith({
    int? id,
    String? code,
    String? category,
    int? value,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UpsertTestModel',
      if (id != null) 'id': id,
      'code': code,
      'category': category,
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UpsertTestModel',
      if (id != null) 'id': id,
      'code': code,
      'category': category,
      'value': value,
    };
  }

  static UpsertTestModelInclude include() {
    return UpsertTestModelInclude._();
  }

  static UpsertTestModelIncludeList includeList({
    _i1.WhereExpressionBuilder<UpsertTestModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UpsertTestModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UpsertTestModelTable>? orderByList,
    UpsertTestModelInclude? include,
  }) {
    return UpsertTestModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UpsertTestModel.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(UpsertTestModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UpsertTestModelImpl extends UpsertTestModel {
  _UpsertTestModelImpl({
    int? id,
    required String code,
    required String category,
    required int value,
  }) : super._(
         id: id,
         code: code,
         category: category,
         value: value,
       );

  /// Returns a shallow copy of this [UpsertTestModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UpsertTestModel copyWith({
    Object? id = _Undefined,
    String? code,
    String? category,
    int? value,
  }) {
    return UpsertTestModel(
      id: id is int? ? id : this.id,
      code: code ?? this.code,
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }
}

class UpsertTestModelUpdateTable extends _i1.UpdateTable<UpsertTestModelTable> {
  UpsertTestModelUpdateTable(super.table);

  _i1.ColumnValue<String, String> code(String value) => _i1.ColumnValue(
    table.code,
    value,
  );

  _i1.ColumnValue<String, String> category(String value) => _i1.ColumnValue(
    table.category,
    value,
  );

  _i1.ColumnValue<int, int> value(int value) => _i1.ColumnValue(
    table.value,
    value,
  );
}

class UpsertTestModelTable extends _i1.Table<int?> {
  UpsertTestModelTable({super.tableRelation})
    : super(tableName: 'upsert_test_model') {
    updateTable = UpsertTestModelUpdateTable(this);
    code = _i1.ColumnString(
      'code',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    value = _i1.ColumnInt(
      'value',
      this,
    );
  }

  late final UpsertTestModelUpdateTable updateTable;

  late final _i1.ColumnString code;

  late final _i1.ColumnString category;

  late final _i1.ColumnInt value;

  @override
  List<_i1.Column> get columns => [
    id,
    code,
    category,
    value,
  ];
}

class UpsertTestModelInclude extends _i1.IncludeObject {
  UpsertTestModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UpsertTestModel.t;
}

class UpsertTestModelIncludeList extends _i1.IncludeList {
  UpsertTestModelIncludeList._({
    _i1.WhereExpressionBuilder<UpsertTestModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UpsertTestModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UpsertTestModel.t;
}

class UpsertTestModelRepository {
  const UpsertTestModelRepository._();

  /// Returns a list of [UpsertTestModel]s matching the given query parameters.
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
  Future<List<UpsertTestModel>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UpsertTestModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UpsertTestModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UpsertTestModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UpsertTestModel>(
      where: where?.call(UpsertTestModel.t),
      orderBy: orderBy?.call(UpsertTestModel.t),
      orderByList: orderByList?.call(UpsertTestModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UpsertTestModel] matching the given query parameters.
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
  Future<UpsertTestModel?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UpsertTestModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<UpsertTestModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UpsertTestModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UpsertTestModel>(
      where: where?.call(UpsertTestModel.t),
      orderBy: orderBy?.call(UpsertTestModel.t),
      orderByList: orderByList?.call(UpsertTestModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UpsertTestModel] by its [id] or null if no such row exists.
  Future<UpsertTestModel?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UpsertTestModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UpsertTestModel]s in the list and returns the inserted rows.
  ///
  /// The returned [UpsertTestModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UpsertTestModel>> insert(
    _i1.DatabaseSession session,
    List<UpsertTestModel> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UpsertTestModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UpsertTestModel] and returns the inserted row.
  ///
  /// The returned [UpsertTestModel] will have its `id` field set.
  Future<UpsertTestModel> insertRow(
    _i1.DatabaseSession session,
    UpsertTestModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UpsertTestModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UpsertTestModel]s in the list and returns the resulting rows.
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
  /// The returned [UpsertTestModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  Future<List<UpsertTestModel>> upsert(
    _i1.DatabaseSession session,
    List<UpsertTestModel> rows, {
    required _i1.ColumnSelections<UpsertTestModelTable> conflictColumns,
    _i1.ColumnSelections<UpsertTestModelTable>? updateColumns,
    _i1.WhereExpressionBuilder<UpsertTestModelTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsert<UpsertTestModel>(
      rows,
      conflictColumns: conflictColumns(UpsertTestModel.t),
      updateColumns: updateColumns?.call(UpsertTestModel.t),
      updateWhere: updateWhere?.call(UpsertTestModel.t),
      transaction: transaction,
    );
  }

  /// Upserts a single [UpsertTestModel] and returns the resulting row.
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
  /// The returned [UpsertTestModel] will have its `id` field set.
  Future<UpsertTestModel?> upsertRow(
    _i1.DatabaseSession session,
    UpsertTestModel row, {
    required _i1.ColumnSelections<UpsertTestModelTable> conflictColumns,
    _i1.ColumnSelections<UpsertTestModelTable>? updateColumns,
    _i1.WhereExpressionBuilder<UpsertTestModelTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UpsertTestModel>(
      row,
      conflictColumns: conflictColumns(UpsertTestModel.t),
      updateColumns: updateColumns?.call(UpsertTestModel.t),
      updateWhere: updateWhere?.call(UpsertTestModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [UpsertTestModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UpsertTestModel>> update(
    _i1.DatabaseSession session,
    List<UpsertTestModel> rows, {
    _i1.ColumnSelections<UpsertTestModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UpsertTestModel>(
      rows,
      columns: columns?.call(UpsertTestModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UpsertTestModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UpsertTestModel> updateRow(
    _i1.DatabaseSession session,
    UpsertTestModel row, {
    _i1.ColumnSelections<UpsertTestModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UpsertTestModel>(
      row,
      columns: columns?.call(UpsertTestModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UpsertTestModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UpsertTestModel?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UpsertTestModelUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UpsertTestModel>(
      id,
      columnValues: columnValues(UpsertTestModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UpsertTestModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UpsertTestModel>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UpsertTestModelUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<UpsertTestModelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UpsertTestModelTable>? orderBy,
    _i1.OrderByListBuilder<UpsertTestModelTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UpsertTestModel>(
      columnValues: columnValues(UpsertTestModel.t.updateTable),
      where: where(UpsertTestModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UpsertTestModel.t),
      orderByList: orderByList?.call(UpsertTestModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UpsertTestModel]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UpsertTestModel>> delete(
    _i1.DatabaseSession session,
    List<UpsertTestModel> rows, {
    _i1.OrderByBuilder<UpsertTestModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UpsertTestModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UpsertTestModel>(
      rows,
      orderBy: orderBy?.call(UpsertTestModel.t),
      orderByList: orderByList?.call(UpsertTestModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [UpsertTestModel].
  Future<UpsertTestModel> deleteRow(
    _i1.DatabaseSession session,
    UpsertTestModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UpsertTestModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<UpsertTestModel>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UpsertTestModelTable> where,
    _i1.OrderByBuilder<UpsertTestModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UpsertTestModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UpsertTestModel>(
      where: where(UpsertTestModel.t),
      orderBy: orderBy?.call(UpsertTestModel.t),
      orderByList: orderByList?.call(UpsertTestModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UpsertTestModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UpsertTestModel>(
      where: where?.call(UpsertTestModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UpsertTestModel] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UpsertTestModelTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UpsertTestModel>(
      where: where(UpsertTestModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

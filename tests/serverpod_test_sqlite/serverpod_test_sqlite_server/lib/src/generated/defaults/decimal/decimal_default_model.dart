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

abstract class DecimalDefaultModel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DecimalDefaultModel._({
    this.id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  }) : decimalDefaultModelStr =
           decimalDefaultModelStr ?? _i1.Decimal.parse('10.5'),
       decimalDefaultModelStrNull =
           decimalDefaultModelStrNull ?? _i1.Decimal.parse('20.5');

  factory DecimalDefaultModel({
    int? id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  }) = _DecimalDefaultModelImpl;

  factory DecimalDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return DecimalDefaultModel(
      id: jsonSerialization['id'] as int?,
      decimalDefaultModelStr:
          jsonSerialization['decimalDefaultModelStr'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultModelStr'],
            ),
      decimalDefaultModelStrNull:
          jsonSerialization['decimalDefaultModelStrNull'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultModelStrNull'],
            ),
    );
  }

  static final t = DecimalDefaultModelTable();

  static const db = DecimalDefaultModelRepository._();

  @override
  int? id;

  _i1.Decimal decimalDefaultModelStr;

  _i1.Decimal? decimalDefaultModelStrNull;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DecimalDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecimalDefaultModel copyWith({
    int? id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecimalDefaultModel',
      if (id != null) 'id': id,
      'decimalDefaultModelStr': decimalDefaultModelStr.toJson(),
      if (decimalDefaultModelStrNull != null)
        'decimalDefaultModelStrNull': decimalDefaultModelStrNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DecimalDefaultModel',
      if (id != null) 'id': id,
      'decimalDefaultModelStr': decimalDefaultModelStr.toJson(),
      if (decimalDefaultModelStrNull != null)
        'decimalDefaultModelStrNull': decimalDefaultModelStrNull?.toJson(),
    };
  }

  static DecimalDefaultModelInclude include() {
    return DecimalDefaultModelInclude._();
  }

  static DecimalDefaultModelIncludeList includeList({
    _i1.WhereExpressionBuilder<DecimalDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultModelTable>? orderByList,
    DecimalDefaultModelInclude? include,
  }) {
    return DecimalDefaultModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(DecimalDefaultModel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecimalDefaultModelImpl extends DecimalDefaultModel {
  _DecimalDefaultModelImpl({
    int? id,
    _i1.Decimal? decimalDefaultModelStr,
    _i1.Decimal? decimalDefaultModelStrNull,
  }) : super._(
         id: id,
         decimalDefaultModelStr: decimalDefaultModelStr,
         decimalDefaultModelStrNull: decimalDefaultModelStrNull,
       );

  /// Returns a shallow copy of this [DecimalDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecimalDefaultModel copyWith({
    Object? id = _Undefined,
    _i1.Decimal? decimalDefaultModelStr,
    Object? decimalDefaultModelStrNull = _Undefined,
  }) {
    return DecimalDefaultModel(
      id: id is int? ? id : this.id,
      decimalDefaultModelStr:
          decimalDefaultModelStr ?? this.decimalDefaultModelStr,
      decimalDefaultModelStrNull: decimalDefaultModelStrNull is _i1.Decimal?
          ? decimalDefaultModelStrNull
          : this.decimalDefaultModelStrNull,
    );
  }
}

class DecimalDefaultModelUpdateTable
    extends _i1.UpdateTable<DecimalDefaultModelTable> {
  DecimalDefaultModelUpdateTable(super.table);

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> decimalDefaultModelStr(
    _i1.Decimal value,
  ) => _i1.ColumnValue(
    table.decimalDefaultModelStr,
    value,
  );

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> decimalDefaultModelStrNull(
    _i1.Decimal? value,
  ) => _i1.ColumnValue(
    table.decimalDefaultModelStrNull,
    value,
  );
}

class DecimalDefaultModelTable extends _i1.Table<int?> {
  DecimalDefaultModelTable({super.tableRelation})
    : super(tableName: 'decimal_default_model') {
    updateTable = DecimalDefaultModelUpdateTable(this);
    decimalDefaultModelStr = _i1.ColumnDecimal(
      'decimalDefaultModelStr',
      this,
    );
    decimalDefaultModelStrNull = _i1.ColumnDecimal(
      'decimalDefaultModelStrNull',
      this,
    );
  }

  late final DecimalDefaultModelUpdateTable updateTable;

  late final _i1.ColumnDecimal decimalDefaultModelStr;

  late final _i1.ColumnDecimal decimalDefaultModelStrNull;

  @override
  List<_i1.Column> get columns => [
    id,
    decimalDefaultModelStr,
    decimalDefaultModelStrNull,
  ];
}

class DecimalDefaultModelInclude extends _i1.IncludeObject {
  DecimalDefaultModelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DecimalDefaultModel.t;
}

class DecimalDefaultModelIncludeList extends _i1.IncludeList {
  DecimalDefaultModelIncludeList._({
    _i1.WhereExpressionBuilder<DecimalDefaultModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DecimalDefaultModel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DecimalDefaultModel.t;
}

class DecimalDefaultModelRepository {
  const DecimalDefaultModelRepository._();

  /// Returns a list of [DecimalDefaultModel]s matching the given query parameters.
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
  Future<List<DecimalDefaultModel>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultModelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DecimalDefaultModel>(
      where: where?.call(DecimalDefaultModel.t),
      orderBy: orderBy?.call(DecimalDefaultModel.t),
      orderByList: orderByList?.call(DecimalDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DecimalDefaultModel] matching the given query parameters.
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
  Future<DecimalDefaultModel?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultModelTable>? where,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DecimalDefaultModel>(
      where: where?.call(DecimalDefaultModel.t),
      orderBy: orderBy?.call(DecimalDefaultModel.t),
      orderByList: orderByList?.call(DecimalDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DecimalDefaultModel] by its [id] or null if no such row exists.
  Future<DecimalDefaultModel?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DecimalDefaultModel>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DecimalDefaultModel]s in the list and returns the inserted rows.
  ///
  /// The returned [DecimalDefaultModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DecimalDefaultModel>> insert(
    _i1.DatabaseSession session,
    List<DecimalDefaultModel> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DecimalDefaultModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DecimalDefaultModel] and returns the inserted row.
  ///
  /// The returned [DecimalDefaultModel] will have its `id` field set.
  Future<DecimalDefaultModel> insertRow(
    _i1.DatabaseSession session,
    DecimalDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DecimalDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefaultModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DecimalDefaultModel>> update(
    _i1.DatabaseSession session,
    List<DecimalDefaultModel> rows, {
    _i1.ColumnSelections<DecimalDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DecimalDefaultModel>(
      rows,
      columns: columns?.call(DecimalDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefaultModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DecimalDefaultModel> updateRow(
    _i1.DatabaseSession session,
    DecimalDefaultModel row, {
    _i1.ColumnSelections<DecimalDefaultModelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DecimalDefaultModel>(
      row,
      columns: columns?.call(DecimalDefaultModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefaultModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DecimalDefaultModel?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DecimalDefaultModelUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DecimalDefaultModel>(
      id,
      columnValues: columnValues(DecimalDefaultModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefaultModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DecimalDefaultModel>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DecimalDefaultModelUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DecimalDefaultModelTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultModelTable>? orderBy,
    _i1.OrderByListBuilder<DecimalDefaultModelTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DecimalDefaultModel>(
      columnValues: columnValues(DecimalDefaultModel.t.updateTable),
      where: where(DecimalDefaultModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefaultModel.t),
      orderByList: orderByList?.call(DecimalDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DecimalDefaultModel]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DecimalDefaultModel>> delete(
    _i1.DatabaseSession session,
    List<DecimalDefaultModel> rows, {
    _i1.OrderByBuilder<DecimalDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DecimalDefaultModel>(
      rows,
      orderBy: orderBy?.call(DecimalDefaultModel.t),
      orderByList: orderByList?.call(DecimalDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [DecimalDefaultModel].
  Future<DecimalDefaultModel> deleteRow(
    _i1.DatabaseSession session,
    DecimalDefaultModel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DecimalDefaultModel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<DecimalDefaultModel>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultModelTable> where,
    _i1.OrderByBuilder<DecimalDefaultModelTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultModelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DecimalDefaultModel>(
      where: where(DecimalDefaultModel.t),
      orderBy: orderBy?.call(DecimalDefaultModel.t),
      orderByList: orderByList?.call(DecimalDefaultModel.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultModelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DecimalDefaultModel>(
      where: where?.call(DecimalDefaultModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DecimalDefaultModel] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultModelTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DecimalDefaultModel>(
      where: where(DecimalDefaultModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class DecimalDefault
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DecimalDefault._({
    this.id,
    _i1.Decimal? decimalDefault,
    _i1.Decimal? decimalDefaultNull,
  }) : decimalDefault = decimalDefault ?? _i1.Decimal.parse('10.5'),
       decimalDefaultNull = decimalDefaultNull ?? _i1.Decimal.parse('20.5');

  factory DecimalDefault({
    int? id,
    _i1.Decimal? decimalDefault,
    _i1.Decimal? decimalDefaultNull,
  }) = _DecimalDefaultImpl;

  factory DecimalDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return DecimalDefault(
      id: jsonSerialization['id'] as int?,
      decimalDefault: jsonSerialization['decimalDefault'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefault'],
            ),
      decimalDefaultNull: jsonSerialization['decimalDefaultNull'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultNull'],
            ),
    );
  }

  static final t = DecimalDefaultTable();

  static const db = DecimalDefaultRepository._();

  @override
  int? id;

  _i1.Decimal decimalDefault;

  _i1.Decimal? decimalDefaultNull;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DecimalDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecimalDefault copyWith({
    int? id,
    _i1.Decimal? decimalDefault,
    _i1.Decimal? decimalDefaultNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecimalDefault',
      if (id != null) 'id': id,
      'decimalDefault': decimalDefault.toJson(),
      if (decimalDefaultNull != null)
        'decimalDefaultNull': decimalDefaultNull?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DecimalDefault',
      if (id != null) 'id': id,
      'decimalDefault': decimalDefault.toJson(),
      if (decimalDefaultNull != null)
        'decimalDefaultNull': decimalDefaultNull?.toJson(),
    };
  }

  static DecimalDefaultInclude include() {
    return DecimalDefaultInclude._();
  }

  static DecimalDefaultIncludeList includeList({
    _i1.WhereExpressionBuilder<DecimalDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultTable>? orderByList,
    DecimalDefaultInclude? include,
  }) {
    return DecimalDefaultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefault.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(DecimalDefault.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecimalDefaultImpl extends DecimalDefault {
  _DecimalDefaultImpl({
    int? id,
    _i1.Decimal? decimalDefault,
    _i1.Decimal? decimalDefaultNull,
  }) : super._(
         id: id,
         decimalDefault: decimalDefault,
         decimalDefaultNull: decimalDefaultNull,
       );

  /// Returns a shallow copy of this [DecimalDefault]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecimalDefault copyWith({
    Object? id = _Undefined,
    _i1.Decimal? decimalDefault,
    Object? decimalDefaultNull = _Undefined,
  }) {
    return DecimalDefault(
      id: id is int? ? id : this.id,
      decimalDefault: decimalDefault ?? this.decimalDefault,
      decimalDefaultNull: decimalDefaultNull is _i1.Decimal?
          ? decimalDefaultNull
          : this.decimalDefaultNull,
    );
  }
}

class DecimalDefaultUpdateTable extends _i1.UpdateTable<DecimalDefaultTable> {
  DecimalDefaultUpdateTable(super.table);

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> decimalDefault(_i1.Decimal value) =>
      _i1.ColumnValue(
        table.decimalDefault,
        value,
      );

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> decimalDefaultNull(
    _i1.Decimal? value,
  ) => _i1.ColumnValue(
    table.decimalDefaultNull,
    value,
  );
}

class DecimalDefaultTable extends _i1.Table<int?> {
  DecimalDefaultTable({super.tableRelation})
    : super(tableName: 'decimal_default') {
    updateTable = DecimalDefaultUpdateTable(this);
    decimalDefault = _i1.ColumnDecimal(
      'decimalDefault',
      this,
      hasDefault: true,
    );
    decimalDefaultNull = _i1.ColumnDecimal(
      'decimalDefaultNull',
      this,
      hasDefault: true,
    );
  }

  late final DecimalDefaultUpdateTable updateTable;

  late final _i1.ColumnDecimal decimalDefault;

  late final _i1.ColumnDecimal decimalDefaultNull;

  @override
  List<_i1.Column> get columns => [
    id,
    decimalDefault,
    decimalDefaultNull,
  ];
}

class DecimalDefaultInclude extends _i1.IncludeObject {
  DecimalDefaultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DecimalDefault.t;
}

class DecimalDefaultIncludeList extends _i1.IncludeList {
  DecimalDefaultIncludeList._({
    _i1.WhereExpressionBuilder<DecimalDefaultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DecimalDefault.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DecimalDefault.t;
}

class DecimalDefaultRepository {
  const DecimalDefaultRepository._();

  /// Returns a list of [DecimalDefault]s matching the given query parameters.
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
  Future<List<DecimalDefault>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DecimalDefault>(
      where: where?.call(DecimalDefault.t),
      orderBy: orderBy?.call(DecimalDefault.t),
      orderByList: orderByList?.call(DecimalDefault.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DecimalDefault] matching the given query parameters.
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
  Future<DecimalDefault?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultTable>? where,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DecimalDefault>(
      where: where?.call(DecimalDefault.t),
      orderBy: orderBy?.call(DecimalDefault.t),
      orderByList: orderByList?.call(DecimalDefault.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DecimalDefault] by its [id] or null if no such row exists.
  Future<DecimalDefault?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DecimalDefault>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DecimalDefault]s in the list and returns the inserted rows.
  ///
  /// The returned [DecimalDefault]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DecimalDefault>> insert(
    _i1.DatabaseSession session,
    List<DecimalDefault> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DecimalDefault>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DecimalDefault] and returns the inserted row.
  ///
  /// The returned [DecimalDefault] will have its `id` field set.
  Future<DecimalDefault> insertRow(
    _i1.DatabaseSession session,
    DecimalDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DecimalDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefault]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DecimalDefault>> update(
    _i1.DatabaseSession session,
    List<DecimalDefault> rows, {
    _i1.ColumnSelections<DecimalDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DecimalDefault>(
      rows,
      columns: columns?.call(DecimalDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefault]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DecimalDefault> updateRow(
    _i1.DatabaseSession session,
    DecimalDefault row, {
    _i1.ColumnSelections<DecimalDefaultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DecimalDefault>(
      row,
      columns: columns?.call(DecimalDefault.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefault] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DecimalDefault?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DecimalDefaultUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DecimalDefault>(
      id,
      columnValues: columnValues(DecimalDefault.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefault]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DecimalDefault>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DecimalDefaultUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<DecimalDefaultTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultTable>? orderBy,
    _i1.OrderByListBuilder<DecimalDefaultTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DecimalDefault>(
      columnValues: columnValues(DecimalDefault.t.updateTable),
      where: where(DecimalDefault.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefault.t),
      orderByList: orderByList?.call(DecimalDefault.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DecimalDefault]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DecimalDefault>> delete(
    _i1.DatabaseSession session,
    List<DecimalDefault> rows, {
    _i1.OrderByBuilder<DecimalDefaultTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DecimalDefault>(
      rows,
      orderBy: orderBy?.call(DecimalDefault.t),
      orderByList: orderByList?.call(DecimalDefault.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [DecimalDefault].
  Future<DecimalDefault> deleteRow(
    _i1.DatabaseSession session,
    DecimalDefault row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DecimalDefault>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<DecimalDefault>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultTable> where,
    _i1.OrderByBuilder<DecimalDefaultTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DecimalDefault>(
      where: where(DecimalDefault.t),
      orderBy: orderBy?.call(DecimalDefault.t),
      orderByList: orderByList?.call(DecimalDefault.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DecimalDefault>(
      where: where?.call(DecimalDefault.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DecimalDefault] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DecimalDefault>(
      where: where(DecimalDefault.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class DecimalDefaultPersist
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DecimalDefaultPersist._({
    this.id,
    this.decimalDefaultPersist,
  });

  factory DecimalDefaultPersist({
    int? id,
    _i1.Decimal? decimalDefaultPersist,
  }) = _DecimalDefaultPersistImpl;

  factory DecimalDefaultPersist.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DecimalDefaultPersist(
      id: jsonSerialization['id'] as int?,
      decimalDefaultPersist: jsonSerialization['decimalDefaultPersist'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultPersist'],
            ),
    );
  }

  static final t = DecimalDefaultPersistTable();

  static const db = DecimalDefaultPersistRepository._();

  @override
  int? id;

  _i1.Decimal? decimalDefaultPersist;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DecimalDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecimalDefaultPersist copyWith({
    int? id,
    _i1.Decimal? decimalDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecimalDefaultPersist',
      if (id != null) 'id': id,
      if (decimalDefaultPersist != null)
        'decimalDefaultPersist': decimalDefaultPersist?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DecimalDefaultPersist',
      if (id != null) 'id': id,
      if (decimalDefaultPersist != null)
        'decimalDefaultPersist': decimalDefaultPersist?.toJson(),
    };
  }

  static DecimalDefaultPersistInclude include() {
    return DecimalDefaultPersistInclude._();
  }

  static DecimalDefaultPersistIncludeList includeList({
    _i1.WhereExpressionBuilder<DecimalDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultPersistTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultPersistTable>? orderByList,
    DecimalDefaultPersistInclude? include,
  }) {
    return DecimalDefaultPersistIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefaultPersist.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(DecimalDefaultPersist.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecimalDefaultPersistImpl extends DecimalDefaultPersist {
  _DecimalDefaultPersistImpl({
    int? id,
    _i1.Decimal? decimalDefaultPersist,
  }) : super._(
         id: id,
         decimalDefaultPersist: decimalDefaultPersist,
       );

  /// Returns a shallow copy of this [DecimalDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecimalDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? decimalDefaultPersist = _Undefined,
  }) {
    return DecimalDefaultPersist(
      id: id is int? ? id : this.id,
      decimalDefaultPersist: decimalDefaultPersist is _i1.Decimal?
          ? decimalDefaultPersist
          : this.decimalDefaultPersist,
    );
  }
}

class DecimalDefaultPersistUpdateTable
    extends _i1.UpdateTable<DecimalDefaultPersistTable> {
  DecimalDefaultPersistUpdateTable(super.table);

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> decimalDefaultPersist(
    _i1.Decimal? value,
  ) => _i1.ColumnValue(
    table.decimalDefaultPersist,
    value,
  );
}

class DecimalDefaultPersistTable extends _i1.Table<int?> {
  DecimalDefaultPersistTable({super.tableRelation})
    : super(tableName: 'decimal_default_persist') {
    updateTable = DecimalDefaultPersistUpdateTable(this);
    decimalDefaultPersist = _i1.ColumnDecimal(
      'decimalDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final DecimalDefaultPersistUpdateTable updateTable;

  late final _i1.ColumnDecimal decimalDefaultPersist;

  @override
  List<_i1.Column> get columns => [
    id,
    decimalDefaultPersist,
  ];
}

class DecimalDefaultPersistInclude extends _i1.IncludeObject {
  DecimalDefaultPersistInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DecimalDefaultPersist.t;
}

class DecimalDefaultPersistIncludeList extends _i1.IncludeList {
  DecimalDefaultPersistIncludeList._({
    _i1.WhereExpressionBuilder<DecimalDefaultPersistTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DecimalDefaultPersist.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DecimalDefaultPersist.t;
}

class DecimalDefaultPersistRepository {
  const DecimalDefaultPersistRepository._();

  /// Returns a list of [DecimalDefaultPersist]s matching the given query parameters.
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
  Future<List<DecimalDefaultPersist>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultPersistTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultPersistTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DecimalDefaultPersist>(
      where: where?.call(DecimalDefaultPersist.t),
      orderBy: orderBy?.call(DecimalDefaultPersist.t),
      orderByList: orderByList?.call(DecimalDefaultPersist.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DecimalDefaultPersist] matching the given query parameters.
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
  Future<DecimalDefaultPersist?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultPersistTable>? where,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultPersistTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DecimalDefaultPersist>(
      where: where?.call(DecimalDefaultPersist.t),
      orderBy: orderBy?.call(DecimalDefaultPersist.t),
      orderByList: orderByList?.call(DecimalDefaultPersist.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DecimalDefaultPersist] by its [id] or null if no such row exists.
  Future<DecimalDefaultPersist?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DecimalDefaultPersist>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DecimalDefaultPersist]s in the list and returns the inserted rows.
  ///
  /// The returned [DecimalDefaultPersist]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DecimalDefaultPersist>> insert(
    _i1.DatabaseSession session,
    List<DecimalDefaultPersist> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DecimalDefaultPersist>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DecimalDefaultPersist] and returns the inserted row.
  ///
  /// The returned [DecimalDefaultPersist] will have its `id` field set.
  Future<DecimalDefaultPersist> insertRow(
    _i1.DatabaseSession session,
    DecimalDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DecimalDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefaultPersist]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DecimalDefaultPersist>> update(
    _i1.DatabaseSession session,
    List<DecimalDefaultPersist> rows, {
    _i1.ColumnSelections<DecimalDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DecimalDefaultPersist>(
      rows,
      columns: columns?.call(DecimalDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefaultPersist]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DecimalDefaultPersist> updateRow(
    _i1.DatabaseSession session,
    DecimalDefaultPersist row, {
    _i1.ColumnSelections<DecimalDefaultPersistTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DecimalDefaultPersist>(
      row,
      columns: columns?.call(DecimalDefaultPersist.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefaultPersist] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DecimalDefaultPersist?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DecimalDefaultPersistUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DecimalDefaultPersist>(
      id,
      columnValues: columnValues(DecimalDefaultPersist.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefaultPersist]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DecimalDefaultPersist>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DecimalDefaultPersistUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DecimalDefaultPersistTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultPersistTable>? orderBy,
    _i1.OrderByListBuilder<DecimalDefaultPersistTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DecimalDefaultPersist>(
      columnValues: columnValues(DecimalDefaultPersist.t.updateTable),
      where: where(DecimalDefaultPersist.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefaultPersist.t),
      orderByList: orderByList?.call(DecimalDefaultPersist.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DecimalDefaultPersist]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DecimalDefaultPersist>> delete(
    _i1.DatabaseSession session,
    List<DecimalDefaultPersist> rows, {
    _i1.OrderByBuilder<DecimalDefaultPersistTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DecimalDefaultPersist>(
      rows,
      orderBy: orderBy?.call(DecimalDefaultPersist.t),
      orderByList: orderByList?.call(DecimalDefaultPersist.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [DecimalDefaultPersist].
  Future<DecimalDefaultPersist> deleteRow(
    _i1.DatabaseSession session,
    DecimalDefaultPersist row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DecimalDefaultPersist>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<DecimalDefaultPersist>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultPersistTable> where,
    _i1.OrderByBuilder<DecimalDefaultPersistTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultPersistTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DecimalDefaultPersist>(
      where: where(DecimalDefaultPersist.t),
      orderBy: orderBy?.call(DecimalDefaultPersist.t),
      orderByList: orderByList?.call(DecimalDefaultPersist.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultPersistTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DecimalDefaultPersist>(
      where: where?.call(DecimalDefaultPersist.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DecimalDefaultPersist] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultPersistTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DecimalDefaultPersist>(
      where: where(DecimalDefaultPersist.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

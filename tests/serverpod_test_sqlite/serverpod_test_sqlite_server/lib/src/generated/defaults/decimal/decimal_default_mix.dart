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

abstract class DecimalDefaultMix
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  DecimalDefaultMix._({
    this.id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) : decimalDefaultAndDefaultModel =
           decimalDefaultAndDefaultModel ?? _i1.Decimal.parse('20.5'),
       decimalDefaultAndDefaultPersist =
           decimalDefaultAndDefaultPersist ?? _i1.Decimal.parse('10.5'),
       decimalDefaultModelAndDefaultPersist =
           decimalDefaultModelAndDefaultPersist ?? _i1.Decimal.parse('10.5');

  factory DecimalDefaultMix({
    int? id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) = _DecimalDefaultMixImpl;

  factory DecimalDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return DecimalDefaultMix(
      id: jsonSerialization['id'] as int?,
      decimalDefaultAndDefaultModel:
          jsonSerialization['decimalDefaultAndDefaultModel'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultAndDefaultModel'],
            ),
      decimalDefaultAndDefaultPersist:
          jsonSerialization['decimalDefaultAndDefaultPersist'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultAndDefaultPersist'],
            ),
      decimalDefaultModelAndDefaultPersist:
          jsonSerialization['decimalDefaultModelAndDefaultPersist'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultModelAndDefaultPersist'],
            ),
    );
  }

  static final t = DecimalDefaultMixTable();

  static const db = DecimalDefaultMixRepository._();

  @override
  int? id;

  _i1.Decimal decimalDefaultAndDefaultModel;

  _i1.Decimal decimalDefaultAndDefaultPersist;

  _i1.Decimal decimalDefaultModelAndDefaultPersist;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [DecimalDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecimalDefaultMix copyWith({
    int? id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecimalDefaultMix',
      if (id != null) 'id': id,
      'decimalDefaultAndDefaultModel': decimalDefaultAndDefaultModel.toJson(),
      'decimalDefaultAndDefaultPersist': decimalDefaultAndDefaultPersist
          .toJson(),
      'decimalDefaultModelAndDefaultPersist':
          decimalDefaultModelAndDefaultPersist.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DecimalDefaultMix',
      if (id != null) 'id': id,
      'decimalDefaultAndDefaultModel': decimalDefaultAndDefaultModel.toJson(),
      'decimalDefaultAndDefaultPersist': decimalDefaultAndDefaultPersist
          .toJson(),
      'decimalDefaultModelAndDefaultPersist':
          decimalDefaultModelAndDefaultPersist.toJson(),
    };
  }

  static DecimalDefaultMixInclude include() {
    return DecimalDefaultMixInclude._();
  }

  static DecimalDefaultMixIncludeList includeList({
    _i1.WhereExpressionBuilder<DecimalDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultMixTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultMixTable>? orderByList,
    DecimalDefaultMixInclude? include,
  }) {
    return DecimalDefaultMixIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefaultMix.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(DecimalDefaultMix.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecimalDefaultMixImpl extends DecimalDefaultMix {
  _DecimalDefaultMixImpl({
    int? id,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) : super._(
         id: id,
         decimalDefaultAndDefaultModel: decimalDefaultAndDefaultModel,
         decimalDefaultAndDefaultPersist: decimalDefaultAndDefaultPersist,
         decimalDefaultModelAndDefaultPersist:
             decimalDefaultModelAndDefaultPersist,
       );

  /// Returns a shallow copy of this [DecimalDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecimalDefaultMix copyWith({
    Object? id = _Undefined,
    _i1.Decimal? decimalDefaultAndDefaultModel,
    _i1.Decimal? decimalDefaultAndDefaultPersist,
    _i1.Decimal? decimalDefaultModelAndDefaultPersist,
  }) {
    return DecimalDefaultMix(
      id: id is int? ? id : this.id,
      decimalDefaultAndDefaultModel:
          decimalDefaultAndDefaultModel ?? this.decimalDefaultAndDefaultModel,
      decimalDefaultAndDefaultPersist:
          decimalDefaultAndDefaultPersist ??
          this.decimalDefaultAndDefaultPersist,
      decimalDefaultModelAndDefaultPersist:
          decimalDefaultModelAndDefaultPersist ??
          this.decimalDefaultModelAndDefaultPersist,
    );
  }
}

class DecimalDefaultMixUpdateTable
    extends _i1.UpdateTable<DecimalDefaultMixTable> {
  DecimalDefaultMixUpdateTable(super.table);

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> decimalDefaultAndDefaultModel(
    _i1.Decimal value,
  ) => _i1.ColumnValue(
    table.decimalDefaultAndDefaultModel,
    value,
  );

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal> decimalDefaultAndDefaultPersist(
    _i1.Decimal value,
  ) => _i1.ColumnValue(
    table.decimalDefaultAndDefaultPersist,
    value,
  );

  _i1.ColumnValue<_i1.Decimal, _i1.Decimal>
  decimalDefaultModelAndDefaultPersist(_i1.Decimal value) => _i1.ColumnValue(
    table.decimalDefaultModelAndDefaultPersist,
    value,
  );
}

class DecimalDefaultMixTable extends _i1.Table<int?> {
  DecimalDefaultMixTable({super.tableRelation})
    : super(tableName: 'decimal_default_mix') {
    updateTable = DecimalDefaultMixUpdateTable(this);
    decimalDefaultAndDefaultModel = _i1.ColumnDecimal(
      'decimalDefaultAndDefaultModel',
      this,
      hasDefault: true,
    );
    decimalDefaultAndDefaultPersist = _i1.ColumnDecimal(
      'decimalDefaultAndDefaultPersist',
      this,
      hasDefault: true,
    );
    decimalDefaultModelAndDefaultPersist = _i1.ColumnDecimal(
      'decimalDefaultModelAndDefaultPersist',
      this,
      hasDefault: true,
    );
  }

  late final DecimalDefaultMixUpdateTable updateTable;

  late final _i1.ColumnDecimal decimalDefaultAndDefaultModel;

  late final _i1.ColumnDecimal decimalDefaultAndDefaultPersist;

  late final _i1.ColumnDecimal decimalDefaultModelAndDefaultPersist;

  @override
  List<_i1.Column> get columns => [
    id,
    decimalDefaultAndDefaultModel,
    decimalDefaultAndDefaultPersist,
    decimalDefaultModelAndDefaultPersist,
  ];
}

class DecimalDefaultMixInclude extends _i1.IncludeObject {
  DecimalDefaultMixInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => DecimalDefaultMix.t;
}

class DecimalDefaultMixIncludeList extends _i1.IncludeList {
  DecimalDefaultMixIncludeList._({
    _i1.WhereExpressionBuilder<DecimalDefaultMixTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DecimalDefaultMix.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => DecimalDefaultMix.t;
}

class DecimalDefaultMixRepository {
  const DecimalDefaultMixRepository._();

  /// Returns a list of [DecimalDefaultMix]s matching the given query parameters.
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
  Future<List<DecimalDefaultMix>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultMixTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultMixTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DecimalDefaultMix>(
      where: where?.call(DecimalDefaultMix.t),
      orderBy: orderBy?.call(DecimalDefaultMix.t),
      orderByList: orderByList?.call(DecimalDefaultMix.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DecimalDefaultMix] matching the given query parameters.
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
  Future<DecimalDefaultMix?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultMixTable>? where,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultMixTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DecimalDefaultMix>(
      where: where?.call(DecimalDefaultMix.t),
      orderBy: orderBy?.call(DecimalDefaultMix.t),
      orderByList: orderByList?.call(DecimalDefaultMix.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DecimalDefaultMix] by its [id] or null if no such row exists.
  Future<DecimalDefaultMix?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DecimalDefaultMix>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DecimalDefaultMix]s in the list and returns the inserted rows.
  ///
  /// The returned [DecimalDefaultMix]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<DecimalDefaultMix>> insert(
    _i1.DatabaseSession session,
    List<DecimalDefaultMix> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<DecimalDefaultMix>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [DecimalDefaultMix] and returns the inserted row.
  ///
  /// The returned [DecimalDefaultMix] will have its `id` field set.
  Future<DecimalDefaultMix> insertRow(
    _i1.DatabaseSession session,
    DecimalDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<DecimalDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefaultMix]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<DecimalDefaultMix>> update(
    _i1.DatabaseSession session,
    List<DecimalDefaultMix> rows, {
    _i1.ColumnSelections<DecimalDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<DecimalDefaultMix>(
      rows,
      columns: columns?.call(DecimalDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefaultMix]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DecimalDefaultMix> updateRow(
    _i1.DatabaseSession session,
    DecimalDefaultMix row, {
    _i1.ColumnSelections<DecimalDefaultMixTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<DecimalDefaultMix>(
      row,
      columns: columns?.call(DecimalDefaultMix.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DecimalDefaultMix] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DecimalDefaultMix?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<DecimalDefaultMixUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<DecimalDefaultMix>(
      id,
      columnValues: columnValues(DecimalDefaultMix.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DecimalDefaultMix]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<DecimalDefaultMix>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<DecimalDefaultMixUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<DecimalDefaultMixTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<DecimalDefaultMixTable>? orderBy,
    _i1.OrderByListBuilder<DecimalDefaultMixTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<DecimalDefaultMix>(
      columnValues: columnValues(DecimalDefaultMix.t.updateTable),
      where: where(DecimalDefaultMix.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DecimalDefaultMix.t),
      orderByList: orderByList?.call(DecimalDefaultMix.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [DecimalDefaultMix]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<DecimalDefaultMix>> delete(
    _i1.DatabaseSession session,
    List<DecimalDefaultMix> rows, {
    _i1.OrderByBuilder<DecimalDefaultMixTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<DecimalDefaultMix>(
      rows,
      orderBy: orderBy?.call(DecimalDefaultMix.t),
      orderByList: orderByList?.call(DecimalDefaultMix.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [DecimalDefaultMix].
  Future<DecimalDefaultMix> deleteRow(
    _i1.DatabaseSession session,
    DecimalDefaultMix row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DecimalDefaultMix>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<DecimalDefaultMix>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultMixTable> where,
    _i1.OrderByBuilder<DecimalDefaultMixTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<DecimalDefaultMixTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<DecimalDefaultMix>(
      where: where(DecimalDefaultMix.t),
      orderBy: orderBy?.call(DecimalDefaultMix.t),
      orderByList: orderByList?.call(DecimalDefaultMix.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<DecimalDefaultMixTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<DecimalDefaultMix>(
      where: where?.call(DecimalDefaultMix.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DecimalDefaultMix] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<DecimalDefaultMixTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DecimalDefaultMix>(
      where: where(DecimalDefaultMix.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

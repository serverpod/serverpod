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
import 'package:serverpod_database/serverpod_database.dart' as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;

abstract class UniqueData implements _i1.TableRow<int?> {
  UniqueData._({
    this.id,
    required this.number,
    required this.email,
  });

  factory UniqueData({
    int? id,
    required int number,
    required String email,
  }) = _UniqueDataImpl;

  factory UniqueData.fromJson(Map<String, dynamic> jsonSerialization) {
    return UniqueData(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
      email: jsonSerialization['email'] as String,
    );
  }

  static final t = UniqueDataTable();

  static const db = UniqueDataRepository._();

  @override
  int? id;

  int number;

  String email;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  UniqueData copyWith({
    int? id,
    int? number,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UniqueData',
      if (id != null) 'id': id,
      'number': number,
      'email': email,
    };
  }

  static UniqueDataInclude include() {
    return UniqueDataInclude._();
  }

  static UniqueDataIncludeList includeList({
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    UniqueDataInclude? include,
  }) {
    return UniqueDataIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueData.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(UniqueData.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UniqueDataImpl extends UniqueData {
  _UniqueDataImpl({
    int? id,
    required int number,
    required String email,
  }) : super._(
         id: id,
         number: number,
         email: email,
       );

  /// Returns a shallow copy of this [UniqueData]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  UniqueData copyWith({
    Object? id = _Undefined,
    int? number,
    String? email,
  }) {
    return UniqueData(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      email: email ?? this.email,
    );
  }
}

class UniqueDataUpdateTable extends _i1.UpdateTable<UniqueDataTable> {
  UniqueDataUpdateTable(super.table);

  _i1.ColumnValue<int, int> number(int value) => _i1.ColumnValue(
    table.number,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );
}

class UniqueDataTable extends _i1.Table<int?> {
  UniqueDataTable({super.tableRelation}) : super(tableName: 'unique_data') {
    updateTable = UniqueDataUpdateTable(this);
    number = _i1.ColumnInt(
      'number',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
  }

  late final UniqueDataUpdateTable updateTable;

  late final _i1.ColumnInt number;

  late final _i1.ColumnString email;

  @override
  List<_i1.Column> get columns => [
    id,
    number,
    email,
  ];
}

class UniqueDataInclude extends _i1.IncludeObject {
  UniqueDataInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UniqueData.t;
}

class UniqueDataIncludeList extends _i1.IncludeList {
  UniqueDataIncludeList._({
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UniqueData.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UniqueData.t;
}

class UniqueDataRepository {
  const UniqueDataRepository._();

  /// Returns a list of [UniqueData]s matching the given query parameters.
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
  Future<List<UniqueData>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UniqueData] matching the given query parameters.
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
  Future<UniqueData?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UniqueData>(
      where: where?.call(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UniqueData] by its [id] or null if no such row exists.
  Future<UniqueData?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UniqueData>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UniqueData]s in the list and returns the inserted rows.
  ///
  /// The returned [UniqueData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<UniqueData>> insert(
    _i1.DatabaseSession session,
    List<UniqueData> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<UniqueData>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [UniqueData] and returns the inserted row.
  ///
  /// The returned [UniqueData] will have its `id` field set.
  Future<UniqueData> insertRow(
    _i1.DatabaseSession session,
    UniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UniqueData]s in the list and returns the resulting rows.
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
  /// The returned [UniqueData]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  Future<List<UniqueData>> upsert(
    _i1.DatabaseSession session,
    List<UniqueData> rows, {
    required _i1.ColumnSelections<UniqueDataTable> conflictColumns,
    _i1.ColumnSelections<UniqueDataTable>? updateColumns,
    _i1.WhereExpressionBuilder<UniqueDataTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsert<UniqueData>(
      rows,
      conflictColumns: conflictColumns(UniqueData.t),
      updateColumns: updateColumns?.call(UniqueData.t),
      updateWhere: updateWhere?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Upserts a single [UniqueData] and returns the resulting row.
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
  /// The returned [UniqueData] will have its `id` field set.
  Future<UniqueData?> upsertRow(
    _i1.DatabaseSession session,
    UniqueData row, {
    required _i1.ColumnSelections<UniqueDataTable> conflictColumns,
    _i1.ColumnSelections<UniqueDataTable>? updateColumns,
    _i1.WhereExpressionBuilder<UniqueDataTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UniqueData>(
      row,
      conflictColumns: conflictColumns(UniqueData.t),
      updateColumns: updateColumns?.call(UniqueData.t),
      updateWhere: updateWhere?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates all [UniqueData]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UniqueData>> update(
    _i1.DatabaseSession session,
    List<UniqueData> rows, {
    _i1.ColumnSelections<UniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UniqueData>(
      rows,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UniqueData]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UniqueData> updateRow(
    _i1.DatabaseSession session,
    UniqueData row, {
    _i1.ColumnSelections<UniqueDataTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UniqueData>(
      row,
      columns: columns?.call(UniqueData.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UniqueData] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UniqueData?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<UniqueDataUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UniqueData>(
      id,
      columnValues: columnValues(UniqueData.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UniqueData]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UniqueData>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<UniqueDataUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UniqueDataTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UniqueData>(
      columnValues: columnValues(UniqueData.t.updateTable),
      where: where(UniqueData.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UniqueData]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UniqueData>> delete(
    _i1.DatabaseSession session,
    List<UniqueData> rows, {
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UniqueData>(
      rows,
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes a single [UniqueData].
  Future<UniqueData> deleteRow(
    _i1.DatabaseSession session,
    UniqueData row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UniqueData>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  Future<List<UniqueData>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UniqueDataTable> where,
    _i1.OrderByBuilder<UniqueDataTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<UniqueDataTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UniqueData>(
      where: where(UniqueData.t),
      orderBy: orderBy?.call(UniqueData.t),
      orderByList: orderByList?.call(UniqueData.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<UniqueDataTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UniqueData>(
      where: where?.call(UniqueData.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UniqueData] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<UniqueDataTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UniqueData>(
      where: where(UniqueData.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

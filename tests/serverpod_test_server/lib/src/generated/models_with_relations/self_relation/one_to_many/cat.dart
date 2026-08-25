/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../../../models_with_relations/self_relation/one_to_many/cat.dart'
    as _iayhscrz;

abstract class Cat implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Cat._({
    this.id,
    required this.name,
    this.motherId,
    this.mother,
    this.kittens,
  });

  factory Cat({
    int? id,
    required String name,
    int? motherId,
    _iayhscrz.Cat? mother,
    List<_iayhscrz.Cat>? kittens,
  }) = _CatImpl;

  factory Cat.fromJson(Map<String, dynamic> jsonSerialization) {
    return Cat(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      motherId: jsonSerialization['motherId'] as int?,
      mother: jsonSerialization['mother'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iayhscrz.Cat>(
              jsonSerialization['mother'],
            ),
      kittens: jsonSerialization['kittens'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_iayhscrz.Cat>>(
              jsonSerialization['kittens'],
            ),
    );
  }

  static final t = CatTable();

  static const db = CatRepository._();

  @override
  int? id;

  String name;

  int? motherId;

  _iayhscrz.Cat? mother;

  List<_iayhscrz.Cat>? kittens;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Cat]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Cat copyWith({
    int? id,
    String? name,
    int? motherId,
    _iayhscrz.Cat? mother,
    List<_iayhscrz.Cat>? kittens,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Cat',
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother?.toJson(),
      if (kittens != null)
        'kittens': kittens?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Cat',
      if (id != null) 'id': id,
      'name': name,
      if (motherId != null) 'motherId': motherId,
      if (mother != null) 'mother': mother?.toJsonForProtocol(),
      if (kittens != null)
        'kittens': kittens?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static CatInclude include({
    _iayhscrz.CatInclude? mother,
    _iayhscrz.CatIncludeList? kittens,
    _is.SelectColumnsBuilder<CatTable>? select,
  }) {
    return CatInclude._(
      mother: mother,
      kittens: kittens,
      selectedColumns: select?.call(Cat.t),
    );
  }

  static CatIncludeList includeList({
    _is.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    CatInclude? include,
    _is.SelectColumnsBuilder<CatTable>? select,
  }) {
    return CatIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      include: include,
      selectedColumns: select?.call(Cat.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatImpl extends Cat {
  _CatImpl({
    int? id,
    required String name,
    int? motherId,
    _iayhscrz.Cat? mother,
    List<_iayhscrz.Cat>? kittens,
  }) : super._(
         id: id,
         name: name,
         motherId: motherId,
         mother: mother,
         kittens: kittens,
       );

  /// Returns a shallow copy of this [Cat]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Cat copyWith({
    Object? id = _Undefined,
    String? name,
    Object? motherId = _Undefined,
    Object? mother = _Undefined,
    Object? kittens = _Undefined,
  }) {
    return Cat(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      motherId: motherId is int? ? motherId : this.motherId,
      mother: mother is _iayhscrz.Cat? ? mother : this.mother?.copyWith(),
      kittens: kittens is List<_iayhscrz.Cat>?
          ? kittens
          : this.kittens?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CatUpdateTable extends _is.UpdateTable<CatTable> {
  CatUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> motherId(int? value) => _is.ColumnValue(
    table.motherId,
    value,
  );
}

class CatTable extends _is.Table<int?> {
  CatTable({super.tableRelation}) : super(tableName: 'cat') {
    updateTable = CatUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    motherId = _is.ColumnInt(
      'motherId',
      this,
    );
  }

  late final CatUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt motherId;

  _iayhscrz.CatTable? _mother;

  _iayhscrz.CatTable? ___kittens;

  _is.ManyRelation<_iayhscrz.CatTable>? _kittens;

  _iayhscrz.CatTable get mother {
    if (_mother != null) return _mother!;
    _mother = _is.createRelationTable(
      relationFieldName: 'mother',
      field: Cat.t.motherId,
      foreignField: _iayhscrz.Cat.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iayhscrz.CatTable(tableRelation: foreignTableRelation),
    );
    return _mother!;
  }

  _iayhscrz.CatTable get __kittens {
    if (___kittens != null) return ___kittens!;
    ___kittens = _is.createRelationTable(
      relationFieldName: '__kittens',
      field: Cat.t.id,
      foreignField: _iayhscrz.Cat.t.motherId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iayhscrz.CatTable(tableRelation: foreignTableRelation),
    );
    return ___kittens!;
  }

  _is.ManyRelation<_iayhscrz.CatTable> get kittens {
    if (_kittens != null) return _kittens!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'kittens',
      field: Cat.t.id,
      foreignField: _iayhscrz.Cat.t.motherId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iayhscrz.CatTable(tableRelation: foreignTableRelation),
    );
    _kittens = _is.ManyRelation<_iayhscrz.CatTable>(
      tableWithRelations: relationTable,
      table: _iayhscrz.CatTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _kittens!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    motherId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'mother') {
      return mother;
    }
    if (relationField == 'kittens') {
      return __kittens;
    }
    return null;
  }
}

class CatInclude extends _is.IncludeObject {
  CatInclude._({
    _iayhscrz.CatInclude? mother,
    _iayhscrz.CatIncludeList? kittens,
    this.selectedColumns,
  }) {
    _mother = mother;
    _kittens = kittens;
  }

  _iayhscrz.CatInclude? _mother;

  _iayhscrz.CatIncludeList? _kittens;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'mother': _mother,
    'kittens': _kittens,
  };

  @override
  _is.Table<int?> get table => Cat.t;
}

class CatIncludeList extends _is.IncludeList {
  CatIncludeList._({
    _is.WhereExpressionBuilder<CatTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Cat.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Cat.t;
}

class CatRepository {
  const CatRepository._();

  final attach = const CatAttachRepository._();

  final attachRow = const CatAttachRowRepository._();

  final detach = const CatDetachRepository._();

  final detachRow = const CatDetachRowRepository._();

  /// Returns a list of [Cat]s matching the given query parameters.
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
  Future<List<Cat>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    _is.Transaction? transaction,
    CatInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Cat>(
      where: where?.call(Cat.t),
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Cat] matching the given query parameters.
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
  Future<Cat?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatTable>? where,
    int? offset,
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    _is.Transaction? transaction,
    CatInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Cat>(
      where: where?.call(Cat.t),
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Cat] by its [id] or null if no such row exists.
  Future<Cat?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CatInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Cat>(
      id,
      transaction: transaction,
      include: include,
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
    _is.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    _is.Transaction? transaction,
    CatInclude? include,
    _is.SelectColumnsBuilder<CatTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Cat>(
      where: where?.call(Cat.t),
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Cat.t),
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
    _is.WhereExpressionBuilder<CatTable>? where,
    int? offset,
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    _is.Transaction? transaction,
    CatInclude? include,
    _is.SelectColumnsBuilder<CatTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Cat>(
      where: where?.call(Cat.t),
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Cat.t),
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
    CatInclude? include,
    _is.SelectColumnsBuilder<CatTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Cat>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Cat.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Cat]s in the list and returns the inserted rows.
  ///
  /// The returned [Cat]s will have their `id` fields set.
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
  Future<List<Cat>> insert(
    _is.DatabaseSession session,
    List<Cat> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Cat>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Cat] and returns the inserted row.
  ///
  /// The returned [Cat] will have its `id` field set.
  Future<Cat> insertRow(
    _is.DatabaseSession session,
    Cat row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Cat>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Cat]s in the list and returns the resulting rows.
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
  /// The returned [Cat]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Cat>> upsert(
    _is.DatabaseSession session,
    List<Cat> rows, {
    required _is.ColumnSelections<CatTable> conflictColumns,
    _is.ColumnSelections<CatTable>? updateColumns,
    _is.WhereExpressionBuilder<CatTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Cat>(
      rows,
      conflictColumns: conflictColumns(Cat.t),
      updateColumns: updateColumns?.call(Cat.t),
      updateWhere: updateWhere?.call(Cat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Cat] and returns the resulting row.
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
  /// The returned [Cat] will have its `id` field set.
  Future<Cat?> upsertRow(
    _is.DatabaseSession session,
    Cat row, {
    required _is.ColumnSelections<CatTable> conflictColumns,
    _is.ColumnSelections<CatTable>? updateColumns,
    _is.WhereExpressionBuilder<CatTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Cat>(
      row,
      conflictColumns: conflictColumns(Cat.t),
      updateColumns: updateColumns?.call(Cat.t),
      updateWhere: updateWhere?.call(Cat.t),
      transaction: transaction,
    );
  }

  /// Updates all [Cat]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Cat>> update(
    _is.DatabaseSession session,
    List<Cat> rows, {
    _is.ColumnSelections<CatTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Cat>(
      rows,
      columns: columns?.call(Cat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Cat]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Cat> updateRow(
    _is.DatabaseSession session,
    Cat row, {
    _is.ColumnSelections<CatTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Cat>(
      row,
      columns: columns?.call(Cat.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Cat] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Cat?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CatUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Cat>(
      id,
      columnValues: columnValues(Cat.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Cat]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Cat>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CatUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CatTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Cat>(
      columnValues: columnValues(Cat.t.updateTable),
      where: where(Cat.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Cat]s in the list and returns the deleted rows.
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
  Future<List<Cat>> delete(
    _is.DatabaseSession session,
    List<Cat> rows, {
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Cat>(
      rows,
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Cat].
  Future<Cat> deleteRow(
    _is.DatabaseSession session,
    Cat row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Cat>(
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
  Future<List<Cat>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CatTable> where,
    _is.OrderByBuilder<CatTable>? orderBy,
    _is.OrderByListBuilder<CatTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Cat>(
      where: where(Cat.t),
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Cat>(
      where: where?.call(Cat.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Cat] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CatTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Cat>(
      where: where(Cat.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CatAttachRepository {
  const CatAttachRepository._();

  /// Creates a relation between this [Cat] and the given [Cat]s
  /// by setting each [Cat]'s foreign key `motherId` to refer to this [Cat].
  Future<void> kittens(
    _is.DatabaseSession session,
    Cat cat,
    List<_iayhscrz.Cat> nestedCat, {
    _is.Transaction? transaction,
  }) async {
    if (nestedCat.any((e) => e.id == null)) {
      throw ArgumentError.notNull('nestedCat.id');
    }
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $nestedCat = nestedCat
        .map((e) => e.copyWith(motherId: cat.id))
        .toList();
    await session.db.update<_iayhscrz.Cat>(
      $nestedCat,
      columns: [_iayhscrz.Cat.t.motherId],
      transaction: transaction,
    );
  }
}

class CatAttachRowRepository {
  const CatAttachRowRepository._();

  /// Creates a relation between the given [Cat] and [Cat]
  /// by setting the [Cat]'s foreign key `motherId` to refer to the [Cat].
  Future<void> mother(
    _is.DatabaseSession session,
    Cat cat,
    _iayhscrz.Cat mother, {
    _is.Transaction? transaction,
  }) async {
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }
    if (mother.id == null) {
      throw ArgumentError.notNull('mother.id');
    }

    var $cat = cat.copyWith(motherId: mother.id);
    await session.db.updateRow<Cat>(
      $cat,
      columns: [Cat.t.motherId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Cat] and the given [Cat]
  /// by setting the [Cat]'s foreign key `motherId` to refer to this [Cat].
  Future<void> kittens(
    _is.DatabaseSession session,
    Cat cat,
    _iayhscrz.Cat nestedCat, {
    _is.Transaction? transaction,
  }) async {
    if (nestedCat.id == null) {
      throw ArgumentError.notNull('nestedCat.id');
    }
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $nestedCat = nestedCat.copyWith(motherId: cat.id);
    await session.db.updateRow<_iayhscrz.Cat>(
      $nestedCat,
      columns: [_iayhscrz.Cat.t.motherId],
      transaction: transaction,
    );
  }
}

class CatDetachRepository {
  const CatDetachRepository._();

  /// Detaches the relation between this [Cat] and the given [Cat]
  /// by setting the [Cat]'s foreign key `motherId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> kittens(
    _is.DatabaseSession session,
    List<_iayhscrz.Cat> cat, {
    _is.Transaction? transaction,
  }) async {
    if (cat.any((e) => e.id == null)) {
      throw ArgumentError.notNull('cat.id');
    }

    var $cat = cat.map((e) => e.copyWith(motherId: null)).toList();
    await session.db.update<_iayhscrz.Cat>(
      $cat,
      columns: [_iayhscrz.Cat.t.motherId],
      transaction: transaction,
    );
  }
}

class CatDetachRowRepository {
  const CatDetachRowRepository._();

  /// Detaches the relation between this [Cat] and the [Cat] set in `mother`
  /// by setting the [Cat]'s foreign key `motherId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> mother(
    _is.DatabaseSession session,
    Cat cat, {
    _is.Transaction? transaction,
  }) async {
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $cat = cat.copyWith(motherId: null);
    await session.db.updateRow<Cat>(
      $cat,
      columns: [Cat.t.motherId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Cat] and the given [Cat]
  /// by setting the [Cat]'s foreign key `motherId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> kittens(
    _is.DatabaseSession session,
    _iayhscrz.Cat cat, {
    _is.Transaction? transaction,
  }) async {
    if (cat.id == null) {
      throw ArgumentError.notNull('cat.id');
    }

    var $cat = cat.copyWith(motherId: null);
    await session.db.updateRow<_iayhscrz.Cat>(
      $cat,
      columns: [_iayhscrz.Cat.t.motherId],
      transaction: transaction,
    );
  }
}

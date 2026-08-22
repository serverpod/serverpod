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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../../../models_with_relations/self_relation/one_to_many/cat.dart'
    as _iayhscrz;

abstract class Cat implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
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
          : _i0ntutnq.Protocol().deserialize<_iayhscrz.Cat>(
              jsonSerialization['mother'],
            ),
      kittens: jsonSerialization['kittens'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_iayhscrz.Cat>>(
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
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Cat]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
  }) {
    return CatInclude.internal_(
      mother: mother,
      kittens: kittens,
    );
  }

  static CatIncludeList includeList({
    _isd.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CatTable>? orderBy,
    _isd.OrderByListBuilder<CatTable>? orderByList,
    CatInclude? include,
  }) {
    return CatIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Cat.t),
      orderByList: orderByList?.call(Cat.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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

class CatUpdateTable extends _isd.UpdateTable<CatTable> {
  CatUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );

  _isd.ColumnValue<int, int> motherId(int? value) => _isd.ColumnValue(
    table.motherId,
    value,
  );
}

class CatTable extends _isd.Table<int?> {
  CatTable({super.tableRelation}) : super(tableName: 'cat') {
    updateTable = CatUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
    motherId = _isd.ColumnInt(
      'motherId',
      this,
    );
  }

  late final CatUpdateTable updateTable;

  late final _isd.ColumnString name;

  late final _isd.ColumnInt motherId;

  _iayhscrz.CatTable? _mother;

  _iayhscrz.CatTable? ___kittens;

  _isd.ManyRelation<_iayhscrz.CatTable>? _kittens;

  _iayhscrz.CatTable get mother {
    if (_mother != null) return _mother!;
    _mother = _isd.createRelationTable(
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
    ___kittens = _isd.createRelationTable(
      relationFieldName: '__kittens',
      field: Cat.t.id,
      foreignField: _iayhscrz.Cat.t.motherId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iayhscrz.CatTable(tableRelation: foreignTableRelation),
    );
    return ___kittens!;
  }

  _isd.ManyRelation<_iayhscrz.CatTable> get kittens {
    if (_kittens != null) return _kittens!;
    var relationTable = _isd.createRelationTable(
      relationFieldName: 'kittens',
      field: Cat.t.id,
      foreignField: _iayhscrz.Cat.t.motherId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iayhscrz.CatTable(tableRelation: foreignTableRelation),
    );
    _kittens = _isd.ManyRelation<_iayhscrz.CatTable>(
      tableWithRelations: relationTable,
      table: _iayhscrz.CatTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _kittens!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    name,
    motherId,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'mother') {
      return mother;
    }
    if (relationField == 'kittens') {
      return __kittens;
    }
    return null;
  }
}

class CatInclude extends _isd.IncludeObject {
  CatInclude.internal_({
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
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {
    'mother': _mother,
    'kittens': _kittens,
  };

  @override
  _isd.Table<int?> get table => Cat.t;
}

class CatIncludeList extends _isd.IncludeList {
  CatIncludeList.internal_({
    _isd.WhereExpressionBuilder<CatTable>? where,
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
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Cat.t;
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CatTable>? orderBy,
    _isd.OrderByListBuilder<CatTable>? orderByList,
    _isd.Transaction? transaction,
    CatInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CatTable>? where,
    int? offset,
    _isd.OrderByBuilder<CatTable>? orderBy,
    _isd.OrderByListBuilder<CatTable>? orderByList,
    _isd.Transaction? transaction,
    CatInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
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
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    CatInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Cat>(
      id,
      transaction: transaction,
      include: include,
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
    _isd.DatabaseSession session,
    List<Cat> rows, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Cat row, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<Cat> rows, {
    required _isd.ColumnSelections<CatTable> conflictColumns,
    _isd.ColumnSelections<CatTable>? updateColumns,
    _isd.WhereExpressionBuilder<CatTable>? updateWhere,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Cat row, {
    required _isd.ColumnSelections<CatTable> conflictColumns,
    _isd.ColumnSelections<CatTable>? updateColumns,
    _isd.WhereExpressionBuilder<CatTable>? updateWhere,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<Cat> rows, {
    _isd.ColumnSelections<CatTable>? columns,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Cat row, {
    _isd.ColumnSelections<CatTable>? columns,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<CatUpdateTable> columnValues,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<CatUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<CatTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<CatTable>? orderBy,
    _isd.OrderByListBuilder<CatTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<Cat> rows, {
    _isd.OrderByBuilder<CatTable>? orderBy,
    _isd.OrderByListBuilder<CatTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Cat row, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CatTable> where,
    _isd.OrderByBuilder<CatTable>? orderBy,
    _isd.OrderByListBuilder<CatTable>? orderByList,
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<CatTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Cat>(
      where: where?.call(Cat.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Cat] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<CatTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
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
    _isd.DatabaseSession session,
    Cat cat,
    List<_iayhscrz.Cat> nestedCat, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Cat cat,
    _iayhscrz.Cat mother, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Cat cat,
    _iayhscrz.Cat nestedCat, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    List<_iayhscrz.Cat> cat, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    Cat cat, {
    _isd.Transaction? transaction,
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
    _isd.DatabaseSession session,
    _iayhscrz.Cat cat, {
    _isd.Transaction? transaction,
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

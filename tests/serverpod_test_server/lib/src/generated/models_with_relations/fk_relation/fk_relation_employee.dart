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
import '../../models_with_relations/fk_relation/fk_relation_company.dart'
    as _ikyus01r;

abstract class FkRelationEmployee
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  FkRelationEmployee._({
    this.id,
    required this.name,
    required this.companyId,
    this.company,
    this.previousCompanyId,
    this.previousCompany,
  });

  factory FkRelationEmployee({
    int? id,
    required String name,
    required int companyId,
    _ikyus01r.FkRelationCompany? company,
    int? previousCompanyId,
    _ikyus01r.FkRelationCompany? previousCompany,
  }) = _FkRelationEmployeeImpl;

  factory FkRelationEmployee.fromJson(Map<String, dynamic> jsonSerialization) {
    return FkRelationEmployee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      companyId: jsonSerialization['companyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ikyus01r.FkRelationCompany>(
              jsonSerialization['company'],
            ),
      previousCompanyId: jsonSerialization['previousCompanyId'] as int?,
      previousCompany: jsonSerialization['previousCompany'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ikyus01r.FkRelationCompany>(
              jsonSerialization['previousCompany'],
            ),
    );
  }

  static final t = FkRelationEmployeeTable();

  static const db = FkRelationEmployeeRepository._();

  @override
  int? id;

  String name;

  int companyId;

  _ikyus01r.FkRelationCompany? company;

  int? previousCompanyId;

  _ikyus01r.FkRelationCompany? previousCompany;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FkRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FkRelationEmployee copyWith({
    int? id,
    String? name,
    int? companyId,
    _ikyus01r.FkRelationCompany? company,
    int? previousCompanyId,
    _ikyus01r.FkRelationCompany? previousCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FkRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'companyId': companyId,
      if (company != null) 'company': company?.toJson(),
      if (previousCompanyId != null) 'previousCompanyId': previousCompanyId,
      if (previousCompany != null) 'previousCompany': previousCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FkRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'companyId': companyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (previousCompanyId != null) 'previousCompanyId': previousCompanyId,
      if (previousCompany != null)
        'previousCompany': previousCompany?.toJsonForProtocol(),
    };
  }

  static FkRelationEmployeeInclude include({
    _ikyus01r.FkRelationCompanyInclude? company,
    _ikyus01r.FkRelationCompanyInclude? previousCompany,
  }) {
    return FkRelationEmployeeInclude._(
      company: company,
      previousCompany: previousCompany,
    );
  }

  static FkRelationEmployeeIncludeList includeList({
    _is.WhereExpressionBuilder<FkRelationEmployeeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FkRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<FkRelationEmployeeTable>? orderByList,
    FkRelationEmployeeInclude? include,
  }) {
    return FkRelationEmployeeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FkRelationEmployee.t),
      orderByList: orderByList?.call(FkRelationEmployee.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FkRelationEmployeeImpl extends FkRelationEmployee {
  _FkRelationEmployeeImpl({
    int? id,
    required String name,
    required int companyId,
    _ikyus01r.FkRelationCompany? company,
    int? previousCompanyId,
    _ikyus01r.FkRelationCompany? previousCompany,
  }) : super._(
         id: id,
         name: name,
         companyId: companyId,
         company: company,
         previousCompanyId: previousCompanyId,
         previousCompany: previousCompany,
       );

  /// Returns a shallow copy of this [FkRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FkRelationEmployee copyWith({
    Object? id = _Undefined,
    String? name,
    int? companyId,
    Object? company = _Undefined,
    Object? previousCompanyId = _Undefined,
    Object? previousCompany = _Undefined,
  }) {
    return FkRelationEmployee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      companyId: companyId ?? this.companyId,
      company: company is _ikyus01r.FkRelationCompany?
          ? company
          : this.company?.copyWith(),
      previousCompanyId: previousCompanyId is int?
          ? previousCompanyId
          : this.previousCompanyId,
      previousCompany: previousCompany is _ikyus01r.FkRelationCompany?
          ? previousCompany
          : this.previousCompany?.copyWith(),
    );
  }
}

class FkRelationEmployeeUpdateTable
    extends _is.UpdateTable<FkRelationEmployeeTable> {
  FkRelationEmployeeUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> companyId(int value) => _is.ColumnValue(
    table.companyId,
    value,
  );

  _is.ColumnValue<int, int> previousCompanyId(int? value) => _is.ColumnValue(
    table.previousCompanyId,
    value,
  );
}

class FkRelationEmployeeTable extends _is.Table<int?> {
  FkRelationEmployeeTable({super.tableRelation})
    : super(tableName: 'fk_relation_employee') {
    updateTable = FkRelationEmployeeUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    companyId = _is.ColumnInt(
      'companyId',
      this,
    );
    previousCompanyId = _is.ColumnInt(
      'previousCompanyId',
      this,
    );
  }

  late final FkRelationEmployeeUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt companyId;

  _ikyus01r.FkRelationCompanyTable? _company;

  late final _is.ColumnInt previousCompanyId;

  _ikyus01r.FkRelationCompanyTable? _previousCompany;

  _ikyus01r.FkRelationCompanyTable get company {
    if (_company != null) return _company!;
    _company = _is.createRelationTable(
      relationFieldName: 'company',
      field: FkRelationEmployee.t.companyId,
      foreignField: _ikyus01r.FkRelationCompany.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ikyus01r.FkRelationCompanyTable(tableRelation: foreignTableRelation),
    );
    return _company!;
  }

  _ikyus01r.FkRelationCompanyTable get previousCompany {
    if (_previousCompany != null) return _previousCompany!;
    _previousCompany = _is.createRelationTable(
      relationFieldName: 'previousCompany',
      field: FkRelationEmployee.t.previousCompanyId,
      foreignField: _ikyus01r.FkRelationCompany.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ikyus01r.FkRelationCompanyTable(tableRelation: foreignTableRelation),
    );
    return _previousCompany!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    companyId,
    previousCompanyId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'company') {
      return company;
    }
    if (relationField == 'previousCompany') {
      return previousCompany;
    }
    return null;
  }
}

class FkRelationEmployeeInclude extends _is.IncludeObject {
  FkRelationEmployeeInclude._({
    _ikyus01r.FkRelationCompanyInclude? company,
    _ikyus01r.FkRelationCompanyInclude? previousCompany,
  }) {
    _company = company;
    _previousCompany = previousCompany;
  }

  _ikyus01r.FkRelationCompanyInclude? _company;

  _ikyus01r.FkRelationCompanyInclude? _previousCompany;

  @override
  Map<String, _is.Include?> get includes => {
    'company': _company,
    'previousCompany': _previousCompany,
  };

  @override
  _is.Table<int?> get table => FkRelationEmployee.t;
}

class FkRelationEmployeeIncludeList extends _is.IncludeList {
  FkRelationEmployeeIncludeList._({
    _is.WhereExpressionBuilder<FkRelationEmployeeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FkRelationEmployee.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FkRelationEmployee.t;
}

class FkRelationEmployeeRepository {
  const FkRelationEmployeeRepository._();

  final attachRow = const FkRelationEmployeeAttachRowRepository._();

  final detachRow = const FkRelationEmployeeDetachRowRepository._();

  /// Returns a list of [FkRelationEmployee]s matching the given query parameters.
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
  Future<List<FkRelationEmployee>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FkRelationEmployeeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FkRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<FkRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    FkRelationEmployeeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FkRelationEmployee>(
      where: where?.call(FkRelationEmployee.t),
      orderBy: orderBy?.call(FkRelationEmployee.t),
      orderByList: orderByList?.call(FkRelationEmployee.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FkRelationEmployee] matching the given query parameters.
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
  Future<FkRelationEmployee?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FkRelationEmployeeTable>? where,
    int? offset,
    _is.OrderByBuilder<FkRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<FkRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    FkRelationEmployeeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FkRelationEmployee>(
      where: where?.call(FkRelationEmployee.t),
      orderBy: orderBy?.call(FkRelationEmployee.t),
      orderByList: orderByList?.call(FkRelationEmployee.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FkRelationEmployee] by its [id] or null if no such row exists.
  Future<FkRelationEmployee?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    FkRelationEmployeeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FkRelationEmployee>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FkRelationEmployee]s in the list and returns the inserted rows.
  ///
  /// The returned [FkRelationEmployee]s will have their `id` fields set.
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
  Future<List<FkRelationEmployee>> insert(
    _is.DatabaseSession session,
    List<FkRelationEmployee> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FkRelationEmployee>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FkRelationEmployee] and returns the inserted row.
  ///
  /// The returned [FkRelationEmployee] will have its `id` field set.
  Future<FkRelationEmployee> insertRow(
    _is.DatabaseSession session,
    FkRelationEmployee row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FkRelationEmployee>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FkRelationEmployee]s in the list and returns the resulting rows.
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
  /// The returned [FkRelationEmployee]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationEmployee>> upsert(
    _is.DatabaseSession session,
    List<FkRelationEmployee> rows, {
    required _is.ColumnSelections<FkRelationEmployeeTable> conflictColumns,
    _is.ColumnSelections<FkRelationEmployeeTable>? updateColumns,
    _is.WhereExpressionBuilder<FkRelationEmployeeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FkRelationEmployee>(
      rows,
      conflictColumns: conflictColumns(FkRelationEmployee.t),
      updateColumns: updateColumns?.call(FkRelationEmployee.t),
      updateWhere: updateWhere?.call(FkRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FkRelationEmployee] and returns the resulting row.
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
  /// The returned [FkRelationEmployee] will have its `id` field set.
  Future<FkRelationEmployee?> upsertRow(
    _is.DatabaseSession session,
    FkRelationEmployee row, {
    required _is.ColumnSelections<FkRelationEmployeeTable> conflictColumns,
    _is.ColumnSelections<FkRelationEmployeeTable>? updateColumns,
    _is.WhereExpressionBuilder<FkRelationEmployeeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FkRelationEmployee>(
      row,
      conflictColumns: conflictColumns(FkRelationEmployee.t),
      updateColumns: updateColumns?.call(FkRelationEmployee.t),
      updateWhere: updateWhere?.call(FkRelationEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates all [FkRelationEmployee]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationEmployee>> update(
    _is.DatabaseSession session,
    List<FkRelationEmployee> rows, {
    _is.ColumnSelections<FkRelationEmployeeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FkRelationEmployee>(
      rows,
      columns: columns?.call(FkRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FkRelationEmployee]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FkRelationEmployee> updateRow(
    _is.DatabaseSession session,
    FkRelationEmployee row, {
    _is.ColumnSelections<FkRelationEmployeeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FkRelationEmployee>(
      row,
      columns: columns?.call(FkRelationEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FkRelationEmployee] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FkRelationEmployee?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FkRelationEmployeeUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FkRelationEmployee>(
      id,
      columnValues: columnValues(FkRelationEmployee.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FkRelationEmployee]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationEmployee>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FkRelationEmployeeUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FkRelationEmployeeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FkRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<FkRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FkRelationEmployee>(
      columnValues: columnValues(FkRelationEmployee.t.updateTable),
      where: where(FkRelationEmployee.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FkRelationEmployee.t),
      orderByList: orderByList?.call(FkRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FkRelationEmployee]s in the list and returns the deleted rows.
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
  Future<List<FkRelationEmployee>> delete(
    _is.DatabaseSession session,
    List<FkRelationEmployee> rows, {
    _is.OrderByBuilder<FkRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<FkRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FkRelationEmployee>(
      rows,
      orderBy: orderBy?.call(FkRelationEmployee.t),
      orderByList: orderByList?.call(FkRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FkRelationEmployee].
  Future<FkRelationEmployee> deleteRow(
    _is.DatabaseSession session,
    FkRelationEmployee row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FkRelationEmployee>(
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
  Future<List<FkRelationEmployee>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FkRelationEmployeeTable> where,
    _is.OrderByBuilder<FkRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<FkRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FkRelationEmployee>(
      where: where(FkRelationEmployee.t),
      orderBy: orderBy?.call(FkRelationEmployee.t),
      orderByList: orderByList?.call(FkRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FkRelationEmployeeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FkRelationEmployee>(
      where: where?.call(FkRelationEmployee.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FkRelationEmployee] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FkRelationEmployeeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FkRelationEmployee>(
      where: where(FkRelationEmployee.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FkRelationEmployeeAttachRowRepository {
  const FkRelationEmployeeAttachRowRepository._();

  /// Creates a relation between the given [FkRelationEmployee] and [FkRelationCompany]
  /// by setting the [FkRelationEmployee]'s foreign key `companyId` to refer to the [FkRelationCompany].
  Future<void> company(
    _is.DatabaseSession session,
    FkRelationEmployee fkRelationEmployee,
    _ikyus01r.FkRelationCompany company, {
    _is.Transaction? transaction,
  }) async {
    if (fkRelationEmployee.id == null) {
      throw ArgumentError.notNull('fkRelationEmployee.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $fkRelationEmployee = fkRelationEmployee.copyWith(
      companyId: company.id,
    );
    await session.db.updateRow<FkRelationEmployee>(
      $fkRelationEmployee,
      columns: [FkRelationEmployee.t.companyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [FkRelationEmployee] and [FkRelationCompany]
  /// by setting the [FkRelationEmployee]'s foreign key `previousCompanyId` to refer to the [FkRelationCompany].
  Future<void> previousCompany(
    _is.DatabaseSession session,
    FkRelationEmployee fkRelationEmployee,
    _ikyus01r.FkRelationCompany previousCompany, {
    _is.Transaction? transaction,
  }) async {
    if (fkRelationEmployee.id == null) {
      throw ArgumentError.notNull('fkRelationEmployee.id');
    }
    if (previousCompany.id == null) {
      throw ArgumentError.notNull('previousCompany.id');
    }

    var $fkRelationEmployee = fkRelationEmployee.copyWith(
      previousCompanyId: previousCompany.id,
    );
    await session.db.updateRow<FkRelationEmployee>(
      $fkRelationEmployee,
      columns: [FkRelationEmployee.t.previousCompanyId],
      transaction: transaction,
    );
  }
}

class FkRelationEmployeeDetachRowRepository {
  const FkRelationEmployeeDetachRowRepository._();

  /// Detaches the relation between this [FkRelationEmployee] and the [FkRelationCompany] set in `previousCompany`
  /// by setting the [FkRelationEmployee]'s foreign key `previousCompanyId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> previousCompany(
    _is.DatabaseSession session,
    FkRelationEmployee fkRelationEmployee, {
    _is.Transaction? transaction,
  }) async {
    if (fkRelationEmployee.id == null) {
      throw ArgumentError.notNull('fkRelationEmployee.id');
    }

    var $fkRelationEmployee = fkRelationEmployee.copyWith(
      previousCompanyId: null,
    );
    await session.db.updateRow<FkRelationEmployee>(
      $fkRelationEmployee,
      columns: [FkRelationEmployee.t.previousCompanyId],
      transaction: transaction,
    );
  }
}

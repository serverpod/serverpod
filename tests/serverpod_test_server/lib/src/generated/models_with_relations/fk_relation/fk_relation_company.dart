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
import '../../models_with_relations/fk_relation/fk_relation_employee.dart'
    as _iweb20ql;
import '../../models_with_relations/fk_relation/fk_relation_office.dart'
    as _iiacif8a;

abstract class FkRelationCompany
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  FkRelationCompany._({
    this.id,
    required this.name,
    this.office,
    this.employees,
  });

  factory FkRelationCompany({
    int? id,
    required String name,
    _iiacif8a.FkRelationOffice? office,
    List<_iweb20ql.FkRelationEmployee>? employees,
  }) = _FkRelationCompanyImpl;

  factory FkRelationCompany.fromJson(Map<String, dynamic> jsonSerialization) {
    return FkRelationCompany(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      office: jsonSerialization['office'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iiacif8a.FkRelationOffice>(
              jsonSerialization['office'],
            ),
      employees: jsonSerialization['employees'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_iweb20ql.FkRelationEmployee>>(
                  jsonSerialization['employees'],
                ),
    );
  }

  static final t = FkRelationCompanyTable();

  static const db = FkRelationCompanyRepository._();

  @override
  int? id;

  String name;

  _iiacif8a.FkRelationOffice? office;

  List<_iweb20ql.FkRelationEmployee>? employees;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [FkRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FkRelationCompany copyWith({
    int? id,
    String? name,
    _iiacif8a.FkRelationOffice? office,
    List<_iweb20ql.FkRelationEmployee>? employees,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FkRelationCompany',
      if (id != null) 'id': id,
      'name': name,
      if (office != null) 'office': office?.toJson(),
      if (employees != null)
        'employees': employees?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FkRelationCompany',
      if (id != null) 'id': id,
      'name': name,
      if (office != null) 'office': office?.toJsonForProtocol(),
      if (employees != null)
        'employees': employees?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static FkRelationCompanyInclude include({
    _iiacif8a.FkRelationOfficeInclude? office,
    _iweb20ql.FkRelationEmployeeIncludeList? employees,
  }) {
    return FkRelationCompanyInclude._(
      office: office,
      employees: employees,
    );
  }

  static FkRelationCompanyIncludeList includeList({
    _is.WhereExpressionBuilder<FkRelationCompanyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FkRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<FkRelationCompanyTable>? orderByList,
    FkRelationCompanyInclude? include,
  }) {
    return FkRelationCompanyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FkRelationCompany.t),
      orderByList: orderByList?.call(FkRelationCompany.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FkRelationCompanyImpl extends FkRelationCompany {
  _FkRelationCompanyImpl({
    int? id,
    required String name,
    _iiacif8a.FkRelationOffice? office,
    List<_iweb20ql.FkRelationEmployee>? employees,
  }) : super._(
         id: id,
         name: name,
         office: office,
         employees: employees,
       );

  /// Returns a shallow copy of this [FkRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FkRelationCompany copyWith({
    Object? id = _Undefined,
    String? name,
    Object? office = _Undefined,
    Object? employees = _Undefined,
  }) {
    return FkRelationCompany(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      office: office is _iiacif8a.FkRelationOffice?
          ? office
          : this.office?.copyWith(),
      employees: employees is List<_iweb20ql.FkRelationEmployee>?
          ? employees
          : this.employees?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class FkRelationCompanyUpdateTable
    extends _is.UpdateTable<FkRelationCompanyTable> {
  FkRelationCompanyUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class FkRelationCompanyTable extends _is.Table<int?> {
  FkRelationCompanyTable({super.tableRelation})
    : super(tableName: 'fk_relation_company') {
    updateTable = FkRelationCompanyUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final FkRelationCompanyUpdateTable updateTable;

  late final _is.ColumnString name;

  _iiacif8a.FkRelationOfficeTable? _office;

  _iweb20ql.FkRelationEmployeeTable? ___employees;

  _is.ManyRelation<_iweb20ql.FkRelationEmployeeTable>? _employees;

  _iiacif8a.FkRelationOfficeTable get office {
    if (_office != null) return _office!;
    _office = _is.createRelationTable(
      relationFieldName: 'office',
      field: FkRelationCompany.t.id,
      foreignField: _iiacif8a.FkRelationOffice.t.companyId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iiacif8a.FkRelationOfficeTable(tableRelation: foreignTableRelation),
    );
    return _office!;
  }

  _iweb20ql.FkRelationEmployeeTable get __employees {
    if (___employees != null) return ___employees!;
    ___employees = _is.createRelationTable(
      relationFieldName: '__employees',
      field: FkRelationCompany.t.id,
      foreignField: _iweb20ql.FkRelationEmployee.t.companyId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _iweb20ql.FkRelationEmployeeTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return ___employees!;
  }

  _is.ManyRelation<_iweb20ql.FkRelationEmployeeTable> get employees {
    if (_employees != null) return _employees!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'employees',
      field: FkRelationCompany.t.id,
      foreignField: _iweb20ql.FkRelationEmployee.t.companyId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _iweb20ql.FkRelationEmployeeTable(
        tableRelation: foreignTableRelation,
      ),
    );
    _employees = _is.ManyRelation<_iweb20ql.FkRelationEmployeeTable>(
      tableWithRelations: relationTable,
      table: _iweb20ql.FkRelationEmployeeTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _employees!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'office') {
      return office;
    }
    if (relationField == 'employees') {
      return __employees;
    }
    return null;
  }
}

class FkRelationCompanyInclude extends _is.IncludeObject {
  FkRelationCompanyInclude._({
    _iiacif8a.FkRelationOfficeInclude? office,
    _iweb20ql.FkRelationEmployeeIncludeList? employees,
  }) {
    _office = office;
    _employees = employees;
  }

  _iiacif8a.FkRelationOfficeInclude? _office;

  _iweb20ql.FkRelationEmployeeIncludeList? _employees;

  @override
  Map<String, _is.Include?> get includes => {
    'office': _office,
    'employees': _employees,
  };

  @override
  _is.Table<int?> get table => FkRelationCompany.t;
}

class FkRelationCompanyIncludeList extends _is.IncludeList {
  FkRelationCompanyIncludeList._({
    _is.WhereExpressionBuilder<FkRelationCompanyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FkRelationCompany.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => FkRelationCompany.t;
}

class FkRelationCompanyRepository {
  const FkRelationCompanyRepository._();

  final attach = const FkRelationCompanyAttachRepository._();

  final attachRow = const FkRelationCompanyAttachRowRepository._();

  /// Returns a list of [FkRelationCompany]s matching the given query parameters.
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
  Future<List<FkRelationCompany>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FkRelationCompanyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FkRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<FkRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    FkRelationCompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FkRelationCompany>(
      where: where?.call(FkRelationCompany.t),
      orderBy: orderBy?.call(FkRelationCompany.t),
      orderByList: orderByList?.call(FkRelationCompany.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FkRelationCompany] matching the given query parameters.
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
  Future<FkRelationCompany?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FkRelationCompanyTable>? where,
    int? offset,
    _is.OrderByBuilder<FkRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<FkRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    FkRelationCompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FkRelationCompany>(
      where: where?.call(FkRelationCompany.t),
      orderBy: orderBy?.call(FkRelationCompany.t),
      orderByList: orderByList?.call(FkRelationCompany.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FkRelationCompany] by its [id] or null if no such row exists.
  Future<FkRelationCompany?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    FkRelationCompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FkRelationCompany>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FkRelationCompany]s in the list and returns the inserted rows.
  ///
  /// The returned [FkRelationCompany]s will have their `id` fields set.
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
  Future<List<FkRelationCompany>> insert(
    _is.DatabaseSession session,
    List<FkRelationCompany> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FkRelationCompany>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FkRelationCompany] and returns the inserted row.
  ///
  /// The returned [FkRelationCompany] will have its `id` field set.
  Future<FkRelationCompany> insertRow(
    _is.DatabaseSession session,
    FkRelationCompany row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<FkRelationCompany>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FkRelationCompany]s in the list and returns the resulting rows.
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
  /// The returned [FkRelationCompany]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationCompany>> upsert(
    _is.DatabaseSession session,
    List<FkRelationCompany> rows, {
    required _is.ColumnSelections<FkRelationCompanyTable> conflictColumns,
    _is.ColumnSelections<FkRelationCompanyTable>? updateColumns,
    _is.WhereExpressionBuilder<FkRelationCompanyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FkRelationCompany>(
      rows,
      conflictColumns: conflictColumns(FkRelationCompany.t),
      updateColumns: updateColumns?.call(FkRelationCompany.t),
      updateWhere: updateWhere?.call(FkRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FkRelationCompany] and returns the resulting row.
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
  /// The returned [FkRelationCompany] will have its `id` field set.
  Future<FkRelationCompany?> upsertRow(
    _is.DatabaseSession session,
    FkRelationCompany row, {
    required _is.ColumnSelections<FkRelationCompanyTable> conflictColumns,
    _is.ColumnSelections<FkRelationCompanyTable>? updateColumns,
    _is.WhereExpressionBuilder<FkRelationCompanyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FkRelationCompany>(
      row,
      conflictColumns: conflictColumns(FkRelationCompany.t),
      updateColumns: updateColumns?.call(FkRelationCompany.t),
      updateWhere: updateWhere?.call(FkRelationCompany.t),
      transaction: transaction,
    );
  }

  /// Updates all [FkRelationCompany]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationCompany>> update(
    _is.DatabaseSession session,
    List<FkRelationCompany> rows, {
    _is.ColumnSelections<FkRelationCompanyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FkRelationCompany>(
      rows,
      columns: columns?.call(FkRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FkRelationCompany]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FkRelationCompany> updateRow(
    _is.DatabaseSession session,
    FkRelationCompany row, {
    _is.ColumnSelections<FkRelationCompanyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<FkRelationCompany>(
      row,
      columns: columns?.call(FkRelationCompany.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FkRelationCompany] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FkRelationCompany?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<FkRelationCompanyUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<FkRelationCompany>(
      id,
      columnValues: columnValues(FkRelationCompany.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FkRelationCompany]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationCompany>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<FkRelationCompanyUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<FkRelationCompanyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<FkRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<FkRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FkRelationCompany>(
      columnValues: columnValues(FkRelationCompany.t.updateTable),
      where: where(FkRelationCompany.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FkRelationCompany.t),
      orderByList: orderByList?.call(FkRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FkRelationCompany]s in the list and returns the deleted rows.
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
  Future<List<FkRelationCompany>> delete(
    _is.DatabaseSession session,
    List<FkRelationCompany> rows, {
    _is.OrderByBuilder<FkRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<FkRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FkRelationCompany>(
      rows,
      orderBy: orderBy?.call(FkRelationCompany.t),
      orderByList: orderByList?.call(FkRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FkRelationCompany].
  Future<FkRelationCompany> deleteRow(
    _is.DatabaseSession session,
    FkRelationCompany row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FkRelationCompany>(
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
  Future<List<FkRelationCompany>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FkRelationCompanyTable> where,
    _is.OrderByBuilder<FkRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<FkRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FkRelationCompany>(
      where: where(FkRelationCompany.t),
      orderBy: orderBy?.call(FkRelationCompany.t),
      orderByList: orderByList?.call(FkRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<FkRelationCompanyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<FkRelationCompany>(
      where: where?.call(FkRelationCompany.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FkRelationCompany] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<FkRelationCompanyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FkRelationCompany>(
      where: where(FkRelationCompany.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FkRelationCompanyAttachRepository {
  const FkRelationCompanyAttachRepository._();

  /// Creates a relation between this [FkRelationCompany] and the given [FkRelationEmployee]s
  /// by setting each [FkRelationEmployee]'s foreign key `companyId` to refer to this [FkRelationCompany].
  Future<void> employees(
    _is.DatabaseSession session,
    FkRelationCompany fkRelationCompany,
    List<_iweb20ql.FkRelationEmployee> fkRelationEmployee, {
    _is.Transaction? transaction,
  }) async {
    if (fkRelationEmployee.any((e) => e.id == null)) {
      throw ArgumentError.notNull('fkRelationEmployee.id');
    }
    if (fkRelationCompany.id == null) {
      throw ArgumentError.notNull('fkRelationCompany.id');
    }

    var $fkRelationEmployee = fkRelationEmployee
        .map((e) => e.copyWith(companyId: fkRelationCompany.id))
        .toList();
    await session.db.update<_iweb20ql.FkRelationEmployee>(
      $fkRelationEmployee,
      columns: [_iweb20ql.FkRelationEmployee.t.companyId],
      transaction: transaction,
    );
  }
}

class FkRelationCompanyAttachRowRepository {
  const FkRelationCompanyAttachRowRepository._();

  /// Creates a relation between the given [FkRelationCompany] and [FkRelationOffice]
  /// by setting the [FkRelationCompany]'s foreign key `id` to refer to the [FkRelationOffice].
  Future<void> office(
    _is.DatabaseSession session,
    FkRelationCompany fkRelationCompany,
    _iiacif8a.FkRelationOffice office, {
    _is.Transaction? transaction,
  }) async {
    if (office.id == null) {
      throw ArgumentError.notNull('office.id');
    }
    if (fkRelationCompany.id == null) {
      throw ArgumentError.notNull('fkRelationCompany.id');
    }

    var $office = office.copyWith(companyId: fkRelationCompany.id);
    await session.db.updateRow<_iiacif8a.FkRelationOffice>(
      $office,
      columns: [_iiacif8a.FkRelationOffice.t.companyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [FkRelationCompany] and the given [FkRelationEmployee]
  /// by setting the [FkRelationEmployee]'s foreign key `companyId` to refer to this [FkRelationCompany].
  Future<void> employees(
    _is.DatabaseSession session,
    FkRelationCompany fkRelationCompany,
    _iweb20ql.FkRelationEmployee fkRelationEmployee, {
    _is.Transaction? transaction,
  }) async {
    if (fkRelationEmployee.id == null) {
      throw ArgumentError.notNull('fkRelationEmployee.id');
    }
    if (fkRelationCompany.id == null) {
      throw ArgumentError.notNull('fkRelationCompany.id');
    }

    var $fkRelationEmployee = fkRelationEmployee.copyWith(
      companyId: fkRelationCompany.id,
    );
    await session.db.updateRow<_iweb20ql.FkRelationEmployee>(
      $fkRelationEmployee,
      columns: [_iweb20ql.FkRelationEmployee.t.companyId],
      transaction: transaction,
    );
  }
}

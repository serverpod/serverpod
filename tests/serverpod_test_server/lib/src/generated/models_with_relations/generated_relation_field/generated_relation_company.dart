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
import '../../models_with_relations/generated_relation_field/generated_relation_employee.dart'
    as _inw8ul07;
import '../../models_with_relations/generated_relation_field/generated_relation_office.dart'
    as _im57bsix;

abstract class GeneratedRelationCompany
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  GeneratedRelationCompany._({
    this.id,
    required this.name,
    this.office,
    this.employees,
  });

  factory GeneratedRelationCompany({
    int? id,
    required String name,
    _im57bsix.GeneratedRelationOffice? office,
    List<_inw8ul07.GeneratedRelationEmployee>? employees,
  }) = _GeneratedRelationCompanyImpl;

  factory GeneratedRelationCompany.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GeneratedRelationCompany(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      office: jsonSerialization['office'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_im57bsix.GeneratedRelationOffice>(
              jsonSerialization['office'],
            ),
      employees: jsonSerialization['employees'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_inw8ul07.GeneratedRelationEmployee>>(
                  jsonSerialization['employees'],
                ),
    );
  }

  static final t = GeneratedRelationCompanyTable();

  static const db = GeneratedRelationCompanyRepository._();

  @override
  int? id;

  String name;

  _im57bsix.GeneratedRelationOffice? office;

  List<_inw8ul07.GeneratedRelationEmployee>? employees;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [GeneratedRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GeneratedRelationCompany copyWith({
    int? id,
    String? name,
    _im57bsix.GeneratedRelationOffice? office,
    List<_inw8ul07.GeneratedRelationEmployee>? employees,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeneratedRelationCompany',
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
      '__className__': 'GeneratedRelationCompany',
      if (id != null) 'id': id,
      'name': name,
      if (office != null) 'office': office?.toJsonForProtocol(),
      if (employees != null)
        'employees': employees?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static GeneratedRelationCompanyInclude include({
    _im57bsix.GeneratedRelationOfficeInclude? office,
    _inw8ul07.GeneratedRelationEmployeeIncludeList? employees,
  }) {
    return GeneratedRelationCompanyInclude._(
      office: office,
      employees: employees,
    );
  }

  static GeneratedRelationCompanyIncludeList includeList({
    _is.WhereExpressionBuilder<GeneratedRelationCompanyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationCompanyTable>? orderByList,
    GeneratedRelationCompanyInclude? include,
  }) {
    return GeneratedRelationCompanyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedRelationCompany.t),
      orderByList: orderByList?.call(GeneratedRelationCompany.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeneratedRelationCompanyImpl extends GeneratedRelationCompany {
  _GeneratedRelationCompanyImpl({
    int? id,
    required String name,
    _im57bsix.GeneratedRelationOffice? office,
    List<_inw8ul07.GeneratedRelationEmployee>? employees,
  }) : super._(
         id: id,
         name: name,
         office: office,
         employees: employees,
       );

  /// Returns a shallow copy of this [GeneratedRelationCompany]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GeneratedRelationCompany copyWith({
    Object? id = _Undefined,
    String? name,
    Object? office = _Undefined,
    Object? employees = _Undefined,
  }) {
    return GeneratedRelationCompany(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      office: office is _im57bsix.GeneratedRelationOffice?
          ? office
          : this.office?.copyWith(),
      employees: employees is List<_inw8ul07.GeneratedRelationEmployee>?
          ? employees
          : this.employees?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class GeneratedRelationCompanyUpdateTable
    extends _is.UpdateTable<GeneratedRelationCompanyTable> {
  GeneratedRelationCompanyUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class GeneratedRelationCompanyTable extends _is.Table<int?> {
  GeneratedRelationCompanyTable({super.tableRelation})
    : super(tableName: 'generated_relation_company') {
    updateTable = GeneratedRelationCompanyUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final GeneratedRelationCompanyUpdateTable updateTable;

  late final _is.ColumnString name;

  _im57bsix.GeneratedRelationOfficeTable? _office;

  _inw8ul07.GeneratedRelationEmployeeTable? ___employees;

  _is.ManyRelation<_inw8ul07.GeneratedRelationEmployeeTable>? _employees;

  _im57bsix.GeneratedRelationOfficeTable get office {
    if (_office != null) return _office!;
    _office = _is.createRelationTable(
      relationFieldName: 'office',
      field: GeneratedRelationCompany.t.id,
      foreignField: _im57bsix.GeneratedRelationOffice.t.customCompanyId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _im57bsix.GeneratedRelationOfficeTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return _office!;
  }

  _inw8ul07.GeneratedRelationEmployeeTable get __employees {
    if (___employees != null) return ___employees!;
    ___employees = _is.createRelationTable(
      relationFieldName: '__employees',
      field: GeneratedRelationCompany.t.id,
      foreignField: _inw8ul07.GeneratedRelationEmployee.t.customCompanyId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _inw8ul07.GeneratedRelationEmployeeTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___employees!;
  }

  _is.ManyRelation<_inw8ul07.GeneratedRelationEmployeeTable> get employees {
    if (_employees != null) return _employees!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'employees',
      field: GeneratedRelationCompany.t.id,
      foreignField: _inw8ul07.GeneratedRelationEmployee.t.customCompanyId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _inw8ul07.GeneratedRelationEmployeeTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _employees = _is.ManyRelation<_inw8ul07.GeneratedRelationEmployeeTable>(
      tableWithRelations: relationTable,
      table: _inw8ul07.GeneratedRelationEmployeeTable(
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

class GeneratedRelationCompanyInclude extends _is.IncludeObject {
  GeneratedRelationCompanyInclude._({
    _im57bsix.GeneratedRelationOfficeInclude? office,
    _inw8ul07.GeneratedRelationEmployeeIncludeList? employees,
  }) {
    _office = office;
    _employees = employees;
  }

  _im57bsix.GeneratedRelationOfficeInclude? _office;

  _inw8ul07.GeneratedRelationEmployeeIncludeList? _employees;

  @override
  Map<String, _is.Include?> get includes => {
    'office': _office,
    'employees': _employees,
  };

  @override
  _is.Table<int?> get table => GeneratedRelationCompany.t;
}

class GeneratedRelationCompanyIncludeList extends _is.IncludeList {
  GeneratedRelationCompanyIncludeList._({
    _is.WhereExpressionBuilder<GeneratedRelationCompanyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GeneratedRelationCompany.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => GeneratedRelationCompany.t;
}

class GeneratedRelationCompanyRepository {
  const GeneratedRelationCompanyRepository._();

  final attach = const GeneratedRelationCompanyAttachRepository._();

  final attachRow = const GeneratedRelationCompanyAttachRowRepository._();

  final detachRow = const GeneratedRelationCompanyDetachRowRepository._();

  /// Returns a list of [GeneratedRelationCompany]s matching the given query parameters.
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
  Future<List<GeneratedRelationCompany>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GeneratedRelationCompanyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    GeneratedRelationCompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GeneratedRelationCompany>(
      where: where?.call(GeneratedRelationCompany.t),
      orderBy: orderBy?.call(GeneratedRelationCompany.t),
      orderByList: orderByList?.call(GeneratedRelationCompany.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GeneratedRelationCompany] matching the given query parameters.
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
  Future<GeneratedRelationCompany?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GeneratedRelationCompanyTable>? where,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    GeneratedRelationCompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GeneratedRelationCompany>(
      where: where?.call(GeneratedRelationCompany.t),
      orderBy: orderBy?.call(GeneratedRelationCompany.t),
      orderByList: orderByList?.call(GeneratedRelationCompany.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GeneratedRelationCompany] by its [id] or null if no such row exists.
  Future<GeneratedRelationCompany?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    GeneratedRelationCompanyInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GeneratedRelationCompany>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GeneratedRelationCompany]s in the list and returns the inserted rows.
  ///
  /// The returned [GeneratedRelationCompany]s will have their `id` fields set.
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
  Future<List<GeneratedRelationCompany>> insert(
    _is.DatabaseSession session,
    List<GeneratedRelationCompany> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<GeneratedRelationCompany>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [GeneratedRelationCompany] and returns the inserted row.
  ///
  /// The returned [GeneratedRelationCompany] will have its `id` field set.
  Future<GeneratedRelationCompany> insertRow(
    _is.DatabaseSession session,
    GeneratedRelationCompany row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<GeneratedRelationCompany>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [GeneratedRelationCompany]s in the list and returns the resulting rows.
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
  /// The returned [GeneratedRelationCompany]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationCompany>> upsert(
    _is.DatabaseSession session,
    List<GeneratedRelationCompany> rows, {
    required _is.ColumnSelections<GeneratedRelationCompanyTable>
    conflictColumns,
    _is.ColumnSelections<GeneratedRelationCompanyTable>? updateColumns,
    _is.WhereExpressionBuilder<GeneratedRelationCompanyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<GeneratedRelationCompany>(
      rows,
      conflictColumns: conflictColumns(GeneratedRelationCompany.t),
      updateColumns: updateColumns?.call(GeneratedRelationCompany.t),
      updateWhere: updateWhere?.call(GeneratedRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [GeneratedRelationCompany] and returns the resulting row.
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
  /// The returned [GeneratedRelationCompany] will have its `id` field set.
  Future<GeneratedRelationCompany?> upsertRow(
    _is.DatabaseSession session,
    GeneratedRelationCompany row, {
    required _is.ColumnSelections<GeneratedRelationCompanyTable>
    conflictColumns,
    _is.ColumnSelections<GeneratedRelationCompanyTable>? updateColumns,
    _is.WhereExpressionBuilder<GeneratedRelationCompanyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<GeneratedRelationCompany>(
      row,
      conflictColumns: conflictColumns(GeneratedRelationCompany.t),
      updateColumns: updateColumns?.call(GeneratedRelationCompany.t),
      updateWhere: updateWhere?.call(GeneratedRelationCompany.t),
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedRelationCompany]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationCompany>> update(
    _is.DatabaseSession session,
    List<GeneratedRelationCompany> rows, {
    _is.ColumnSelections<GeneratedRelationCompanyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<GeneratedRelationCompany>(
      rows,
      columns: columns?.call(GeneratedRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [GeneratedRelationCompany]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GeneratedRelationCompany> updateRow(
    _is.DatabaseSession session,
    GeneratedRelationCompany row, {
    _is.ColumnSelections<GeneratedRelationCompanyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<GeneratedRelationCompany>(
      row,
      columns: columns?.call(GeneratedRelationCompany.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GeneratedRelationCompany] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GeneratedRelationCompany?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<GeneratedRelationCompanyUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<GeneratedRelationCompany>(
      id,
      columnValues: columnValues(GeneratedRelationCompany.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedRelationCompany]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationCompany>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<GeneratedRelationCompanyUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<GeneratedRelationCompanyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<GeneratedRelationCompany>(
      columnValues: columnValues(GeneratedRelationCompany.t.updateTable),
      where: where(GeneratedRelationCompany.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedRelationCompany.t),
      orderByList: orderByList?.call(GeneratedRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [GeneratedRelationCompany]s in the list and returns the deleted rows.
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
  Future<List<GeneratedRelationCompany>> delete(
    _is.DatabaseSession session,
    List<GeneratedRelationCompany> rows, {
    _is.OrderByBuilder<GeneratedRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<GeneratedRelationCompany>(
      rows,
      orderBy: orderBy?.call(GeneratedRelationCompany.t),
      orderByList: orderByList?.call(GeneratedRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [GeneratedRelationCompany].
  Future<GeneratedRelationCompany> deleteRow(
    _is.DatabaseSession session,
    GeneratedRelationCompany row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GeneratedRelationCompany>(
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
  Future<List<GeneratedRelationCompany>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GeneratedRelationCompanyTable> where,
    _is.OrderByBuilder<GeneratedRelationCompanyTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationCompanyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<GeneratedRelationCompany>(
      where: where(GeneratedRelationCompany.t),
      orderBy: orderBy?.call(GeneratedRelationCompany.t),
      orderByList: orderByList?.call(GeneratedRelationCompany.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GeneratedRelationCompanyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<GeneratedRelationCompany>(
      where: where?.call(GeneratedRelationCompany.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GeneratedRelationCompany] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GeneratedRelationCompanyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GeneratedRelationCompany>(
      where: where(GeneratedRelationCompany.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class GeneratedRelationCompanyAttachRepository {
  const GeneratedRelationCompanyAttachRepository._();

  /// Creates a relation between this [GeneratedRelationCompany] and the given [GeneratedRelationEmployee]s
  /// by setting each [GeneratedRelationEmployee]'s foreign key `customCompanyId` to refer to this [GeneratedRelationCompany].
  Future<void> employees(
    _is.DatabaseSession session,
    GeneratedRelationCompany generatedRelationCompany,
    List<_inw8ul07.GeneratedRelationEmployee> generatedRelationEmployee, {
    _is.Transaction? transaction,
  }) async {
    if (generatedRelationEmployee.any((e) => e.id == null)) {
      throw ArgumentError.notNull('generatedRelationEmployee.id');
    }
    if (generatedRelationCompany.id == null) {
      throw ArgumentError.notNull('generatedRelationCompany.id');
    }

    var $generatedRelationEmployee = generatedRelationEmployee
        .map((e) => e.copyWith(customCompanyId: generatedRelationCompany.id))
        .toList();
    await session.db.update<_inw8ul07.GeneratedRelationEmployee>(
      $generatedRelationEmployee,
      columns: [_inw8ul07.GeneratedRelationEmployee.t.customCompanyId],
      transaction: transaction,
    );
  }
}

class GeneratedRelationCompanyAttachRowRepository {
  const GeneratedRelationCompanyAttachRowRepository._();

  /// Creates a relation between the given [GeneratedRelationCompany] and [GeneratedRelationOffice]
  /// by setting the [GeneratedRelationCompany]'s foreign key `id` to refer to the [GeneratedRelationOffice].
  Future<void> office(
    _is.DatabaseSession session,
    GeneratedRelationCompany generatedRelationCompany,
    _im57bsix.GeneratedRelationOffice office, {
    _is.Transaction? transaction,
  }) async {
    if (office.id == null) {
      throw ArgumentError.notNull('office.id');
    }
    if (generatedRelationCompany.id == null) {
      throw ArgumentError.notNull('generatedRelationCompany.id');
    }

    var $office = office.copyWith(customCompanyId: generatedRelationCompany.id);
    await session.db.updateRow<_im57bsix.GeneratedRelationOffice>(
      $office,
      columns: [_im57bsix.GeneratedRelationOffice.t.customCompanyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [GeneratedRelationCompany] and the given [GeneratedRelationEmployee]
  /// by setting the [GeneratedRelationEmployee]'s foreign key `customCompanyId` to refer to this [GeneratedRelationCompany].
  Future<void> employees(
    _is.DatabaseSession session,
    GeneratedRelationCompany generatedRelationCompany,
    _inw8ul07.GeneratedRelationEmployee generatedRelationEmployee, {
    _is.Transaction? transaction,
  }) async {
    if (generatedRelationEmployee.id == null) {
      throw ArgumentError.notNull('generatedRelationEmployee.id');
    }
    if (generatedRelationCompany.id == null) {
      throw ArgumentError.notNull('generatedRelationCompany.id');
    }

    var $generatedRelationEmployee = generatedRelationEmployee.copyWith(
      customCompanyId: generatedRelationCompany.id,
    );
    await session.db.updateRow<_inw8ul07.GeneratedRelationEmployee>(
      $generatedRelationEmployee,
      columns: [_inw8ul07.GeneratedRelationEmployee.t.customCompanyId],
      transaction: transaction,
    );
  }
}

class GeneratedRelationCompanyDetachRowRepository {
  const GeneratedRelationCompanyDetachRowRepository._();

  /// Detaches the relation between this [GeneratedRelationCompany] and the [GeneratedRelationOffice] set in `office`
  /// by setting the [GeneratedRelationCompany]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> office(
    _is.DatabaseSession session,
    GeneratedRelationCompany generatedRelationCompany, {
    _is.Transaction? transaction,
  }) async {
    var $office = generatedRelationCompany.office;

    if ($office == null) {
      throw ArgumentError.notNull('generatedRelationCompany.office');
    }
    if ($office.id == null) {
      throw ArgumentError.notNull('generatedRelationCompany.office.id');
    }
    if (generatedRelationCompany.id == null) {
      throw ArgumentError.notNull('generatedRelationCompany.id');
    }

    var $$office = $office.copyWith(customCompanyId: null);
    await session.db.updateRow<_im57bsix.GeneratedRelationOffice>(
      $$office,
      columns: [_im57bsix.GeneratedRelationOffice.t.customCompanyId],
      transaction: transaction,
    );
  }
}

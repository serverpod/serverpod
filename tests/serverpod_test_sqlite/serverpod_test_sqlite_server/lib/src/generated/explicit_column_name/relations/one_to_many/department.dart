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
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import '../../../explicit_column_name/relations/one_to_many/employee.dart'
    as _ilvmgye0;

abstract class Department
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Department._({
    this.id,
    required this.name,
    this.employees,
  });

  factory Department({
    int? id,
    required String name,
    List<_ilvmgye0.Employee>? employees,
  }) = _DepartmentImpl;

  factory Department.fromJson(Map<String, dynamic> jsonSerialization) {
    return Department(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      employees: jsonSerialization['employees'] == null
          ? null
          : _i08l111i.Protocol().deserialize<List<_ilvmgye0.Employee>>(
              jsonSerialization['employees'],
            ),
    );
  }

  static final t = DepartmentTable();

  static const db = DepartmentRepository._();

  @override
  int? id;

  String name;

  List<_ilvmgye0.Employee>? employees;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Department]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Department copyWith({
    int? id,
    String? name,
    List<_ilvmgye0.Employee>? employees,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Department',
      if (id != null) 'id': id,
      'name': name,
      if (employees != null)
        'employees': employees?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Department',
      if (id != null) 'id': id,
      'name': name,
      if (employees != null)
        'employees': employees?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  /// Builds a complete [DepartmentInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DepartmentInclude include({_ilvmgye0.EmployeeIncludeList? employees}) {
    return DepartmentInclude._(employees: employees);
  }

  /// Builds a complete [DepartmentIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static DepartmentIncludeList includeList({
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    DepartmentInclude? include,
  }) {
    return DepartmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [DepartmentJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static DepartmentJsonInclude includeJson({
    _ilvmgye0.EmployeeJsonIncludeList? employees,
    _is.SelectColumnsBuilder<DepartmentTable>? select,
  }) {
    return _DepartmentJsonInclude._(
      employees: employees,
      selectedColumns: select?.call(Department.t),
    );
  }

  /// Builds a JSON-compatible [DepartmentJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static DepartmentJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    DepartmentJsonInclude? include,
    _is.SelectColumnsBuilder<DepartmentTable>? select,
  }) {
    return _DepartmentJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      include: include,
      selectedColumns: select?.call(Department.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepartmentImpl extends Department {
  _DepartmentImpl({
    int? id,
    required String name,
    List<_ilvmgye0.Employee>? employees,
  }) : super._(
         id: id,
         name: name,
         employees: employees,
       );

  /// Returns a shallow copy of this [Department]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Department copyWith({
    Object? id = _Undefined,
    String? name,
    Object? employees = _Undefined,
  }) {
    return Department(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      employees: employees is List<_ilvmgye0.Employee>?
          ? employees
          : this.employees?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class DepartmentUpdateTable extends _is.UpdateTable<DepartmentTable> {
  DepartmentUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class DepartmentTable extends _is.Table<int?> {
  DepartmentTable({super.tableRelation}) : super(tableName: 'department') {
    updateTable = DepartmentUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final DepartmentUpdateTable updateTable;

  late final _is.ColumnString name;

  _ilvmgye0.EmployeeTable? ___employees;

  _is.ManyRelation<_ilvmgye0.EmployeeTable>? _employees;

  _ilvmgye0.EmployeeTable get __employees {
    if (___employees != null) return ___employees!;
    ___employees = _is.createRelationTable(
      relationFieldName: '__employees',
      field: Department.t.id,
      foreignField: _ilvmgye0.Employee.t.departmentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ilvmgye0.EmployeeTable(tableRelation: foreignTableRelation),
    );
    return ___employees!;
  }

  _is.ManyRelation<_ilvmgye0.EmployeeTable> get employees {
    if (_employees != null) return _employees!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'employees',
      field: Department.t.id,
      foreignField: _ilvmgye0.Employee.t.departmentId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ilvmgye0.EmployeeTable(tableRelation: foreignTableRelation),
    );
    _employees = _is.ManyRelation<_ilvmgye0.EmployeeTable>(
      tableWithRelations: relationTable,
      table: _ilvmgye0.EmployeeTable(
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
    if (relationField == 'employees') {
      return __employees;
    }
    return null;
  }
}

abstract interface class DepartmentJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class DepartmentJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class DepartmentInclude extends _is.IncludeObject
    implements DepartmentJsonInclude, _is.FullModelInclude {
  DepartmentInclude._({_ilvmgye0.EmployeeIncludeList? employees}) {
    _employees = employees;
  }

  _ilvmgye0.EmployeeIncludeList? _employees;

  @override
  Map<String, _is.Include?> get includes => {'employees': _employees};

  @override
  _is.Table<int?> get table => Department.t;
}

final class DepartmentIncludeList extends _is.IncludeList
    implements DepartmentJsonIncludeList, _is.FullModelInclude {
  DepartmentIncludeList._({
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DepartmentInclude? super.include,
  }) {
    super.where = where?.call(Department.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Department.t;
}

final class _DepartmentJsonInclude extends _is.IncludeObject
    implements DepartmentJsonInclude {
  _DepartmentJsonInclude._({
    _ilvmgye0.EmployeeJsonIncludeList? employees,
    this.selectedColumns,
  }) {
    _employees = employees;
  }

  _ilvmgye0.EmployeeJsonIncludeList? _employees;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'employees': _employees};

  @override
  _is.Table<int?> get table => Department.t;
}

final class _DepartmentJsonIncludeList extends _is.IncludeList
    implements DepartmentJsonIncludeList {
  _DepartmentJsonIncludeList._({
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    DepartmentJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Department.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Department.t;
}

class DepartmentRepository {
  const DepartmentRepository._();

  final attach = const DepartmentAttachRepository._();

  final attachRow = const DepartmentAttachRowRepository._();

  /// Returns a list of [Department]s matching the given query parameters.
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
  Future<List<Department>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    _is.Transaction? transaction,
    DepartmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Department>(
      where: where?.call(Department.t),
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Department] matching the given query parameters.
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
  Future<Department?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    int? offset,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    _is.Transaction? transaction,
    DepartmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Department>(
      where: where?.call(Department.t),
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Department] by its [id] or null if no such row exists.
  Future<Department?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    DepartmentInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Department>(
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
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    _is.Transaction? transaction,
    DepartmentJsonInclude? include,
    _is.SelectColumnsBuilder<DepartmentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Department>(
      where: where?.call(Department.t),
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Department.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    int? offset,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    _is.Transaction? transaction,
    DepartmentJsonInclude? include,
    _is.SelectColumnsBuilder<DepartmentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Department>(
      where: where?.call(Department.t),
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Department.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    DepartmentJsonInclude? include,
    _is.SelectColumnsBuilder<DepartmentTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Department>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Department.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Department]s in the list and returns the inserted rows.
  ///
  /// The returned [Department]s will have their `id` fields set.
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
  Future<List<Department>> insert(
    _is.DatabaseSession session,
    List<Department> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Department>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Department] and returns the inserted row.
  ///
  /// The returned [Department] will have its `id` field set.
  Future<Department> insertRow(
    _is.DatabaseSession session,
    Department row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Department>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Department]s in the list and returns the resulting rows.
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
  /// The returned [Department]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Department>> upsert(
    _is.DatabaseSession session,
    List<Department> rows, {
    required _is.ColumnSelections<DepartmentTable> conflictColumns,
    _is.ColumnSelections<DepartmentTable>? updateColumns,
    _is.WhereExpressionBuilder<DepartmentTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Department>(
      rows,
      conflictColumns: conflictColumns(Department.t),
      updateColumns: updateColumns?.call(Department.t),
      updateWhere: updateWhere?.call(Department.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Department] and returns the resulting row.
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
  /// The returned [Department] will have its `id` field set.
  Future<Department?> upsertRow(
    _is.DatabaseSession session,
    Department row, {
    required _is.ColumnSelections<DepartmentTable> conflictColumns,
    _is.ColumnSelections<DepartmentTable>? updateColumns,
    _is.WhereExpressionBuilder<DepartmentTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Department>(
      row,
      conflictColumns: conflictColumns(Department.t),
      updateColumns: updateColumns?.call(Department.t),
      updateWhere: updateWhere?.call(Department.t),
      transaction: transaction,
    );
  }

  /// Updates all [Department]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Department>> update(
    _is.DatabaseSession session,
    List<Department> rows, {
    _is.ColumnSelections<DepartmentTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Department>(
      rows,
      columns: columns?.call(Department.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Department]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Department> updateRow(
    _is.DatabaseSession session,
    Department row, {
    _is.ColumnSelections<DepartmentTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Department>(
      row,
      columns: columns?.call(Department.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Department] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Department?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DepartmentUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Department>(
      id,
      columnValues: columnValues(Department.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Department]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Department>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DepartmentUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DepartmentTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Department>(
      columnValues: columnValues(Department.t.updateTable),
      where: where(Department.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Department]s in the list and returns the deleted rows.
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
  Future<List<Department>> delete(
    _is.DatabaseSession session,
    List<Department> rows, {
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Department>(
      rows,
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Department].
  Future<Department> deleteRow(
    _is.DatabaseSession session,
    Department row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Department>(
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
  Future<List<Department>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DepartmentTable> where,
    _is.OrderByBuilder<DepartmentTable>? orderBy,
    _is.OrderByListBuilder<DepartmentTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Department>(
      where: where(Department.t),
      orderBy: orderBy?.call(Department.t),
      orderByList: orderByList?.call(Department.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DepartmentTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Department>(
      where: where?.call(Department.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Department] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DepartmentTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Department>(
      where: where(Department.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class DepartmentAttachRepository {
  const DepartmentAttachRepository._();

  /// Creates a relation between this [Department] and the given [Employee]s
  /// by setting each [Employee]'s foreign key `departmentId` to refer to this [Department].
  Future<void> employees(
    _is.DatabaseSession session,
    Department department,
    List<_ilvmgye0.Employee> employee, {
    _is.Transaction? transaction,
  }) async {
    if (employee.any((e) => e.id == null)) {
      throw ArgumentError.notNull('employee.id');
    }
    if (department.id == null) {
      throw ArgumentError.notNull('department.id');
    }

    var $employee = employee
        .map((e) => e.copyWith(departmentId: department.id))
        .toList();
    await session.db.update<_ilvmgye0.Employee>(
      $employee,
      columns: [_ilvmgye0.Employee.t.departmentId],
      transaction: transaction,
    );
  }
}

class DepartmentAttachRowRepository {
  const DepartmentAttachRowRepository._();

  /// Creates a relation between this [Department] and the given [Employee]
  /// by setting the [Employee]'s foreign key `departmentId` to refer to this [Department].
  Future<void> employees(
    _is.DatabaseSession session,
    Department department,
    _ilvmgye0.Employee employee, {
    _is.Transaction? transaction,
  }) async {
    if (employee.id == null) {
      throw ArgumentError.notNull('employee.id');
    }
    if (department.id == null) {
      throw ArgumentError.notNull('department.id');
    }

    var $employee = employee.copyWith(departmentId: department.id);
    await session.db.updateRow<_ilvmgye0.Employee>(
      $employee,
      columns: [_ilvmgye0.Employee.t.departmentId],
      transaction: transaction,
    );
  }
}

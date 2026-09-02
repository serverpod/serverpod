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
import '../../models_with_relations/generated_relation_field/generated_relation_company.dart'
    as _ipeijyfj;

abstract class GeneratedRelationEmployee
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  GeneratedRelationEmployee._({
    this.id,
    required this.name,
    required this.customCompanyId,
    this.company,
    this.customPreviousCompanyId,
    this.previousCompany,
  });

  factory GeneratedRelationEmployee({
    int? id,
    required String name,
    required int customCompanyId,
    _ipeijyfj.GeneratedRelationCompany? company,
    int? customPreviousCompanyId,
    _ipeijyfj.GeneratedRelationCompany? previousCompany,
  }) = _GeneratedRelationEmployeeImpl;

  factory GeneratedRelationEmployee.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GeneratedRelationEmployee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      customCompanyId: jsonSerialization['customCompanyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<_ipeijyfj.GeneratedRelationCompany>(
                  jsonSerialization['company'],
                ),
      customPreviousCompanyId:
          jsonSerialization['customPreviousCompanyId'] as int?,
      previousCompany: jsonSerialization['previousCompany'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<_ipeijyfj.GeneratedRelationCompany>(
                  jsonSerialization['previousCompany'],
                ),
    );
  }

  static final t = GeneratedRelationEmployeeTable();

  static const db = GeneratedRelationEmployeeRepository._();

  @override
  int? id;

  String name;

  /// The foreign key of the [company] relation.
  int customCompanyId;

  _ipeijyfj.GeneratedRelationCompany? company;

  /// The foreign key of the [previousCompany] relation.
  int? customPreviousCompanyId;

  _ipeijyfj.GeneratedRelationCompany? previousCompany;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [GeneratedRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  GeneratedRelationEmployee copyWith({
    int? id,
    String? name,
    int? customCompanyId,
    _ipeijyfj.GeneratedRelationCompany? company,
    int? customPreviousCompanyId,
    _ipeijyfj.GeneratedRelationCompany? previousCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeneratedRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJson(),
      if (customPreviousCompanyId != null)
        'customPreviousCompanyId': customPreviousCompanyId,
      if (previousCompany != null) 'previousCompany': previousCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GeneratedRelationEmployee',
      if (id != null) 'id': id,
      'name': name,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (customPreviousCompanyId != null)
        'customPreviousCompanyId': customPreviousCompanyId,
      if (previousCompany != null)
        'previousCompany': previousCompany?.toJsonForProtocol(),
    };
  }

  static GeneratedRelationEmployeeInclude include({
    _ipeijyfj.GeneratedRelationCompanyInclude? company,
    _ipeijyfj.GeneratedRelationCompanyInclude? previousCompany,
  }) {
    return GeneratedRelationEmployeeInclude._(
      company: company,
      previousCompany: previousCompany,
    );
  }

  static GeneratedRelationEmployeeIncludeList includeList({
    _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationEmployeeTable>? orderByList,
    GeneratedRelationEmployeeInclude? include,
  }) {
    return GeneratedRelationEmployeeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedRelationEmployee.t),
      orderByList: orderByList?.call(GeneratedRelationEmployee.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeneratedRelationEmployeeImpl extends GeneratedRelationEmployee {
  _GeneratedRelationEmployeeImpl({
    int? id,
    required String name,
    required int customCompanyId,
    _ipeijyfj.GeneratedRelationCompany? company,
    int? customPreviousCompanyId,
    _ipeijyfj.GeneratedRelationCompany? previousCompany,
  }) : super._(
         id: id,
         name: name,
         customCompanyId: customCompanyId,
         company: company,
         customPreviousCompanyId: customPreviousCompanyId,
         previousCompany: previousCompany,
       );

  /// Returns a shallow copy of this [GeneratedRelationEmployee]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  GeneratedRelationEmployee copyWith({
    Object? id = _Undefined,
    String? name,
    int? customCompanyId,
    Object? company = _Undefined,
    Object? customPreviousCompanyId = _Undefined,
    Object? previousCompany = _Undefined,
  }) {
    return GeneratedRelationEmployee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      customCompanyId: customCompanyId ?? this.customCompanyId,
      company: company is _ipeijyfj.GeneratedRelationCompany?
          ? company
          : this.company?.copyWith(),
      customPreviousCompanyId: customPreviousCompanyId is int?
          ? customPreviousCompanyId
          : this.customPreviousCompanyId,
      previousCompany: previousCompany is _ipeijyfj.GeneratedRelationCompany?
          ? previousCompany
          : this.previousCompany?.copyWith(),
    );
  }
}

class GeneratedRelationEmployeeUpdateTable
    extends _is.UpdateTable<GeneratedRelationEmployeeTable> {
  GeneratedRelationEmployeeUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> customCompanyId(int value) => _is.ColumnValue(
    table.customCompanyId,
    value,
  );

  _is.ColumnValue<int, int> customPreviousCompanyId(int? value) =>
      _is.ColumnValue(
        table.customPreviousCompanyId,
        value,
      );
}

class GeneratedRelationEmployeeTable extends _is.Table<int?> {
  GeneratedRelationEmployeeTable({super.tableRelation})
    : super(tableName: 'generated_relation_employee') {
    updateTable = GeneratedRelationEmployeeUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    customCompanyId = _is.ColumnInt(
      'customCompanyId',
      this,
    );
    customPreviousCompanyId = _is.ColumnInt(
      'customPreviousCompanyId',
      this,
    );
  }

  late final GeneratedRelationEmployeeUpdateTable updateTable;

  late final _is.ColumnString name;

  /// The foreign key of the [company] relation.
  late final _is.ColumnInt customCompanyId;

  _ipeijyfj.GeneratedRelationCompanyTable? _company;

  /// The foreign key of the [previousCompany] relation.
  late final _is.ColumnInt customPreviousCompanyId;

  _ipeijyfj.GeneratedRelationCompanyTable? _previousCompany;

  _ipeijyfj.GeneratedRelationCompanyTable get company {
    if (_company != null) return _company!;
    _company = _is.createRelationTable(
      relationFieldName: 'company',
      field: GeneratedRelationEmployee.t.customCompanyId,
      foreignField: _ipeijyfj.GeneratedRelationCompany.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ipeijyfj.GeneratedRelationCompanyTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return _company!;
  }

  _ipeijyfj.GeneratedRelationCompanyTable get previousCompany {
    if (_previousCompany != null) return _previousCompany!;
    _previousCompany = _is.createRelationTable(
      relationFieldName: 'previousCompany',
      field: GeneratedRelationEmployee.t.customPreviousCompanyId,
      foreignField: _ipeijyfj.GeneratedRelationCompany.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ipeijyfj.GeneratedRelationCompanyTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return _previousCompany!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    customCompanyId,
    customPreviousCompanyId,
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

class GeneratedRelationEmployeeInclude extends _is.IncludeObject {
  GeneratedRelationEmployeeInclude._({
    _ipeijyfj.GeneratedRelationCompanyInclude? company,
    _ipeijyfj.GeneratedRelationCompanyInclude? previousCompany,
  }) {
    _company = company;
    _previousCompany = previousCompany;
  }

  _ipeijyfj.GeneratedRelationCompanyInclude? _company;

  _ipeijyfj.GeneratedRelationCompanyInclude? _previousCompany;

  @override
  Map<String, _is.Include?> get includes => {
    'company': _company,
    'previousCompany': _previousCompany,
  };

  @override
  _is.Table<int?> get table => GeneratedRelationEmployee.t;
}

class GeneratedRelationEmployeeIncludeList extends _is.IncludeList {
  GeneratedRelationEmployeeIncludeList._({
    _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(GeneratedRelationEmployee.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => GeneratedRelationEmployee.t;
}

class GeneratedRelationEmployeeRepository {
  const GeneratedRelationEmployeeRepository._();

  final attachRow = const GeneratedRelationEmployeeAttachRowRepository._();

  final detachRow = const GeneratedRelationEmployeeDetachRowRepository._();

  /// Returns a list of [GeneratedRelationEmployee]s matching the given query parameters.
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
  Future<List<GeneratedRelationEmployee>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    GeneratedRelationEmployeeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GeneratedRelationEmployee>(
      where: where?.call(GeneratedRelationEmployee.t),
      orderBy: orderBy?.call(GeneratedRelationEmployee.t),
      orderByList: orderByList?.call(GeneratedRelationEmployee.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GeneratedRelationEmployee] matching the given query parameters.
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
  Future<GeneratedRelationEmployee?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable>? where,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    GeneratedRelationEmployeeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GeneratedRelationEmployee>(
      where: where?.call(GeneratedRelationEmployee.t),
      orderBy: orderBy?.call(GeneratedRelationEmployee.t),
      orderByList: orderByList?.call(GeneratedRelationEmployee.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GeneratedRelationEmployee] by its [id] or null if no such row exists.
  Future<GeneratedRelationEmployee?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    GeneratedRelationEmployeeInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GeneratedRelationEmployee>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GeneratedRelationEmployee]s in the list and returns the inserted rows.
  ///
  /// The returned [GeneratedRelationEmployee]s will have their `id` fields set.
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
  Future<List<GeneratedRelationEmployee>> insert(
    _is.DatabaseSession session,
    List<GeneratedRelationEmployee> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<GeneratedRelationEmployee>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [GeneratedRelationEmployee] and returns the inserted row.
  ///
  /// The returned [GeneratedRelationEmployee] will have its `id` field set.
  Future<GeneratedRelationEmployee> insertRow(
    _is.DatabaseSession session,
    GeneratedRelationEmployee row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<GeneratedRelationEmployee>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [GeneratedRelationEmployee]s in the list and returns the resulting rows.
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
  /// The returned [GeneratedRelationEmployee]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationEmployee>> upsert(
    _is.DatabaseSession session,
    List<GeneratedRelationEmployee> rows, {
    required _is.ColumnSelections<GeneratedRelationEmployeeTable>
    conflictColumns,
    _is.ColumnSelections<GeneratedRelationEmployeeTable>? updateColumns,
    _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<GeneratedRelationEmployee>(
      rows,
      conflictColumns: conflictColumns(GeneratedRelationEmployee.t),
      updateColumns: updateColumns?.call(GeneratedRelationEmployee.t),
      updateWhere: updateWhere?.call(GeneratedRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [GeneratedRelationEmployee] and returns the resulting row.
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
  /// The returned [GeneratedRelationEmployee] will have its `id` field set.
  Future<GeneratedRelationEmployee?> upsertRow(
    _is.DatabaseSession session,
    GeneratedRelationEmployee row, {
    required _is.ColumnSelections<GeneratedRelationEmployeeTable>
    conflictColumns,
    _is.ColumnSelections<GeneratedRelationEmployeeTable>? updateColumns,
    _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<GeneratedRelationEmployee>(
      row,
      conflictColumns: conflictColumns(GeneratedRelationEmployee.t),
      updateColumns: updateColumns?.call(GeneratedRelationEmployee.t),
      updateWhere: updateWhere?.call(GeneratedRelationEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedRelationEmployee]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationEmployee>> update(
    _is.DatabaseSession session,
    List<GeneratedRelationEmployee> rows, {
    _is.ColumnSelections<GeneratedRelationEmployeeTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<GeneratedRelationEmployee>(
      rows,
      columns: columns?.call(GeneratedRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [GeneratedRelationEmployee]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GeneratedRelationEmployee> updateRow(
    _is.DatabaseSession session,
    GeneratedRelationEmployee row, {
    _is.ColumnSelections<GeneratedRelationEmployeeTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<GeneratedRelationEmployee>(
      row,
      columns: columns?.call(GeneratedRelationEmployee.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GeneratedRelationEmployee] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GeneratedRelationEmployee?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<GeneratedRelationEmployeeUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<GeneratedRelationEmployee>(
      id,
      columnValues: columnValues(GeneratedRelationEmployee.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedRelationEmployee]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationEmployee>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<GeneratedRelationEmployeeUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<GeneratedRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<GeneratedRelationEmployee>(
      columnValues: columnValues(GeneratedRelationEmployee.t.updateTable),
      where: where(GeneratedRelationEmployee.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedRelationEmployee.t),
      orderByList: orderByList?.call(GeneratedRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [GeneratedRelationEmployee]s in the list and returns the deleted rows.
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
  Future<List<GeneratedRelationEmployee>> delete(
    _is.DatabaseSession session,
    List<GeneratedRelationEmployee> rows, {
    _is.OrderByBuilder<GeneratedRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<GeneratedRelationEmployee>(
      rows,
      orderBy: orderBy?.call(GeneratedRelationEmployee.t),
      orderByList: orderByList?.call(GeneratedRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [GeneratedRelationEmployee].
  Future<GeneratedRelationEmployee> deleteRow(
    _is.DatabaseSession session,
    GeneratedRelationEmployee row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GeneratedRelationEmployee>(
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
  Future<List<GeneratedRelationEmployee>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable> where,
    _is.OrderByBuilder<GeneratedRelationEmployeeTable>? orderBy,
    _is.OrderByListBuilder<GeneratedRelationEmployeeTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<GeneratedRelationEmployee>(
      where: where(GeneratedRelationEmployee.t),
      orderBy: orderBy?.call(GeneratedRelationEmployee.t),
      orderByList: orderByList?.call(GeneratedRelationEmployee.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<GeneratedRelationEmployee>(
      where: where?.call(GeneratedRelationEmployee.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GeneratedRelationEmployee] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<GeneratedRelationEmployeeTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GeneratedRelationEmployee>(
      where: where(GeneratedRelationEmployee.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class GeneratedRelationEmployeeAttachRowRepository {
  const GeneratedRelationEmployeeAttachRowRepository._();

  /// Creates a relation between the given [GeneratedRelationEmployee] and [GeneratedRelationCompany]
  /// by setting the [GeneratedRelationEmployee]'s foreign key `customCompanyId` to refer to the [GeneratedRelationCompany].
  Future<void> company(
    _is.DatabaseSession session,
    GeneratedRelationEmployee generatedRelationEmployee,
    _ipeijyfj.GeneratedRelationCompany company, {
    _is.Transaction? transaction,
  }) async {
    if (generatedRelationEmployee.id == null) {
      throw ArgumentError.notNull('generatedRelationEmployee.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $generatedRelationEmployee = generatedRelationEmployee.copyWith(
      customCompanyId: company.id,
    );
    await session.db.updateRow<GeneratedRelationEmployee>(
      $generatedRelationEmployee,
      columns: [GeneratedRelationEmployee.t.customCompanyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [GeneratedRelationEmployee] and [GeneratedRelationCompany]
  /// by setting the [GeneratedRelationEmployee]'s foreign key `customPreviousCompanyId` to refer to the [GeneratedRelationCompany].
  Future<void> previousCompany(
    _is.DatabaseSession session,
    GeneratedRelationEmployee generatedRelationEmployee,
    _ipeijyfj.GeneratedRelationCompany previousCompany, {
    _is.Transaction? transaction,
  }) async {
    if (generatedRelationEmployee.id == null) {
      throw ArgumentError.notNull('generatedRelationEmployee.id');
    }
    if (previousCompany.id == null) {
      throw ArgumentError.notNull('previousCompany.id');
    }

    var $generatedRelationEmployee = generatedRelationEmployee.copyWith(
      customPreviousCompanyId: previousCompany.id,
    );
    await session.db.updateRow<GeneratedRelationEmployee>(
      $generatedRelationEmployee,
      columns: [GeneratedRelationEmployee.t.customPreviousCompanyId],
      transaction: transaction,
    );
  }
}

class GeneratedRelationEmployeeDetachRowRepository {
  const GeneratedRelationEmployeeDetachRowRepository._();

  /// Detaches the relation between this [GeneratedRelationEmployee] and the [GeneratedRelationCompany] set in `previousCompany`
  /// by setting the [GeneratedRelationEmployee]'s foreign key `customPreviousCompanyId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> previousCompany(
    _is.DatabaseSession session,
    GeneratedRelationEmployee generatedRelationEmployee, {
    _is.Transaction? transaction,
  }) async {
    if (generatedRelationEmployee.id == null) {
      throw ArgumentError.notNull('generatedRelationEmployee.id');
    }

    var $generatedRelationEmployee = generatedRelationEmployee.copyWith(
      customPreviousCompanyId: null,
    );
    await session.db.updateRow<GeneratedRelationEmployee>(
      $generatedRelationEmployee,
      columns: [GeneratedRelationEmployee.t.customPreviousCompanyId],
      transaction: transaction,
    );
  }
}

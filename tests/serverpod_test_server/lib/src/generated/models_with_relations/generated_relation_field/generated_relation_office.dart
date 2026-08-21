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
import 'package:serverpod/serverpod.dart' as _i1;
import '../../models_with_relations/generated_relation_field/generated_relation_company.dart'
    as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;
import 'package:meta/meta.dart' as _i4;

abstract class GeneratedRelationOffice
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  GeneratedRelationOffice._({
    this.id,
    required this.address,
    required this.customCompanyId,
    this.company,
  });

  factory GeneratedRelationOffice({
    int? id,
    required String address,
    required int customCompanyId,
    _i2.GeneratedRelationCompany? company,
  }) = _GeneratedRelationOfficeImpl;

  factory GeneratedRelationOffice.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return GeneratedRelationOffice(
      id: jsonSerialization['id'] as int?,
      address: jsonSerialization['address'] as String,
      customCompanyId: jsonSerialization['customCompanyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.GeneratedRelationCompany>(
              jsonSerialization['company'],
            ),
    );
  }

  static final t = GeneratedRelationOfficeTable();

  static const db = GeneratedRelationOfficeRepository._();

  @override
  int? id;

  String address;

  /// The foreign key of the [company] relation.
  int customCompanyId;

  _i2.GeneratedRelationCompany? company;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [GeneratedRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  GeneratedRelationOffice copyWith({
    int? id,
    String? address,
    int? customCompanyId,
    _i2.GeneratedRelationCompany? company,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'GeneratedRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'GeneratedRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'customCompanyId': customCompanyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
    };
  }

  static GeneratedRelationOfficeInclude include({
    _i2.GeneratedRelationCompanyInclude? company,
  }) {
    return GeneratedRelationOfficeInclude.internal_(company: company);
  }

  static GeneratedRelationOfficeIncludeList includeList({
    _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GeneratedRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<GeneratedRelationOfficeTable>? orderByList,
    GeneratedRelationOfficeInclude? include,
  }) {
    return GeneratedRelationOfficeIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedRelationOffice.t),
      orderByList: orderByList?.call(GeneratedRelationOffice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _GeneratedRelationOfficeImpl extends GeneratedRelationOffice {
  _GeneratedRelationOfficeImpl({
    int? id,
    required String address,
    required int customCompanyId,
    _i2.GeneratedRelationCompany? company,
  }) : super._(
         id: id,
         address: address,
         customCompanyId: customCompanyId,
         company: company,
       );

  /// Returns a shallow copy of this [GeneratedRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  GeneratedRelationOffice copyWith({
    Object? id = _Undefined,
    String? address,
    int? customCompanyId,
    Object? company = _Undefined,
  }) {
    return GeneratedRelationOffice(
      id: id is int? ? id : this.id,
      address: address ?? this.address,
      customCompanyId: customCompanyId ?? this.customCompanyId,
      company: company is _i2.GeneratedRelationCompany?
          ? company
          : this.company?.copyWith(),
    );
  }
}

class GeneratedRelationOfficeUpdateTable
    extends _i1.UpdateTable<GeneratedRelationOfficeTable> {
  GeneratedRelationOfficeUpdateTable(super.table);

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<int, int> customCompanyId(int value) => _i1.ColumnValue(
    table.customCompanyId,
    value,
  );
}

class GeneratedRelationOfficeTable extends _i1.Table<int?> {
  GeneratedRelationOfficeTable({super.tableRelation})
    : super(tableName: 'generated_relation_office') {
    updateTable = GeneratedRelationOfficeUpdateTable(this);
    address = _i1.ColumnString(
      'address',
      this,
    );
    customCompanyId = _i1.ColumnInt(
      'customCompanyId',
      this,
    );
  }

  late final GeneratedRelationOfficeUpdateTable updateTable;

  late final _i1.ColumnString address;

  /// The foreign key of the [company] relation.
  late final _i1.ColumnInt customCompanyId;

  _i2.GeneratedRelationCompanyTable? _company;

  _i2.GeneratedRelationCompanyTable get company {
    if (_company != null) return _company!;
    _company = _i1.createRelationTable(
      relationFieldName: 'company',
      field: GeneratedRelationOffice.t.customCompanyId,
      foreignField: _i2.GeneratedRelationCompany.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) => _i2.GeneratedRelationCompanyTable(
        tableRelation: foreignTableRelation,
      ),
    );
    return _company!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    address,
    customCompanyId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'company') {
      return company;
    }
    return null;
  }
}

class GeneratedRelationOfficeInclude extends _i1.IncludeObject {
  @_i4.internal
  GeneratedRelationOfficeInclude.internal_({
    _i2.GeneratedRelationCompanyInclude? company,
    List<_i1.Column>? this.selectedColumns,
  }) {
    _company = company;
  }

  _i2.GeneratedRelationCompanyInclude? _company;

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => {'company': _company};

  @override
  _i1.Table<int?> get table => GeneratedRelationOffice.t;
}

class GeneratedRelationOfficeIncludeList extends _i1.IncludeList {
  @_i4.internal
  GeneratedRelationOfficeIncludeList.internal_({
    _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_i1.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(GeneratedRelationOffice.t);
  }

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => GeneratedRelationOffice.t;
}

class GeneratedRelationOfficeRepository {
  const GeneratedRelationOfficeRepository._();

  final attachRow = const GeneratedRelationOfficeAttachRowRepository._();

  /// Returns a list of [GeneratedRelationOffice]s matching the given query parameters.
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
  Future<List<GeneratedRelationOffice>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GeneratedRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<GeneratedRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    GeneratedRelationOfficeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<GeneratedRelationOffice>(
      where: where?.call(GeneratedRelationOffice.t),
      orderBy: orderBy?.call(GeneratedRelationOffice.t),
      orderByList: orderByList?.call(GeneratedRelationOffice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [GeneratedRelationOffice] matching the given query parameters.
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
  Future<GeneratedRelationOffice?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable>? where,
    int? offset,
    _i1.OrderByBuilder<GeneratedRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<GeneratedRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    GeneratedRelationOfficeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<GeneratedRelationOffice>(
      where: where?.call(GeneratedRelationOffice.t),
      orderBy: orderBy?.call(GeneratedRelationOffice.t),
      orderByList: orderByList?.call(GeneratedRelationOffice.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [GeneratedRelationOffice] by its [id] or null if no such row exists.
  Future<GeneratedRelationOffice?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    GeneratedRelationOfficeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<GeneratedRelationOffice>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [GeneratedRelationOffice]s in the list and returns the inserted rows.
  ///
  /// The returned [GeneratedRelationOffice]s will have their `id` fields set.
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
  Future<List<GeneratedRelationOffice>> insert(
    _i1.DatabaseSession session,
    List<GeneratedRelationOffice> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<GeneratedRelationOffice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [GeneratedRelationOffice] and returns the inserted row.
  ///
  /// The returned [GeneratedRelationOffice] will have its `id` field set.
  Future<GeneratedRelationOffice> insertRow(
    _i1.DatabaseSession session,
    GeneratedRelationOffice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<GeneratedRelationOffice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [GeneratedRelationOffice]s in the list and returns the resulting rows.
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
  /// The returned [GeneratedRelationOffice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationOffice>> upsert(
    _i1.DatabaseSession session,
    List<GeneratedRelationOffice> rows, {
    required _i1.ColumnSelections<GeneratedRelationOfficeTable> conflictColumns,
    _i1.ColumnSelections<GeneratedRelationOfficeTable>? updateColumns,
    _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<GeneratedRelationOffice>(
      rows,
      conflictColumns: conflictColumns(GeneratedRelationOffice.t),
      updateColumns: updateColumns?.call(GeneratedRelationOffice.t),
      updateWhere: updateWhere?.call(GeneratedRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [GeneratedRelationOffice] and returns the resulting row.
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
  /// The returned [GeneratedRelationOffice] will have its `id` field set.
  Future<GeneratedRelationOffice?> upsertRow(
    _i1.DatabaseSession session,
    GeneratedRelationOffice row, {
    required _i1.ColumnSelections<GeneratedRelationOfficeTable> conflictColumns,
    _i1.ColumnSelections<GeneratedRelationOfficeTable>? updateColumns,
    _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<GeneratedRelationOffice>(
      row,
      conflictColumns: conflictColumns(GeneratedRelationOffice.t),
      updateColumns: updateColumns?.call(GeneratedRelationOffice.t),
      updateWhere: updateWhere?.call(GeneratedRelationOffice.t),
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedRelationOffice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationOffice>> update(
    _i1.DatabaseSession session,
    List<GeneratedRelationOffice> rows, {
    _i1.ColumnSelections<GeneratedRelationOfficeTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<GeneratedRelationOffice>(
      rows,
      columns: columns?.call(GeneratedRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [GeneratedRelationOffice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<GeneratedRelationOffice> updateRow(
    _i1.DatabaseSession session,
    GeneratedRelationOffice row, {
    _i1.ColumnSelections<GeneratedRelationOfficeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<GeneratedRelationOffice>(
      row,
      columns: columns?.call(GeneratedRelationOffice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [GeneratedRelationOffice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<GeneratedRelationOffice?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<GeneratedRelationOfficeUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<GeneratedRelationOffice>(
      id,
      columnValues: columnValues(GeneratedRelationOffice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [GeneratedRelationOffice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<GeneratedRelationOffice>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<GeneratedRelationOfficeUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<GeneratedRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<GeneratedRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<GeneratedRelationOffice>(
      columnValues: columnValues(GeneratedRelationOffice.t.updateTable),
      where: where(GeneratedRelationOffice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(GeneratedRelationOffice.t),
      orderByList: orderByList?.call(GeneratedRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [GeneratedRelationOffice]s in the list and returns the deleted rows.
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
  Future<List<GeneratedRelationOffice>> delete(
    _i1.DatabaseSession session,
    List<GeneratedRelationOffice> rows, {
    _i1.OrderByBuilder<GeneratedRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<GeneratedRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<GeneratedRelationOffice>(
      rows,
      orderBy: orderBy?.call(GeneratedRelationOffice.t),
      orderByList: orderByList?.call(GeneratedRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [GeneratedRelationOffice].
  Future<GeneratedRelationOffice> deleteRow(
    _i1.DatabaseSession session,
    GeneratedRelationOffice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<GeneratedRelationOffice>(
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
  Future<List<GeneratedRelationOffice>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable> where,
    _i1.OrderByBuilder<GeneratedRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<GeneratedRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<GeneratedRelationOffice>(
      where: where(GeneratedRelationOffice.t),
      orderBy: orderBy?.call(GeneratedRelationOffice.t),
      orderByList: orderByList?.call(GeneratedRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<GeneratedRelationOffice>(
      where: where?.call(GeneratedRelationOffice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [GeneratedRelationOffice] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<GeneratedRelationOfficeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<GeneratedRelationOffice>(
      where: where(GeneratedRelationOffice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class GeneratedRelationOfficeAttachRowRepository {
  const GeneratedRelationOfficeAttachRowRepository._();

  /// Creates a relation between the given [GeneratedRelationOffice] and [GeneratedRelationCompany]
  /// by setting the [GeneratedRelationOffice]'s foreign key `customCompanyId` to refer to the [GeneratedRelationCompany].
  Future<void> company(
    _i1.DatabaseSession session,
    GeneratedRelationOffice generatedRelationOffice,
    _i2.GeneratedRelationCompany company, {
    _i1.Transaction? transaction,
  }) async {
    if (generatedRelationOffice.id == null) {
      throw ArgumentError.notNull('generatedRelationOffice.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $generatedRelationOffice = generatedRelationOffice.copyWith(
      customCompanyId: company.id,
    );
    await session.db.updateRow<GeneratedRelationOffice>(
      $generatedRelationOffice,
      columns: [GeneratedRelationOffice.t.customCompanyId],
      transaction: transaction,
    );
  }
}

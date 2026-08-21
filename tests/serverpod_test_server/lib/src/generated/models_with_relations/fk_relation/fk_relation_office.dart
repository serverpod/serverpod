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
import '../../models_with_relations/fk_relation/fk_relation_company.dart'
    as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class FkRelationOffice
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  FkRelationOffice._({
    this.id,
    required this.address,
    required this.companyId,
    this.company,
  });

  factory FkRelationOffice({
    int? id,
    required String address,
    required int companyId,
    _i2.FkRelationCompany? company,
  }) = _FkRelationOfficeImpl;

  factory FkRelationOffice.fromJson(Map<String, dynamic> jsonSerialization) {
    return FkRelationOffice(
      id: jsonSerialization['id'] as int?,
      address: jsonSerialization['address'] as String,
      companyId: jsonSerialization['companyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.FkRelationCompany>(
              jsonSerialization['company'],
            ),
    );
  }

  static final t = FkRelationOfficeTable();

  static const db = FkRelationOfficeRepository._();

  @override
  int? id;

  String address;

  int companyId;

  _i2.FkRelationCompany? company;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [FkRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  FkRelationOffice copyWith({
    int? id,
    String? address,
    int? companyId,
    _i2.FkRelationCompany? company,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FkRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'companyId': companyId,
      if (company != null) 'company': company?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FkRelationOffice',
      if (id != null) 'id': id,
      'address': address,
      'companyId': companyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
    };
  }

  static FkRelationOfficeInclude include({
    _i2.FkRelationCompanyInclude? company,
  }) {
    return FkRelationOfficeInclude._(company: company);
  }

  static FkRelationOfficeIncludeList includeList({
    _i1.WhereExpressionBuilder<FkRelationOfficeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FkRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<FkRelationOfficeTable>? orderByList,
    FkRelationOfficeInclude? include,
  }) {
    return FkRelationOfficeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FkRelationOffice.t),
      orderByList: orderByList?.call(FkRelationOffice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _FkRelationOfficeImpl extends FkRelationOffice {
  _FkRelationOfficeImpl({
    int? id,
    required String address,
    required int companyId,
    _i2.FkRelationCompany? company,
  }) : super._(
         id: id,
         address: address,
         companyId: companyId,
         company: company,
       );

  /// Returns a shallow copy of this [FkRelationOffice]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  FkRelationOffice copyWith({
    Object? id = _Undefined,
    String? address,
    int? companyId,
    Object? company = _Undefined,
  }) {
    return FkRelationOffice(
      id: id is int? ? id : this.id,
      address: address ?? this.address,
      companyId: companyId ?? this.companyId,
      company: company is _i2.FkRelationCompany?
          ? company
          : this.company?.copyWith(),
    );
  }
}

class FkRelationOfficeUpdateTable
    extends _i1.UpdateTable<FkRelationOfficeTable> {
  FkRelationOfficeUpdateTable(super.table);

  _i1.ColumnValue<String, String> address(String value) => _i1.ColumnValue(
    table.address,
    value,
  );

  _i1.ColumnValue<int, int> companyId(int value) => _i1.ColumnValue(
    table.companyId,
    value,
  );
}

class FkRelationOfficeTable extends _i1.Table<int?> {
  FkRelationOfficeTable({super.tableRelation})
    : super(tableName: 'fk_relation_office') {
    updateTable = FkRelationOfficeUpdateTable(this);
    address = _i1.ColumnString(
      'address',
      this,
    );
    companyId = _i1.ColumnInt(
      'companyId',
      this,
    );
  }

  late final FkRelationOfficeUpdateTable updateTable;

  late final _i1.ColumnString address;

  late final _i1.ColumnInt companyId;

  _i2.FkRelationCompanyTable? _company;

  _i2.FkRelationCompanyTable get company {
    if (_company != null) return _company!;
    _company = _i1.createRelationTable(
      relationFieldName: 'company',
      field: FkRelationOffice.t.companyId,
      foreignField: _i2.FkRelationCompany.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.FkRelationCompanyTable(tableRelation: foreignTableRelation),
    );
    return _company!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    address,
    companyId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'company') {
      return company;
    }
    return null;
  }
}

class FkRelationOfficeInclude extends _i1.IncludeObject {
  FkRelationOfficeInclude._({_i2.FkRelationCompanyInclude? company}) {
    _company = company;
  }

  _i2.FkRelationCompanyInclude? _company;

  @override
  Map<String, _i1.Include?> get includes => {'company': _company};

  @override
  _i1.Table<int?> get table => FkRelationOffice.t;
}

class FkRelationOfficeIncludeList extends _i1.IncludeList {
  FkRelationOfficeIncludeList._({
    _i1.WhereExpressionBuilder<FkRelationOfficeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(FkRelationOffice.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => FkRelationOffice.t;
}

class FkRelationOfficeRepository {
  const FkRelationOfficeRepository._();

  final attachRow = const FkRelationOfficeAttachRowRepository._();

  /// Returns a list of [FkRelationOffice]s matching the given query parameters.
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
  Future<List<FkRelationOffice>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FkRelationOfficeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FkRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<FkRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    FkRelationOfficeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<FkRelationOffice>(
      where: where?.call(FkRelationOffice.t),
      orderBy: orderBy?.call(FkRelationOffice.t),
      orderByList: orderByList?.call(FkRelationOffice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [FkRelationOffice] matching the given query parameters.
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
  Future<FkRelationOffice?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FkRelationOfficeTable>? where,
    int? offset,
    _i1.OrderByBuilder<FkRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<FkRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    FkRelationOfficeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<FkRelationOffice>(
      where: where?.call(FkRelationOffice.t),
      orderBy: orderBy?.call(FkRelationOffice.t),
      orderByList: orderByList?.call(FkRelationOffice.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [FkRelationOffice] by its [id] or null if no such row exists.
  Future<FkRelationOffice?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    FkRelationOfficeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<FkRelationOffice>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [FkRelationOffice]s in the list and returns the inserted rows.
  ///
  /// The returned [FkRelationOffice]s will have their `id` fields set.
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
  Future<List<FkRelationOffice>> insert(
    _i1.DatabaseSession session,
    List<FkRelationOffice> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<FkRelationOffice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [FkRelationOffice] and returns the inserted row.
  ///
  /// The returned [FkRelationOffice] will have its `id` field set.
  Future<FkRelationOffice> insertRow(
    _i1.DatabaseSession session,
    FkRelationOffice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<FkRelationOffice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [FkRelationOffice]s in the list and returns the resulting rows.
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
  /// The returned [FkRelationOffice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationOffice>> upsert(
    _i1.DatabaseSession session,
    List<FkRelationOffice> rows, {
    required _i1.ColumnSelections<FkRelationOfficeTable> conflictColumns,
    _i1.ColumnSelections<FkRelationOfficeTable>? updateColumns,
    _i1.WhereExpressionBuilder<FkRelationOfficeTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<FkRelationOffice>(
      rows,
      conflictColumns: conflictColumns(FkRelationOffice.t),
      updateColumns: updateColumns?.call(FkRelationOffice.t),
      updateWhere: updateWhere?.call(FkRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [FkRelationOffice] and returns the resulting row.
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
  /// The returned [FkRelationOffice] will have its `id` field set.
  Future<FkRelationOffice?> upsertRow(
    _i1.DatabaseSession session,
    FkRelationOffice row, {
    required _i1.ColumnSelections<FkRelationOfficeTable> conflictColumns,
    _i1.ColumnSelections<FkRelationOfficeTable>? updateColumns,
    _i1.WhereExpressionBuilder<FkRelationOfficeTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<FkRelationOffice>(
      row,
      conflictColumns: conflictColumns(FkRelationOffice.t),
      updateColumns: updateColumns?.call(FkRelationOffice.t),
      updateWhere: updateWhere?.call(FkRelationOffice.t),
      transaction: transaction,
    );
  }

  /// Updates all [FkRelationOffice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationOffice>> update(
    _i1.DatabaseSession session,
    List<FkRelationOffice> rows, {
    _i1.ColumnSelections<FkRelationOfficeTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<FkRelationOffice>(
      rows,
      columns: columns?.call(FkRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [FkRelationOffice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<FkRelationOffice> updateRow(
    _i1.DatabaseSession session,
    FkRelationOffice row, {
    _i1.ColumnSelections<FkRelationOfficeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<FkRelationOffice>(
      row,
      columns: columns?.call(FkRelationOffice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [FkRelationOffice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<FkRelationOffice?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<FkRelationOfficeUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<FkRelationOffice>(
      id,
      columnValues: columnValues(FkRelationOffice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [FkRelationOffice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<FkRelationOffice>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<FkRelationOfficeUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<FkRelationOfficeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<FkRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<FkRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<FkRelationOffice>(
      columnValues: columnValues(FkRelationOffice.t.updateTable),
      where: where(FkRelationOffice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(FkRelationOffice.t),
      orderByList: orderByList?.call(FkRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [FkRelationOffice]s in the list and returns the deleted rows.
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
  Future<List<FkRelationOffice>> delete(
    _i1.DatabaseSession session,
    List<FkRelationOffice> rows, {
    _i1.OrderByBuilder<FkRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<FkRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<FkRelationOffice>(
      rows,
      orderBy: orderBy?.call(FkRelationOffice.t),
      orderByList: orderByList?.call(FkRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [FkRelationOffice].
  Future<FkRelationOffice> deleteRow(
    _i1.DatabaseSession session,
    FkRelationOffice row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<FkRelationOffice>(
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
  Future<List<FkRelationOffice>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FkRelationOfficeTable> where,
    _i1.OrderByBuilder<FkRelationOfficeTable>? orderBy,
    _i1.OrderByListBuilder<FkRelationOfficeTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<FkRelationOffice>(
      where: where(FkRelationOffice.t),
      orderBy: orderBy?.call(FkRelationOffice.t),
      orderByList: orderByList?.call(FkRelationOffice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<FkRelationOfficeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<FkRelationOffice>(
      where: where?.call(FkRelationOffice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [FkRelationOffice] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<FkRelationOfficeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<FkRelationOffice>(
      where: where(FkRelationOffice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class FkRelationOfficeAttachRowRepository {
  const FkRelationOfficeAttachRowRepository._();

  /// Creates a relation between the given [FkRelationOffice] and [FkRelationCompany]
  /// by setting the [FkRelationOffice]'s foreign key `companyId` to refer to the [FkRelationCompany].
  Future<void> company(
    _i1.DatabaseSession session,
    FkRelationOffice fkRelationOffice,
    _i2.FkRelationCompany company, {
    _i1.Transaction? transaction,
  }) async {
    if (fkRelationOffice.id == null) {
      throw ArgumentError.notNull('fkRelationOffice.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $fkRelationOffice = fkRelationOffice.copyWith(companyId: company.id);
    await session.db.updateRow<FkRelationOffice>(
      $fkRelationOffice,
      columns: [FkRelationOffice.t.companyId],
      transaction: transaction,
    );
  }
}

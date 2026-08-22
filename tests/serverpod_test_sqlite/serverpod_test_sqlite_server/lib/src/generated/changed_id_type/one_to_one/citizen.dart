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
import '../../changed_id_type/one_to_one/address.dart' as _ih0efjtk;
import '../../changed_id_type/one_to_one/company.dart' as _i441ok8u;

abstract class CitizenInt
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CitizenInt._({
    this.id,
    required this.name,
    this.address,
    required this.companyId,
    this.company,
    this.oldCompanyId,
    this.oldCompany,
  });

  factory CitizenInt({
    int? id,
    required String name,
    _ih0efjtk.AddressUuid? address,
    required _is.UuidValue companyId,
    _i441ok8u.CompanyUuid? company,
    _is.UuidValue? oldCompanyId,
    _i441ok8u.CompanyUuid? oldCompany,
  }) = _CitizenIntImpl;

  factory CitizenInt.fromJson(Map<String, dynamic> jsonSerialization) {
    return CitizenInt(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_ih0efjtk.AddressUuid>(
              jsonSerialization['address'],
            ),
      companyId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['companyId'],
      ),
      company: jsonSerialization['company'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_i441ok8u.CompanyUuid>(
              jsonSerialization['company'],
            ),
      oldCompanyId: jsonSerialization['oldCompanyId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['oldCompanyId'],
            ),
      oldCompany: jsonSerialization['oldCompany'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_i441ok8u.CompanyUuid>(
              jsonSerialization['oldCompany'],
            ),
    );
  }

  static final t = CitizenIntTable();

  static const db = CitizenIntRepository._();

  @override
  int? id;

  String name;

  _ih0efjtk.AddressUuid? address;

  _is.UuidValue companyId;

  _i441ok8u.CompanyUuid? company;

  _is.UuidValue? oldCompanyId;

  _i441ok8u.CompanyUuid? oldCompany;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CitizenInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CitizenInt copyWith({
    int? id,
    String? name,
    _ih0efjtk.AddressUuid? address,
    _is.UuidValue? companyId,
    _i441ok8u.CompanyUuid? company,
    _is.UuidValue? oldCompanyId,
    _i441ok8u.CompanyUuid? oldCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CitizenInt',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
      'companyId': companyId.toJson(),
      if (company != null) 'company': company?.toJson(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId?.toJson(),
      if (oldCompany != null) 'oldCompany': oldCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CitizenInt',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJsonForProtocol(),
      'companyId': companyId.toJson(),
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId?.toJson(),
      if (oldCompany != null) 'oldCompany': oldCompany?.toJsonForProtocol(),
    };
  }

  static CitizenIntInclude include({
    _ih0efjtk.AddressUuidInclude? address,
    _i441ok8u.CompanyUuidInclude? company,
    _i441ok8u.CompanyUuidInclude? oldCompany,
  }) {
    return CitizenIntInclude.internal_(
      address: address,
      company: company,
      oldCompany: oldCompany,
    );
  }

  static CitizenIntIncludeList includeList({
    _is.WhereExpressionBuilder<CitizenIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenIntTable>? orderBy,
    _is.OrderByListBuilder<CitizenIntTable>? orderByList,
    CitizenIntInclude? include,
  }) {
    return CitizenIntIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenIntImpl extends CitizenInt {
  _CitizenIntImpl({
    int? id,
    required String name,
    _ih0efjtk.AddressUuid? address,
    required _is.UuidValue companyId,
    _i441ok8u.CompanyUuid? company,
    _is.UuidValue? oldCompanyId,
    _i441ok8u.CompanyUuid? oldCompany,
  }) : super._(
         id: id,
         name: name,
         address: address,
         companyId: companyId,
         company: company,
         oldCompanyId: oldCompanyId,
         oldCompany: oldCompany,
       );

  /// Returns a shallow copy of this [CitizenInt]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CitizenInt copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
    _is.UuidValue? companyId,
    Object? company = _Undefined,
    Object? oldCompanyId = _Undefined,
    Object? oldCompany = _Undefined,
  }) {
    return CitizenInt(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _ih0efjtk.AddressUuid?
          ? address
          : this.address?.copyWith(),
      companyId: companyId ?? this.companyId,
      company: company is _i441ok8u.CompanyUuid?
          ? company
          : this.company?.copyWith(),
      oldCompanyId: oldCompanyId is _is.UuidValue?
          ? oldCompanyId
          : this.oldCompanyId,
      oldCompany: oldCompany is _i441ok8u.CompanyUuid?
          ? oldCompany
          : this.oldCompany?.copyWith(),
    );
  }
}

class CitizenIntUpdateTable extends _is.UpdateTable<CitizenIntTable> {
  CitizenIntUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> companyId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.companyId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> oldCompanyId(
    _is.UuidValue? value,
  ) => _is.ColumnValue(
    table.oldCompanyId,
    value,
  );
}

class CitizenIntTable extends _is.Table<int?> {
  CitizenIntTable({super.tableRelation}) : super(tableName: 'citizen_int') {
    updateTable = CitizenIntUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    companyId = _is.ColumnUuid(
      'companyId',
      this,
    );
    oldCompanyId = _is.ColumnUuid(
      'oldCompanyId',
      this,
    );
  }

  late final CitizenIntUpdateTable updateTable;

  late final _is.ColumnString name;

  _ih0efjtk.AddressUuidTable? _address;

  late final _is.ColumnUuid companyId;

  _i441ok8u.CompanyUuidTable? _company;

  late final _is.ColumnUuid oldCompanyId;

  _i441ok8u.CompanyUuidTable? _oldCompany;

  _ih0efjtk.AddressUuidTable get address {
    if (_address != null) return _address!;
    _address = _is.createRelationTable(
      relationFieldName: 'address',
      field: CitizenInt.t.id,
      foreignField: _ih0efjtk.AddressUuid.t.inhabitantId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ih0efjtk.AddressUuidTable(tableRelation: foreignTableRelation),
    );
    return _address!;
  }

  _i441ok8u.CompanyUuidTable get company {
    if (_company != null) return _company!;
    _company = _is.createRelationTable(
      relationFieldName: 'company',
      field: CitizenInt.t.companyId,
      foreignField: _i441ok8u.CompanyUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i441ok8u.CompanyUuidTable(tableRelation: foreignTableRelation),
    );
    return _company!;
  }

  _i441ok8u.CompanyUuidTable get oldCompany {
    if (_oldCompany != null) return _oldCompany!;
    _oldCompany = _is.createRelationTable(
      relationFieldName: 'oldCompany',
      field: CitizenInt.t.oldCompanyId,
      foreignField: _i441ok8u.CompanyUuid.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i441ok8u.CompanyUuidTable(tableRelation: foreignTableRelation),
    );
    return _oldCompany!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    companyId,
    oldCompanyId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'address') {
      return address;
    }
    if (relationField == 'company') {
      return company;
    }
    if (relationField == 'oldCompany') {
      return oldCompany;
    }
    return null;
  }
}

class CitizenIntInclude extends _is.IncludeObject {
  CitizenIntInclude.internal_({
    _ih0efjtk.AddressUuidInclude? address,
    _i441ok8u.CompanyUuidInclude? company,
    _i441ok8u.CompanyUuidInclude? oldCompany,
    this.selectedColumns,
  }) {
    _address = address;
    _company = company;
    _oldCompany = oldCompany;
  }

  _ih0efjtk.AddressUuidInclude? _address;

  _i441ok8u.CompanyUuidInclude? _company;

  _i441ok8u.CompanyUuidInclude? _oldCompany;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'address': _address,
    'company': _company,
    'oldCompany': _oldCompany,
  };

  @override
  _is.Table<int?> get table => CitizenInt.t;
}

class CitizenIntIncludeList extends _is.IncludeList {
  CitizenIntIncludeList.internal_({
    _is.WhereExpressionBuilder<CitizenIntTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(CitizenInt.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CitizenInt.t;
}

class CitizenIntRepository {
  const CitizenIntRepository._();

  final attachRow = const CitizenIntAttachRowRepository._();

  final detachRow = const CitizenIntDetachRowRepository._();

  /// Returns a list of [CitizenInt]s matching the given query parameters.
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
  Future<List<CitizenInt>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenIntTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenIntTable>? orderBy,
    _is.OrderByListBuilder<CitizenIntTable>? orderByList,
    _is.Transaction? transaction,
    CitizenIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CitizenInt>(
      where: where?.call(CitizenInt.t),
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CitizenInt] matching the given query parameters.
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
  Future<CitizenInt?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenIntTable>? where,
    int? offset,
    _is.OrderByBuilder<CitizenIntTable>? orderBy,
    _is.OrderByListBuilder<CitizenIntTable>? orderByList,
    _is.Transaction? transaction,
    CitizenIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CitizenInt>(
      where: where?.call(CitizenInt.t),
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CitizenInt] by its [id] or null if no such row exists.
  Future<CitizenInt?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CitizenIntInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CitizenInt>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CitizenInt]s in the list and returns the inserted rows.
  ///
  /// The returned [CitizenInt]s will have their `id` fields set.
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
  Future<List<CitizenInt>> insert(
    _is.DatabaseSession session,
    List<CitizenInt> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CitizenInt>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CitizenInt] and returns the inserted row.
  ///
  /// The returned [CitizenInt] will have its `id` field set.
  Future<CitizenInt> insertRow(
    _is.DatabaseSession session,
    CitizenInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CitizenInt>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CitizenInt]s in the list and returns the resulting rows.
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
  /// The returned [CitizenInt]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenInt>> upsert(
    _is.DatabaseSession session,
    List<CitizenInt> rows, {
    required _is.ColumnSelections<CitizenIntTable> conflictColumns,
    _is.ColumnSelections<CitizenIntTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenIntTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CitizenInt>(
      rows,
      conflictColumns: conflictColumns(CitizenInt.t),
      updateColumns: updateColumns?.call(CitizenInt.t),
      updateWhere: updateWhere?.call(CitizenInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CitizenInt] and returns the resulting row.
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
  /// The returned [CitizenInt] will have its `id` field set.
  Future<CitizenInt?> upsertRow(
    _is.DatabaseSession session,
    CitizenInt row, {
    required _is.ColumnSelections<CitizenIntTable> conflictColumns,
    _is.ColumnSelections<CitizenIntTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenIntTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CitizenInt>(
      row,
      conflictColumns: conflictColumns(CitizenInt.t),
      updateColumns: updateColumns?.call(CitizenInt.t),
      updateWhere: updateWhere?.call(CitizenInt.t),
      transaction: transaction,
    );
  }

  /// Updates all [CitizenInt]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenInt>> update(
    _is.DatabaseSession session,
    List<CitizenInt> rows, {
    _is.ColumnSelections<CitizenIntTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CitizenInt>(
      rows,
      columns: columns?.call(CitizenInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CitizenInt]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CitizenInt> updateRow(
    _is.DatabaseSession session,
    CitizenInt row, {
    _is.ColumnSelections<CitizenIntTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CitizenInt>(
      row,
      columns: columns?.call(CitizenInt.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CitizenInt] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CitizenInt?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CitizenIntUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CitizenInt>(
      id,
      columnValues: columnValues(CitizenInt.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CitizenInt]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CitizenInt>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CitizenIntUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CitizenIntTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenIntTable>? orderBy,
    _is.OrderByListBuilder<CitizenIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CitizenInt>(
      columnValues: columnValues(CitizenInt.t.updateTable),
      where: where(CitizenInt.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CitizenInt]s in the list and returns the deleted rows.
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
  Future<List<CitizenInt>> delete(
    _is.DatabaseSession session,
    List<CitizenInt> rows, {
    _is.OrderByBuilder<CitizenIntTable>? orderBy,
    _is.OrderByListBuilder<CitizenIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CitizenInt>(
      rows,
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CitizenInt].
  Future<CitizenInt> deleteRow(
    _is.DatabaseSession session,
    CitizenInt row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CitizenInt>(
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
  Future<List<CitizenInt>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenIntTable> where,
    _is.OrderByBuilder<CitizenIntTable>? orderBy,
    _is.OrderByListBuilder<CitizenIntTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CitizenInt>(
      where: where(CitizenInt.t),
      orderBy: orderBy?.call(CitizenInt.t),
      orderByList: orderByList?.call(CitizenInt.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenIntTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CitizenInt>(
      where: where?.call(CitizenInt.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CitizenInt] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenIntTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CitizenInt>(
      where: where(CitizenInt.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CitizenIntAttachRowRepository {
  const CitizenIntAttachRowRepository._();

  /// Creates a relation between the given [CitizenInt] and [AddressUuid]
  /// by setting the [CitizenInt]'s foreign key `id` to refer to the [AddressUuid].
  Future<void> address(
    _is.DatabaseSession session,
    CitizenInt citizenInt,
    _ih0efjtk.AddressUuid address, {
    _is.Transaction? transaction,
  }) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }

    var $address = address.copyWith(inhabitantId: citizenInt.id);
    await session.db.updateRow<_ih0efjtk.AddressUuid>(
      $address,
      columns: [_ih0efjtk.AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CitizenInt] and [CompanyUuid]
  /// by setting the [CitizenInt]'s foreign key `companyId` to refer to the [CompanyUuid].
  Future<void> company(
    _is.DatabaseSession session,
    CitizenInt citizenInt,
    _i441ok8u.CompanyUuid company, {
    _is.Transaction? transaction,
  }) async {
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $citizenInt = citizenInt.copyWith(companyId: company.id);
    await session.db.updateRow<CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.companyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [CitizenInt] and [CompanyUuid]
  /// by setting the [CitizenInt]'s foreign key `oldCompanyId` to refer to the [CompanyUuid].
  Future<void> oldCompany(
    _is.DatabaseSession session,
    CitizenInt citizenInt,
    _i441ok8u.CompanyUuid oldCompany, {
    _is.Transaction? transaction,
  }) async {
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }
    if (oldCompany.id == null) {
      throw ArgumentError.notNull('oldCompany.id');
    }

    var $citizenInt = citizenInt.copyWith(oldCompanyId: oldCompany.id);
    await session.db.updateRow<CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

class CitizenIntDetachRowRepository {
  const CitizenIntDetachRowRepository._();

  /// Detaches the relation between this [CitizenInt] and the [AddressUuid] set in `address`
  /// by setting the [CitizenInt]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> address(
    _is.DatabaseSession session,
    CitizenInt citizenInt, {
    _is.Transaction? transaction,
  }) async {
    var $address = citizenInt.address;

    if ($address == null) {
      throw ArgumentError.notNull('citizenInt.address');
    }
    if ($address.id == null) {
      throw ArgumentError.notNull('citizenInt.address.id');
    }
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }

    var $$address = $address.copyWith(inhabitantId: null);
    await session.db.updateRow<_ih0efjtk.AddressUuid>(
      $$address,
      columns: [_ih0efjtk.AddressUuid.t.inhabitantId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [CitizenInt] and the [CompanyUuid] set in `oldCompany`
  /// by setting the [CitizenInt]'s foreign key `oldCompanyId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> oldCompany(
    _is.DatabaseSession session,
    CitizenInt citizenInt, {
    _is.Transaction? transaction,
  }) async {
    if (citizenInt.id == null) {
      throw ArgumentError.notNull('citizenInt.id');
    }

    var $citizenInt = citizenInt.copyWith(oldCompanyId: null);
    await session.db.updateRow<CitizenInt>(
      $citizenInt,
      columns: [CitizenInt.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

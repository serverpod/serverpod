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
import '../../models_with_relations/one_to_one/address.dart' as _i5rzbc0r;
import '../../models_with_relations/one_to_one/company.dart' as _i2fdza8t;

abstract class Citizen
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Citizen._({
    this.id,
    required this.name,
    this.address,
    required this.companyId,
    this.company,
    this.oldCompanyId,
    this.oldCompany,
  });

  factory Citizen({
    int? id,
    required String name,
    _i5rzbc0r.Address? address,
    required int companyId,
    _i2fdza8t.Company? company,
    int? oldCompanyId,
    _i2fdza8t.Company? oldCompany,
  }) = _CitizenImpl;

  factory Citizen.fromJson(Map<String, dynamic> jsonSerialization) {
    return Citizen(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      address: jsonSerialization['address'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i5rzbc0r.Address>(
              jsonSerialization['address'],
            ),
      companyId: jsonSerialization['companyId'] as int,
      company: jsonSerialization['company'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i2fdza8t.Company>(
              jsonSerialization['company'],
            ),
      oldCompanyId: jsonSerialization['oldCompanyId'] as int?,
      oldCompany: jsonSerialization['oldCompany'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i2fdza8t.Company>(
              jsonSerialization['oldCompany'],
            ),
    );
  }

  static final t = CitizenTable();

  static const db = CitizenRepository._();

  @override
  int? id;

  String name;

  _i5rzbc0r.Address? address;

  int companyId;

  _i2fdza8t.Company? company;

  int? oldCompanyId;

  _i2fdza8t.Company? oldCompany;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Citizen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Citizen copyWith({
    int? id,
    String? name,
    _i5rzbc0r.Address? address,
    int? companyId,
    _i2fdza8t.Company? company,
    int? oldCompanyId,
    _i2fdza8t.Company? oldCompany,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Citizen',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJson(),
      'companyId': companyId,
      if (company != null) 'company': company?.toJson(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId,
      if (oldCompany != null) 'oldCompany': oldCompany?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Citizen',
      if (id != null) 'id': id,
      'name': name,
      if (address != null) 'address': address?.toJsonForProtocol(),
      'companyId': companyId,
      if (company != null) 'company': company?.toJsonForProtocol(),
      if (oldCompanyId != null) 'oldCompanyId': oldCompanyId,
      if (oldCompany != null) 'oldCompany': oldCompany?.toJsonForProtocol(),
    };
  }

  static CitizenInclude include({
    _i5rzbc0r.AddressInclude? address,
    _i2fdza8t.CompanyInclude? company,
    _i2fdza8t.CompanyInclude? oldCompany,
    _is.SelectColumnsBuilder<CitizenTable>? select,
  }) {
    return CitizenInclude._(
      address: address,
      company: company,
      oldCompany: oldCompany,
      selectedColumns: select?.call(Citizen.t),
    );
  }

  static CitizenIncludeList includeList({
    _is.WhereExpressionBuilder<CitizenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    CitizenInclude? include,
    _is.SelectColumnsBuilder<CitizenTable>? select,
  }) {
    return CitizenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      include: include,
      selectedColumns: select?.call(Citizen.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenImpl extends Citizen {
  _CitizenImpl({
    int? id,
    required String name,
    _i5rzbc0r.Address? address,
    required int companyId,
    _i2fdza8t.Company? company,
    int? oldCompanyId,
    _i2fdza8t.Company? oldCompany,
  }) : super._(
         id: id,
         name: name,
         address: address,
         companyId: companyId,
         company: company,
         oldCompanyId: oldCompanyId,
         oldCompany: oldCompany,
       );

  /// Returns a shallow copy of this [Citizen]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Citizen copyWith({
    Object? id = _Undefined,
    String? name,
    Object? address = _Undefined,
    int? companyId,
    Object? company = _Undefined,
    Object? oldCompanyId = _Undefined,
    Object? oldCompany = _Undefined,
  }) {
    return Citizen(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      address: address is _i5rzbc0r.Address?
          ? address
          : this.address?.copyWith(),
      companyId: companyId ?? this.companyId,
      company: company is _i2fdza8t.Company?
          ? company
          : this.company?.copyWith(),
      oldCompanyId: oldCompanyId is int? ? oldCompanyId : this.oldCompanyId,
      oldCompany: oldCompany is _i2fdza8t.Company?
          ? oldCompany
          : this.oldCompany?.copyWith(),
    );
  }
}

class CitizenUpdateTable extends _is.UpdateTable<CitizenTable> {
  CitizenUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> companyId(int value) => _is.ColumnValue(
    table.companyId,
    value,
  );

  _is.ColumnValue<int, int> oldCompanyId(int? value) => _is.ColumnValue(
    table.oldCompanyId,
    value,
  );
}

class CitizenTable extends _is.Table<int?> {
  CitizenTable({super.tableRelation}) : super(tableName: 'citizen') {
    updateTable = CitizenUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    companyId = _is.ColumnInt(
      'companyId',
      this,
    );
    oldCompanyId = _is.ColumnInt(
      'oldCompanyId',
      this,
    );
  }

  late final CitizenUpdateTable updateTable;

  late final _is.ColumnString name;

  _i5rzbc0r.AddressTable? _address;

  late final _is.ColumnInt companyId;

  _i2fdza8t.CompanyTable? _company;

  late final _is.ColumnInt oldCompanyId;

  _i2fdza8t.CompanyTable? _oldCompany;

  _i5rzbc0r.AddressTable get address {
    if (_address != null) return _address!;
    _address = _is.createRelationTable(
      relationFieldName: 'address',
      field: Citizen.t.id,
      foreignField: _i5rzbc0r.Address.t.inhabitantId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5rzbc0r.AddressTable(tableRelation: foreignTableRelation),
    );
    return _address!;
  }

  _i2fdza8t.CompanyTable get company {
    if (_company != null) return _company!;
    _company = _is.createRelationTable(
      relationFieldName: 'company',
      field: Citizen.t.companyId,
      foreignField: _i2fdza8t.Company.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2fdza8t.CompanyTable(tableRelation: foreignTableRelation),
    );
    return _company!;
  }

  _i2fdza8t.CompanyTable get oldCompany {
    if (_oldCompany != null) return _oldCompany!;
    _oldCompany = _is.createRelationTable(
      relationFieldName: 'oldCompany',
      field: Citizen.t.oldCompanyId,
      foreignField: _i2fdza8t.Company.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2fdza8t.CompanyTable(tableRelation: foreignTableRelation),
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

class CitizenInclude extends _is.IncludeObject {
  CitizenInclude._({
    _i5rzbc0r.AddressInclude? address,
    _i2fdza8t.CompanyInclude? company,
    _i2fdza8t.CompanyInclude? oldCompany,
    this.selectedColumns,
  }) {
    _address = address;
    _company = company;
    _oldCompany = oldCompany;
  }

  _i5rzbc0r.AddressInclude? _address;

  _i2fdza8t.CompanyInclude? _company;

  _i2fdza8t.CompanyInclude? _oldCompany;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'address': _address,
    'company': _company,
    'oldCompany': _oldCompany,
  };

  @override
  _is.Table<int?> get table => Citizen.t;
}

class CitizenIncludeList extends _is.IncludeList {
  CitizenIncludeList._({
    _is.WhereExpressionBuilder<CitizenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Citizen.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Citizen.t;
}

class CitizenRepository {
  const CitizenRepository._();

  final attachRow = const CitizenAttachRowRepository._();

  final detachRow = const CitizenDetachRowRepository._();

  /// Returns a list of [Citizen]s matching the given query parameters.
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
  Future<List<Citizen>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    _is.Transaction? transaction,
    CitizenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Citizen>(
      where: where?.call(Citizen.t),
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Citizen] matching the given query parameters.
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
  Future<Citizen?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenTable>? where,
    int? offset,
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    _is.Transaction? transaction,
    CitizenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Citizen>(
      where: where?.call(Citizen.t),
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Citizen] by its [id] or null if no such row exists.
  Future<Citizen?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CitizenInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Citizen>(
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
    _is.WhereExpressionBuilder<CitizenTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    _is.Transaction? transaction,
    CitizenInclude? include,
    _is.SelectColumnsBuilder<CitizenTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Citizen>(
      where: where?.call(Citizen.t),
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Citizen.t),
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
    _is.WhereExpressionBuilder<CitizenTable>? where,
    int? offset,
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    _is.Transaction? transaction,
    CitizenInclude? include,
    _is.SelectColumnsBuilder<CitizenTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Citizen>(
      where: where?.call(Citizen.t),
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Citizen.t),
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
    CitizenInclude? include,
    _is.SelectColumnsBuilder<CitizenTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Citizen>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Citizen.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Citizen]s in the list and returns the inserted rows.
  ///
  /// The returned [Citizen]s will have their `id` fields set.
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
  Future<List<Citizen>> insert(
    _is.DatabaseSession session,
    List<Citizen> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Citizen>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Citizen] and returns the inserted row.
  ///
  /// The returned [Citizen] will have its `id` field set.
  Future<Citizen> insertRow(
    _is.DatabaseSession session,
    Citizen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Citizen>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Citizen]s in the list and returns the resulting rows.
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
  /// The returned [Citizen]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Citizen>> upsert(
    _is.DatabaseSession session,
    List<Citizen> rows, {
    required _is.ColumnSelections<CitizenTable> conflictColumns,
    _is.ColumnSelections<CitizenTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Citizen>(
      rows,
      conflictColumns: conflictColumns(Citizen.t),
      updateColumns: updateColumns?.call(Citizen.t),
      updateWhere: updateWhere?.call(Citizen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Citizen] and returns the resulting row.
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
  /// The returned [Citizen] will have its `id` field set.
  Future<Citizen?> upsertRow(
    _is.DatabaseSession session,
    Citizen row, {
    required _is.ColumnSelections<CitizenTable> conflictColumns,
    _is.ColumnSelections<CitizenTable>? updateColumns,
    _is.WhereExpressionBuilder<CitizenTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Citizen>(
      row,
      conflictColumns: conflictColumns(Citizen.t),
      updateColumns: updateColumns?.call(Citizen.t),
      updateWhere: updateWhere?.call(Citizen.t),
      transaction: transaction,
    );
  }

  /// Updates all [Citizen]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Citizen>> update(
    _is.DatabaseSession session,
    List<Citizen> rows, {
    _is.ColumnSelections<CitizenTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Citizen>(
      rows,
      columns: columns?.call(Citizen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Citizen]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Citizen> updateRow(
    _is.DatabaseSession session,
    Citizen row, {
    _is.ColumnSelections<CitizenTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Citizen>(
      row,
      columns: columns?.call(Citizen.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Citizen] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Citizen?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CitizenUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Citizen>(
      id,
      columnValues: columnValues(Citizen.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Citizen]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Citizen>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CitizenUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CitizenTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Citizen>(
      columnValues: columnValues(Citizen.t.updateTable),
      where: where(Citizen.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Citizen]s in the list and returns the deleted rows.
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
  Future<List<Citizen>> delete(
    _is.DatabaseSession session,
    List<Citizen> rows, {
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Citizen>(
      rows,
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Citizen].
  Future<Citizen> deleteRow(
    _is.DatabaseSession session,
    Citizen row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Citizen>(
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
  Future<List<Citizen>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenTable> where,
    _is.OrderByBuilder<CitizenTable>? orderBy,
    _is.OrderByListBuilder<CitizenTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Citizen>(
      where: where(Citizen.t),
      orderBy: orderBy?.call(Citizen.t),
      orderByList: orderByList?.call(Citizen.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CitizenTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Citizen>(
      where: where?.call(Citizen.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Citizen] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CitizenTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Citizen>(
      where: where(Citizen.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CitizenAttachRowRepository {
  const CitizenAttachRowRepository._();

  /// Creates a relation between the given [Citizen] and [Address]
  /// by setting the [Citizen]'s foreign key `id` to refer to the [Address].
  Future<void> address(
    _is.DatabaseSession session,
    Citizen citizen,
    _i5rzbc0r.Address address, {
    _is.Transaction? transaction,
  }) async {
    if (address.id == null) {
      throw ArgumentError.notNull('address.id');
    }
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }

    var $address = address.copyWith(inhabitantId: citizen.id);
    await session.db.updateRow<_i5rzbc0r.Address>(
      $address,
      columns: [_i5rzbc0r.Address.t.inhabitantId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Citizen] and [Company]
  /// by setting the [Citizen]'s foreign key `companyId` to refer to the [Company].
  Future<void> company(
    _is.DatabaseSession session,
    Citizen citizen,
    _i2fdza8t.Company company, {
    _is.Transaction? transaction,
  }) async {
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }
    if (company.id == null) {
      throw ArgumentError.notNull('company.id');
    }

    var $citizen = citizen.copyWith(companyId: company.id);
    await session.db.updateRow<Citizen>(
      $citizen,
      columns: [Citizen.t.companyId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [Citizen] and [Company]
  /// by setting the [Citizen]'s foreign key `oldCompanyId` to refer to the [Company].
  Future<void> oldCompany(
    _is.DatabaseSession session,
    Citizen citizen,
    _i2fdza8t.Company oldCompany, {
    _is.Transaction? transaction,
  }) async {
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }
    if (oldCompany.id == null) {
      throw ArgumentError.notNull('oldCompany.id');
    }

    var $citizen = citizen.copyWith(oldCompanyId: oldCompany.id);
    await session.db.updateRow<Citizen>(
      $citizen,
      columns: [Citizen.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

class CitizenDetachRowRepository {
  const CitizenDetachRowRepository._();

  /// Detaches the relation between this [Citizen] and the [Address] set in `address`
  /// by setting the [Citizen]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> address(
    _is.DatabaseSession session,
    Citizen citizen, {
    _is.Transaction? transaction,
  }) async {
    var $address = citizen.address;

    if ($address == null) {
      throw ArgumentError.notNull('citizen.address');
    }
    if ($address.id == null) {
      throw ArgumentError.notNull('citizen.address.id');
    }
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }

    var $$address = $address.copyWith(inhabitantId: null);
    await session.db.updateRow<_i5rzbc0r.Address>(
      $$address,
      columns: [_i5rzbc0r.Address.t.inhabitantId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Citizen] and the [Company] set in `oldCompany`
  /// by setting the [Citizen]'s foreign key `oldCompanyId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> oldCompany(
    _is.DatabaseSession session,
    Citizen citizen, {
    _is.Transaction? transaction,
  }) async {
    if (citizen.id == null) {
      throw ArgumentError.notNull('citizen.id');
    }

    var $citizen = citizen.copyWith(oldCompanyId: null);
    await session.db.updateRow<Citizen>(
      $citizen,
      columns: [Citizen.t.oldCompanyId],
      transaction: transaction,
    );
  }
}

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
import '../models_with_list_relations/organization.dart' as _i0ptycc3;
import '../models_with_list_relations/person.dart' as _ijqkgw0m;

abstract class City implements _is.TableRow<int?>, _is.ProtocolSerialization {
  City._({
    this.id,
    required this.name,
    this.citizens,
    this.organizations,
  });

  factory City({
    int? id,
    required String name,
    List<_ijqkgw0m.Person>? citizens,
    List<_i0ptycc3.Organization>? organizations,
  }) = _CityImpl;

  factory City.fromJson(Map<String, dynamic> jsonSerialization) {
    return City(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      citizens: jsonSerialization['citizens'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_ijqkgw0m.Person>>(
              jsonSerialization['citizens'],
            ),
      organizations: jsonSerialization['organizations'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_i0ptycc3.Organization>>(
              jsonSerialization['organizations'],
            ),
    );
  }

  static final t = CityTable();

  static const db = CityRepository._();

  @override
  int? id;

  String name;

  List<_ijqkgw0m.Person>? citizens;

  List<_i0ptycc3.Organization>? organizations;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [City]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  City copyWith({
    int? id,
    String? name,
    List<_ijqkgw0m.Person>? citizens,
    List<_i0ptycc3.Organization>? organizations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'City',
      if (id != null) 'id': id,
      'name': name,
      if (citizens != null)
        'citizens': citizens?.toJson(valueToJson: (v) => v.toJson()),
      if (organizations != null)
        'organizations': organizations?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'City',
      if (id != null) 'id': id,
      'name': name,
      if (citizens != null)
        'citizens': citizens?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (organizations != null)
        'organizations': organizations?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static CityInclude include({
    _ijqkgw0m.PersonIncludeList? citizens,
    _i0ptycc3.OrganizationIncludeList? organizations,
    _is.SelectColumnsBuilder<CityTable>? select,
  }) {
    return CityInclude._(
      citizens: citizens,
      organizations: organizations,
      selectedColumns: select?.call(City.t),
    );
  }

  static CityIncludeList includeList({
    _is.WhereExpressionBuilder<CityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    CityInclude? include,
    _is.SelectColumnsBuilder<CityTable>? select,
  }) {
    return CityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      include: include,
      selectedColumns: select?.call(City.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CityImpl extends City {
  _CityImpl({
    int? id,
    required String name,
    List<_ijqkgw0m.Person>? citizens,
    List<_i0ptycc3.Organization>? organizations,
  }) : super._(
         id: id,
         name: name,
         citizens: citizens,
         organizations: organizations,
       );

  /// Returns a shallow copy of this [City]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  City copyWith({
    Object? id = _Undefined,
    String? name,
    Object? citizens = _Undefined,
    Object? organizations = _Undefined,
  }) {
    return City(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      citizens: citizens is List<_ijqkgw0m.Person>?
          ? citizens
          : this.citizens?.map((e0) => e0.copyWith()).toList(),
      organizations: organizations is List<_i0ptycc3.Organization>?
          ? organizations
          : this.organizations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CityUpdateTable extends _is.UpdateTable<CityTable> {
  CityUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class CityTable extends _is.Table<int?> {
  CityTable({super.tableRelation}) : super(tableName: 'city') {
    updateTable = CityUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final CityUpdateTable updateTable;

  late final _is.ColumnString name;

  _ijqkgw0m.PersonTable? ___citizens;

  _is.ManyRelation<_ijqkgw0m.PersonTable>? _citizens;

  _i0ptycc3.OrganizationTable? ___organizations;

  _is.ManyRelation<_i0ptycc3.OrganizationTable>? _organizations;

  _ijqkgw0m.PersonTable get __citizens {
    if (___citizens != null) return ___citizens!;
    ___citizens = _is.createRelationTable(
      relationFieldName: '__citizens',
      field: City.t.id,
      foreignField: _ijqkgw0m.Person.t.$_cityCitizensCityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ijqkgw0m.PersonTable(tableRelation: foreignTableRelation),
    );
    return ___citizens!;
  }

  _i0ptycc3.OrganizationTable get __organizations {
    if (___organizations != null) return ___organizations!;
    ___organizations = _is.createRelationTable(
      relationFieldName: '__organizations',
      field: City.t.id,
      foreignField: _i0ptycc3.Organization.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i0ptycc3.OrganizationTable(tableRelation: foreignTableRelation),
    );
    return ___organizations!;
  }

  _is.ManyRelation<_ijqkgw0m.PersonTable> get citizens {
    if (_citizens != null) return _citizens!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'citizens',
      field: City.t.id,
      foreignField: _ijqkgw0m.Person.t.$_cityCitizensCityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ijqkgw0m.PersonTable(tableRelation: foreignTableRelation),
    );
    _citizens = _is.ManyRelation<_ijqkgw0m.PersonTable>(
      tableWithRelations: relationTable,
      table: _ijqkgw0m.PersonTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _citizens!;
  }

  _is.ManyRelation<_i0ptycc3.OrganizationTable> get organizations {
    if (_organizations != null) return _organizations!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'organizations',
      field: City.t.id,
      foreignField: _i0ptycc3.Organization.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i0ptycc3.OrganizationTable(tableRelation: foreignTableRelation),
    );
    _organizations = _is.ManyRelation<_i0ptycc3.OrganizationTable>(
      tableWithRelations: relationTable,
      table: _i0ptycc3.OrganizationTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _organizations!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'citizens') {
      return __citizens;
    }
    if (relationField == 'organizations') {
      return __organizations;
    }
    return null;
  }
}

class CityInclude extends _is.IncludeObject {
  CityInclude._({
    _ijqkgw0m.PersonIncludeList? citizens,
    _i0ptycc3.OrganizationIncludeList? organizations,
    this.selectedColumns,
  }) {
    _citizens = citizens;
    _organizations = organizations;
  }

  _ijqkgw0m.PersonIncludeList? _citizens;

  _i0ptycc3.OrganizationIncludeList? _organizations;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'citizens': _citizens,
    'organizations': _organizations,
  };

  @override
  _is.Table<int?> get table => City.t;
}

class CityIncludeList extends _is.IncludeList {
  CityIncludeList._({
    _is.WhereExpressionBuilder<CityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(City.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => City.t;
}

class CityRepository {
  const CityRepository._();

  final attach = const CityAttachRepository._();

  final attachRow = const CityAttachRowRepository._();

  final detach = const CityDetachRepository._();

  final detachRow = const CityDetachRowRepository._();

  /// Returns a list of [City]s matching the given query parameters.
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
  Future<List<City>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    _is.Transaction? transaction,
    CityInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<City>(
      where: where?.call(City.t),
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [City] matching the given query parameters.
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
  Future<City?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CityTable>? where,
    int? offset,
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    _is.Transaction? transaction,
    CityInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<City>(
      where: where?.call(City.t),
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [City] by its [id] or null if no such row exists.
  Future<City?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CityInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<City>(
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
    _is.WhereExpressionBuilder<CityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    _is.Transaction? transaction,
    CityInclude? include,
    _is.SelectColumnsBuilder<CityTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<City>(
      where: where?.call(City.t),
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(City.t),
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
    _is.WhereExpressionBuilder<CityTable>? where,
    int? offset,
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    _is.Transaction? transaction,
    CityInclude? include,
    _is.SelectColumnsBuilder<CityTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<City>(
      where: where?.call(City.t),
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(City.t),
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
    CityInclude? include,
    _is.SelectColumnsBuilder<CityTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<City>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(City.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [City]s in the list and returns the inserted rows.
  ///
  /// The returned [City]s will have their `id` fields set.
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
  Future<List<City>> insert(
    _is.DatabaseSession session,
    List<City> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<City>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [City] and returns the inserted row.
  ///
  /// The returned [City] will have its `id` field set.
  Future<City> insertRow(
    _is.DatabaseSession session,
    City row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<City>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [City]s in the list and returns the resulting rows.
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
  /// The returned [City]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<City>> upsert(
    _is.DatabaseSession session,
    List<City> rows, {
    required _is.ColumnSelections<CityTable> conflictColumns,
    _is.ColumnSelections<CityTable>? updateColumns,
    _is.WhereExpressionBuilder<CityTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<City>(
      rows,
      conflictColumns: conflictColumns(City.t),
      updateColumns: updateColumns?.call(City.t),
      updateWhere: updateWhere?.call(City.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [City] and returns the resulting row.
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
  /// The returned [City] will have its `id` field set.
  Future<City?> upsertRow(
    _is.DatabaseSession session,
    City row, {
    required _is.ColumnSelections<CityTable> conflictColumns,
    _is.ColumnSelections<CityTable>? updateColumns,
    _is.WhereExpressionBuilder<CityTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<City>(
      row,
      conflictColumns: conflictColumns(City.t),
      updateColumns: updateColumns?.call(City.t),
      updateWhere: updateWhere?.call(City.t),
      transaction: transaction,
    );
  }

  /// Updates all [City]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<City>> update(
    _is.DatabaseSession session,
    List<City> rows, {
    _is.ColumnSelections<CityTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<City>(
      rows,
      columns: columns?.call(City.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [City]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<City> updateRow(
    _is.DatabaseSession session,
    City row, {
    _is.ColumnSelections<CityTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<City>(
      row,
      columns: columns?.call(City.t),
      transaction: transaction,
    );
  }

  /// Updates a single [City] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<City?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CityUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<City>(
      id,
      columnValues: columnValues(City.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [City]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<City>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CityUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CityTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<City>(
      columnValues: columnValues(City.t.updateTable),
      where: where(City.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [City]s in the list and returns the deleted rows.
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
  Future<List<City>> delete(
    _is.DatabaseSession session,
    List<City> rows, {
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<City>(
      rows,
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [City].
  Future<City> deleteRow(
    _is.DatabaseSession session,
    City row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<City>(
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
  Future<List<City>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CityTable> where,
    _is.OrderByBuilder<CityTable>? orderBy,
    _is.OrderByListBuilder<CityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<City>(
      where: where(City.t),
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CityTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<City>(
      where: where?.call(City.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [City] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CityTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<City>(
      where: where(City.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CityAttachRepository {
  const CityAttachRepository._();

  /// Creates a relation between this [City] and the given [Person]s
  /// by setting each [Person]'s foreign key `_cityCitizensCityId` to refer to this [City].
  Future<void> citizens(
    _is.DatabaseSession session,
    City city,
    List<_ijqkgw0m.Person> person, {
    _is.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $person = person
        .map(
          (e) => _ijqkgw0m.PersonImplicit(
            e,
            $_cityCitizensCityId: city.id,
          ),
        )
        .toList();
    await session.db.update<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [City] and the given [Organization]s
  /// by setting each [Organization]'s foreign key `cityId` to refer to this [City].
  Future<void> organizations(
    _is.DatabaseSession session,
    City city,
    List<_i0ptycc3.Organization> organization, {
    _is.Transaction? transaction,
  }) async {
    if (organization.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization = organization
        .map((e) => e.copyWith(cityId: city.id))
        .toList();
    await session.db.update<_i0ptycc3.Organization>(
      $organization,
      columns: [_i0ptycc3.Organization.t.cityId],
      transaction: transaction,
    );
  }
}

class CityAttachRowRepository {
  const CityAttachRowRepository._();

  /// Creates a relation between this [City] and the given [Person]
  /// by setting the [Person]'s foreign key `_cityCitizensCityId` to refer to this [City].
  Future<void> citizens(
    _is.DatabaseSession session,
    City city,
    _ijqkgw0m.Person person, {
    _is.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $person = _ijqkgw0m.PersonImplicit(
      person,
      $_cityCitizensCityId: city.id,
    );
    await session.db.updateRow<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [City] and the given [Organization]
  /// by setting the [Organization]'s foreign key `cityId` to refer to this [City].
  Future<void> organizations(
    _is.DatabaseSession session,
    City city,
    _i0ptycc3.Organization organization, {
    _is.Transaction? transaction,
  }) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization = organization.copyWith(cityId: city.id);
    await session.db.updateRow<_i0ptycc3.Organization>(
      $organization,
      columns: [_i0ptycc3.Organization.t.cityId],
      transaction: transaction,
    );
  }
}

class CityDetachRepository {
  const CityDetachRepository._();

  /// Detaches the relation between this [City] and the given [Person]
  /// by setting the [Person]'s foreign key `_cityCitizensCityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> citizens(
    _is.DatabaseSession session,
    List<_ijqkgw0m.Person> person, {
    _is.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person
        .map(
          (e) => _ijqkgw0m.PersonImplicit(
            e,
            $_cityCitizensCityId: null,
          ),
        )
        .toList();
    await session.db.update<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [City] and the given [Organization]
  /// by setting the [Organization]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organizations(
    _is.DatabaseSession session,
    List<_i0ptycc3.Organization> organization, {
    _is.Transaction? transaction,
  }) async {
    if (organization.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization = organization
        .map((e) => e.copyWith(cityId: null))
        .toList();
    await session.db.update<_i0ptycc3.Organization>(
      $organization,
      columns: [_i0ptycc3.Organization.t.cityId],
      transaction: transaction,
    );
  }
}

class CityDetachRowRepository {
  const CityDetachRowRepository._();

  /// Detaches the relation between this [City] and the given [Person]
  /// by setting the [Person]'s foreign key `_cityCitizensCityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> citizens(
    _is.DatabaseSession session,
    _ijqkgw0m.Person person, {
    _is.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = _ijqkgw0m.PersonImplicit(
      person,
      $_cityCitizensCityId: null,
    );
    await session.db.updateRow<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [City] and the given [Organization]
  /// by setting the [Organization]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organizations(
    _is.DatabaseSession session,
    _i0ptycc3.Organization organization, {
    _is.Transaction? transaction,
  }) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization = organization.copyWith(cityId: null);
    await session.db.updateRow<_i0ptycc3.Organization>(
      $organization,
      columns: [_i0ptycc3.Organization.t.cityId],
      transaction: transaction,
    );
  }
}

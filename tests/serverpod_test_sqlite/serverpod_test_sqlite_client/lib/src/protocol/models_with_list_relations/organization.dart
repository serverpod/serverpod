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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../models_with_list_relations/city.dart' as _i64066zp;
import '../models_with_list_relations/person.dart' as _ijqkgw0m;

abstract class Organization
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  Organization._({
    this.id,
    required this.name,
    this.people,
    this.cityId,
    this.city,
  });

  factory Organization({
    int? id,
    required String name,
    List<_ijqkgw0m.Person>? people,
    int? cityId,
    _i64066zp.City? city,
  }) = _OrganizationImpl;

  factory Organization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Organization(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      people: jsonSerialization['people'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_ijqkgw0m.Person>>(
              jsonSerialization['people'],
            ),
      cityId: jsonSerialization['cityId'] as int?,
      city: jsonSerialization['city'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_i64066zp.City>(
              jsonSerialization['city'],
            ),
    );
  }

  static final t = OrganizationTable();

  static const db = OrganizationRepository._();

  @override
  int? id;

  String name;

  List<_ijqkgw0m.Person>? people;

  int? cityId;

  _i64066zp.City? city;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Organization copyWith({
    int? id,
    String? name,
    List<_ijqkgw0m.Person>? people,
    int? cityId,
    _i64066zp.City? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Organization',
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJson()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Organization',
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJsonForProtocol(),
    };
  }

  static OrganizationInclude include({
    _ijqkgw0m.PersonIncludeList? people,
    _i64066zp.CityInclude? city,
    _isd.SelectColumnsBuilder<OrganizationTable>? select,
  }) {
    return OrganizationInclude._(
      people: people,
      city: city,
      selectedColumns: select?.call(Organization.t),
    );
  }

  static OrganizationIncludeList includeList({
    _isd.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    OrganizationInclude? include,
    _isd.SelectColumnsBuilder<OrganizationTable>? select,
  }) {
    return OrganizationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      include: include,
      selectedColumns: select?.call(Organization.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    required String name,
    List<_ijqkgw0m.Person>? people,
    int? cityId,
    _i64066zp.City? city,
  }) : super._(
         id: id,
         name: name,
         people: people,
         cityId: cityId,
         city: city,
       );

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Organization copyWith({
    Object? id = _Undefined,
    String? name,
    Object? people = _Undefined,
    Object? cityId = _Undefined,
    Object? city = _Undefined,
  }) {
    return Organization(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      people: people is List<_ijqkgw0m.Person>?
          ? people
          : this.people?.map((e0) => e0.copyWith()).toList(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _i64066zp.City? ? city : this.city?.copyWith(),
    );
  }
}

class OrganizationUpdateTable extends _isd.UpdateTable<OrganizationTable> {
  OrganizationUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );

  _isd.ColumnValue<int, int> cityId(int? value) => _isd.ColumnValue(
    table.cityId,
    value,
  );
}

class OrganizationTable extends _isd.Table<int?> {
  OrganizationTable({super.tableRelation}) : super(tableName: 'organization') {
    updateTable = OrganizationUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
    cityId = _isd.ColumnInt(
      'cityId',
      this,
    );
  }

  late final OrganizationUpdateTable updateTable;

  late final _isd.ColumnString name;

  _ijqkgw0m.PersonTable? ___people;

  _isd.ManyRelation<_ijqkgw0m.PersonTable>? _people;

  late final _isd.ColumnInt cityId;

  _i64066zp.CityTable? _city;

  _ijqkgw0m.PersonTable get __people {
    if (___people != null) return ___people!;
    ___people = _isd.createRelationTable(
      relationFieldName: '__people',
      field: Organization.t.id,
      foreignField: _ijqkgw0m.Person.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ijqkgw0m.PersonTable(tableRelation: foreignTableRelation),
    );
    return ___people!;
  }

  _i64066zp.CityTable get city {
    if (_city != null) return _city!;
    _city = _isd.createRelationTable(
      relationFieldName: 'city',
      field: Organization.t.cityId,
      foreignField: _i64066zp.City.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i64066zp.CityTable(tableRelation: foreignTableRelation),
    );
    return _city!;
  }

  _isd.ManyRelation<_ijqkgw0m.PersonTable> get people {
    if (_people != null) return _people!;
    var relationTable = _isd.createRelationTable(
      relationFieldName: 'people',
      field: Organization.t.id,
      foreignField: _ijqkgw0m.Person.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ijqkgw0m.PersonTable(tableRelation: foreignTableRelation),
    );
    _people = _isd.ManyRelation<_ijqkgw0m.PersonTable>(
      tableWithRelations: relationTable,
      table: _ijqkgw0m.PersonTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _people!;
  }

  @override
  List<_isd.Column> get columns => [
    id,
    name,
    cityId,
  ];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'people') {
      return __people;
    }
    if (relationField == 'city') {
      return city;
    }
    return null;
  }
}

class OrganizationInclude extends _isd.IncludeObject {
  OrganizationInclude._({
    _ijqkgw0m.PersonIncludeList? people,
    _i64066zp.CityInclude? city,
    this.selectedColumns,
  }) {
    _people = people;
    _city = city;
  }

  _ijqkgw0m.PersonIncludeList? _people;

  _i64066zp.CityInclude? _city;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {
    'people': _people,
    'city': _city,
  };

  @override
  _isd.Table<int?> get table => Organization.t;
}

class OrganizationIncludeList extends _isd.IncludeList {
  OrganizationIncludeList._({
    _isd.WhereExpressionBuilder<OrganizationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Organization.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => Organization.t;
}

class OrganizationRepository {
  const OrganizationRepository._();

  final attach = const OrganizationAttachRepository._();

  final attachRow = const OrganizationAttachRowRepository._();

  final detach = const OrganizationDetachRepository._();

  final detachRow = const OrganizationDetachRowRepository._();

  /// Returns a list of [Organization]s matching the given query parameters.
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
  Future<List<Organization>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    _isd.Transaction? transaction,
    OrganizationInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Organization] matching the given query parameters.
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
  Future<Organization?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    _isd.Transaction? transaction,
    OrganizationInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Organization] by its [id] or null if no such row exists.
  Future<Organization?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    OrganizationInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Organization>(
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

  Future<List<Map<String, dynamic>>> findAsJson(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    _isd.Transaction? transaction,
    OrganizationInclude? include,
    _isd.SelectColumnsBuilder<OrganizationTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Organization.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    _isd.Transaction? transaction,
    OrganizationInclude? include,
    _isd.SelectColumnsBuilder<OrganizationTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Organization.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    OrganizationInclude? include,
    _isd.SelectColumnsBuilder<OrganizationTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Organization>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Organization.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Organization]s in the list and returns the inserted rows.
  ///
  /// The returned [Organization]s will have their `id` fields set.
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
  Future<List<Organization>> insert(
    _isd.DatabaseSession session,
    List<Organization> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Organization>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Organization] and returns the inserted row.
  ///
  /// The returned [Organization] will have its `id` field set.
  Future<Organization> insertRow(
    _isd.DatabaseSession session,
    Organization row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Organization]s in the list and returns the resulting rows.
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
  /// The returned [Organization]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Organization>> upsert(
    _isd.DatabaseSession session,
    List<Organization> rows, {
    required _isd.ColumnSelections<OrganizationTable> conflictColumns,
    _isd.ColumnSelections<OrganizationTable>? updateColumns,
    _isd.WhereExpressionBuilder<OrganizationTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Organization>(
      rows,
      conflictColumns: conflictColumns(Organization.t),
      updateColumns: updateColumns?.call(Organization.t),
      updateWhere: updateWhere?.call(Organization.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Organization] and returns the resulting row.
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
  /// The returned [Organization] will have its `id` field set.
  Future<Organization?> upsertRow(
    _isd.DatabaseSession session,
    Organization row, {
    required _isd.ColumnSelections<OrganizationTable> conflictColumns,
    _isd.ColumnSelections<OrganizationTable>? updateColumns,
    _isd.WhereExpressionBuilder<OrganizationTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Organization>(
      row,
      conflictColumns: conflictColumns(Organization.t),
      updateColumns: updateColumns?.call(Organization.t),
      updateWhere: updateWhere?.call(Organization.t),
      transaction: transaction,
    );
  }

  /// Updates all [Organization]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Organization>> update(
    _isd.DatabaseSession session,
    List<Organization> rows, {
    _isd.ColumnSelections<OrganizationTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Organization>(
      rows,
      columns: columns?.call(Organization.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Organization]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Organization> updateRow(
    _isd.DatabaseSession session,
    Organization row, {
    _isd.ColumnSelections<OrganizationTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<Organization>(
      row,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Organization] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Organization?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<OrganizationUpdateTable> columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<Organization>(
      id,
      columnValues: columnValues(Organization.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Organization]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Organization>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<OrganizationUpdateTable> columnValues,
    required _isd.WhereExpressionBuilder<OrganizationTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Organization>(
      columnValues: columnValues(Organization.t.updateTable),
      where: where(Organization.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Organization]s in the list and returns the deleted rows.
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
  Future<List<Organization>> delete(
    _isd.DatabaseSession session,
    List<Organization> rows, {
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Organization>(
      rows,
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Organization].
  Future<Organization> deleteRow(
    _isd.DatabaseSession session,
    Organization row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Organization>(
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
  Future<List<Organization>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OrganizationTable> where,
    _isd.OrderByBuilder<OrganizationTable>? orderBy,
    _isd.OrderByListBuilder<OrganizationTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Organization>(
      where: where(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<Organization>(
      where: where?.call(Organization.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Organization] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<OrganizationTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Organization>(
      where: where(Organization.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class OrganizationAttachRepository {
  const OrganizationAttachRepository._();

  /// Creates a relation between this [Organization] and the given [Person]s
  /// by setting each [Person]'s foreign key `organizationId` to refer to this [Organization].
  Future<void> people(
    _isd.DatabaseSession session,
    Organization organization,
    List<_ijqkgw0m.Person> person, {
    _isd.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $person = person
        .map((e) => e.copyWith(organizationId: organization.id))
        .toList();
    await session.db.update<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationAttachRowRepository {
  const OrganizationAttachRowRepository._();

  /// Creates a relation between the given [Organization] and [City]
  /// by setting the [Organization]'s foreign key `cityId` to refer to the [City].
  Future<void> city(
    _isd.DatabaseSession session,
    Organization organization,
    _i64066zp.City city, {
    _isd.Transaction? transaction,
  }) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization = organization.copyWith(cityId: city.id);
    await session.db.updateRow<Organization>(
      $organization,
      columns: [Organization.t.cityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Organization] and the given [Person]
  /// by setting the [Person]'s foreign key `organizationId` to refer to this [Organization].
  Future<void> people(
    _isd.DatabaseSession session,
    Organization organization,
    _ijqkgw0m.Person person, {
    _isd.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $person = person.copyWith(organizationId: organization.id);
    await session.db.updateRow<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationDetachRepository {
  const OrganizationDetachRepository._();

  /// Detaches the relation between this [Organization] and the given [Person]
  /// by setting the [Person]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> people(
    _isd.DatabaseSession session,
    List<_ijqkgw0m.Person> person, {
    _isd.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.map((e) => e.copyWith(organizationId: null)).toList();
    await session.db.update<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationDetachRowRepository {
  const OrganizationDetachRowRepository._();

  /// Detaches the relation between this [Organization] and the [City] set in `city`
  /// by setting the [Organization]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> city(
    _isd.DatabaseSession session,
    Organization organization, {
    _isd.Transaction? transaction,
  }) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization = organization.copyWith(cityId: null);
    await session.db.updateRow<Organization>(
      $organization,
      columns: [Organization.t.cityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Organization] and the given [Person]
  /// by setting the [Person]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> people(
    _isd.DatabaseSession session,
    _ijqkgw0m.Person person, {
    _isd.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.copyWith(organizationId: null);
    await session.db.updateRow<_ijqkgw0m.Person>(
      $person,
      columns: [_ijqkgw0m.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

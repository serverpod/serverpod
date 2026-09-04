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
import '../models_with_list_relations/city.dart' as _i64066zp;
import '../models_with_list_relations/person.dart' as _ijqkgw0m;

abstract class Organization
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
          : _igqrxdcj.Protocol().deserialize<List<_ijqkgw0m.Person>>(
              jsonSerialization['people'],
            ),
      cityId: jsonSerialization['cityId'] as int?,
      city: jsonSerialization['city'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i64066zp.City>(
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
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  /// Builds a complete [OrganizationInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static OrganizationInclude include({
    _ijqkgw0m.PersonIncludeList? people,
    _i64066zp.CityInclude? city,
  }) {
    return OrganizationInclude._(
      people: people,
      city: city,
    );
  }

  /// Builds a complete [OrganizationIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static OrganizationIncludeList includeList({
    _is.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    OrganizationInclude? include,
  }) {
    return OrganizationIncludeList._(
      where: where?.call(Organization.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [OrganizationJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static OrganizationJsonInclude includeJson({
    _ijqkgw0m.PersonJsonIncludeList? people,
    _i64066zp.CityJsonInclude? city,
    _is.SelectColumnsBuilder<OrganizationTable>? select,
  }) {
    return _OrganizationJsonInclude._(
      people: people,
      city: city,
      selectedColumns: select?.call(Organization.t),
    );
  }

  /// Builds a JSON-compatible [OrganizationJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static OrganizationJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    OrganizationJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationTable>? select,
  }) {
    return _OrganizationJsonIncludeList._(
      where: where?.call(Organization.t),
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
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class OrganizationUpdateTable extends _is.UpdateTable<OrganizationTable> {
  OrganizationUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> cityId(int? value) => _is.ColumnValue(
    table.cityId,
    value,
  );
}

class OrganizationTable extends _is.Table<int?> {
  OrganizationTable({super.tableRelation}) : super(tableName: 'organization') {
    updateTable = OrganizationUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    cityId = _is.ColumnInt(
      'cityId',
      this,
    );
  }

  late final OrganizationUpdateTable updateTable;

  late final _is.ColumnString name;

  _ijqkgw0m.PersonTable? ___people;

  _is.ManyRelation<_ijqkgw0m.PersonTable>? _people;

  late final _is.ColumnInt cityId;

  _i64066zp.CityTable? _city;

  _ijqkgw0m.PersonTable get __people {
    if (___people != null) return ___people!;
    ___people = _is.createRelationTable(
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
    _city = _is.createRelationTable(
      relationFieldName: 'city',
      field: Organization.t.cityId,
      foreignField: _i64066zp.City.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i64066zp.CityTable(tableRelation: foreignTableRelation),
    );
    return _city!;
  }

  _is.ManyRelation<_ijqkgw0m.PersonTable> get people {
    if (_people != null) return _people!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'people',
      field: Organization.t.id,
      foreignField: _ijqkgw0m.Person.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ijqkgw0m.PersonTable(tableRelation: foreignTableRelation),
    );
    _people = _is.ManyRelation<_ijqkgw0m.PersonTable>(
      tableWithRelations: relationTable,
      table: _ijqkgw0m.PersonTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _people!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    cityId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'people') {
      return __people;
    }
    if (relationField == 'city') {
      return city;
    }
    return null;
  }
}

abstract interface class OrganizationJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class OrganizationJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class OrganizationInclude extends _is.IncludeObject
    implements OrganizationJsonInclude, _is.FullModelInclude {
  OrganizationInclude._({
    _ijqkgw0m.PersonIncludeList? people,
    _i64066zp.CityInclude? city,
  }) {
    _people = people;
    _city = city;
  }

  _ijqkgw0m.PersonIncludeList? _people;

  _i64066zp.CityInclude? _city;

  @override
  Map<String, _is.Include?> get includes => {
    'people': _people,
    'city': _city,
  };

  @override
  _is.Table<int?> get table => Organization.t;
}

final class OrganizationIncludeList extends _is.IncludeList
    implements OrganizationJsonIncludeList, _is.FullModelInclude {
  OrganizationIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    OrganizationInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Organization.t;
}

final class _OrganizationJsonInclude extends _is.IncludeObject
    implements OrganizationJsonInclude {
  _OrganizationJsonInclude._({
    _ijqkgw0m.PersonJsonIncludeList? people,
    _i64066zp.CityJsonInclude? city,
    this.selectedColumns,
  }) {
    _people = people;
    _city = city;
  }

  _ijqkgw0m.PersonJsonIncludeList? _people;

  _i64066zp.CityJsonInclude? _city;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'people': _people,
    'city': _city,
  };

  @override
  _is.Table<int?> get table => Organization.t;
}

final class _OrganizationJsonIncludeList extends _is.IncludeList
    implements OrganizationJsonIncludeList {
  _OrganizationJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    OrganizationJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Organization.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    OrganizationInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    OrganizationJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
    _is.DatabaseSession session,
    List<Organization> rows, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Organization row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Organization> rows, {
    required _is.ColumnSelections<OrganizationTable> conflictColumns,
    _is.ColumnSelections<OrganizationTable>? updateColumns,
    _is.WhereExpressionBuilder<OrganizationTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Organization row, {
    required _is.ColumnSelections<OrganizationTable> conflictColumns,
    _is.ColumnSelections<OrganizationTable>? updateColumns,
    _is.WhereExpressionBuilder<OrganizationTable>? updateWhere,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Organization> rows, {
    _is.ColumnSelections<OrganizationTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Organization row, {
    _is.ColumnSelections<OrganizationTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<OrganizationUpdateTable> columnValues,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<OrganizationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<OrganizationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<Organization> rows, {
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Organization row, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrganizationTable> where,
    _is.OrderByBuilder<OrganizationTable>? orderBy,
    _is.OrderByListBuilder<OrganizationTable>? orderByList,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Organization>(
      where: where?.call(Organization.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Organization] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrganizationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
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
    _is.DatabaseSession session,
    Organization organization,
    List<_ijqkgw0m.Person> person, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Organization organization,
    _i64066zp.City city, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Organization organization,
    _ijqkgw0m.Person person, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    List<_ijqkgw0m.Person> person, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Organization organization, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    _ijqkgw0m.Person person, {
    _is.Transaction? transaction,
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

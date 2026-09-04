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
import '../../long_identifiers/deep_includes/city_with_long_table_name.dart'
    as _ii8bs4lb;
import '../../long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i5nficvp;

abstract class OrganizationWithLongTableName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  OrganizationWithLongTableName._({
    this.id,
    required this.name,
    this.people,
    this.cityId,
    this.city,
  });

  factory OrganizationWithLongTableName({
    int? id,
    required String name,
    List<_i5nficvp.PersonWithLongTableName>? people,
    int? cityId,
    _ii8bs4lb.CityWithLongTableName? city,
  }) = _OrganizationWithLongTableNameImpl;

  factory OrganizationWithLongTableName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return OrganizationWithLongTableName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      people: jsonSerialization['people'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<List<_i5nficvp.PersonWithLongTableName>>(
                  jsonSerialization['people'],
                ),
      cityId: jsonSerialization['cityId'] as int?,
      city: jsonSerialization['city'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ii8bs4lb.CityWithLongTableName>(
              jsonSerialization['city'],
            ),
    );
  }

  static final t = OrganizationWithLongTableNameTable();

  static const db = OrganizationWithLongTableNameRepository._();

  @override
  int? id;

  String name;

  List<_i5nficvp.PersonWithLongTableName>? people;

  int? cityId;

  _ii8bs4lb.CityWithLongTableName? city;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [OrganizationWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  OrganizationWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i5nficvp.PersonWithLongTableName>? people,
    int? cityId,
    _ii8bs4lb.CityWithLongTableName? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'OrganizationWithLongTableName',
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
      '__className__': 'OrganizationWithLongTableName',
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [OrganizationWithLongTableNameInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static OrganizationWithLongTableNameInclude include({
    _i5nficvp.PersonWithLongTableNameIncludeList? people,
    _ii8bs4lb.CityWithLongTableNameInclude? city,
  }) {
    return OrganizationWithLongTableNameInclude._(
      people: people,
      city: city,
    );
  }

  /// Builds a complete [OrganizationWithLongTableNameIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static OrganizationWithLongTableNameIncludeList includeList({
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    OrganizationWithLongTableNameInclude? include,
  }) {
    return OrganizationWithLongTableNameIncludeList._(
      where: where?.call(OrganizationWithLongTableName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [OrganizationWithLongTableNameJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static OrganizationWithLongTableNameJsonInclude includeJson({
    _i5nficvp.PersonWithLongTableNameJsonIncludeList? people,
    _ii8bs4lb.CityWithLongTableNameJsonInclude? city,
    _is.SelectColumnsBuilder<OrganizationWithLongTableNameTable>? select,
  }) {
    return _OrganizationWithLongTableNameJsonInclude._(
      people: people,
      city: city,
      selectedColumns: select?.call(OrganizationWithLongTableName.t),
    );
  }

  /// Builds a JSON-compatible [OrganizationWithLongTableNameJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static OrganizationWithLongTableNameJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    OrganizationWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationWithLongTableNameTable>? select,
  }) {
    return _OrganizationWithLongTableNameJsonIncludeList._(
      where: where?.call(OrganizationWithLongTableName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      include: include,
      selectedColumns: select?.call(OrganizationWithLongTableName.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationWithLongTableNameImpl extends OrganizationWithLongTableName {
  _OrganizationWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i5nficvp.PersonWithLongTableName>? people,
    int? cityId,
    _ii8bs4lb.CityWithLongTableName? city,
  }) : super._(
         id: id,
         name: name,
         people: people,
         cityId: cityId,
         city: city,
       );

  /// Returns a shallow copy of this [OrganizationWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  OrganizationWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? people = _Undefined,
    Object? cityId = _Undefined,
    Object? city = _Undefined,
  }) {
    return OrganizationWithLongTableName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      people: people is List<_i5nficvp.PersonWithLongTableName>?
          ? people
          : this.people?.map((e0) => e0.copyWith()).toList(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _ii8bs4lb.CityWithLongTableName?
          ? city
          : this.city?.copyWith(),
    );
  }
}

class OrganizationWithLongTableNameUpdateTable
    extends _is.UpdateTable<OrganizationWithLongTableNameTable> {
  OrganizationWithLongTableNameUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> cityId(int? value) => _is.ColumnValue(
    table.cityId,
    value,
  );
}

class OrganizationWithLongTableNameTable extends _is.Table<int?> {
  OrganizationWithLongTableNameTable({super.tableRelation})
    : super(
        tableName: 'organization_with_long_table_name_that_is_still_valid',
      ) {
    updateTable = OrganizationWithLongTableNameUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    cityId = _is.ColumnInt(
      'cityId',
      this,
    );
  }

  late final OrganizationWithLongTableNameUpdateTable updateTable;

  late final _is.ColumnString name;

  _i5nficvp.PersonWithLongTableNameTable? ___people;

  _is.ManyRelation<_i5nficvp.PersonWithLongTableNameTable>? _people;

  late final _is.ColumnInt cityId;

  _ii8bs4lb.CityWithLongTableNameTable? _city;

  _i5nficvp.PersonWithLongTableNameTable get __people {
    if (___people != null) return ___people!;
    ___people = _is.createRelationTable(
      relationFieldName: '__people',
      field: OrganizationWithLongTableName.t.id,
      foreignField: _i5nficvp.PersonWithLongTableName.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5nficvp.PersonWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___people!;
  }

  _ii8bs4lb.CityWithLongTableNameTable get city {
    if (_city != null) return _city!;
    _city = _is.createRelationTable(
      relationFieldName: 'city',
      field: OrganizationWithLongTableName.t.cityId,
      foreignField: _ii8bs4lb.CityWithLongTableName.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ii8bs4lb.CityWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return _city!;
  }

  _is.ManyRelation<_i5nficvp.PersonWithLongTableNameTable> get people {
    if (_people != null) return _people!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'people',
      field: OrganizationWithLongTableName.t.id,
      foreignField: _i5nficvp.PersonWithLongTableName.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5nficvp.PersonWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _people = _is.ManyRelation<_i5nficvp.PersonWithLongTableNameTable>(
      tableWithRelations: relationTable,
      table: _i5nficvp.PersonWithLongTableNameTable(
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

abstract interface class OrganizationWithLongTableNameJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class OrganizationWithLongTableNameJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class OrganizationWithLongTableNameInclude extends _is.IncludeObject
    implements OrganizationWithLongTableNameJsonInclude, _is.FullModelInclude {
  OrganizationWithLongTableNameInclude._({
    _i5nficvp.PersonWithLongTableNameIncludeList? people,
    _ii8bs4lb.CityWithLongTableNameInclude? city,
  }) {
    _people = people;
    _city = city;
  }

  _i5nficvp.PersonWithLongTableNameIncludeList? _people;

  _ii8bs4lb.CityWithLongTableNameInclude? _city;

  @override
  Map<String, _is.Include?> get includes => {
    'people': _people,
    'city': _city,
  };

  @override
  _is.Table<int?> get table => OrganizationWithLongTableName.t;
}

final class OrganizationWithLongTableNameIncludeList extends _is.IncludeList
    implements
        OrganizationWithLongTableNameJsonIncludeList,
        _is.FullModelInclude {
  OrganizationWithLongTableNameIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    OrganizationWithLongTableNameInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => OrganizationWithLongTableName.t;
}

final class _OrganizationWithLongTableNameJsonInclude extends _is.IncludeObject
    implements OrganizationWithLongTableNameJsonInclude {
  _OrganizationWithLongTableNameJsonInclude._({
    _i5nficvp.PersonWithLongTableNameJsonIncludeList? people,
    _ii8bs4lb.CityWithLongTableNameJsonInclude? city,
    this.selectedColumns,
  }) {
    _people = people;
    _city = city;
  }

  _i5nficvp.PersonWithLongTableNameJsonIncludeList? _people;

  _ii8bs4lb.CityWithLongTableNameJsonInclude? _city;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'people': _people,
    'city': _city,
  };

  @override
  _is.Table<int?> get table => OrganizationWithLongTableName.t;
}

final class _OrganizationWithLongTableNameJsonIncludeList
    extends _is.IncludeList
    implements OrganizationWithLongTableNameJsonIncludeList {
  _OrganizationWithLongTableNameJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    OrganizationWithLongTableNameJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => OrganizationWithLongTableName.t;
}

class OrganizationWithLongTableNameRepository {
  const OrganizationWithLongTableNameRepository._();

  final attach = const OrganizationWithLongTableNameAttachRepository._();

  final attachRow = const OrganizationWithLongTableNameAttachRowRepository._();

  final detach = const OrganizationWithLongTableNameDetachRepository._();

  final detachRow = const OrganizationWithLongTableNameDetachRowRepository._();

  /// Returns a list of [OrganizationWithLongTableName]s matching the given query parameters.
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
  Future<List<OrganizationWithLongTableName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [OrganizationWithLongTableName] matching the given query parameters.
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
  Future<OrganizationWithLongTableName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? offset,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [OrganizationWithLongTableName] by its [id] or null if no such row exists.
  Future<OrganizationWithLongTableName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<OrganizationWithLongTableName>(
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
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationWithLongTableNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(OrganizationWithLongTableName.t),
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
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? offset,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    OrganizationWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationWithLongTableNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(OrganizationWithLongTableName.t),
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
    OrganizationWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<OrganizationWithLongTableNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<OrganizationWithLongTableName>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(OrganizationWithLongTableName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [OrganizationWithLongTableName]s in the list and returns the inserted rows.
  ///
  /// The returned [OrganizationWithLongTableName]s will have their `id` fields set.
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
  Future<List<OrganizationWithLongTableName>> insert(
    _is.DatabaseSession session,
    List<OrganizationWithLongTableName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<OrganizationWithLongTableName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [OrganizationWithLongTableName] and returns the inserted row.
  ///
  /// The returned [OrganizationWithLongTableName] will have its `id` field set.
  Future<OrganizationWithLongTableName> insertRow(
    _is.DatabaseSession session,
    OrganizationWithLongTableName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrganizationWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [OrganizationWithLongTableName]s in the list and returns the resulting rows.
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
  /// The returned [OrganizationWithLongTableName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrganizationWithLongTableName>> upsert(
    _is.DatabaseSession session,
    List<OrganizationWithLongTableName> rows, {
    required _is.ColumnSelections<OrganizationWithLongTableNameTable>
    conflictColumns,
    _is.ColumnSelections<OrganizationWithLongTableNameTable>? updateColumns,
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<OrganizationWithLongTableName>(
      rows,
      conflictColumns: conflictColumns(OrganizationWithLongTableName.t),
      updateColumns: updateColumns?.call(OrganizationWithLongTableName.t),
      updateWhere: updateWhere?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [OrganizationWithLongTableName] and returns the resulting row.
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
  /// The returned [OrganizationWithLongTableName] will have its `id` field set.
  Future<OrganizationWithLongTableName?> upsertRow(
    _is.DatabaseSession session,
    OrganizationWithLongTableName row, {
    required _is.ColumnSelections<OrganizationWithLongTableNameTable>
    conflictColumns,
    _is.ColumnSelections<OrganizationWithLongTableNameTable>? updateColumns,
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<OrganizationWithLongTableName>(
      row,
      conflictColumns: conflictColumns(OrganizationWithLongTableName.t),
      updateColumns: updateColumns?.call(OrganizationWithLongTableName.t),
      updateWhere: updateWhere?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Updates all [OrganizationWithLongTableName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrganizationWithLongTableName>> update(
    _is.DatabaseSession session,
    List<OrganizationWithLongTableName> rows, {
    _is.ColumnSelections<OrganizationWithLongTableNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<OrganizationWithLongTableName>(
      rows,
      columns: columns?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [OrganizationWithLongTableName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrganizationWithLongTableName> updateRow(
    _is.DatabaseSession session,
    OrganizationWithLongTableName row, {
    _is.ColumnSelections<OrganizationWithLongTableNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrganizationWithLongTableName>(
      row,
      columns: columns?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrganizationWithLongTableName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<OrganizationWithLongTableName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<
      OrganizationWithLongTableNameUpdateTable
    >
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<OrganizationWithLongTableName>(
      id,
      columnValues: columnValues(OrganizationWithLongTableName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [OrganizationWithLongTableName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<OrganizationWithLongTableName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<
      OrganizationWithLongTableNameUpdateTable
    >
    columnValues,
    required _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>
    where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<OrganizationWithLongTableName>(
      columnValues: columnValues(OrganizationWithLongTableName.t.updateTable),
      where: where(OrganizationWithLongTableName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [OrganizationWithLongTableName]s in the list and returns the deleted rows.
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
  Future<List<OrganizationWithLongTableName>> delete(
    _is.DatabaseSession session,
    List<OrganizationWithLongTableName> rows, {
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<OrganizationWithLongTableName>(
      rows,
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [OrganizationWithLongTableName].
  Future<OrganizationWithLongTableName> deleteRow(
    _is.DatabaseSession session,
    OrganizationWithLongTableName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrganizationWithLongTableName>(
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
  Future<List<OrganizationWithLongTableName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>
    where,
    _is.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<OrganizationWithLongTableName>(
      where: where(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [OrganizationWithLongTableName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<OrganizationWithLongTableNameTable>
    where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<OrganizationWithLongTableName>(
      where: where(OrganizationWithLongTableName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameAttachRepository {
  const OrganizationWithLongTableNameAttachRepository._();

  /// Creates a relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]s
  /// by setting each [PersonWithLongTableName]'s foreign key `organizationId` to refer to this [OrganizationWithLongTableName].
  Future<void> people(
    _is.DatabaseSession session,
    OrganizationWithLongTableName organizationWithLongTableName,
    List<_i5nficvp.PersonWithLongTableName> personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map(
          (e) => e.copyWith(organizationId: organizationWithLongTableName.id),
        )
        .toList();
    await session.db.update<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i5nficvp.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameAttachRowRepository {
  const OrganizationWithLongTableNameAttachRowRepository._();

  /// Creates a relation between the given [OrganizationWithLongTableName] and [CityWithLongTableName]
  /// by setting the [OrganizationWithLongTableName]'s foreign key `cityId` to refer to the [CityWithLongTableName].
  Future<void> city(
    _is.DatabaseSession session,
    OrganizationWithLongTableName organizationWithLongTableName,
    _ii8bs4lb.CityWithLongTableName city, {
    _is.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName.copyWith(
      cityId: city.id,
    );
    await session.db.updateRow<OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to refer to this [OrganizationWithLongTableName].
  Future<void> people(
    _is.DatabaseSession session,
    OrganizationWithLongTableName organizationWithLongTableName,
    _i5nficvp.PersonWithLongTableName personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName.copyWith(
      organizationId: organizationWithLongTableName.id,
    );
    await session.db.updateRow<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i5nficvp.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameDetachRepository {
  const OrganizationWithLongTableNameDetachRepository._();

  /// Detaches the relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> people(
    _is.DatabaseSession session,
    List<_i5nficvp.PersonWithLongTableName> personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map((e) => e.copyWith(organizationId: null))
        .toList();
    await session.db.update<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i5nficvp.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameDetachRowRepository {
  const OrganizationWithLongTableNameDetachRowRepository._();

  /// Detaches the relation between this [OrganizationWithLongTableName] and the [CityWithLongTableName] set in `city`
  /// by setting the [OrganizationWithLongTableName]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> city(
    _is.DatabaseSession session,
    OrganizationWithLongTableName organizationWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName.copyWith(
      cityId: null,
    );
    await session.db.updateRow<OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> people(
    _is.DatabaseSession session,
    _i5nficvp.PersonWithLongTableName personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName.copyWith(
      organizationId: null,
    );
    await session.db.updateRow<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i5nficvp.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

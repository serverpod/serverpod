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
import '../../long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _imc5i9r4;
import '../../long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i5nficvp;

abstract class CityWithLongTableName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  CityWithLongTableName._({
    this.id,
    required this.name,
    this.citizens,
    this.organizations,
  });

  factory CityWithLongTableName({
    int? id,
    required String name,
    List<_i5nficvp.PersonWithLongTableName>? citizens,
    List<_imc5i9r4.OrganizationWithLongTableName>? organizations,
  }) = _CityWithLongTableNameImpl;

  factory CityWithLongTableName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CityWithLongTableName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      citizens: jsonSerialization['citizens'] == null
          ? null
          : _i08l111i.Protocol()
                .deserialize<List<_i5nficvp.PersonWithLongTableName>>(
                  jsonSerialization['citizens'],
                ),
      organizations: jsonSerialization['organizations'] == null
          ? null
          : _i08l111i.Protocol()
                .deserialize<List<_imc5i9r4.OrganizationWithLongTableName>>(
                  jsonSerialization['organizations'],
                ),
    );
  }

  static final t = CityWithLongTableNameTable();

  static const db = CityWithLongTableNameRepository._();

  @override
  int? id;

  String name;

  List<_i5nficvp.PersonWithLongTableName>? citizens;

  List<_imc5i9r4.OrganizationWithLongTableName>? organizations;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CityWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CityWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i5nficvp.PersonWithLongTableName>? citizens,
    List<_imc5i9r4.OrganizationWithLongTableName>? organizations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CityWithLongTableName',
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
      '__className__': 'CityWithLongTableName',
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

  /// Builds a complete [CityWithLongTableNameInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CityWithLongTableNameInclude include({
    _i5nficvp.PersonWithLongTableNameIncludeList? citizens,
    _imc5i9r4.OrganizationWithLongTableNameIncludeList? organizations,
  }) {
    return CityWithLongTableNameInclude._(
      citizens: citizens,
      organizations: organizations,
    );
  }

  /// Builds a complete [CityWithLongTableNameIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static CityWithLongTableNameIncludeList includeList({
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    CityWithLongTableNameInclude? include,
  }) {
    return CityWithLongTableNameIncludeList._(
      where: where?.call(CityWithLongTableName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [CityWithLongTableNameJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static CityWithLongTableNameJsonInclude includeJson({
    _i5nficvp.PersonWithLongTableNameJsonIncludeList? citizens,
    _imc5i9r4.OrganizationWithLongTableNameJsonIncludeList? organizations,
    _is.SelectColumnsBuilder<CityWithLongTableNameTable>? select,
  }) {
    return _CityWithLongTableNameJsonInclude._(
      citizens: citizens,
      organizations: organizations,
      selectedColumns: select?.call(CityWithLongTableName.t),
    );
  }

  /// Builds a JSON-compatible [CityWithLongTableNameJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static CityWithLongTableNameJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    CityWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<CityWithLongTableNameTable>? select,
  }) {
    return _CityWithLongTableNameJsonIncludeList._(
      where: where?.call(CityWithLongTableName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      include: include,
      selectedColumns: select?.call(CityWithLongTableName.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CityWithLongTableNameImpl extends CityWithLongTableName {
  _CityWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i5nficvp.PersonWithLongTableName>? citizens,
    List<_imc5i9r4.OrganizationWithLongTableName>? organizations,
  }) : super._(
         id: id,
         name: name,
         citizens: citizens,
         organizations: organizations,
       );

  /// Returns a shallow copy of this [CityWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CityWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? citizens = _Undefined,
    Object? organizations = _Undefined,
  }) {
    return CityWithLongTableName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      citizens: citizens is List<_i5nficvp.PersonWithLongTableName>?
          ? citizens
          : this.citizens?.map((e0) => e0.copyWith()).toList(),
      organizations:
          organizations is List<_imc5i9r4.OrganizationWithLongTableName>?
          ? organizations
          : this.organizations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CityWithLongTableNameUpdateTable
    extends _is.UpdateTable<CityWithLongTableNameTable> {
  CityWithLongTableNameUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class CityWithLongTableNameTable extends _is.Table<int?> {
  CityWithLongTableNameTable({super.tableRelation})
    : super(tableName: 'city_with_long_table_name_that_is_still_valid') {
    updateTable = CityWithLongTableNameUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final CityWithLongTableNameUpdateTable updateTable;

  late final _is.ColumnString name;

  _i5nficvp.PersonWithLongTableNameTable? ___citizens;

  _is.ManyRelation<_i5nficvp.PersonWithLongTableNameTable>? _citizens;

  _imc5i9r4.OrganizationWithLongTableNameTable? ___organizations;

  _is.ManyRelation<_imc5i9r4.OrganizationWithLongTableNameTable>?
  _organizations;

  _i5nficvp.PersonWithLongTableNameTable get __citizens {
    if (___citizens != null) return ___citizens!;
    ___citizens = _is.createRelationTable(
      relationFieldName: '__citizens',
      field: CityWithLongTableName.t.id,
      foreignField: _i5nficvp
          .PersonWithLongTableName
          .t
          .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5nficvp.PersonWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___citizens!;
  }

  _imc5i9r4.OrganizationWithLongTableNameTable get __organizations {
    if (___organizations != null) return ___organizations!;
    ___organizations = _is.createRelationTable(
      relationFieldName: '__organizations',
      field: CityWithLongTableName.t.id,
      foreignField: _imc5i9r4.OrganizationWithLongTableName.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _imc5i9r4.OrganizationWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___organizations!;
  }

  _is.ManyRelation<_i5nficvp.PersonWithLongTableNameTable> get citizens {
    if (_citizens != null) return _citizens!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'citizens',
      field: CityWithLongTableName.t.id,
      foreignField: _i5nficvp
          .PersonWithLongTableName
          .t
          .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5nficvp.PersonWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _citizens = _is.ManyRelation<_i5nficvp.PersonWithLongTableNameTable>(
      tableWithRelations: relationTable,
      table: _i5nficvp.PersonWithLongTableNameTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _citizens!;
  }

  _is.ManyRelation<_imc5i9r4.OrganizationWithLongTableNameTable>
  get organizations {
    if (_organizations != null) return _organizations!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'organizations',
      field: CityWithLongTableName.t.id,
      foreignField: _imc5i9r4.OrganizationWithLongTableName.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _imc5i9r4.OrganizationWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _organizations =
        _is.ManyRelation<_imc5i9r4.OrganizationWithLongTableNameTable>(
          tableWithRelations: relationTable,
          table: _imc5i9r4.OrganizationWithLongTableNameTable(
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

abstract interface class CityWithLongTableNameJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class CityWithLongTableNameJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class CityWithLongTableNameInclude extends _is.IncludeObject
    implements CityWithLongTableNameJsonInclude, _is.FullModelInclude {
  CityWithLongTableNameInclude._({
    _i5nficvp.PersonWithLongTableNameIncludeList? citizens,
    _imc5i9r4.OrganizationWithLongTableNameIncludeList? organizations,
  }) {
    _citizens = citizens;
    _organizations = organizations;
  }

  _i5nficvp.PersonWithLongTableNameIncludeList? _citizens;

  _imc5i9r4.OrganizationWithLongTableNameIncludeList? _organizations;

  @override
  Map<String, _is.Include?> get includes => {
    'citizens': _citizens,
    'organizations': _organizations,
  };

  @override
  _is.Table<int?> get table => CityWithLongTableName.t;
}

final class CityWithLongTableNameIncludeList extends _is.IncludeList
    implements CityWithLongTableNameJsonIncludeList, _is.FullModelInclude {
  CityWithLongTableNameIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CityWithLongTableNameInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CityWithLongTableName.t;
}

final class _CityWithLongTableNameJsonInclude extends _is.IncludeObject
    implements CityWithLongTableNameJsonInclude {
  _CityWithLongTableNameJsonInclude._({
    _i5nficvp.PersonWithLongTableNameJsonIncludeList? citizens,
    _imc5i9r4.OrganizationWithLongTableNameJsonIncludeList? organizations,
    this.selectedColumns,
  }) {
    _citizens = citizens;
    _organizations = organizations;
  }

  _i5nficvp.PersonWithLongTableNameJsonIncludeList? _citizens;

  _imc5i9r4.OrganizationWithLongTableNameJsonIncludeList? _organizations;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'citizens': _citizens,
    'organizations': _organizations,
  };

  @override
  _is.Table<int?> get table => CityWithLongTableName.t;
}

final class _CityWithLongTableNameJsonIncludeList extends _is.IncludeList
    implements CityWithLongTableNameJsonIncludeList {
  _CityWithLongTableNameJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    CityWithLongTableNameJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CityWithLongTableName.t;
}

class CityWithLongTableNameRepository {
  const CityWithLongTableNameRepository._();

  final attach = const CityWithLongTableNameAttachRepository._();

  final attachRow = const CityWithLongTableNameAttachRowRepository._();

  final detach = const CityWithLongTableNameDetachRepository._();

  final detachRow = const CityWithLongTableNameDetachRowRepository._();

  /// Returns a list of [CityWithLongTableName]s matching the given query parameters.
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
  Future<List<CityWithLongTableName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    CityWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CityWithLongTableName] matching the given query parameters.
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
  Future<CityWithLongTableName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? offset,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    CityWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CityWithLongTableName] by its [id] or null if no such row exists.
  Future<CityWithLongTableName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    CityWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CityWithLongTableName>(
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
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    CityWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<CityWithLongTableNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(CityWithLongTableName.t),
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
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? offset,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    CityWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<CityWithLongTableNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(CityWithLongTableName.t),
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
    CityWithLongTableNameJsonInclude? include,
    _is.SelectColumnsBuilder<CityWithLongTableNameTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<CityWithLongTableName>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(CityWithLongTableName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CityWithLongTableName]s in the list and returns the inserted rows.
  ///
  /// The returned [CityWithLongTableName]s will have their `id` fields set.
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
  Future<List<CityWithLongTableName>> insert(
    _is.DatabaseSession session,
    List<CityWithLongTableName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CityWithLongTableName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CityWithLongTableName] and returns the inserted row.
  ///
  /// The returned [CityWithLongTableName] will have its `id` field set.
  Future<CityWithLongTableName> insertRow(
    _is.DatabaseSession session,
    CityWithLongTableName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CityWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CityWithLongTableName]s in the list and returns the resulting rows.
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
  /// The returned [CityWithLongTableName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CityWithLongTableName>> upsert(
    _is.DatabaseSession session,
    List<CityWithLongTableName> rows, {
    required _is.ColumnSelections<CityWithLongTableNameTable> conflictColumns,
    _is.ColumnSelections<CityWithLongTableNameTable>? updateColumns,
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CityWithLongTableName>(
      rows,
      conflictColumns: conflictColumns(CityWithLongTableName.t),
      updateColumns: updateColumns?.call(CityWithLongTableName.t),
      updateWhere: updateWhere?.call(CityWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CityWithLongTableName] and returns the resulting row.
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
  /// The returned [CityWithLongTableName] will have its `id` field set.
  Future<CityWithLongTableName?> upsertRow(
    _is.DatabaseSession session,
    CityWithLongTableName row, {
    required _is.ColumnSelections<CityWithLongTableNameTable> conflictColumns,
    _is.ColumnSelections<CityWithLongTableNameTable>? updateColumns,
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CityWithLongTableName>(
      row,
      conflictColumns: conflictColumns(CityWithLongTableName.t),
      updateColumns: updateColumns?.call(CityWithLongTableName.t),
      updateWhere: updateWhere?.call(CityWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Updates all [CityWithLongTableName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CityWithLongTableName>> update(
    _is.DatabaseSession session,
    List<CityWithLongTableName> rows, {
    _is.ColumnSelections<CityWithLongTableNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CityWithLongTableName>(
      rows,
      columns: columns?.call(CityWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CityWithLongTableName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CityWithLongTableName> updateRow(
    _is.DatabaseSession session,
    CityWithLongTableName row, {
    _is.ColumnSelections<CityWithLongTableNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CityWithLongTableName>(
      row,
      columns: columns?.call(CityWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CityWithLongTableName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CityWithLongTableName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CityWithLongTableNameUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CityWithLongTableName>(
      id,
      columnValues: columnValues(CityWithLongTableName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CityWithLongTableName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CityWithLongTableName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CityWithLongTableNameUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<CityWithLongTableNameTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CityWithLongTableName>(
      columnValues: columnValues(CityWithLongTableName.t.updateTable),
      where: where(CityWithLongTableName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CityWithLongTableName]s in the list and returns the deleted rows.
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
  Future<List<CityWithLongTableName>> delete(
    _is.DatabaseSession session,
    List<CityWithLongTableName> rows, {
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CityWithLongTableName>(
      rows,
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CityWithLongTableName].
  Future<CityWithLongTableName> deleteRow(
    _is.DatabaseSession session,
    CityWithLongTableName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CityWithLongTableName>(
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
  Future<List<CityWithLongTableName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CityWithLongTableNameTable> where,
    _is.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CityWithLongTableName>(
      where: where(CityWithLongTableName.t),
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CityWithLongTableName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CityWithLongTableNameTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CityWithLongTableName>(
      where: where(CityWithLongTableName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameAttachRepository {
  const CityWithLongTableNameAttachRepository._();

  /// Creates a relation between this [CityWithLongTableName] and the given [PersonWithLongTableName]s
  /// by setting each [PersonWithLongTableName]'s foreign key `_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id` to refer to this [CityWithLongTableName].
  Future<void> citizens(
    _is.DatabaseSession session,
    CityWithLongTableName cityWithLongTableName,
    List<_i5nficvp.PersonWithLongTableName> personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (cityWithLongTableName.id == null) {
      throw ArgumentError.notNull('cityWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map(
          (e) => _i5nficvp.PersonWithLongTableNameImplicit(
            e,
            $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
                cityWithLongTableName.id,
          ),
        )
        .toList();
    await session.db.update<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i5nficvp
            .PersonWithLongTableName
            .t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      ],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [CityWithLongTableName] and the given [OrganizationWithLongTableName]s
  /// by setting each [OrganizationWithLongTableName]'s foreign key `cityId` to refer to this [CityWithLongTableName].
  Future<void> organizations(
    _is.DatabaseSession session,
    CityWithLongTableName cityWithLongTableName,
    List<_imc5i9r4.OrganizationWithLongTableName>
    organizationWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }
    if (cityWithLongTableName.id == null) {
      throw ArgumentError.notNull('cityWithLongTableName.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName
        .map((e) => e.copyWith(cityId: cityWithLongTableName.id))
        .toList();
    await session.db.update<_imc5i9r4.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_imc5i9r4.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameAttachRowRepository {
  const CityWithLongTableNameAttachRowRepository._();

  /// Creates a relation between this [CityWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id` to refer to this [CityWithLongTableName].
  Future<void> citizens(
    _is.DatabaseSession session,
    CityWithLongTableName cityWithLongTableName,
    _i5nficvp.PersonWithLongTableName personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (cityWithLongTableName.id == null) {
      throw ArgumentError.notNull('cityWithLongTableName.id');
    }

    var $personWithLongTableName = _i5nficvp.PersonWithLongTableNameImplicit(
      personWithLongTableName,
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
          cityWithLongTableName.id,
    );
    await session.db.updateRow<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i5nficvp
            .PersonWithLongTableName
            .t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      ],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [CityWithLongTableName] and the given [OrganizationWithLongTableName]
  /// by setting the [OrganizationWithLongTableName]'s foreign key `cityId` to refer to this [CityWithLongTableName].
  Future<void> organizations(
    _is.DatabaseSession session,
    CityWithLongTableName cityWithLongTableName,
    _imc5i9r4.OrganizationWithLongTableName organizationWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }
    if (cityWithLongTableName.id == null) {
      throw ArgumentError.notNull('cityWithLongTableName.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName.copyWith(
      cityId: cityWithLongTableName.id,
    );
    await session.db.updateRow<_imc5i9r4.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_imc5i9r4.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameDetachRepository {
  const CityWithLongTableNameDetachRepository._();

  /// Detaches the relation between this [CityWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> citizens(
    _is.DatabaseSession session,
    List<_i5nficvp.PersonWithLongTableName> personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map(
          (e) => _i5nficvp.PersonWithLongTableNameImplicit(
            e,
            $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
                null,
          ),
        )
        .toList();
    await session.db.update<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i5nficvp
            .PersonWithLongTableName
            .t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      ],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [CityWithLongTableName] and the given [OrganizationWithLongTableName]
  /// by setting the [OrganizationWithLongTableName]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organizations(
    _is.DatabaseSession session,
    List<_imc5i9r4.OrganizationWithLongTableName>
    organizationWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName
        .map((e) => e.copyWith(cityId: null))
        .toList();
    await session.db.update<_imc5i9r4.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_imc5i9r4.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameDetachRowRepository {
  const CityWithLongTableNameDetachRowRepository._();

  /// Detaches the relation between this [CityWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> citizens(
    _is.DatabaseSession session,
    _i5nficvp.PersonWithLongTableName personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = _i5nficvp.PersonWithLongTableNameImplicit(
      personWithLongTableName,
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id: null,
    );
    await session.db.updateRow<_i5nficvp.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i5nficvp
            .PersonWithLongTableName
            .t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      ],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [CityWithLongTableName] and the given [OrganizationWithLongTableName]
  /// by setting the [OrganizationWithLongTableName]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organizations(
    _is.DatabaseSession session,
    _imc5i9r4.OrganizationWithLongTableName organizationWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName.copyWith(
      cityId: null,
    );
    await session.db.updateRow<_imc5i9r4.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_imc5i9r4.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

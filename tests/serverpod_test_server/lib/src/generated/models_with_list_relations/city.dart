/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../models_with_list_relations/person.dart' as _i2;
import '../models_with_list_relations/organization.dart' as _i3;

abstract class City implements _i1.TableRow, _i1.ProtocolSerialization {
  City._({
    this.id,
    required this.name,
    this.citizens,
    this.organizations,
  });

  factory City({
    int? id,
    required String name,
    List<_i2.Person>? citizens,
    List<_i3.Organization>? organizations,
  }) = _CityImpl;

  factory City.fromJson(Map<String, dynamic> jsonSerialization) {
    return City(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      citizens: (jsonSerialization['citizens'] as List?)
          ?.map((e) => _i2.Person.fromJson((e as Map<String, dynamic>)))
          .toList(),
      organizations: (jsonSerialization['organizations'] as List?)
          ?.map((e) => _i3.Organization.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = CityTable();

  static const db = CityRepository._();

  @override
  int? id;

  String name;

  List<_i2.Person>? citizens;

  List<_i3.Organization>? organizations;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [City]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  City copyWith({
    int? id,
    String? name,
    List<_i2.Person>? citizens,
    List<_i3.Organization>? organizations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
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
      if (id != null) 'id': id,
      'name': name,
      if (citizens != null)
        'citizens': citizens?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (organizations != null)
        'organizations':
            organizations?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static CityInclude include({
    _i2.PersonIncludeList? citizens,
    _i3.OrganizationIncludeList? organizations,
  }) {
    return CityInclude._(
      citizens: citizens,
      organizations: organizations,
    );
  }

  static CityIncludeList includeList({
    _i1.WhereExpressionBuilder<CityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CityTable>? orderByList,
    CityInclude? include,
  }) {
    return CityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(City.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(City.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CityImpl extends City {
  _CityImpl({
    int? id,
    required String name,
    List<_i2.Person>? citizens,
    List<_i3.Organization>? organizations,
  }) : super._(
          id: id,
          name: name,
          citizens: citizens,
          organizations: organizations,
        );

  /// Returns a shallow copy of this [City]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      citizens: citizens is List<_i2.Person>?
          ? citizens
          : this.citizens?.map((e0) => e0.copyWith()).toList(),
      organizations: organizations is List<_i3.Organization>?
          ? organizations
          : this.organizations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CityTable extends _i1.Table {
  CityTable({super.tableRelation}) : super(tableName: 'city') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.PersonTable? ___citizens;

  _i1.ManyRelation<_i2.PersonTable>? _citizens;

  _i3.OrganizationTable? ___organizations;

  _i1.ManyRelation<_i3.OrganizationTable>? _organizations;

  _i2.PersonTable get __citizens {
    if (___citizens != null) return ___citizens!;
    ___citizens = _i1.createRelationTable(
      relationFieldName: '__citizens',
      field: City.t.id,
      foreignField: _i2.Person.t.$_cityCitizensCityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonTable(tableRelation: foreignTableRelation),
    );
    return ___citizens!;
  }

  _i3.OrganizationTable get __organizations {
    if (___organizations != null) return ___organizations!;
    ___organizations = _i1.createRelationTable(
      relationFieldName: '__organizations',
      field: City.t.id,
      foreignField: _i3.Organization.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.OrganizationTable(tableRelation: foreignTableRelation),
    );
    return ___organizations!;
  }

  _i1.ManyRelation<_i2.PersonTable> get citizens {
    if (_citizens != null) return _citizens!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'citizens',
      field: City.t.id,
      foreignField: _i2.Person.t.$_cityCitizensCityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonTable(tableRelation: foreignTableRelation),
    );
    _citizens = _i1.ManyRelation<_i2.PersonTable>(
      tableWithRelations: relationTable,
      table: _i2.PersonTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _citizens!;
  }

  _i1.ManyRelation<_i3.OrganizationTable> get organizations {
    if (_organizations != null) return _organizations!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'organizations',
      field: City.t.id,
      foreignField: _i3.Organization.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.OrganizationTable(tableRelation: foreignTableRelation),
    );
    _organizations = _i1.ManyRelation<_i3.OrganizationTable>(
      tableWithRelations: relationTable,
      table: _i3.OrganizationTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _organizations!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'citizens') {
      return __citizens;
    }
    if (relationField == 'organizations') {
      return __organizations;
    }
    return null;
  }
}

class CityInclude extends _i1.IncludeObject {
  CityInclude._({
    _i2.PersonIncludeList? citizens,
    _i3.OrganizationIncludeList? organizations,
  }) {
    _citizens = citizens;
    _organizations = organizations;
  }

  _i2.PersonIncludeList? _citizens;

  _i3.OrganizationIncludeList? _organizations;

  @override
  Map<String, _i1.Include?> get includes => {
        'citizens': _citizens,
        'organizations': _organizations,
      };

  @override
  _i1.Table get table => City.t;
}

class CityIncludeList extends _i1.IncludeList {
  CityIncludeList._({
    _i1.WhereExpressionBuilder<CityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(City.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => City.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CityTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CityTable>? orderByList,
    _i1.Transaction? transaction,
    CityInclude? include,
  }) async {
    return session.db.find<City>(
      where: where?.call(City.t),
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CityTable>? where,
    int? offset,
    _i1.OrderByBuilder<CityTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CityTable>? orderByList,
    _i1.Transaction? transaction,
    CityInclude? include,
  }) async {
    return session.db.findFirstRow<City>(
      where: where?.call(City.t),
      orderBy: orderBy?.call(City.t),
      orderByList: orderByList?.call(City.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [City] by its [id] or null if no such row exists.
  Future<City?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CityInclude? include,
  }) async {
    return session.db.findById<City>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [City]s in the list and returns the inserted rows.
  ///
  /// The returned [City]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<City>> insert(
    _i1.Session session,
    List<City> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<City>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [City] and returns the inserted row.
  ///
  /// The returned [City] will have its `id` field set.
  Future<City> insertRow(
    _i1.Session session,
    City row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<City>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [City]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<City>> update(
    _i1.Session session,
    List<City> rows, {
    _i1.ColumnSelections<CityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<City>(
      rows,
      columns: columns?.call(City.t),
      transaction: transaction,
    );
  }

  /// Updates a single [City]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<City> updateRow(
    _i1.Session session,
    City row, {
    _i1.ColumnSelections<CityTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<City>(
      row,
      columns: columns?.call(City.t),
      transaction: transaction,
    );
  }

  /// Deletes all [City]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<City>> delete(
    _i1.Session session,
    List<City> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<City>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [City].
  Future<City> deleteRow(
    _i1.Session session,
    City row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<City>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<City>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<City>(
      where: where(City.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CityTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<City>(
      where: where?.call(City.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CityAttachRepository {
  const CityAttachRepository._();

  /// Creates a relation between this [City] and the given [Person]s
  /// by setting each [Person]'s foreign key `_cityCitizensCityId` to refer to this [City].
  Future<void> citizens(
    _i1.Session session,
    City city,
    List<_i2.Person> person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $person = person
        .map((e) => _i2.PersonImplicit(
              e,
              $_cityCitizensCityId: city.id,
            ))
        .toList();
    await session.db.update<_i2.Person>(
      $person,
      columns: [_i2.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [City] and the given [Organization]s
  /// by setting each [Organization]'s foreign key `cityId` to refer to this [City].
  Future<void> organizations(
    _i1.Session session,
    City city,
    List<_i3.Organization> organization, {
    _i1.Transaction? transaction,
  }) async {
    if (organization.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization =
        organization.map((e) => e.copyWith(cityId: city.id)).toList();
    await session.db.update<_i3.Organization>(
      $organization,
      columns: [_i3.Organization.t.cityId],
      transaction: transaction,
    );
  }
}

class CityAttachRowRepository {
  const CityAttachRowRepository._();

  /// Creates a relation between this [City] and the given [Person]
  /// by setting the [Person]'s foreign key `_cityCitizensCityId` to refer to this [City].
  Future<void> citizens(
    _i1.Session session,
    City city,
    _i2.Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $person = _i2.PersonImplicit(
      person,
      $_cityCitizensCityId: city.id,
    );
    await session.db.updateRow<_i2.Person>(
      $person,
      columns: [_i2.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [City] and the given [Organization]
  /// by setting the [Organization]'s foreign key `cityId` to refer to this [City].
  Future<void> organizations(
    _i1.Session session,
    City city,
    _i3.Organization organization, {
    _i1.Transaction? transaction,
  }) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization = organization.copyWith(cityId: city.id);
    await session.db.updateRow<_i3.Organization>(
      $organization,
      columns: [_i3.Organization.t.cityId],
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
    _i1.Session session,
    List<_i2.Person> person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person
        .map((e) => _i2.PersonImplicit(
              e,
              $_cityCitizensCityId: null,
            ))
        .toList();
    await session.db.update<_i2.Person>(
      $person,
      columns: [_i2.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [City] and the given [Organization]
  /// by setting the [Organization]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organizations(
    _i1.Session session,
    List<_i3.Organization> organization, {
    _i1.Transaction? transaction,
  }) async {
    if (organization.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization =
        organization.map((e) => e.copyWith(cityId: null)).toList();
    await session.db.update<_i3.Organization>(
      $organization,
      columns: [_i3.Organization.t.cityId],
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
    _i1.Session session,
    _i2.Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = _i2.PersonImplicit(
      person,
      $_cityCitizensCityId: null,
    );
    await session.db.updateRow<_i2.Person>(
      $person,
      columns: [_i2.Person.t.$_cityCitizensCityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [City] and the given [Organization]
  /// by setting the [Organization]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organizations(
    _i1.Session session,
    _i3.Organization organization, {
    _i1.Transaction? transaction,
  }) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization = organization.copyWith(cityId: null);
    await session.db.updateRow<_i3.Organization>(
      $organization,
      columns: [_i3.Organization.t.cityId],
      transaction: transaction,
    );
  }
}

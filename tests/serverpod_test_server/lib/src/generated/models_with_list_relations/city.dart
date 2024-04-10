/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class City extends _i1.TableRow {
  City._({
    int? id,
    required this.name,
    this.citizens,
    this.organizations,
  }) : super(id);

  factory City({
    int? id,
    required String name,
    List<_i2.Person>? citizens,
    List<_i2.Organization>? organizations,
  }) = _CityImpl;

  factory City.fromJson(Map<String, dynamic> jsonSerialization) {
    return City(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      citizens: (jsonSerialization['citizens'] as List?)
          ?.map((e) => _i2.Person.fromJson((e as Map<String, dynamic>)))
          .toList(),
      organizations: (jsonSerialization['organizations'] as List?)
          ?.map((e) => _i2.Organization.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = CityTable();

  static const db = CityRepository._();

  String name;

  List<_i2.Person>? citizens;

  List<_i2.Organization>? organizations;

  @override
  _i1.Table get table => t;

  City copyWith({
    int? id,
    String? name,
    List<_i2.Person>? citizens,
    List<_i2.Organization>? organizations,
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
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (citizens != null)
        'citizens': citizens?.toJson(valueToJson: (v) => v.allToJson()),
      if (organizations != null)
        'organizations':
            organizations?.toJson(valueToJson: (v) => v.allToJson()),
    };
  }

  static CityInclude include({
    _i2.PersonIncludeList? citizens,
    _i2.OrganizationIncludeList? organizations,
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
}

class _Undefined {}

class _CityImpl extends City {
  _CityImpl({
    int? id,
    required String name,
    List<_i2.Person>? citizens,
    List<_i2.Organization>? organizations,
  }) : super._(
          id: id,
          name: name,
          citizens: citizens,
          organizations: organizations,
        );

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
      citizens:
          citizens is List<_i2.Person>? ? citizens : this.citizens?.clone(),
      organizations: organizations is List<_i2.Organization>?
          ? organizations
          : this.organizations?.clone(),
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

  _i2.OrganizationTable? ___organizations;

  _i1.ManyRelation<_i2.OrganizationTable>? _organizations;

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

  _i2.OrganizationTable get __organizations {
    if (___organizations != null) return ___organizations!;
    ___organizations = _i1.createRelationTable(
      relationFieldName: '__organizations',
      field: City.t.id,
      foreignField: _i2.Organization.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrganizationTable(tableRelation: foreignTableRelation),
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

  _i1.ManyRelation<_i2.OrganizationTable> get organizations {
    if (_organizations != null) return _organizations!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'organizations',
      field: City.t.id,
      foreignField: _i2.Organization.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrganizationTable(tableRelation: foreignTableRelation),
    );
    _organizations = _i1.ManyRelation<_i2.OrganizationTable>(
      tableWithRelations: relationTable,
      table: _i2.OrganizationTable(
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
    _i2.OrganizationIncludeList? organizations,
  }) {
    _citizens = citizens;
    _organizations = organizations;
  }

  _i2.PersonIncludeList? _citizens;

  _i2.OrganizationIncludeList? _organizations;

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

  Future<List<int>> delete(
    _i1.Session session,
    List<City> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<City>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    City row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<City>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CityTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<City>(
      where: where(City.t),
      transaction: transaction,
    );
  }

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

  Future<void> citizens(
    _i1.Session session,
    City city,
    List<_i2.Person> person,
  ) async {
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
    );
  }

  Future<void> organizations(
    _i1.Session session,
    City city,
    List<_i2.Organization> organization,
  ) async {
    if (organization.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization =
        organization.map((e) => e.copyWith(cityId: city.id)).toList();
    await session.db.update<_i2.Organization>(
      $organization,
      columns: [_i2.Organization.t.cityId],
    );
  }
}

class CityAttachRowRepository {
  const CityAttachRowRepository._();

  Future<void> citizens(
    _i1.Session session,
    City city,
    _i2.Person person,
  ) async {
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
    );
  }

  Future<void> organizations(
    _i1.Session session,
    City city,
    _i2.Organization organization,
  ) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization = organization.copyWith(cityId: city.id);
    await session.db.updateRow<_i2.Organization>(
      $organization,
      columns: [_i2.Organization.t.cityId],
    );
  }
}

class CityDetachRepository {
  const CityDetachRepository._();

  Future<void> citizens(
    _i1.Session session,
    List<_i2.Person> person,
  ) async {
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
    );
  }

  Future<void> organizations(
    _i1.Session session,
    List<_i2.Organization> organization,
  ) async {
    if (organization.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization =
        organization.map((e) => e.copyWith(cityId: null)).toList();
    await session.db.update<_i2.Organization>(
      $organization,
      columns: [_i2.Organization.t.cityId],
    );
  }
}

class CityDetachRowRepository {
  const CityDetachRowRepository._();

  Future<void> citizens(
    _i1.Session session,
    _i2.Person person,
  ) async {
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
    );
  }

  Future<void> organizations(
    _i1.Session session,
    _i2.Organization organization,
  ) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization = organization.copyWith(cityId: null);
    await session.db.updateRow<_i2.Organization>(
      $organization,
      columns: [_i2.Organization.t.cityId],
    );
  }
}

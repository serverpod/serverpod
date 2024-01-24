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

abstract class Organization extends _i1.TableRow {
  Organization._({
    int? id,
    required this.name,
    this.people,
    this.cityId,
    this.city,
  }) : super(id);

  factory Organization({
    int? id,
    required String name,
    List<_i2.Person>? people,
    int? cityId,
    _i2.City? city,
  }) = _OrganizationImpl;

  factory Organization.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Organization(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      people: serializationManager
          .deserialize<List<_i2.Person>?>(jsonSerialization['people']),
      cityId:
          serializationManager.deserialize<int?>(jsonSerialization['cityId']),
      city: serializationManager
          .deserialize<_i2.City?>(jsonSerialization['city']),
    );
  }

  static final t = OrganizationTable();

  static const db = OrganizationRepository._();

  String name;

  List<_i2.Person>? people;

  int? cityId;

  _i2.City? city;

  @override
  _i1.Table get table => t;

  Organization copyWith({
    int? id,
    String? name,
    List<_i2.Person>? people,
    int? cityId,
    _i2.City? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJson()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJson(),
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'cityId': cityId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.allToJson()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.allToJson(),
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'name':
        name = value;
        return;
      case 'cityId':
        cityId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Organization>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    OrganizationInclude? include,
  }) async {
    return session.db.find<Organization>(
      where: where != null ? where(Organization.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<Organization?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    OrganizationInclude? include,
  }) async {
    return session.db.findSingleRow<Organization>(
      where: where != null ? where(Organization.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Organization?> findById(
    _i1.Session session,
    int id, {
    OrganizationInclude? include,
  }) async {
    return session.db.findById<Organization>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OrganizationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Organization>(
      where: where(Organization.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.update instead.')
  static Future<bool> update(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  @Deprecated(
      'Will be removed in 2.0.0. Use: db.insert instead. Important note: In db.insert, the object you pass in is no longer modified, instead a new copy with the added row is returned which contains the inserted id.')
  static Future<void> insert(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.count instead.')
  static Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Organization>(
      where: where != null ? where(Organization.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static OrganizationInclude include({
    _i2.PersonIncludeList? people,
    _i2.CityInclude? city,
  }) {
    return OrganizationInclude._(
      people: people,
      city: city,
    );
  }

  static OrganizationIncludeList includeList({
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    OrganizationInclude? include,
  }) {
    return OrganizationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Organization.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Organization.t),
      include: include,
    );
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    required String name,
    List<_i2.Person>? people,
    int? cityId,
    _i2.City? city,
  }) : super._(
          id: id,
          name: name,
          people: people,
          cityId: cityId,
          city: city,
        );

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
      people: people is List<_i2.Person>? ? people : this.people?.clone(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _i2.City? ? city : this.city?.copyWith(),
    );
  }
}

class OrganizationTable extends _i1.Table {
  OrganizationTable({super.tableRelation}) : super(tableName: 'organization') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    cityId = _i1.ColumnInt(
      'cityId',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.PersonTable? ___people;

  _i1.ManyRelation<_i2.PersonTable>? _people;

  late final _i1.ColumnInt cityId;

  _i2.CityTable? _city;

  _i2.PersonTable get __people {
    if (___people != null) return ___people!;
    ___people = _i1.createRelationTable(
      relationFieldName: '__people',
      field: Organization.t.id,
      foreignField: _i2.Person.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonTable(tableRelation: foreignTableRelation),
    );
    return ___people!;
  }

  _i2.CityTable get city {
    if (_city != null) return _city!;
    _city = _i1.createRelationTable(
      relationFieldName: 'city',
      field: Organization.t.cityId,
      foreignField: _i2.City.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CityTable(tableRelation: foreignTableRelation),
    );
    return _city!;
  }

  _i1.ManyRelation<_i2.PersonTable> get people {
    if (_people != null) return _people!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'people',
      field: Organization.t.id,
      foreignField: _i2.Person.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonTable(tableRelation: foreignTableRelation),
    );
    _people = _i1.ManyRelation<_i2.PersonTable>(
      tableWithRelations: relationTable,
      table: _i2.PersonTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _people!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        cityId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'people') {
      return __people;
    }
    if (relationField == 'city') {
      return city;
    }
    return null;
  }
}

@Deprecated('Use OrganizationTable.t instead.')
OrganizationTable tOrganization = OrganizationTable();

class OrganizationInclude extends _i1.IncludeObject {
  OrganizationInclude._({
    _i2.PersonIncludeList? people,
    _i2.CityInclude? city,
  }) {
    _people = people;
    _city = city;
  }

  _i2.PersonIncludeList? _people;

  _i2.CityInclude? _city;

  @override
  Map<String, _i1.Include?> get includes => {
        'people': _people,
        'city': _city,
      };

  @override
  _i1.Table get table => Organization.t;
}

class OrganizationIncludeList extends _i1.IncludeList {
  OrganizationIncludeList._({
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Organization.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Organization.t;
}

class OrganizationRepository {
  const OrganizationRepository._();

  final attach = const OrganizationAttachRepository._();

  final attachRow = const OrganizationAttachRowRepository._();

  final detach = const OrganizationDetachRepository._();

  final detachRow = const OrganizationDetachRowRepository._();

  Future<List<Organization>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    _i1.Transaction? transaction,
    OrganizationInclude? include,
  }) async {
    return session.dbNext.find<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Organization?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrganizationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationTable>? orderByList,
    _i1.Transaction? transaction,
    OrganizationInclude? include,
  }) async {
    return session.dbNext.findFirstRow<Organization>(
      where: where?.call(Organization.t),
      orderBy: orderBy?.call(Organization.t),
      orderByList: orderByList?.call(Organization.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Organization?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    OrganizationInclude? include,
  }) async {
    return session.dbNext.findById<Organization>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Organization>> insert(
    _i1.Session session,
    List<Organization> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Organization>(
      rows,
      transaction: transaction,
    );
  }

  Future<Organization> insertRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Organization>> update(
    _i1.Session session,
    List<Organization> rows, {
    _i1.ColumnSelections<OrganizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Organization>(
      rows,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  Future<Organization> updateRow(
    _i1.Session session,
    Organization row, {
    _i1.ColumnSelections<OrganizationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Organization>(
      row,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Organization> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Organization>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OrganizationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Organization>(
      where: where(Organization.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Organization>(
      where: where?.call(Organization.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class OrganizationAttachRepository {
  const OrganizationAttachRepository._();

  Future<void> people(
    _i1.Session session,
    Organization organization,
    List<_i2.Person> person,
  ) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $person =
        person.map((e) => e.copyWith(organizationId: organization.id)).toList();
    await session.dbNext.update<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
    );
  }
}

class OrganizationAttachRowRepository {
  const OrganizationAttachRowRepository._();

  Future<void> city(
    _i1.Session session,
    Organization organization,
    _i2.City city,
  ) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organization = organization.copyWith(cityId: city.id);
    await session.dbNext.updateRow<Organization>(
      $organization,
      columns: [Organization.t.cityId],
    );
  }

  Future<void> people(
    _i1.Session session,
    Organization organization,
    _i2.Person person,
  ) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $person = person.copyWith(organizationId: organization.id);
    await session.dbNext.updateRow<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
    );
  }
}

class OrganizationDetachRepository {
  const OrganizationDetachRepository._();

  Future<void> people(
    _i1.Session session,
    List<_i2.Person> person,
  ) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.map((e) => e.copyWith(organizationId: null)).toList();
    await session.dbNext.update<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
    );
  }
}

class OrganizationDetachRowRepository {
  const OrganizationDetachRowRepository._();

  Future<void> city(
    _i1.Session session,
    Organization organization,
  ) async {
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $organization = organization.copyWith(cityId: null);
    await session.dbNext.updateRow<Organization>(
      $organization,
      columns: [Organization.t.cityId],
    );
  }

  Future<void> people(
    _i1.Session session,
    _i2.Person person,
  ) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.copyWith(organizationId: null);
    await session.dbNext.updateRow<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
    );
  }
}

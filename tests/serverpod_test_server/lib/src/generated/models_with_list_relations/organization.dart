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
import '../models_with_list_relations/city.dart' as _i3;

abstract class Organization implements _i1.TableRow, _i1.ProtocolSerialization {
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
    List<_i2.Person>? people,
    int? cityId,
    _i3.City? city,
  }) = _OrganizationImpl;

  factory Organization.fromJson(Map<String, dynamic> jsonSerialization) {
    return Organization(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      people: (jsonSerialization['people'] as List?)
          ?.map((e) => _i2.Person.fromJson((e as Map<String, dynamic>)))
          .toList(),
      cityId: jsonSerialization['cityId'] as int?,
      city: jsonSerialization['city'] == null
          ? null
          : _i3.City.fromJson(
              (jsonSerialization['city'] as Map<String, dynamic>)),
    );
  }

  static final t = OrganizationTable();

  static const db = OrganizationRepository._();

  @override
  int? id;

  String name;

  List<_i2.Person>? people;

  int? cityId;

  _i3.City? city;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Organization copyWith({
    int? id,
    String? name,
    List<_i2.Person>? people,
    int? cityId,
    _i3.City? city,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJsonForProtocol(),
    };
  }

  static OrganizationInclude include({
    _i2.PersonIncludeList? people,
    _i3.CityInclude? city,
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    required String name,
    List<_i2.Person>? people,
    int? cityId,
    _i3.City? city,
  }) : super._(
          id: id,
          name: name,
          people: people,
          cityId: cityId,
          city: city,
        );

  /// Returns a shallow copy of this [Organization]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      people: people is List<_i2.Person>?
          ? people
          : this.people?.map((e0) => e0.copyWith()).toList(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _i3.City? ? city : this.city?.copyWith(),
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

  _i3.CityTable? _city;

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

  _i3.CityTable get city {
    if (_city != null) return _city!;
    _city = _i1.createRelationTable(
      relationFieldName: 'city',
      field: Organization.t.cityId,
      foreignField: _i3.City.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CityTable(tableRelation: foreignTableRelation),
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

class OrganizationInclude extends _i1.IncludeObject {
  OrganizationInclude._({
    _i2.PersonIncludeList? people,
    _i3.CityInclude? city,
  }) {
    _people = people;
    _city = city;
  }

  _i2.PersonIncludeList? _people;

  _i3.CityInclude? _city;

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
    return session.db.find<Organization>(
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
    return session.db.findFirstRow<Organization>(
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
    return session.db.findById<Organization>(
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
    return session.db.insert<Organization>(
      rows,
      transaction: transaction,
    );
  }

  Future<Organization> insertRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Organization>(
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
    return session.db.update<Organization>(
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
    return session.db.updateRow<Organization>(
      row,
      columns: columns?.call(Organization.t),
      transaction: transaction,
    );
  }

  Future<List<Organization>> delete(
    _i1.Session session,
    List<Organization> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Organization>(
      rows,
      transaction: transaction,
    );
  }

  Future<Organization> deleteRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Organization>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Organization>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OrganizationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Organization>(
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
    return session.db.count<Organization>(
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
    List<_i2.Person> person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $person =
        person.map((e) => e.copyWith(organizationId: organization.id)).toList();
    await session.db.update<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationAttachRowRepository {
  const OrganizationAttachRowRepository._();

  Future<void> city(
    _i1.Session session,
    Organization organization,
    _i3.City city, {
    _i1.Transaction? transaction,
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

  Future<void> people(
    _i1.Session session,
    Organization organization,
    _i2.Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $person = person.copyWith(organizationId: organization.id);
    await session.db.updateRow<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationDetachRepository {
  const OrganizationDetachRepository._();

  Future<void> people(
    _i1.Session session,
    List<_i2.Person> person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.any((e) => e.id == null)) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.map((e) => e.copyWith(organizationId: null)).toList();
    await session.db.update<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationDetachRowRepository {
  const OrganizationDetachRowRepository._();

  Future<void> city(
    _i1.Session session,
    Organization organization, {
    _i1.Transaction? transaction,
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

  Future<void> people(
    _i1.Session session,
    _i2.Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.copyWith(organizationId: null);
    await session.db.updateRow<_i2.Person>(
      $person,
      columns: [_i2.Person.t.organizationId],
      transaction: transaction,
    );
  }
}

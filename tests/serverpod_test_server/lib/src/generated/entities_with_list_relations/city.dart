/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

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

  factory City.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return City(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      citizens: serializationManager
          .deserialize<List<_i2.Person>?>(jsonSerialization['citizens']),
      organizations: serializationManager.deserialize<List<_i2.Organization>?>(
          jsonSerialization['organizations']),
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
      'id': id,
      'name': name,
      'citizens': citizens,
      'organizations': organizations,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'citizens': citizens,
      'organizations': organizations,
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
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<City>> find(
    _i1.Session session, {
    CityExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<City>(
      where: where != null ? where(City.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<City?> findSingleRow(
    _i1.Session session, {
    CityExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<City>(
      where: where != null ? where(City.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<City?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<City>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required CityExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<City>(
      where: where(City.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    City row, {
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
    City row, {
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
    City row, {
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
    CityExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<City>(
      where: where != null ? where(City.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static CityInclude include({_i2.PersonIncludeList? citizens}) {
    return CityInclude._(citizens: citizens);
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

typedef CityExpressionBuilder = _i1.Expression Function(CityTable);

class CityTable extends _i1.Table {
  CityTable({super.tableRelation}) : super(tableName: 'city') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i1.ManyRelation<_i2.PersonTable>? _citizens;

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
      table: _i2.Person.t,
    );
    return _citizens!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  _i2.PersonTable get __citizens {
    return _i1.createRelationTable<_i2.PersonTable>(
      relationFieldName: 'citizens',
      field: City.t.id,
      tableRelation: tableRelation,
      foreignField: _i2.Person.t.$_cityCitizensCityId,
      createTable: (foreignTableRelation) =>
          _i2.PersonTable(tableRelation: foreignTableRelation),
    );
  }

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'citizens') {
      return __citizens;
    }

    return null;
  }
}

@Deprecated('Use CityTable.t instead.')
CityTable tCity = CityTable();

class CityInclude extends _i1.IncludeObject {
  CityInclude._({this.citizens});

  _i2.PersonIncludeList? citizens;

  @override
  Map<String, _i1.Include?> get includes => {
        'citizens': citizens,
      };

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
    CityExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
    CityInclude? include,
  }) async {
    return session.dbNext.find<City>(
      where: where?.call(City.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  Future<City?> findRow(
    _i1.Session session, {
    CityExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
    CityInclude? include,
  }) async {
    return session.dbNext.findRow<City>(
      where: where?.call(City.t),
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
    return session.dbNext.findById<City>(
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
    return session.dbNext.insert<City>(
      rows,
      transaction: transaction,
    );
  }

  Future<City> insertRow(
    _i1.Session session,
    City row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<City>(
      row,
      transaction: transaction,
    );
  }

  Future<List<City>> update(
    _i1.Session session,
    List<City> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<City>(
      rows,
      transaction: transaction,
    );
  }

  Future<City> updateRow(
    _i1.Session session,
    City row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<City>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<City> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<City>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    City row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<City>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required CityExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<City>(
      where: where(City.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    CityExpressionBuilder? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<City>(
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
    await session.dbNext.update<_i2.Person>(
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
    await session.dbNext.update<_i2.Organization>(
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
    await session.dbNext.updateRow<_i2.Person>(
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
    await session.dbNext.updateRow<_i2.Organization>(
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
    await session.dbNext.update<_i2.Person>(
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
    await session.dbNext.update<_i2.Organization>(
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
    await session.dbNext.updateRow<_i2.Person>(
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
    await session.dbNext.updateRow<_i2.Organization>(
      $organization,
      columns: [_i2.Organization.t.cityId],
    );
  }
}

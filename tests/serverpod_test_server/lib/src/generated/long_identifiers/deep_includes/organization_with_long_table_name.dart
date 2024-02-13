/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class OrganizationWithLongTableName extends _i1.TableRow {
  OrganizationWithLongTableName._({
    int? id,
    required this.name,
    this.people,
    this.cityId,
    this.city,
  }) : super(id);

  factory OrganizationWithLongTableName({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i2.CityWithLongTableName? city,
  }) = _OrganizationWithLongTableNameImpl;

  factory OrganizationWithLongTableName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return OrganizationWithLongTableName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      people:
          serializationManager.deserialize<List<_i2.PersonWithLongTableName>?>(
              jsonSerialization['people']),
      cityId:
          serializationManager.deserialize<int?>(jsonSerialization['cityId']),
      city: serializationManager
          .deserialize<_i2.CityWithLongTableName?>(jsonSerialization['city']),
    );
  }

  static final t = OrganizationWithLongTableNameTable();

  static const db = OrganizationWithLongTableNameRepository._();

  String name;

  List<_i2.PersonWithLongTableName>? people;

  int? cityId;

  _i2.CityWithLongTableName? city;

  @override
  _i1.Table get table => t;

  OrganizationWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i2.CityWithLongTableName? city,
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

  static OrganizationWithLongTableNameInclude include({
    _i2.PersonWithLongTableNameIncludeList? people,
    _i2.CityWithLongTableNameInclude? city,
  }) {
    return OrganizationWithLongTableNameInclude._(
      people: people,
      city: city,
    );
  }

  static OrganizationWithLongTableNameIncludeList includeList({
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    OrganizationWithLongTableNameInclude? include,
  }) {
    return OrganizationWithLongTableNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      include: include,
    );
  }
}

class _Undefined {}

class _OrganizationWithLongTableNameImpl extends OrganizationWithLongTableName {
  _OrganizationWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i2.CityWithLongTableName? city,
  }) : super._(
          id: id,
          name: name,
          people: people,
          cityId: cityId,
          city: city,
        );

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
      people: people is List<_i2.PersonWithLongTableName>?
          ? people
          : this.people?.clone(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _i2.CityWithLongTableName? ? city : this.city?.copyWith(),
    );
  }
}

class OrganizationWithLongTableNameTable extends _i1.Table {
  OrganizationWithLongTableNameTable({super.tableRelation})
      : super(
            tableName:
                'organization_with_long_table_name_that_is_still_valid') {
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

  _i2.PersonWithLongTableNameTable? ___people;

  _i1.ManyRelation<_i2.PersonWithLongTableNameTable>? _people;

  late final _i1.ColumnInt cityId;

  _i2.CityWithLongTableNameTable? _city;

  _i2.PersonWithLongTableNameTable get __people {
    if (___people != null) return ___people!;
    ___people = _i1.createRelationTable(
      relationFieldName: '__people',
      field: OrganizationWithLongTableName.t.id,
      foreignField: _i2.PersonWithLongTableName.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    return ___people!;
  }

  _i2.CityWithLongTableNameTable get city {
    if (_city != null) return _city!;
    _city = _i1.createRelationTable(
      relationFieldName: 'city',
      field: OrganizationWithLongTableName.t.cityId,
      foreignField: _i2.CityWithLongTableName.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CityWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    return _city!;
  }

  _i1.ManyRelation<_i2.PersonWithLongTableNameTable> get people {
    if (_people != null) return _people!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'people',
      field: OrganizationWithLongTableName.t.id,
      foreignField: _i2.PersonWithLongTableName.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    _people = _i1.ManyRelation<_i2.PersonWithLongTableNameTable>(
      tableWithRelations: relationTable,
      table: _i2.PersonWithLongTableNameTable(
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

class OrganizationWithLongTableNameInclude extends _i1.IncludeObject {
  OrganizationWithLongTableNameInclude._({
    _i2.PersonWithLongTableNameIncludeList? people,
    _i2.CityWithLongTableNameInclude? city,
  }) {
    _people = people;
    _city = city;
  }

  _i2.PersonWithLongTableNameIncludeList? _people;

  _i2.CityWithLongTableNameInclude? _city;

  @override
  Map<String, _i1.Include?> get includes => {
        'people': _people,
        'city': _city,
      };

  @override
  _i1.Table get table => OrganizationWithLongTableName.t;
}

class OrganizationWithLongTableNameIncludeList extends _i1.IncludeList {
  OrganizationWithLongTableNameIncludeList._({
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrganizationWithLongTableName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => OrganizationWithLongTableName.t;
}

class OrganizationWithLongTableNameRepository {
  const OrganizationWithLongTableNameRepository._();

  final attach = const OrganizationWithLongTableNameAttachRepository._();

  final attachRow = const OrganizationWithLongTableNameAttachRowRepository._();

  final detach = const OrganizationWithLongTableNameDetachRepository._();

  final detachRow = const OrganizationWithLongTableNameDetachRowRepository._();

  Future<List<OrganizationWithLongTableName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
  }) async {
    return session.dbNext.find<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<OrganizationWithLongTableName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
  }) async {
    return session.dbNext.findFirstRow<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<OrganizationWithLongTableName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
  }) async {
    return session.dbNext.findById<OrganizationWithLongTableName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<OrganizationWithLongTableName>> insert(
    _i1.Session session,
    List<OrganizationWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<OrganizationWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<OrganizationWithLongTableName> insertRow(
    _i1.Session session,
    OrganizationWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<OrganizationWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<OrganizationWithLongTableName>> update(
    _i1.Session session,
    List<OrganizationWithLongTableName> rows, {
    _i1.ColumnSelections<OrganizationWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<OrganizationWithLongTableName>(
      rows,
      columns: columns?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<OrganizationWithLongTableName> updateRow(
    _i1.Session session,
    OrganizationWithLongTableName row, {
    _i1.ColumnSelections<OrganizationWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<OrganizationWithLongTableName>(
      row,
      columns: columns?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<OrganizationWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<OrganizationWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    OrganizationWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<OrganizationWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<OrganizationWithLongTableName>(
      where: where(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameAttachRepository {
  const OrganizationWithLongTableNameAttachRepository._();

  Future<void> people(
    _i1.Session session,
    OrganizationWithLongTableName organizationWithLongTableName,
    List<_i2.PersonWithLongTableName> personWithLongTableName,
  ) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map(
            (e) => e.copyWith(organizationId: organizationWithLongTableName.id))
        .toList();
    await session.dbNext.update<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
    );
  }
}

class OrganizationWithLongTableNameAttachRowRepository {
  const OrganizationWithLongTableNameAttachRowRepository._();

  Future<void> city(
    _i1.Session session,
    OrganizationWithLongTableName organizationWithLongTableName,
    _i2.CityWithLongTableName city,
  ) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organizationWithLongTableName =
        organizationWithLongTableName.copyWith(cityId: city.id);
    await session.dbNext.updateRow<OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [OrganizationWithLongTableName.t.cityId],
    );
  }

  Future<void> people(
    _i1.Session session,
    OrganizationWithLongTableName organizationWithLongTableName,
    _i2.PersonWithLongTableName personWithLongTableName,
  ) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName.copyWith(
        organizationId: organizationWithLongTableName.id);
    await session.dbNext.updateRow<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
    );
  }
}

class OrganizationWithLongTableNameDetachRepository {
  const OrganizationWithLongTableNameDetachRepository._();

  Future<void> people(
    _i1.Session session,
    List<_i2.PersonWithLongTableName> personWithLongTableName,
  ) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map((e) => e.copyWith(organizationId: null))
        .toList();
    await session.dbNext.update<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
    );
  }
}

class OrganizationWithLongTableNameDetachRowRepository {
  const OrganizationWithLongTableNameDetachRowRepository._();

  Future<void> city(
    _i1.Session session,
    OrganizationWithLongTableName organizationwithlongtablename,
  ) async {
    if (organizationwithlongtablename.id == null) {
      throw ArgumentError.notNull('organizationwithlongtablename.id');
    }

    var $organizationwithlongtablename =
        organizationwithlongtablename.copyWith(cityId: null);
    await session.dbNext.updateRow<OrganizationWithLongTableName>(
      $organizationwithlongtablename,
      columns: [OrganizationWithLongTableName.t.cityId],
    );
  }

  Future<void> people(
    _i1.Session session,
    _i2.PersonWithLongTableName personWithLongTableName,
  ) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName =
        personWithLongTableName.copyWith(organizationId: null);
    await session.dbNext.updateRow<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
    );
  }
}

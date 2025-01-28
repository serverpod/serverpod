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
import '../../long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i2;
import '../../long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i3;

abstract class CityWithLongTableName
    implements _i1.TableRow, _i1.ProtocolSerialization {
  CityWithLongTableName._({
    this.id,
    required this.name,
    this.citizens,
    this.organizations,
  });

  factory CityWithLongTableName({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? citizens,
    List<_i3.OrganizationWithLongTableName>? organizations,
  }) = _CityWithLongTableNameImpl;

  factory CityWithLongTableName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return CityWithLongTableName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      citizens: (jsonSerialization['citizens'] as List?)
          ?.map((e) =>
              _i2.PersonWithLongTableName.fromJson((e as Map<String, dynamic>)))
          .toList(),
      organizations: (jsonSerialization['organizations'] as List?)
          ?.map((e) => _i3.OrganizationWithLongTableName.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = CityWithLongTableNameTable();

  static const db = CityWithLongTableNameRepository._();

  @override
  int? id;

  String name;

  List<_i2.PersonWithLongTableName>? citizens;

  List<_i3.OrganizationWithLongTableName>? organizations;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [CityWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CityWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i2.PersonWithLongTableName>? citizens,
    List<_i3.OrganizationWithLongTableName>? organizations,
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

  static CityWithLongTableNameInclude include({
    _i2.PersonWithLongTableNameIncludeList? citizens,
    _i3.OrganizationWithLongTableNameIncludeList? organizations,
  }) {
    return CityWithLongTableNameInclude._(
      citizens: citizens,
      organizations: organizations,
    );
  }

  static CityWithLongTableNameIncludeList includeList({
    _i1.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    CityWithLongTableNameInclude? include,
  }) {
    return CityWithLongTableNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CityWithLongTableName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CityWithLongTableNameImpl extends CityWithLongTableName {
  _CityWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? citizens,
    List<_i3.OrganizationWithLongTableName>? organizations,
  }) : super._(
          id: id,
          name: name,
          citizens: citizens,
          organizations: organizations,
        );

  /// Returns a shallow copy of this [CityWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      citizens: citizens is List<_i2.PersonWithLongTableName>?
          ? citizens
          : this.citizens?.map((e0) => e0.copyWith()).toList(),
      organizations: organizations is List<_i3.OrganizationWithLongTableName>?
          ? organizations
          : this.organizations?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CityWithLongTableNameTable extends _i1.Table {
  CityWithLongTableNameTable({super.tableRelation})
      : super(tableName: 'city_with_long_table_name_that_is_still_valid') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.PersonWithLongTableNameTable? ___citizens;

  _i1.ManyRelation<_i2.PersonWithLongTableNameTable>? _citizens;

  _i3.OrganizationWithLongTableNameTable? ___organizations;

  _i1.ManyRelation<_i3.OrganizationWithLongTableNameTable>? _organizations;

  _i2.PersonWithLongTableNameTable get __citizens {
    if (___citizens != null) return ___citizens!;
    ___citizens = _i1.createRelationTable(
      relationFieldName: '__citizens',
      field: CityWithLongTableName.t.id,
      foreignField: _i2.PersonWithLongTableName.t
          .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    return ___citizens!;
  }

  _i3.OrganizationWithLongTableNameTable get __organizations {
    if (___organizations != null) return ___organizations!;
    ___organizations = _i1.createRelationTable(
      relationFieldName: '__organizations',
      field: CityWithLongTableName.t.id,
      foreignField: _i3.OrganizationWithLongTableName.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.OrganizationWithLongTableNameTable(
              tableRelation: foreignTableRelation),
    );
    return ___organizations!;
  }

  _i1.ManyRelation<_i2.PersonWithLongTableNameTable> get citizens {
    if (_citizens != null) return _citizens!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'citizens',
      field: CityWithLongTableName.t.id,
      foreignField: _i2.PersonWithLongTableName.t
          .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    _citizens = _i1.ManyRelation<_i2.PersonWithLongTableNameTable>(
      tableWithRelations: relationTable,
      table: _i2.PersonWithLongTableNameTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _citizens!;
  }

  _i1.ManyRelation<_i3.OrganizationWithLongTableNameTable> get organizations {
    if (_organizations != null) return _organizations!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'organizations',
      field: CityWithLongTableName.t.id,
      foreignField: _i3.OrganizationWithLongTableName.t.cityId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.OrganizationWithLongTableNameTable(
              tableRelation: foreignTableRelation),
    );
    _organizations = _i1.ManyRelation<_i3.OrganizationWithLongTableNameTable>(
      tableWithRelations: relationTable,
      table: _i3.OrganizationWithLongTableNameTable(
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

class CityWithLongTableNameInclude extends _i1.IncludeObject {
  CityWithLongTableNameInclude._({
    _i2.PersonWithLongTableNameIncludeList? citizens,
    _i3.OrganizationWithLongTableNameIncludeList? organizations,
  }) {
    _citizens = citizens;
    _organizations = organizations;
  }

  _i2.PersonWithLongTableNameIncludeList? _citizens;

  _i3.OrganizationWithLongTableNameIncludeList? _organizations;

  @override
  Map<String, _i1.Include?> get includes => {
        'citizens': _citizens,
        'organizations': _organizations,
      };

  @override
  _i1.Table get table => CityWithLongTableName.t;
}

class CityWithLongTableNameIncludeList extends _i1.IncludeList {
  CityWithLongTableNameIncludeList._({
    _i1.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CityWithLongTableName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => CityWithLongTableName.t;
}

class CityWithLongTableNameRepository {
  const CityWithLongTableNameRepository._();

  final attach = const CityWithLongTableNameAttachRepository._();

  final attachRow = const CityWithLongTableNameAttachRowRepository._();

  final detach = const CityWithLongTableNameDetachRepository._();

  final detachRow = const CityWithLongTableNameDetachRowRepository._();

  Future<List<CityWithLongTableName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    CityWithLongTableNameInclude? include,
  }) async {
    return session.db.find<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CityWithLongTableName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<CityWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CityWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    CityWithLongTableNameInclude? include,
  }) async {
    return session.db.findFirstRow<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      orderBy: orderBy?.call(CityWithLongTableName.t),
      orderByList: orderByList?.call(CityWithLongTableName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<CityWithLongTableName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CityWithLongTableNameInclude? include,
  }) async {
    return session.db.findById<CityWithLongTableName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<CityWithLongTableName>> insert(
    _i1.Session session,
    List<CityWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CityWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<CityWithLongTableName> insertRow(
    _i1.Session session,
    CityWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CityWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CityWithLongTableName>> update(
    _i1.Session session,
    List<CityWithLongTableName> rows, {
    _i1.ColumnSelections<CityWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CityWithLongTableName>(
      rows,
      columns: columns?.call(CityWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<CityWithLongTableName> updateRow(
    _i1.Session session,
    CityWithLongTableName row, {
    _i1.ColumnSelections<CityWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CityWithLongTableName>(
      row,
      columns: columns?.call(CityWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<List<CityWithLongTableName>> delete(
    _i1.Session session,
    List<CityWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CityWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<CityWithLongTableName> deleteRow(
    _i1.Session session,
    CityWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CityWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<CityWithLongTableName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CityWithLongTableNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CityWithLongTableName>(
      where: where(CityWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CityWithLongTableNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CityWithLongTableName>(
      where: where?.call(CityWithLongTableName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameAttachRepository {
  const CityWithLongTableNameAttachRepository._();

  Future<void> citizens(
    _i1.Session session,
    CityWithLongTableName cityWithLongTableName,
    List<_i2.PersonWithLongTableName> personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (cityWithLongTableName.id == null) {
      throw ArgumentError.notNull('cityWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map((e) => _i2.PersonWithLongTableNameImplicit(
              e,
              $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
                  cityWithLongTableName.id,
            ))
        .toList();
    await session.db.update<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i2.PersonWithLongTableName.t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id
      ],
      transaction: transaction,
    );
  }

  Future<void> organizations(
    _i1.Session session,
    CityWithLongTableName cityWithLongTableName,
    List<_i3.OrganizationWithLongTableName> organizationWithLongTableName, {
    _i1.Transaction? transaction,
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
    await session.db.update<_i3.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_i3.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameAttachRowRepository {
  const CityWithLongTableNameAttachRowRepository._();

  Future<void> citizens(
    _i1.Session session,
    CityWithLongTableName cityWithLongTableName,
    _i2.PersonWithLongTableName personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (cityWithLongTableName.id == null) {
      throw ArgumentError.notNull('cityWithLongTableName.id');
    }

    var $personWithLongTableName = _i2.PersonWithLongTableNameImplicit(
      personWithLongTableName,
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
          cityWithLongTableName.id,
    );
    await session.db.updateRow<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i2.PersonWithLongTableName.t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id
      ],
      transaction: transaction,
    );
  }

  Future<void> organizations(
    _i1.Session session,
    CityWithLongTableName cityWithLongTableName,
    _i3.OrganizationWithLongTableName organizationWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }
    if (cityWithLongTableName.id == null) {
      throw ArgumentError.notNull('cityWithLongTableName.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName.copyWith(
        cityId: cityWithLongTableName.id);
    await session.db.updateRow<_i3.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_i3.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameDetachRepository {
  const CityWithLongTableNameDetachRepository._();

  Future<void> citizens(
    _i1.Session session,
    List<_i2.PersonWithLongTableName> personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map((e) => _i2.PersonWithLongTableNameImplicit(
              e,
              $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
                  null,
            ))
        .toList();
    await session.db.update<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i2.PersonWithLongTableName.t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id
      ],
      transaction: transaction,
    );
  }

  Future<void> organizations(
    _i1.Session session,
    List<_i3.OrganizationWithLongTableName> organizationWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $organizationWithLongTableName = organizationWithLongTableName
        .map((e) => e.copyWith(cityId: null))
        .toList();
    await session.db.update<_i3.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_i3.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

class CityWithLongTableNameDetachRowRepository {
  const CityWithLongTableNameDetachRowRepository._();

  Future<void> citizens(
    _i1.Session session,
    _i2.PersonWithLongTableName personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = _i2.PersonWithLongTableNameImplicit(
      personWithLongTableName,
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id: null,
    );
    await session.db.updateRow<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [
        _i2.PersonWithLongTableName.t
            .$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id
      ],
      transaction: transaction,
    );
  }

  Future<void> organizations(
    _i1.Session session,
    _i3.OrganizationWithLongTableName organizationWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $organizationWithLongTableName =
        organizationWithLongTableName.copyWith(cityId: null);
    await session.db.updateRow<_i3.OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [_i3.OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }
}

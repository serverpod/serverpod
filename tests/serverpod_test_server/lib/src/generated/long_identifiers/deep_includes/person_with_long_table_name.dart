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

abstract class PersonWithLongTableName extends _i1.TableRow {
  PersonWithLongTableName._({
    int? id,
    required this.name,
    this.organizationId,
    this.organization,
  }) : super(id);

  factory PersonWithLongTableName({
    int? id,
    required String name,
    int? organizationId,
    _i2.OrganizationWithLongTableName? organization,
  }) = _PersonWithLongTableNameImpl;

  factory PersonWithLongTableName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return PersonWithLongTableName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      organizationId: jsonSerialization['organizationId'] as int?,
      organization: jsonSerialization.containsKey('organization')
          ? jsonSerialization['organization'] != null
              ? _i2.OrganizationWithLongTableName.fromJson(
                  jsonSerialization['organization'] as Map<String, dynamic>)
              : null
          : null,
    );
  }

  static final t = PersonWithLongTableNameTable();

  static const db = PersonWithLongTableNameRepository._();

  String name;

  int? organizationId;

  _i2.OrganizationWithLongTableName? organization;

  int? _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id;

  @override
  _i1.Table get table => t;

  PersonWithLongTableName copyWith({
    int? id,
    String? name,
    int? organizationId,
    _i2.OrganizationWithLongTableName? organization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null) 'organization': organization?.toJson(),
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null) 'organization': organization?.allToJson(),
      if (_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id !=
          null)
        '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id':
            _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
    };
  }

  static PersonWithLongTableNameInclude include(
      {_i2.OrganizationWithLongTableNameInclude? organization}) {
    return PersonWithLongTableNameInclude._(organization: organization);
  }

  static PersonWithLongTableNameIncludeList includeList({
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    PersonWithLongTableNameInclude? include,
  }) {
    return PersonWithLongTableNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      include: include,
    );
  }
}

class _Undefined {}

class _PersonWithLongTableNameImpl extends PersonWithLongTableName {
  _PersonWithLongTableNameImpl({
    int? id,
    required String name,
    int? organizationId,
    _i2.OrganizationWithLongTableName? organization,
  }) : super._(
          id: id,
          name: name,
          organizationId: organizationId,
          organization: organization,
        );

  @override
  PersonWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? organizationId = _Undefined,
    Object? organization = _Undefined,
  }) {
    return PersonWithLongTableName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      organizationId:
          organizationId is int? ? organizationId : this.organizationId,
      organization: organization is _i2.OrganizationWithLongTableName?
          ? organization
          : this.organization?.copyWith(),
    );
  }
}

class PersonWithLongTableNameImplicit extends _PersonWithLongTableNameImpl {
  PersonWithLongTableNameImplicit._({
    int? id,
    required String name,
    int? organizationId,
    _i2.OrganizationWithLongTableName? organization,
    this.$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
  }) : super(
          id: id,
          name: name,
          organizationId: organizationId,
          organization: organization,
        );

  factory PersonWithLongTableNameImplicit(
    PersonWithLongTableName personWithLongTableName, {
    int? $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
  }) {
    return PersonWithLongTableNameImplicit._(
      id: personWithLongTableName.id,
      name: personWithLongTableName.name,
      organizationId: personWithLongTableName.organizationId,
      organization: personWithLongTableName.organization,
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
          $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
    );
  }

  int? $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id;

  @override
  Map<String, dynamic> allToJson() {
    var jsonMap = super.allToJson();
    jsonMap.addAll({
      '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id':
          $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id
    });
    return jsonMap;
  }
}

class PersonWithLongTableNameTable extends _i1.Table {
  PersonWithLongTableNameTable({super.tableRelation})
      : super(tableName: 'person_with_long_table_name_that_is_still_valid') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id =
        _i1.ColumnInt(
      '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt organizationId;

  _i2.OrganizationWithLongTableNameTable? _organization;

  late final _i1.ColumnInt
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id;

  _i2.OrganizationWithLongTableNameTable get organization {
    if (_organization != null) return _organization!;
    _organization = _i1.createRelationTable(
      relationFieldName: 'organization',
      field: PersonWithLongTableName.t.organizationId,
      foreignField: _i2.OrganizationWithLongTableName.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrganizationWithLongTableNameTable(
              tableRelation: foreignTableRelation),
    );
    return _organization!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        organizationId,
        $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'organization') {
      return organization;
    }
    return null;
  }
}

class PersonWithLongTableNameInclude extends _i1.IncludeObject {
  PersonWithLongTableNameInclude._(
      {_i2.OrganizationWithLongTableNameInclude? organization}) {
    _organization = organization;
  }

  _i2.OrganizationWithLongTableNameInclude? _organization;

  @override
  Map<String, _i1.Include?> get includes => {'organization': _organization};

  @override
  _i1.Table get table => PersonWithLongTableName.t;
}

class PersonWithLongTableNameIncludeList extends _i1.IncludeList {
  PersonWithLongTableNameIncludeList._({
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PersonWithLongTableName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => PersonWithLongTableName.t;
}

class PersonWithLongTableNameRepository {
  const PersonWithLongTableNameRepository._();

  final attachRow = const PersonWithLongTableNameAttachRowRepository._();

  final detachRow = const PersonWithLongTableNameDetachRowRepository._();

  Future<List<PersonWithLongTableName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
  }) async {
    return session.db.find<PersonWithLongTableName>(
      where: where?.call(PersonWithLongTableName.t),
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<PersonWithLongTableName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
  }) async {
    return session.db.findFirstRow<PersonWithLongTableName>(
      where: where?.call(PersonWithLongTableName.t),
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<PersonWithLongTableName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
  }) async {
    return session.db.findById<PersonWithLongTableName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<PersonWithLongTableName>> insert(
    _i1.Session session,
    List<PersonWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PersonWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<PersonWithLongTableName> insertRow(
    _i1.Session session,
    PersonWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PersonWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<PersonWithLongTableName>> update(
    _i1.Session session,
    List<PersonWithLongTableName> rows, {
    _i1.ColumnSelections<PersonWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PersonWithLongTableName>(
      rows,
      columns: columns?.call(PersonWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<PersonWithLongTableName> updateRow(
    _i1.Session session,
    PersonWithLongTableName row, {
    _i1.ColumnSelections<PersonWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PersonWithLongTableName>(
      row,
      columns: columns?.call(PersonWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<PersonWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PersonWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    PersonWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PersonWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonWithLongTableNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PersonWithLongTableName>(
      where: where(PersonWithLongTableName.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PersonWithLongTableName>(
      where: where?.call(PersonWithLongTableName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PersonWithLongTableNameAttachRowRepository {
  const PersonWithLongTableNameAttachRowRepository._();

  Future<void> organization(
    _i1.Session session,
    PersonWithLongTableName personWithLongTableName,
    _i2.OrganizationWithLongTableName organization,
  ) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $personWithLongTableName =
        personWithLongTableName.copyWith(organizationId: organization.id);
    await session.db.updateRow<PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [PersonWithLongTableName.t.organizationId],
    );
  }
}

class PersonWithLongTableNameDetachRowRepository {
  const PersonWithLongTableNameDetachRowRepository._();

  Future<void> organization(
    _i1.Session session,
    PersonWithLongTableName personwithlongtablename,
  ) async {
    if (personwithlongtablename.id == null) {
      throw ArgumentError.notNull('personwithlongtablename.id');
    }

    var $personwithlongtablename =
        personwithlongtablename.copyWith(organizationId: null);
    await session.db.updateRow<PersonWithLongTableName>(
      $personwithlongtablename,
      columns: [PersonWithLongTableName.t.organizationId],
    );
  }
}

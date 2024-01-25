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
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return PersonWithLongTableName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      organizationId: serializationManager
          .deserialize<int?>(jsonSerialization['organizationId']),
      organization:
          serializationManager.deserialize<_i2.OrganizationWithLongTableName?>(
              jsonSerialization['organization']),
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
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'organizationId': organizationId,
      '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id':
          _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
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
      case 'organizationId':
        organizationId = value;
        return;
      case '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id':
        _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<PersonWithLongTableName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
  }) async {
    return session.db.find<PersonWithLongTableName>(
      where: where != null ? where(PersonWithLongTableName.t) : null,
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
  static Future<PersonWithLongTableName?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
  }) async {
    return session.db.findSingleRow<PersonWithLongTableName>(
      where: where != null ? where(PersonWithLongTableName.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<PersonWithLongTableName?> findById(
    _i1.Session session,
    int id, {
    PersonWithLongTableNameInclude? include,
  }) async {
    return session.db.findById<PersonWithLongTableName>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonWithLongTableNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PersonWithLongTableName>(
      where: where(PersonWithLongTableName.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    PersonWithLongTableName row, {
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
    PersonWithLongTableName row, {
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
    PersonWithLongTableName row, {
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
    _i1.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PersonWithLongTableName>(
      where: where != null ? where(PersonWithLongTableName.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
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

@Deprecated('Use PersonWithLongTableNameTable.t instead.')
PersonWithLongTableNameTable tPersonWithLongTableName =
    PersonWithLongTableNameTable();

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
    return session.dbNext.find<PersonWithLongTableName>(
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
    return session.dbNext.findFirstRow<PersonWithLongTableName>(
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
    return session.dbNext.findById<PersonWithLongTableName>(
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
    return session.dbNext.insert<PersonWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<PersonWithLongTableName> insertRow(
    _i1.Session session,
    PersonWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<PersonWithLongTableName>(
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
    return session.dbNext.update<PersonWithLongTableName>(
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
    return session.dbNext.updateRow<PersonWithLongTableName>(
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
    return session.dbNext.delete<PersonWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    PersonWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<PersonWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonWithLongTableNameTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<PersonWithLongTableName>(
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
    return session.dbNext.count<PersonWithLongTableName>(
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
    await session.dbNext.updateRow<PersonWithLongTableName>(
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
    await session.dbNext.updateRow<PersonWithLongTableName>(
      $personwithlongtablename,
      columns: [PersonWithLongTableName.t.organizationId],
    );
  }
}

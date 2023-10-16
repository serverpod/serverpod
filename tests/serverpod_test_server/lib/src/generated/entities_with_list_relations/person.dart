/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Person extends _i1.TableRow {
  Person._({
    int? id,
    required this.name,
    this.organizationId,
    this.organization,
  }) : super(id);

  factory Person({
    int? id,
    required String name,
    int? organizationId,
    _i2.Organization? organization,
  }) = _PersonImpl;

  factory Person.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Person(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      organizationId: serializationManager
          .deserialize<int?>(jsonSerialization['organizationId']),
      organization: serializationManager
          .deserialize<_i2.Organization?>(jsonSerialization['organization']),
    );
  }

  static final t = PersonTable();

  static const db = PersonRepository._();

  String name;

  int? organizationId;

  _i2.Organization? organization;

  int? _cityCitizensCityId;

  @override
  _i1.Table get table => t;

  Person copyWith({
    int? id,
    String? name,
    int? organizationId,
    _i2.Organization? organization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'organizationId': organizationId,
      'organization': organization,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'name': name,
      'organizationId': organizationId,
      '_cityCitizensCityId': _cityCitizensCityId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'name': name,
      'organizationId': organizationId,
      'organization': organization,
      '_cityCitizensCityId': _cityCitizensCityId,
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
      case '_cityCitizensCityId':
        _cityCitizensCityId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.find instead.')
  static Future<List<Person>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.db.find<Person>(
      where: where != null ? where(Person.t) : null,
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
  static Future<Person?> findSingleRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.db.findSingleRow<Person>(
      where: where != null ? where(Person.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Person?> findById(
    _i1.Session session,
    int id, {
    PersonInclude? include,
  }) async {
    return session.db.findById<Person>(
      id,
      include: include,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Person>(
      where: where(Person.t),
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteRow instead.')
  static Future<bool> deleteRow(
    _i1.Session session,
    Person row, {
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
    Person row, {
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
    Person row, {
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
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Person>(
      where: where != null ? where(Person.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static PersonInclude include({_i2.OrganizationInclude? organization}) {
    return PersonInclude._(organization: organization);
  }

  static PersonIncludeList includeList({
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    PersonInclude? include,
  }) {
    return PersonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      orderByList: orderByList,
      include: include,
    );
  }
}

class _Undefined {}

class _PersonImpl extends Person {
  _PersonImpl({
    int? id,
    required String name,
    int? organizationId,
    _i2.Organization? organization,
  }) : super._(
          id: id,
          name: name,
          organizationId: organizationId,
          organization: organization,
        );

  @override
  Person copyWith({
    Object? id = _Undefined,
    String? name,
    Object? organizationId = _Undefined,
    Object? organization = _Undefined,
  }) {
    return Person(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      organizationId:
          organizationId is int? ? organizationId : this.organizationId,
      organization: organization is _i2.Organization?
          ? organization
          : this.organization?.copyWith(),
    );
  }
}

class PersonImplicit extends _PersonImpl {
  PersonImplicit._({
    int? id,
    required String name,
    int? organizationId,
    _i2.Organization? organization,
    this.$_cityCitizensCityId,
  }) : super(
          id: id,
          name: name,
          organizationId: organizationId,
          organization: organization,
        );

  factory PersonImplicit(
    Person person, {
    int? $_cityCitizensCityId,
  }) {
    return PersonImplicit._(
      id: person.id,
      name: person.name,
      organizationId: person.organizationId,
      organization: person.organization,
      $_cityCitizensCityId: $_cityCitizensCityId,
    );
  }

  int? $_cityCitizensCityId;

  @override
  Map<String, dynamic> allToJson() {
    var jsonMap = super.allToJson();
    jsonMap.addAll({'_cityCitizensCityId': $_cityCitizensCityId});
    return jsonMap;
  }
}

class PersonTable extends _i1.Table {
  PersonTable({super.tableRelation}) : super(tableName: 'person') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    organizationId = _i1.ColumnInt(
      'organizationId',
      this,
    );
    $_cityCitizensCityId = _i1.ColumnInt(
      '_cityCitizensCityId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt organizationId;

  _i2.OrganizationTable? _organization;

  late final _i1.ColumnInt $_cityCitizensCityId;

  _i2.OrganizationTable get organization {
    if (_organization != null) return _organization!;
    _organization = _i1.createRelationTable(
      relationFieldName: 'organization',
      field: Person.t.organizationId,
      foreignField: _i2.Organization.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrganizationTable(tableRelation: foreignTableRelation),
    );
    return _organization!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        organizationId,
        $_cityCitizensCityId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'organization') {
      return organization;
    }
    return null;
  }
}

@Deprecated('Use PersonTable.t instead.')
PersonTable tPerson = PersonTable();

class PersonInclude extends _i1.Include {
  PersonInclude._({_i2.OrganizationInclude? organization}) {
    _organization = organization;
  }

  _i2.OrganizationInclude? _organization;

  @override
  Map<String, _i1.Include?> get includes => {'organization': _organization};

  @override
  _i1.Table get table => Person.t;
}

class PersonIncludeList extends _i1.IncludeList<PersonInclude> {
  PersonIncludeList._({
    _i1.WhereExpressionBuilder<PersonTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Person.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Person.t;
}

class PersonRepository {
  const PersonRepository._();

  final attachRow = const PersonAttachRowRepository._();

  final detachRow = const PersonDetachRowRepository._();

  Future<List<Person>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.dbNext.find<Person>(
      where: where?.call(Person.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
      include: include,
    );
  }

  Future<Person?> findRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.dbNext.findRow<Person>(
      where: where?.call(Person.t),
      transaction: transaction,
      include: include,
    );
  }

  Future<Person?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.dbNext.findById<Person>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  Future<List<Person>> insert(
    _i1.Session session,
    List<Person> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insert<Person>(
      rows,
      transaction: transaction,
    );
  }

  Future<Person> insertRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.insertRow<Person>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Person>> update(
    _i1.Session session,
    List<Person> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Person>(
      rows,
      transaction: transaction,
    );
  }

  Future<Person> updateRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Person>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Person> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.delete<Person>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteRow<Person>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Person>(
      where: where(Person.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.count<Person>(
      where: where?.call(Person.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class PersonAttachRowRepository {
  const PersonAttachRowRepository._();

  Future<void> organization(
    _i1.Session session,
    Person person,
    _i2.Organization organization,
  ) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $person = person.copyWith(organizationId: organization.id);
    await session.dbNext.updateRow<Person>(
      $person,
      columns: [Person.t.organizationId],
    );
  }
}

class PersonDetachRowRepository {
  const PersonDetachRowRepository._();

  Future<void> organization(
    _i1.Session session,
    Person person,
  ) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.copyWith(organizationId: null);
    await session.dbNext.updateRow<Person>(
      $person,
      columns: [Person.t.organizationId],
    );
  }
}

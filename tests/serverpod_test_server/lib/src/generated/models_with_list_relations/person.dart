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

  factory Person.fromJson(Map<String, dynamic> jsonSerialization) {
    return Person(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      organizationId: jsonSerialization['organizationId'] as int?,
      organization: jsonSerialization['organization'] == null
          ? null
          : _i2.Organization.fromJson(
              (jsonSerialization['organization'] as Map<String, dynamic>)),
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
      if (_cityCitizensCityId != null)
        '_cityCitizensCityId': _cityCitizensCityId,
    };
  }

  static PersonInclude include({_i2.OrganizationInclude? organization}) {
    return PersonInclude._(organization: organization);
  }

  static PersonIncludeList includeList({
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonTable>? orderByList,
    PersonInclude? include,
  }) {
    return PersonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Person.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Person.t),
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

class PersonInclude extends _i1.IncludeObject {
  PersonInclude._({_i2.OrganizationInclude? organization}) {
    _organization = organization;
  }

  _i2.OrganizationInclude? _organization;

  @override
  Map<String, _i1.Include?> get includes => {'organization': _organization};

  @override
  _i1.Table get table => Person.t;
}

class PersonIncludeList extends _i1.IncludeList {
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
    _i1.OrderByBuilder<PersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonTable>? orderByList,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.db.find<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  Future<Person?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PersonTable>? where,
    int? offset,
    _i1.OrderByBuilder<PersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PersonTable>? orderByList,
    _i1.Transaction? transaction,
    PersonInclude? include,
  }) async {
    return session.db.findFirstRow<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      orderDescending: orderDescending,
      offset: offset,
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
    return session.db.findById<Person>(
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
    return session.db.insert<Person>(
      rows,
      transaction: transaction,
    );
  }

  Future<Person> insertRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Person>(
      row,
      transaction: transaction,
    );
  }

  Future<List<Person>> update(
    _i1.Session session,
    List<Person> rows, {
    _i1.ColumnSelections<PersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Person>(
      rows,
      columns: columns?.call(Person.t),
      transaction: transaction,
    );
  }

  Future<Person> updateRow(
    _i1.Session session,
    Person row, {
    _i1.ColumnSelections<PersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Person>(
      row,
      columns: columns?.call(Person.t),
      transaction: transaction,
    );
  }

  Future<List<int>> delete(
    _i1.Session session,
    List<Person> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Person>(
      rows,
      transaction: transaction,
    );
  }

  Future<int> deleteRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Person>(
      row,
      transaction: transaction,
    );
  }

  Future<List<int>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Person>(
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
    return session.db.count<Person>(
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
    await session.db.updateRow<Person>(
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
    await session.db.updateRow<Person>(
      $person,
      columns: [Person.t.organizationId],
    );
  }
}

/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Organization extends _i1.TableRow {
  Organization._({
    int? id,
    required this.name,
    this.people,
  }) : super(id);

  factory Organization({
    int? id,
    required String name,
    List<_i2.Person>? people,
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
    );
  }

  static final t = OrganizationTable();

  static const db = OrganizationRepository._();

  String name;

  List<_i2.Person>? people;

  @override
  _i1.Table get table => t;

  Organization copyWith({
    int? id,
    String? name,
    List<_i2.Person>? people,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'people': people,
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
      'people': people,
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
  static Future<List<Organization>> find(
    _i1.Session session, {
    OrganizationExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
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
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findRow instead.')
  static Future<Organization?> findSingleRow(
    _i1.Session session, {
    OrganizationExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findSingleRow<Organization>(
      where: where != null ? where(Organization.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.findById instead.')
  static Future<Organization?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<Organization>(id);
  }

  @Deprecated('Will be removed in 2.0.0. Use: db.deleteWhere instead.')
  static Future<int> delete(
    _i1.Session session, {
    required OrganizationExpressionBuilder where,
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
    OrganizationExpressionBuilder? where,
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

  static OrganizationInclude include() {
    return OrganizationInclude._();
  }
}

class _Undefined {}

class _OrganizationImpl extends Organization {
  _OrganizationImpl({
    int? id,
    required String name,
    List<_i2.Person>? people,
  }) : super._(
          id: id,
          name: name,
          people: people,
        );

  @override
  Organization copyWith({
    Object? id = _Undefined,
    String? name,
    Object? people = _Undefined,
  }) {
    return Organization(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      people: people is List<_i2.Person>? ? people : this.people?.clone(),
    );
  }
}

typedef OrganizationExpressionBuilder = _i1.Expression Function(
    OrganizationTable);

class OrganizationTable extends _i1.Table {
  OrganizationTable({super.tableRelation}) : super(tableName: 'organization') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i1.ManyRelation<_i2.PersonTable>? _people;

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
      table: _i2.Person.t,
    );
    return _people!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];
}

@Deprecated('Use OrganizationTable.t instead.')
OrganizationTable tOrganization = OrganizationTable();

class OrganizationInclude extends _i1.Include {
  OrganizationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

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
    OrganizationExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    List<_i1.Order>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.find<Organization>(
      where: where?.call(Organization.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  Future<Organization?> findRow(
    _i1.Session session, {
    OrganizationExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findRow<Organization>(
      where: where?.call(Organization.t),
      transaction: transaction,
    );
  }

  Future<Organization?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.findById<Organization>(
      id,
      transaction: transaction,
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
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.update<Organization>(
      rows,
      transaction: transaction,
    );
  }

  Future<Organization> updateRow(
    _i1.Session session,
    Organization row, {
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.updateRow<Organization>(
      row,
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
    required OrganizationExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.dbNext.deleteWhere<Organization>(
      where: where(Organization.t),
      transaction: transaction,
    );
  }

  Future<int> count(
    _i1.Session session, {
    OrganizationExpressionBuilder? where,
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

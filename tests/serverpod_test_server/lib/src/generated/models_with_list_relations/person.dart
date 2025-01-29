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
import '../models_with_list_relations/organization.dart' as _i2;

abstract class Person implements _i1.TableRow, _i1.ProtocolSerialization {
  Person._({
    this.id,
    required this.name,
    this.organizationId,
    this.organization,
  });

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

  @override
  int? id;

  String name;

  int? organizationId;

  _i2.Organization? organization;

  int? _cityCitizensCityId;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      if (_cityCitizensCityId != null)
        '_cityCitizensCityId': _cityCitizensCityId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null)
        'organization': organization?.toJsonForProtocol(),
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
  Map<String, dynamic> toJson() {
    var jsonMap = super.toJson();
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

  /// Returns a list of [Person]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
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

  /// Returns the first matching [Person] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
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

  /// Finds a single [Person] by its [id] or null if no such row exists.
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

  /// Inserts all [Person]s in the list and returns the inserted rows.
  ///
  /// The returned [Person]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
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

  /// Inserts a single [Person] and returns the inserted row.
  ///
  /// The returned [Person] will have its `id` field set.
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

  /// Updates all [Person]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
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

  /// Updates a single [Person]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
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

  /// Deletes all [Person]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Person>> delete(
    _i1.Session session,
    List<Person> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Person>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Person].
  Future<Person> deleteRow(
    _i1.Session session,
    Person row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Person>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Person>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PersonTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Person>(
      where: where(Person.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
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

  /// Creates a relation between the given [Person] and [Organization]
  /// by setting the [Person]'s foreign key `organizationId` to refer to the [Organization].
  Future<void> organization(
    _i1.Session session,
    Person person,
    _i2.Organization organization, {
    _i1.Transaction? transaction,
  }) async {
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
      transaction: transaction,
    );
  }
}

class PersonDetachRowRepository {
  const PersonDetachRowRepository._();

  /// Detaches the relation between this [Person] and the [Organization] set in `organization`
  /// by setting the [Person]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organization(
    _i1.Session session,
    Person person, {
    _i1.Transaction? transaction,
  }) async {
    if (person.id == null) {
      throw ArgumentError.notNull('person.id');
    }

    var $person = person.copyWith(organizationId: null);
    await session.db.updateRow<Person>(
      $person,
      columns: [Person.t.organizationId],
      transaction: transaction,
    );
  }
}

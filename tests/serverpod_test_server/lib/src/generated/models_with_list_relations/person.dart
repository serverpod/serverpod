/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import '../models_with_list_relations/organization.dart' as _i0ptycc3;

abstract class Person implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Person._({
    this.id,
    required this.name,
    this.organizationId,
    this.organization,
  }) : _cityCitizensCityId = null;

  factory Person({
    int? id,
    required String name,
    int? organizationId,
    _i0ptycc3.Organization? organization,
  }) = _PersonImpl;

  factory Person.fromJson(Map<String, dynamic> jsonSerialization) {
    return PersonImplicit._(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      organizationId: jsonSerialization['organizationId'] as int?,
      organization: jsonSerialization['organization'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_i0ptycc3.Organization>(
              jsonSerialization['organization'],
            ),
      $_cityCitizensCityId: jsonSerialization['_cityCitizensCityId'] as int?,
    );
  }

  static final t = PersonTable();

  static const db = PersonRepository._();

  @override
  int? id;

  String name;

  int? organizationId;

  _i0ptycc3.Organization? organization;

  final int? _cityCitizensCityId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Person copyWith({
    int? id,
    String? name,
    int? organizationId,
    _i0ptycc3.Organization? organization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Person',
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
      '__className__': 'Person',
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null)
        'organization': organization?.toJsonForProtocol(),
    };
  }

  static PersonInclude include({
    _i0ptycc3.OrganizationInclude? organization,
    _is.SelectColumnsBuilder<PersonTable>? select,
  }) {
    return PersonInclude._(
      organization: organization,
      selectedColumns: select?.call(Person.t),
    );
  }

  static PersonIncludeList includeList({
    _is.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    PersonInclude? include,
    _is.SelectColumnsBuilder<PersonTable>? select,
  }) {
    return PersonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      include: include,
      selectedColumns: select?.call(Person.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PersonImpl extends Person {
  _PersonImpl({
    int? id,
    required String name,
    int? organizationId,
    _i0ptycc3.Organization? organization,
  }) : super._(
         id: id,
         name: name,
         organizationId: organizationId,
         organization: organization,
       );

  /// Returns a shallow copy of this [Person]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Person copyWith({
    Object? id = _Undefined,
    String? name,
    Object? organizationId = _Undefined,
    Object? organization = _Undefined,
  }) {
    return PersonImplicit._(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      organizationId: organizationId is int?
          ? organizationId
          : this.organizationId,
      organization: organization is _i0ptycc3.Organization?
          ? organization
          : this.organization?.copyWith(),
      $_cityCitizensCityId: this._cityCitizensCityId,
    );
  }
}

class PersonImplicit extends _PersonImpl {
  PersonImplicit._({
    int? id,
    required String name,
    int? organizationId,
    _i0ptycc3.Organization? organization,
    int? $_cityCitizensCityId,
  }) : _cityCitizensCityId = $_cityCitizensCityId,
       super(
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

  @override
  final int? _cityCitizensCityId;
}

class PersonUpdateTable extends _is.UpdateTable<PersonTable> {
  PersonUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> organizationId(int? value) => _is.ColumnValue(
    table.organizationId,
    value,
  );

  _is.ColumnValue<int, int> $_cityCitizensCityId(int? value) => _is.ColumnValue(
    table.$_cityCitizensCityId,
    value,
  );
}

class PersonTable extends _is.Table<int?> {
  PersonTable({super.tableRelation}) : super(tableName: 'person') {
    updateTable = PersonUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    organizationId = _is.ColumnInt(
      'organizationId',
      this,
    );
    $_cityCitizensCityId = _is.ColumnInt(
      '_cityCitizensCityId',
      this,
    );
  }

  late final PersonUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt organizationId;

  _i0ptycc3.OrganizationTable? _organization;

  late final _is.ColumnInt $_cityCitizensCityId;

  _i0ptycc3.OrganizationTable get organization {
    if (_organization != null) return _organization!;
    _organization = _is.createRelationTable(
      relationFieldName: 'organization',
      field: Person.t.organizationId,
      foreignField: _i0ptycc3.Organization.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i0ptycc3.OrganizationTable(tableRelation: foreignTableRelation),
    );
    return _organization!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    organizationId,
    $_cityCitizensCityId,
  ];

  @override
  List<_is.Column> get managedColumns => [
    id,
    name,
    organizationId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'organization') {
      return organization;
    }
    return null;
  }
}

class PersonInclude extends _is.IncludeObject {
  PersonInclude._({
    _i0ptycc3.OrganizationInclude? organization,
    this.selectedColumns,
  }) {
    _organization = organization;
  }

  _i0ptycc3.OrganizationInclude? _organization;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'organization': _organization};

  @override
  _is.Table<int?> get table => Person.t;
}

class PersonIncludeList extends _is.IncludeList {
  PersonIncludeList._({
    _is.WhereExpressionBuilder<PersonTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Person.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Person.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    _is.Transaction? transaction,
    PersonInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonTable>? where,
    int? offset,
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    _is.Transaction? transaction,
    PersonInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Person] by its [id] or null if no such row exists.
  Future<Person?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    PersonInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Person>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    _is.Transaction? transaction,
    PersonInclude? include,
    _is.SelectColumnsBuilder<PersonTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Person.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonTable>? where,
    int? offset,
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    _is.Transaction? transaction,
    PersonInclude? include,
    _is.SelectColumnsBuilder<PersonTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Person>(
      where: where?.call(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Person.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    PersonInclude? include,
    _is.SelectColumnsBuilder<PersonTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Person>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Person.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Person]s in the list and returns the inserted rows.
  ///
  /// The returned [Person]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Person>> insert(
    _is.DatabaseSession session,
    List<Person> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Person>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Person] and returns the inserted row.
  ///
  /// The returned [Person] will have its `id` field set.
  Future<Person> insertRow(
    _is.DatabaseSession session,
    Person row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Person>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Person]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [Person]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Person>> upsert(
    _is.DatabaseSession session,
    List<Person> rows, {
    required _is.ColumnSelections<PersonTable> conflictColumns,
    _is.ColumnSelections<PersonTable>? updateColumns,
    _is.WhereExpressionBuilder<PersonTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Person>(
      rows,
      conflictColumns: conflictColumns(Person.t),
      updateColumns: updateColumns?.call(Person.t),
      updateWhere: updateWhere?.call(Person.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Person] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [Person] will have its `id` field set.
  Future<Person?> upsertRow(
    _is.DatabaseSession session,
    Person row, {
    required _is.ColumnSelections<PersonTable> conflictColumns,
    _is.ColumnSelections<PersonTable>? updateColumns,
    _is.WhereExpressionBuilder<PersonTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Person>(
      row,
      conflictColumns: conflictColumns(Person.t),
      updateColumns: updateColumns?.call(Person.t),
      updateWhere: updateWhere?.call(Person.t),
      transaction: transaction,
    );
  }

  /// Updates all [Person]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Person>> update(
    _is.DatabaseSession session,
    List<Person> rows, {
    _is.ColumnSelections<PersonTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Person>(
      rows,
      columns: columns?.call(Person.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Person]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Person> updateRow(
    _is.DatabaseSession session,
    Person row, {
    _is.ColumnSelections<PersonTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Person>(
      row,
      columns: columns?.call(Person.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Person] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Person?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PersonUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Person>(
      id,
      columnValues: columnValues(Person.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Person]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Person>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PersonUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PersonTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Person>(
      columnValues: columnValues(Person.t.updateTable),
      where: where(Person.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Person]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Person>> delete(
    _is.DatabaseSession session,
    List<Person> rows, {
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Person>(
      rows,
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Person].
  Future<Person> deleteRow(
    _is.DatabaseSession session,
    Person row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Person>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Person>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PersonTable> where,
    _is.OrderByBuilder<PersonTable>? orderBy,
    _is.OrderByListBuilder<PersonTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Person>(
      where: where(Person.t),
      orderBy: orderBy?.call(Person.t),
      orderByList: orderByList?.call(Person.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Person>(
      where: where?.call(Person.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Person] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PersonTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Person>(
      where: where(Person.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PersonAttachRowRepository {
  const PersonAttachRowRepository._();

  /// Creates a relation between the given [Person] and [Organization]
  /// by setting the [Person]'s foreign key `organizationId` to refer to the [Organization].
  Future<void> organization(
    _is.DatabaseSession session,
    Person person,
    _i0ptycc3.Organization organization, {
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    Person person, {
    _is.Transaction? transaction,
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

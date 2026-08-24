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
import '../../long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _imc5i9r4;

abstract class PersonWithLongTableName
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PersonWithLongTableName._({
    this.id,
    required this.name,
    this.organizationId,
    this.organization,
  }) : _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id = null;

  factory PersonWithLongTableName({
    int? id,
    required String name,
    int? organizationId,
    _imc5i9r4.OrganizationWithLongTableName? organization,
  }) = _PersonWithLongTableNameImpl;

  factory PersonWithLongTableName.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PersonWithLongTableNameImplicit._(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      organizationId: jsonSerialization['organizationId'] as int?,
      organization: jsonSerialization['organization'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<_imc5i9r4.OrganizationWithLongTableName>(
                  jsonSerialization['organization'],
                ),
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
          jsonSerialization['_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id']
              as int?,
    );
  }

  static final t = PersonWithLongTableNameTable();

  static const db = PersonWithLongTableNameRepository._();

  @override
  int? id;

  String name;

  int? organizationId;

  _imc5i9r4.OrganizationWithLongTableName? organization;

  final int? _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PersonWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PersonWithLongTableName copyWith({
    int? id,
    String? name,
    int? organizationId,
    _imc5i9r4.OrganizationWithLongTableName? organization,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PersonWithLongTableName',
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null) 'organization': organization?.toJson(),
      if (_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id !=
          null)
        '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id':
            _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PersonWithLongTableName',
      if (id != null) 'id': id,
      'name': name,
      if (organizationId != null) 'organizationId': organizationId,
      if (organization != null)
        'organization': organization?.toJsonForProtocol(),
    };
  }

  static PersonWithLongTableNameInclude include({
    _imc5i9r4.OrganizationWithLongTableNameInclude? organization,
    _is.SelectColumnsBuilder<PersonWithLongTableNameTable>? select,
  }) {
    return PersonWithLongTableNameInclude.internal_(
      organization: organization,
      selectedColumns: select?.call(PersonWithLongTableName.t),
    );
  }

  static PersonWithLongTableNameIncludeList includeList({
    _is.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    PersonWithLongTableNameInclude? include,
    _is.SelectColumnsBuilder<PersonWithLongTableNameTable>? select,
  }) {
    return PersonWithLongTableNameIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      include: include,
      selectedColumns: select?.call(PersonWithLongTableName.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PersonWithLongTableNameImpl extends PersonWithLongTableName {
  _PersonWithLongTableNameImpl({
    int? id,
    required String name,
    int? organizationId,
    _imc5i9r4.OrganizationWithLongTableName? organization,
  }) : super._(
         id: id,
         name: name,
         organizationId: organizationId,
         organization: organization,
       );

  /// Returns a shallow copy of this [PersonWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PersonWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? organizationId = _Undefined,
    Object? organization = _Undefined,
  }) {
    return PersonWithLongTableNameImplicit._(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      organizationId: organizationId is int?
          ? organizationId
          : this.organizationId,
      organization: organization is _imc5i9r4.OrganizationWithLongTableName?
          ? organization
          : this.organization?.copyWith(),
      $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id:
          this._cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
    );
  }
}

class PersonWithLongTableNameImplicit extends _PersonWithLongTableNameImpl {
  PersonWithLongTableNameImplicit._({
    int? id,
    required String name,
    int? organizationId,
    _imc5i9r4.OrganizationWithLongTableName? organization,
    int? $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
  }) : _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id =
           $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
       super(
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

  @override
  final int? _cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id;
}

class PersonWithLongTableNameUpdateTable
    extends _is.UpdateTable<PersonWithLongTableNameTable> {
  PersonWithLongTableNameUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> organizationId(int? value) => _is.ColumnValue(
    table.organizationId,
    value,
  );

  _is.ColumnValue<int, int>
  $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id(
    int? value,
  ) => _is.ColumnValue(
    table.$_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
    value,
  );
}

class PersonWithLongTableNameTable extends _is.Table<int?> {
  PersonWithLongTableNameTable({super.tableRelation})
    : super(tableName: 'person_with_long_table_name_that_is_still_valid') {
    updateTable = PersonWithLongTableNameUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    organizationId = _is.ColumnInt(
      'organizationId',
      this,
    );
    $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id =
        _is.ColumnInt(
          '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id',
          this,
        );
  }

  late final PersonWithLongTableNameUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt organizationId;

  _imc5i9r4.OrganizationWithLongTableNameTable? _organization;

  late final _is.ColumnInt
  $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id;

  _imc5i9r4.OrganizationWithLongTableNameTable get organization {
    if (_organization != null) return _organization!;
    _organization = _is.createRelationTable(
      relationFieldName: 'organization',
      field: PersonWithLongTableName.t.organizationId,
      foreignField: _imc5i9r4.OrganizationWithLongTableName.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _imc5i9r4.OrganizationWithLongTableNameTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return _organization!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    organizationId,
    $_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id,
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

class PersonWithLongTableNameInclude extends _is.IncludeObject {
  PersonWithLongTableNameInclude.internal_({
    _imc5i9r4.OrganizationWithLongTableNameInclude? organization,
    this.selectedColumns,
  }) {
    _organization = organization;
  }

  _imc5i9r4.OrganizationWithLongTableNameInclude? _organization;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'organization': _organization};

  @override
  _is.Table<int?> get table => PersonWithLongTableName.t;
}

class PersonWithLongTableNameIncludeList extends _is.IncludeList {
  PersonWithLongTableNameIncludeList.internal_({
    _is.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(PersonWithLongTableName.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PersonWithLongTableName.t;
}

class PersonWithLongTableNameRepository {
  const PersonWithLongTableNameRepository._();

  final attachRow = const PersonWithLongTableNameAttachRowRepository._();

  final detachRow = const PersonWithLongTableNameDetachRowRepository._();

  /// Returns a list of [PersonWithLongTableName]s matching the given query parameters.
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
  Future<List<PersonWithLongTableName>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PersonWithLongTableName>(
      where: where?.call(PersonWithLongTableName.t),
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PersonWithLongTableName] matching the given query parameters.
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
  Future<PersonWithLongTableName?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? offset,
    _is.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PersonWithLongTableName>(
      where: where?.call(PersonWithLongTableName.t),
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PersonWithLongTableName] by its [id] or null if no such row exists.
  Future<PersonWithLongTableName?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    PersonWithLongTableNameInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PersonWithLongTableName>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PersonWithLongTableName]s in the list and returns the inserted rows.
  ///
  /// The returned [PersonWithLongTableName]s will have their `id` fields set.
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
  Future<List<PersonWithLongTableName>> insert(
    _is.DatabaseSession session,
    List<PersonWithLongTableName> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PersonWithLongTableName>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PersonWithLongTableName] and returns the inserted row.
  ///
  /// The returned [PersonWithLongTableName] will have its `id` field set.
  Future<PersonWithLongTableName> insertRow(
    _is.DatabaseSession session,
    PersonWithLongTableName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PersonWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PersonWithLongTableName]s in the list and returns the resulting rows.
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
  /// The returned [PersonWithLongTableName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PersonWithLongTableName>> upsert(
    _is.DatabaseSession session,
    List<PersonWithLongTableName> rows, {
    required _is.ColumnSelections<PersonWithLongTableNameTable> conflictColumns,
    _is.ColumnSelections<PersonWithLongTableNameTable>? updateColumns,
    _is.WhereExpressionBuilder<PersonWithLongTableNameTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PersonWithLongTableName>(
      rows,
      conflictColumns: conflictColumns(PersonWithLongTableName.t),
      updateColumns: updateColumns?.call(PersonWithLongTableName.t),
      updateWhere: updateWhere?.call(PersonWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PersonWithLongTableName] and returns the resulting row.
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
  /// The returned [PersonWithLongTableName] will have its `id` field set.
  Future<PersonWithLongTableName?> upsertRow(
    _is.DatabaseSession session,
    PersonWithLongTableName row, {
    required _is.ColumnSelections<PersonWithLongTableNameTable> conflictColumns,
    _is.ColumnSelections<PersonWithLongTableNameTable>? updateColumns,
    _is.WhereExpressionBuilder<PersonWithLongTableNameTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PersonWithLongTableName>(
      row,
      conflictColumns: conflictColumns(PersonWithLongTableName.t),
      updateColumns: updateColumns?.call(PersonWithLongTableName.t),
      updateWhere: updateWhere?.call(PersonWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Updates all [PersonWithLongTableName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PersonWithLongTableName>> update(
    _is.DatabaseSession session,
    List<PersonWithLongTableName> rows, {
    _is.ColumnSelections<PersonWithLongTableNameTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PersonWithLongTableName>(
      rows,
      columns: columns?.call(PersonWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PersonWithLongTableName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PersonWithLongTableName> updateRow(
    _is.DatabaseSession session,
    PersonWithLongTableName row, {
    _is.ColumnSelections<PersonWithLongTableNameTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PersonWithLongTableName>(
      row,
      columns: columns?.call(PersonWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PersonWithLongTableName] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PersonWithLongTableName?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PersonWithLongTableNameUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PersonWithLongTableName>(
      id,
      columnValues: columnValues(PersonWithLongTableName.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PersonWithLongTableName]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PersonWithLongTableName>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PersonWithLongTableNameUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<PersonWithLongTableNameTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PersonWithLongTableName>(
      columnValues: columnValues(PersonWithLongTableName.t.updateTable),
      where: where(PersonWithLongTableName.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PersonWithLongTableName]s in the list and returns the deleted rows.
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
  Future<List<PersonWithLongTableName>> delete(
    _is.DatabaseSession session,
    List<PersonWithLongTableName> rows, {
    _is.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PersonWithLongTableName>(
      rows,
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PersonWithLongTableName].
  Future<PersonWithLongTableName> deleteRow(
    _is.DatabaseSession session,
    PersonWithLongTableName row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PersonWithLongTableName>(
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
  Future<List<PersonWithLongTableName>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PersonWithLongTableNameTable> where,
    _is.OrderByBuilder<PersonWithLongTableNameTable>? orderBy,
    _is.OrderByListBuilder<PersonWithLongTableNameTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PersonWithLongTableName>(
      where: where(PersonWithLongTableName.t),
      orderBy: orderBy?.call(PersonWithLongTableName.t),
      orderByList: orderByList?.call(PersonWithLongTableName.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PersonWithLongTableNameTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PersonWithLongTableName>(
      where: where?.call(PersonWithLongTableName.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PersonWithLongTableName] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PersonWithLongTableNameTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PersonWithLongTableName>(
      where: where(PersonWithLongTableName.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PersonWithLongTableNameAttachRowRepository {
  const PersonWithLongTableNameAttachRowRepository._();

  /// Creates a relation between the given [PersonWithLongTableName] and [OrganizationWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to refer to the [OrganizationWithLongTableName].
  Future<void> organization(
    _is.DatabaseSession session,
    PersonWithLongTableName personWithLongTableName,
    _imc5i9r4.OrganizationWithLongTableName organization, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organization.id == null) {
      throw ArgumentError.notNull('organization.id');
    }

    var $personWithLongTableName = personWithLongTableName.copyWith(
      organizationId: organization.id,
    );
    await session.db.updateRow<PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

class PersonWithLongTableNameDetachRowRepository {
  const PersonWithLongTableNameDetachRowRepository._();

  /// Detaches the relation between this [PersonWithLongTableName] and the [OrganizationWithLongTableName] set in `organization`
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> organization(
    _is.DatabaseSession session,
    PersonWithLongTableName personWithLongTableName, {
    _is.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName.copyWith(
      organizationId: null,
    );
    await session.db.updateRow<PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

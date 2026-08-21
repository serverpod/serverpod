/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:meta/meta.dart' as _i2;

abstract class ProjectedAddress
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ProjectedAddress._({
    this.id,
    required this.street,
    required this.state,
    required this.country,
  });

  factory ProjectedAddress({
    int? id,
    required String street,
    required String state,
    required String country,
  }) = _ProjectedAddressImpl;

  factory ProjectedAddress.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedAddress(
      id: jsonSerialization['id'] as int?,
      street: jsonSerialization['street'] as String,
      state: jsonSerialization['state'] as String,
      country: jsonSerialization['country'] as String,
    );
  }

  static final t = ProjectedAddressTable();

  static const db = ProjectedAddressRepository._();

  @override
  int? id;

  String street;

  String state;

  String country;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ProjectedAddress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ProjectedAddress copyWith({
    int? id,
    String? street,
    String? state,
    String? country,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedAddress',
      if (id != null) 'id': id,
      'street': street,
      'state': state,
      'country': country,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedAddress',
      if (id != null) 'id': id,
      'street': street,
      'state': state,
      'country': country,
    };
  }

  static ProjectedAddressInclude include() {
    return ProjectedAddressInclude.internal_();
  }

  static ProjectedAddressIncludeList includeList({
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    ProjectedAddressInclude? include,
  }) {
    return ProjectedAddressIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedAddress.t),
      orderDescending: // ignore: deprecated_member_use_from_same_package
          orderDescending,
      orderByList: orderByList?.call(ProjectedAddress.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedAddressImpl extends ProjectedAddress {
  _ProjectedAddressImpl({
    int? id,
    required String street,
    required String state,
    required String country,
  }) : super._(
         id: id,
         street: street,
         state: state,
         country: country,
       );

  /// Returns a shallow copy of this [ProjectedAddress]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ProjectedAddress copyWith({
    Object? id = _Undefined,
    String? street,
    String? state,
    String? country,
  }) {
    return ProjectedAddress(
      id: id is int? ? id : this.id,
      street: street ?? this.street,
      state: state ?? this.state,
      country: country ?? this.country,
    );
  }
}

class ProjectedAddressUpdateTable
    extends _i1.UpdateTable<ProjectedAddressTable> {
  ProjectedAddressUpdateTable(super.table);

  _i1.ColumnValue<String, String> street(String value) => _i1.ColumnValue(
    table.street,
    value,
  );

  _i1.ColumnValue<String, String> state(String value) => _i1.ColumnValue(
    table.state,
    value,
  );

  _i1.ColumnValue<String, String> country(String value) => _i1.ColumnValue(
    table.country,
    value,
  );
}

class ProjectedAddressTable extends _i1.Table<int?> {
  ProjectedAddressTable({super.tableRelation})
    : super(tableName: 'projected_addresses') {
    updateTable = ProjectedAddressUpdateTable(this);
    street = _i1.ColumnString(
      'street',
      this,
    );
    state = _i1.ColumnString(
      'state',
      this,
    );
    country = _i1.ColumnString(
      'country',
      this,
    );
  }

  late final ProjectedAddressUpdateTable updateTable;

  late final _i1.ColumnString street;

  late final _i1.ColumnString state;

  late final _i1.ColumnString country;

  @override
  List<_i1.Column> get columns => [
    id,
    street,
    state,
    country,
  ];
}

class ProjectedAddressInclude extends _i1.IncludeObject {
  @_i2.internal
  ProjectedAddressInclude.internal_({List<_i1.Column>? this.selectedColumns}) {}

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ProjectedAddress.t;
}

class ProjectedAddressIncludeList extends _i1.IncludeList {
  @_i2.internal
  ProjectedAddressIncludeList.internal_({
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    super.orderDescending,
    super.orderByList,
    super.include,
    List<_i1.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedAddress.t);
  }

  final List<_i1.Column>? selectedColumns;

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ProjectedAddress.t;
}

class ProjectedAddressRepository {
  const ProjectedAddressRepository._();

  /// Returns a list of [ProjectedAddress]s matching the given query parameters.
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
  Future<List<ProjectedAddress>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedAddress>(
      where: where?.call(ProjectedAddress.t),
      orderBy: orderBy?.call(ProjectedAddress.t),
      orderByList: orderByList?.call(ProjectedAddress.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedAddress] matching the given query parameters.
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
  Future<ProjectedAddress?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedAddress>(
      where: where?.call(ProjectedAddress.t),
      orderBy: orderBy?.call(ProjectedAddress.t),
      orderByList: orderByList?.call(ProjectedAddress.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedAddress] by its [id] or null if no such row exists.
  Future<ProjectedAddress?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedAddress>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedAddress]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedAddress]s will have their `id` fields set.
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
  Future<List<ProjectedAddress>> insert(
    _i1.DatabaseSession session,
    List<ProjectedAddress> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedAddress>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedAddress] and returns the inserted row.
  ///
  /// The returned [ProjectedAddress] will have its `id` field set.
  Future<ProjectedAddress> insertRow(
    _i1.DatabaseSession session,
    ProjectedAddress row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedAddress>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedAddress]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedAddress]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedAddress>> upsert(
    _i1.DatabaseSession session,
    List<ProjectedAddress> rows, {
    required _i1.ColumnSelections<ProjectedAddressTable> conflictColumns,
    _i1.ColumnSelections<ProjectedAddressTable>? updateColumns,
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? updateWhere,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedAddress>(
      rows,
      conflictColumns: conflictColumns(ProjectedAddress.t),
      updateColumns: updateColumns?.call(ProjectedAddress.t),
      updateWhere: updateWhere?.call(ProjectedAddress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedAddress] and returns the resulting row.
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
  /// The returned [ProjectedAddress] will have its `id` field set.
  Future<ProjectedAddress?> upsertRow(
    _i1.DatabaseSession session,
    ProjectedAddress row, {
    required _i1.ColumnSelections<ProjectedAddressTable> conflictColumns,
    _i1.ColumnSelections<ProjectedAddressTable>? updateColumns,
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? updateWhere,
    _i1.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedAddress>(
      row,
      conflictColumns: conflictColumns(ProjectedAddress.t),
      updateColumns: updateColumns?.call(ProjectedAddress.t),
      updateWhere: updateWhere?.call(ProjectedAddress.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedAddress]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedAddress>> update(
    _i1.DatabaseSession session,
    List<ProjectedAddress> rows, {
    _i1.ColumnSelections<ProjectedAddressTable>? columns,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedAddress>(
      rows,
      columns: columns?.call(ProjectedAddress.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedAddress]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedAddress> updateRow(
    _i1.DatabaseSession session,
    ProjectedAddress row, {
    _i1.ColumnSelections<ProjectedAddressTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedAddress>(
      row,
      columns: columns?.call(ProjectedAddress.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedAddress] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedAddress?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProjectedAddressUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedAddress>(
      id,
      columnValues: columnValues(ProjectedAddress.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedAddress]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedAddress>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProjectedAddressUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ProjectedAddressTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    _i1.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedAddress>(
      columnValues: columnValues(ProjectedAddress.t.updateTable),
      where: where(ProjectedAddress.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedAddress.t),
      orderByList: orderByList?.call(ProjectedAddress.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedAddress]s in the list and returns the deleted rows.
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
  Future<List<ProjectedAddress>> delete(
    _i1.DatabaseSession session,
    List<ProjectedAddress> rows, {
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedAddress>(
      rows,
      orderBy: orderBy?.call(ProjectedAddress.t),
      orderByList: orderByList?.call(ProjectedAddress.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedAddress].
  Future<ProjectedAddress> deleteRow(
    _i1.DatabaseSession session,
    ProjectedAddress row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedAddress>(
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
  Future<List<ProjectedAddress>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectedAddressTable> where,
    _i1.OrderByBuilder<ProjectedAddressTable>? orderBy,
    @Deprecated('Use desc() on the orderBy column instead.')
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProjectedAddressTable>? orderByList,
    _i1.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedAddress>(
      where: where(ProjectedAddress.t),
      orderBy: orderBy?.call(ProjectedAddress.t),
      orderByList: orderByList?.call(ProjectedAddress.t),
      orderDescending: // ignore: deprecated_member_use
          orderDescending,
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProjectedAddressTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedAddress>(
      where: where?.call(ProjectedAddress.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedAddress] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProjectedAddressTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedAddress>(
      where: where(ProjectedAddress.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

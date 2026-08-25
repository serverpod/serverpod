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
import 'package:serverpod/serverpod.dart' as _is;

abstract class Service
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Service._({
    this.id,
    required this.name,
    this.description,
  });

  factory Service({
    int? id,
    required String name,
    String? description,
  }) = _ServiceImpl;

  factory Service.fromJson(Map<String, dynamic> jsonSerialization) {
    return Service(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  static final t = ServiceTable();

  static const db = ServiceRepository._();

  @override
  int? id;

  String name;

  String? description;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Service]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Service copyWith({
    int? id,
    String? name,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Service',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Service',
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  static ServiceInclude include({
    _is.SelectColumnsBuilder<ServiceTable>? select,
  }) {
    return ServiceInclude._(selectedColumns: select?.call(Service.t));
  }

  static ServiceIncludeList includeList({
    _is.WhereExpressionBuilder<ServiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    ServiceInclude? include,
    _is.SelectColumnsBuilder<ServiceTable>? select,
  }) {
    return ServiceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      include: include,
      selectedColumns: select?.call(Service.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ServiceImpl extends Service {
  _ServiceImpl({
    int? id,
    required String name,
    String? description,
  }) : super._(
         id: id,
         name: name,
         description: description,
       );

  /// Returns a shallow copy of this [Service]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Service copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
  }) {
    return Service(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
    );
  }
}

class ServiceUpdateTable extends _is.UpdateTable<ServiceTable> {
  ServiceUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );
}

class ServiceTable extends _is.Table<int?> {
  ServiceTable({super.tableRelation}) : super(tableName: 'service') {
    updateTable = ServiceUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
  }

  late final ServiceUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    description,
  ];
}

class ServiceInclude extends _is.IncludeObject {
  ServiceInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Service.t;
}

class ServiceIncludeList extends _is.IncludeList {
  ServiceIncludeList._({
    _is.WhereExpressionBuilder<ServiceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Service.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Service.t;
}

class ServiceRepository {
  const ServiceRepository._();

  /// Returns a list of [Service]s matching the given query parameters.
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
  Future<List<Service>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Service>(
      where: where?.call(Service.t),
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Service] matching the given query parameters.
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
  Future<Service?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceTable>? where,
    int? offset,
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Service>(
      where: where?.call(Service.t),
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Service] by its [id] or null if no such row exists.
  Future<Service?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Service>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ServiceTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Service>(
      where: where?.call(Service.t),
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(Service.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceTable>? where,
    int? offset,
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ServiceTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Service>(
      where: where?.call(Service.t),
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(Service.t),
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
    _is.SelectColumnsBuilder<ServiceTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Service>(
      id,
      transaction: transaction,
      select: select?.call(Service.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Service]s in the list and returns the inserted rows.
  ///
  /// The returned [Service]s will have their `id` fields set.
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
  Future<List<Service>> insert(
    _is.DatabaseSession session,
    List<Service> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Service>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Service] and returns the inserted row.
  ///
  /// The returned [Service] will have its `id` field set.
  Future<Service> insertRow(
    _is.DatabaseSession session,
    Service row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Service>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Service]s in the list and returns the resulting rows.
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
  /// The returned [Service]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Service>> upsert(
    _is.DatabaseSession session,
    List<Service> rows, {
    required _is.ColumnSelections<ServiceTable> conflictColumns,
    _is.ColumnSelections<ServiceTable>? updateColumns,
    _is.WhereExpressionBuilder<ServiceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Service>(
      rows,
      conflictColumns: conflictColumns(Service.t),
      updateColumns: updateColumns?.call(Service.t),
      updateWhere: updateWhere?.call(Service.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Service] and returns the resulting row.
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
  /// The returned [Service] will have its `id` field set.
  Future<Service?> upsertRow(
    _is.DatabaseSession session,
    Service row, {
    required _is.ColumnSelections<ServiceTable> conflictColumns,
    _is.ColumnSelections<ServiceTable>? updateColumns,
    _is.WhereExpressionBuilder<ServiceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Service>(
      row,
      conflictColumns: conflictColumns(Service.t),
      updateColumns: updateColumns?.call(Service.t),
      updateWhere: updateWhere?.call(Service.t),
      transaction: transaction,
    );
  }

  /// Updates all [Service]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Service>> update(
    _is.DatabaseSession session,
    List<Service> rows, {
    _is.ColumnSelections<ServiceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Service>(
      rows,
      columns: columns?.call(Service.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Service]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Service> updateRow(
    _is.DatabaseSession session,
    Service row, {
    _is.ColumnSelections<ServiceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Service>(
      row,
      columns: columns?.call(Service.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Service] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Service?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ServiceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Service>(
      id,
      columnValues: columnValues(Service.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Service]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Service>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ServiceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ServiceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Service>(
      columnValues: columnValues(Service.t.updateTable),
      where: where(Service.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Service]s in the list and returns the deleted rows.
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
  Future<List<Service>> delete(
    _is.DatabaseSession session,
    List<Service> rows, {
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Service>(
      rows,
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Service].
  Future<Service> deleteRow(
    _is.DatabaseSession session,
    Service row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Service>(
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
  Future<List<Service>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServiceTable> where,
    _is.OrderByBuilder<ServiceTable>? orderBy,
    _is.OrderByListBuilder<ServiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Service>(
      where: where(Service.t),
      orderBy: orderBy?.call(Service.t),
      orderByList: orderByList?.call(Service.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ServiceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Service>(
      where: where?.call(Service.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Service] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ServiceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Service>(
      where: where(Service.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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

abstract class ProjectedOrder
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  ProjectedOrder._({
    this.id,
    required this.description,
    this.summary,
    required this.price,
  }) : _projectedUserOrdersProjectedUserId = null;

  factory ProjectedOrder({
    _is.UuidValue? id,
    required String description,
    String? summary,
    required double price,
  }) = _ProjectedOrderImpl;

  factory ProjectedOrder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedOrderImplicit._(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      description: jsonSerialization['description'] as String,
      summary: jsonSerialization['summary'] as String?,
      price: (jsonSerialization['price'] as num).toDouble(),
      $_projectedUserOrdersProjectedUserId:
          jsonSerialization['_projectedUserOrdersProjectedUserId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(
              jsonSerialization['_projectedUserOrdersProjectedUserId'],
            ),
    );
  }

  static final t = ProjectedOrderTable();

  static const db = ProjectedOrderRepository._();

  @override
  _is.UuidValue? id;

  String description;

  String? summary;

  double price;

  final _is.UuidValue? _projectedUserOrdersProjectedUserId;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [ProjectedOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProjectedOrder copyWith({
    _is.UuidValue? id,
    String? description,
    String? summary,
    double? price,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedOrder',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
      'price': price,
      if (_projectedUserOrdersProjectedUserId != null)
        '_projectedUserOrdersProjectedUserId':
            _projectedUserOrdersProjectedUserId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedOrder',
      if (id != null) 'id': id?.toJson(),
      'description': description,
      if (summary != null) 'summary': summary,
      'price': price,
    };
  }

  static ProjectedOrderInclude include({
    _is.SelectColumnsBuilder<ProjectedOrderTable>? select,
  }) {
    return ProjectedOrderInclude._(
      selectedColumns: select?.call(ProjectedOrder.t),
    );
  }

  static ProjectedOrderIncludeList includeList({
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    ProjectedOrderInclude? include,
    _is.SelectColumnsBuilder<ProjectedOrderTable>? select,
  }) {
    return ProjectedOrderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      include: include,
      selectedColumns: select?.call(ProjectedOrder.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedOrderImpl extends ProjectedOrder {
  _ProjectedOrderImpl({
    _is.UuidValue? id,
    required String description,
    String? summary,
    required double price,
  }) : super._(
         id: id,
         description: description,
         summary: summary,
         price: price,
       );

  /// Returns a shallow copy of this [ProjectedOrder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProjectedOrder copyWith({
    Object? id = _Undefined,
    String? description,
    Object? summary = _Undefined,
    double? price,
  }) {
    return ProjectedOrderImplicit._(
      id: id is _is.UuidValue? ? id : this.id,
      description: description ?? this.description,
      summary: summary is String? ? summary : this.summary,
      price: price ?? this.price,
      $_projectedUserOrdersProjectedUserId:
          this._projectedUserOrdersProjectedUserId,
    );
  }
}

class ProjectedOrderImplicit extends _ProjectedOrderImpl {
  ProjectedOrderImplicit._({
    _is.UuidValue? id,
    required String description,
    String? summary,
    required double price,
    _is.UuidValue? $_projectedUserOrdersProjectedUserId,
  }) : _projectedUserOrdersProjectedUserId =
           $_projectedUserOrdersProjectedUserId,
       super(
         id: id,
         description: description,
         summary: summary,
         price: price,
       );

  factory ProjectedOrderImplicit(
    ProjectedOrder projectedOrder, {
    _is.UuidValue? $_projectedUserOrdersProjectedUserId,
  }) {
    return ProjectedOrderImplicit._(
      id: projectedOrder.id,
      description: projectedOrder.description,
      summary: projectedOrder.summary,
      price: projectedOrder.price,
      $_projectedUserOrdersProjectedUserId:
          $_projectedUserOrdersProjectedUserId,
    );
  }

  @override
  final _is.UuidValue? _projectedUserOrdersProjectedUserId;
}

class ProjectedOrderUpdateTable extends _is.UpdateTable<ProjectedOrderTable> {
  ProjectedOrderUpdateTable(super.table);

  _is.ColumnValue<String, String> description(String value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> summary(String? value) => _is.ColumnValue(
    table.summary,
    value,
  );

  _is.ColumnValue<double, double> price(double value) => _is.ColumnValue(
    table.price,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue>
  $_projectedUserOrdersProjectedUserId(_is.UuidValue? value) => _is.ColumnValue(
    table.$_projectedUserOrdersProjectedUserId,
    value,
  );
}

class ProjectedOrderTable extends _is.Table<_is.UuidValue?> {
  ProjectedOrderTable({super.tableRelation})
    : super(tableName: 'projected_order') {
    updateTable = ProjectedOrderUpdateTable(this);
    description = _is.ColumnString(
      'description',
      this,
    );
    summary = _is.ColumnString(
      'summary',
      this,
    );
    price = _is.ColumnDouble(
      'price',
      this,
    );
    $_projectedUserOrdersProjectedUserId = _is.ColumnUuid(
      '_projectedUserOrdersProjectedUserId',
      this,
    );
  }

  late final ProjectedOrderUpdateTable updateTable;

  late final _is.ColumnString description;

  late final _is.ColumnString summary;

  late final _is.ColumnDouble price;

  late final _is.ColumnUuid $_projectedUserOrdersProjectedUserId;

  @override
  List<_is.Column> get columns => [
    id,
    description,
    summary,
    price,
    $_projectedUserOrdersProjectedUserId,
  ];

  @override
  List<_is.Column> get managedColumns => [
    id,
    description,
    summary,
    price,
  ];
}

class ProjectedOrderInclude extends _is.IncludeObject {
  ProjectedOrderInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectedOrder.t;
}

class ProjectedOrderIncludeList extends _is.IncludeList {
  ProjectedOrderIncludeList._({
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ProjectedOrder.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => ProjectedOrder.t;
}

class ProjectedOrderRepository {
  const ProjectedOrderRepository._();

  /// Returns a list of [ProjectedOrder]s matching the given query parameters.
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
  Future<List<ProjectedOrder>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProjectedOrder>(
      where: where?.call(ProjectedOrder.t),
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ProjectedOrder] matching the given query parameters.
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
  Future<ProjectedOrder?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProjectedOrder>(
      where: where?.call(ProjectedOrder.t),
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProjectedOrder] by its [id] or null if no such row exists.
  Future<ProjectedOrder?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProjectedOrder>(
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
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ProjectedOrderTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ProjectedOrder>(
      where: where?.call(ProjectedOrder.t),
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ProjectedOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.

  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ProjectedOrderTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ProjectedOrder>(
      where: where?.call(ProjectedOrder.t),
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ProjectedOrder.t),
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
    _is.SelectColumnsBuilder<ProjectedOrderTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ProjectedOrder>(
      id,
      transaction: transaction,
      select: select?.call(ProjectedOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProjectedOrder]s in the list and returns the inserted rows.
  ///
  /// The returned [ProjectedOrder]s will have their `id` fields set.
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
  Future<List<ProjectedOrder>> insert(
    _is.DatabaseSession session,
    List<ProjectedOrder> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProjectedOrder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProjectedOrder] and returns the inserted row.
  ///
  /// The returned [ProjectedOrder] will have its `id` field set.
  Future<ProjectedOrder> insertRow(
    _is.DatabaseSession session,
    ProjectedOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProjectedOrder>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProjectedOrder]s in the list and returns the resulting rows.
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
  /// The returned [ProjectedOrder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedOrder>> upsert(
    _is.DatabaseSession session,
    List<ProjectedOrder> rows, {
    required _is.ColumnSelections<ProjectedOrderTable> conflictColumns,
    _is.ColumnSelections<ProjectedOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedOrderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProjectedOrder>(
      rows,
      conflictColumns: conflictColumns(ProjectedOrder.t),
      updateColumns: updateColumns?.call(ProjectedOrder.t),
      updateWhere: updateWhere?.call(ProjectedOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProjectedOrder] and returns the resulting row.
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
  /// The returned [ProjectedOrder] will have its `id` field set.
  Future<ProjectedOrder?> upsertRow(
    _is.DatabaseSession session,
    ProjectedOrder row, {
    required _is.ColumnSelections<ProjectedOrderTable> conflictColumns,
    _is.ColumnSelections<ProjectedOrderTable>? updateColumns,
    _is.WhereExpressionBuilder<ProjectedOrderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProjectedOrder>(
      row,
      conflictColumns: conflictColumns(ProjectedOrder.t),
      updateColumns: updateColumns?.call(ProjectedOrder.t),
      updateWhere: updateWhere?.call(ProjectedOrder.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedOrder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedOrder>> update(
    _is.DatabaseSession session,
    List<ProjectedOrder> rows, {
    _is.ColumnSelections<ProjectedOrderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProjectedOrder>(
      rows,
      columns: columns?.call(ProjectedOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProjectedOrder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProjectedOrder> updateRow(
    _is.DatabaseSession session,
    ProjectedOrder row, {
    _is.ColumnSelections<ProjectedOrderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProjectedOrder>(
      row,
      columns: columns?.call(ProjectedOrder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProjectedOrder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProjectedOrder?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProjectedOrderUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProjectedOrder>(
      id,
      columnValues: columnValues(ProjectedOrder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProjectedOrder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProjectedOrder>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProjectedOrderUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProjectedOrderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProjectedOrder>(
      columnValues: columnValues(ProjectedOrder.t.updateTable),
      where: where(ProjectedOrder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProjectedOrder]s in the list and returns the deleted rows.
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
  Future<List<ProjectedOrder>> delete(
    _is.DatabaseSession session,
    List<ProjectedOrder> rows, {
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProjectedOrder>(
      rows,
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProjectedOrder].
  Future<ProjectedOrder> deleteRow(
    _is.DatabaseSession session,
    ProjectedOrder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProjectedOrder>(
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
  Future<List<ProjectedOrder>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedOrderTable> where,
    _is.OrderByBuilder<ProjectedOrderTable>? orderBy,
    _is.OrderByListBuilder<ProjectedOrderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProjectedOrder>(
      where: where(ProjectedOrder.t),
      orderBy: orderBy?.call(ProjectedOrder.t),
      orderByList: orderByList?.call(ProjectedOrder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProjectedOrderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProjectedOrder>(
      where: where?.call(ProjectedOrder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProjectedOrder] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProjectedOrderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProjectedOrder>(
      where: where(ProjectedOrder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

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
import '../../protocol.dart' as _iototaiw;

abstract class ChildEntity extends _iototaiw.BaseEntity
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  ChildEntity._({
    this.id,
    required super.sharedField,
    required this.localField,
  }) : _parentEntityChildrenParentEntityId = null;

  factory ChildEntity({
    int? id,
    required String sharedField,
    required String localField,
  }) = _ChildEntityImpl;

  factory ChildEntity.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildEntityImplicit._(
      id: jsonSerialization['id'] as int?,
      sharedField: jsonSerialization['sharedField'] as String,
      localField: jsonSerialization['localField'] as String,
      $_parentEntityChildrenParentEntityId:
          jsonSerialization['_parentEntityChildrenParentEntityId'] as int?,
    );
  }

  static final t = ChildEntityTable();

  static const db = ChildEntityRepository._();

  @override
  int? id;

  String localField;

  final int? _parentEntityChildrenParentEntityId;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [ChildEntity]
  /// with some or all fields replaced by the given arguments.
  @override
  @_is.useResult
  ChildEntity copyWith({
    int? id,
    String? sharedField,
    String? localField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildEntity',
      if (id != null) 'id': id,
      'sharedField': sharedField,
      'localField': localField,
      if (_parentEntityChildrenParentEntityId != null)
        '_parentEntityChildrenParentEntityId':
            _parentEntityChildrenParentEntityId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChildEntity',
      if (id != null) 'id': id,
      'sharedField': sharedField,
      'localField': localField,
    };
  }

  static ChildEntityInclude include({
    _is.SelectColumnsBuilder<ChildEntityTable>? select,
  }) {
    return ChildEntityInclude._(selectedColumns: select?.call(ChildEntity.t));
  }

  static ChildEntityIncludeList includeList({
    _is.WhereExpressionBuilder<ChildEntityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    ChildEntityInclude? include,
    _is.SelectColumnsBuilder<ChildEntityTable>? select,
  }) {
    return ChildEntityIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      include: include,
      selectedColumns: select?.call(ChildEntity.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildEntityImpl extends ChildEntity {
  _ChildEntityImpl({
    int? id,
    required String sharedField,
    required String localField,
  }) : super._(
         id: id,
         sharedField: sharedField,
         localField: localField,
       );

  /// Returns a shallow copy of this [ChildEntity]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChildEntity copyWith({
    Object? id = _Undefined,
    String? sharedField,
    String? localField,
  }) {
    return ChildEntityImplicit._(
      id: id is int? ? id : this.id,
      sharedField: sharedField ?? this.sharedField,
      localField: localField ?? this.localField,
      $_parentEntityChildrenParentEntityId:
          this._parentEntityChildrenParentEntityId,
    );
  }
}

class ChildEntityImplicit extends _ChildEntityImpl {
  ChildEntityImplicit._({
    int? id,
    required String sharedField,
    required String localField,
    int? $_parentEntityChildrenParentEntityId,
  }) : _parentEntityChildrenParentEntityId =
           $_parentEntityChildrenParentEntityId,
       super(
         id: id,
         sharedField: sharedField,
         localField: localField,
       );

  factory ChildEntityImplicit(
    ChildEntity childEntity, {
    int? $_parentEntityChildrenParentEntityId,
  }) {
    return ChildEntityImplicit._(
      id: childEntity.id,
      sharedField: childEntity.sharedField,
      localField: childEntity.localField,
      $_parentEntityChildrenParentEntityId:
          $_parentEntityChildrenParentEntityId,
    );
  }

  @override
  final int? _parentEntityChildrenParentEntityId;
}

class ChildEntityUpdateTable extends _is.UpdateTable<ChildEntityTable> {
  ChildEntityUpdateTable(super.table);

  _is.ColumnValue<String, String> sharedField(String value) => _is.ColumnValue(
    table.sharedField,
    value,
  );

  _is.ColumnValue<String, String> localField(String value) => _is.ColumnValue(
    table.localField,
    value,
  );

  _is.ColumnValue<int, int> $_parentEntityChildrenParentEntityId(int? value) =>
      _is.ColumnValue(
        table.$_parentEntityChildrenParentEntityId,
        value,
      );
}

class ChildEntityTable extends _is.Table<int?> {
  ChildEntityTable({super.tableRelation}) : super(tableName: 'child_entity') {
    updateTable = ChildEntityUpdateTable(this);
    sharedField = _is.ColumnString(
      'sharedField',
      this,
    );
    localField = _is.ColumnString(
      'localField',
      this,
    );
    $_parentEntityChildrenParentEntityId = _is.ColumnInt(
      '_parentEntityChildrenParentEntityId',
      this,
    );
  }

  late final ChildEntityUpdateTable updateTable;

  late final _is.ColumnString sharedField;

  late final _is.ColumnString localField;

  late final _is.ColumnInt $_parentEntityChildrenParentEntityId;

  @override
  List<_is.Column> get columns => [
    id,
    sharedField,
    localField,
    $_parentEntityChildrenParentEntityId,
  ];

  @override
  List<_is.Column> get managedColumns => [
    id,
    sharedField,
    localField,
  ];
}

class ChildEntityInclude extends _is.IncludeObject {
  ChildEntityInclude._({this.selectedColumns});

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => ChildEntity.t;
}

class ChildEntityIncludeList extends _is.IncludeList {
  ChildEntityIncludeList._({
    _is.WhereExpressionBuilder<ChildEntityTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(ChildEntity.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => ChildEntity.t;
}

class ChildEntityRepository {
  const ChildEntityRepository._();

  /// Returns a list of [ChildEntity]s matching the given query parameters.
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
  Future<List<ChildEntity>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildEntityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ChildEntity>(
      where: where?.call(ChildEntity.t),
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ChildEntity] matching the given query parameters.
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
  Future<ChildEntity?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildEntityTable>? where,
    int? offset,
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ChildEntity>(
      where: where?.call(ChildEntity.t),
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ChildEntity] by its [id] or null if no such row exists.
  Future<ChildEntity?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ChildEntity>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns a list of [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var persons = await Persons.db.findAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.lastName],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Map<String, dynamic>>> findAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildEntityTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ChildEntityTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<ChildEntity>(
      where: where?.call(ChildEntity.t),
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(ChildEntity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
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
  /// var youngestPerson = await Persons.db.findFirstRowAsJson(
  ///   session,
  ///   select: (t) => [t.firstName, t.age],
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Map<String, dynamic>?> findFirstRowAsJson(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildEntityTable>? where,
    int? offset,
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ChildEntityTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<ChildEntity>(
      where: where?.call(ChildEntity.t),
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(ChildEntity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    _is.SelectColumnsBuilder<ChildEntityTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<ChildEntity>(
      id,
      transaction: transaction,
      select: select?.call(ChildEntity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ChildEntity]s in the list and returns the inserted rows.
  ///
  /// The returned [ChildEntity]s will have their `id` fields set.
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
  Future<List<ChildEntity>> insert(
    _is.DatabaseSession session,
    List<ChildEntity> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ChildEntity>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ChildEntity] and returns the inserted row.
  ///
  /// The returned [ChildEntity] will have its `id` field set.
  Future<ChildEntity> insertRow(
    _is.DatabaseSession session,
    ChildEntity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ChildEntity>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ChildEntity]s in the list and returns the resulting rows.
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
  /// The returned [ChildEntity]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildEntity>> upsert(
    _is.DatabaseSession session,
    List<ChildEntity> rows, {
    required _is.ColumnSelections<ChildEntityTable> conflictColumns,
    _is.ColumnSelections<ChildEntityTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildEntityTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ChildEntity>(
      rows,
      conflictColumns: conflictColumns(ChildEntity.t),
      updateColumns: updateColumns?.call(ChildEntity.t),
      updateWhere: updateWhere?.call(ChildEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ChildEntity] and returns the resulting row.
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
  /// The returned [ChildEntity] will have its `id` field set.
  Future<ChildEntity?> upsertRow(
    _is.DatabaseSession session,
    ChildEntity row, {
    required _is.ColumnSelections<ChildEntityTable> conflictColumns,
    _is.ColumnSelections<ChildEntityTable>? updateColumns,
    _is.WhereExpressionBuilder<ChildEntityTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ChildEntity>(
      row,
      conflictColumns: conflictColumns(ChildEntity.t),
      updateColumns: updateColumns?.call(ChildEntity.t),
      updateWhere: updateWhere?.call(ChildEntity.t),
      transaction: transaction,
    );
  }

  /// Updates all [ChildEntity]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildEntity>> update(
    _is.DatabaseSession session,
    List<ChildEntity> rows, {
    _is.ColumnSelections<ChildEntityTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ChildEntity>(
      rows,
      columns: columns?.call(ChildEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ChildEntity]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ChildEntity> updateRow(
    _is.DatabaseSession session,
    ChildEntity row, {
    _is.ColumnSelections<ChildEntityTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ChildEntity>(
      row,
      columns: columns?.call(ChildEntity.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ChildEntity] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ChildEntity?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ChildEntityUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ChildEntity>(
      id,
      columnValues: columnValues(ChildEntity.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ChildEntity]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ChildEntity>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ChildEntityUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ChildEntityTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ChildEntity>(
      columnValues: columnValues(ChildEntity.t.updateTable),
      where: where(ChildEntity.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ChildEntity]s in the list and returns the deleted rows.
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
  Future<List<ChildEntity>> delete(
    _is.DatabaseSession session,
    List<ChildEntity> rows, {
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ChildEntity>(
      rows,
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ChildEntity].
  Future<ChildEntity> deleteRow(
    _is.DatabaseSession session,
    ChildEntity row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ChildEntity>(
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
  Future<List<ChildEntity>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildEntityTable> where,
    _is.OrderByBuilder<ChildEntityTable>? orderBy,
    _is.OrderByListBuilder<ChildEntityTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ChildEntity>(
      where: where(ChildEntity.t),
      orderBy: orderBy?.call(ChildEntity.t),
      orderByList: orderByList?.call(ChildEntity.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ChildEntityTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ChildEntity>(
      where: where?.call(ChildEntity.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ChildEntity] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ChildEntityTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ChildEntity>(
      where: where(ChildEntity.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

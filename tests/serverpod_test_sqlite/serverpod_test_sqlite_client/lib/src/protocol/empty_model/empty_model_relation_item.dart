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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;

abstract class EmptyModelRelationItem
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  EmptyModelRelationItem._({
    this.id,
    required this.name,
  }) : _relationEmptyModelItemsRelationEmptyModelId = null;

  factory EmptyModelRelationItem({
    int? id,
    required String name,
  }) = _EmptyModelRelationItemImpl;

  factory EmptyModelRelationItem.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmptyModelRelationItemImplicit._(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      $_relationEmptyModelItemsRelationEmptyModelId:
          jsonSerialization['_relationEmptyModelItemsRelationEmptyModelId']
              as int?,
    );
  }

  static final t = EmptyModelRelationItemTable();

  static const db = EmptyModelRelationItemRepository._();

  @override
  int? id;

  String name;

  final int? _relationEmptyModelItemsRelationEmptyModelId;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [EmptyModelRelationItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  EmptyModelRelationItem copyWith({
    int? id,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EmptyModelRelationItem',
      if (id != null) 'id': id,
      'name': name,
      if (_relationEmptyModelItemsRelationEmptyModelId != null)
        '_relationEmptyModelItemsRelationEmptyModelId':
            _relationEmptyModelItemsRelationEmptyModelId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EmptyModelRelationItem',
      if (id != null) 'id': id,
      'name': name,
    };
  }

  /// Builds a complete [EmptyModelRelationItemInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EmptyModelRelationItemInclude include() {
    return EmptyModelRelationItemInclude._();
  }

  /// Builds a complete [EmptyModelRelationItemIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static EmptyModelRelationItemIncludeList includeList({
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    EmptyModelRelationItemInclude? include,
  }) {
    return EmptyModelRelationItemIncludeList._(
      where: where?.call(EmptyModelRelationItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [EmptyModelRelationItemJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static EmptyModelRelationItemJsonInclude includeJson({
    _isd.SelectColumnsBuilder<EmptyModelRelationItemTable>? select,
  }) {
    return _EmptyModelRelationItemJsonInclude._(
      selectedColumns: select?.call(EmptyModelRelationItem.t),
    );
  }

  /// Builds a JSON-compatible [EmptyModelRelationItemJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static EmptyModelRelationItemJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    EmptyModelRelationItemJsonInclude? include,
    _isd.SelectColumnsBuilder<EmptyModelRelationItemTable>? select,
  }) {
    return _EmptyModelRelationItemJsonIncludeList._(
      where: where?.call(EmptyModelRelationItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      include: include,
      selectedColumns: select?.call(EmptyModelRelationItem.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EmptyModelRelationItemImpl extends EmptyModelRelationItem {
  _EmptyModelRelationItemImpl({
    int? id,
    required String name,
  }) : super._(
         id: id,
         name: name,
       );

  /// Returns a shallow copy of this [EmptyModelRelationItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  EmptyModelRelationItem copyWith({
    Object? id = _Undefined,
    String? name,
  }) {
    return EmptyModelRelationItemImplicit._(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      $_relationEmptyModelItemsRelationEmptyModelId:
          this._relationEmptyModelItemsRelationEmptyModelId,
    );
  }
}

class EmptyModelRelationItemImplicit extends _EmptyModelRelationItemImpl {
  EmptyModelRelationItemImplicit._({
    int? id,
    required String name,
    int? $_relationEmptyModelItemsRelationEmptyModelId,
  }) : _relationEmptyModelItemsRelationEmptyModelId =
           $_relationEmptyModelItemsRelationEmptyModelId,
       super(
         id: id,
         name: name,
       );

  factory EmptyModelRelationItemImplicit(
    EmptyModelRelationItem emptyModelRelationItem, {
    int? $_relationEmptyModelItemsRelationEmptyModelId,
  }) {
    return EmptyModelRelationItemImplicit._(
      id: emptyModelRelationItem.id,
      name: emptyModelRelationItem.name,
      $_relationEmptyModelItemsRelationEmptyModelId:
          $_relationEmptyModelItemsRelationEmptyModelId,
    );
  }

  @override
  final int? _relationEmptyModelItemsRelationEmptyModelId;
}

class EmptyModelRelationItemUpdateTable
    extends _isd.UpdateTable<EmptyModelRelationItemTable> {
  EmptyModelRelationItemUpdateTable(super.table);

  _isd.ColumnValue<String, String> name(String value) => _isd.ColumnValue(
    table.name,
    value,
  );

  _isd.ColumnValue<int, int> $_relationEmptyModelItemsRelationEmptyModelId(
    int? value,
  ) => _isd.ColumnValue(
    table.$_relationEmptyModelItemsRelationEmptyModelId,
    value,
  );
}

class EmptyModelRelationItemTable extends _isd.Table<int?> {
  EmptyModelRelationItemTable({super.tableRelation})
    : super(tableName: 'empty_model_relation_item') {
    updateTable = EmptyModelRelationItemUpdateTable(this);
    name = _isd.ColumnString(
      'name',
      this,
    );
    $_relationEmptyModelItemsRelationEmptyModelId = _isd.ColumnInt(
      '_relationEmptyModelItemsRelationEmptyModelId',
      this,
    );
  }

  late final EmptyModelRelationItemUpdateTable updateTable;

  late final _isd.ColumnString name;

  late final _isd.ColumnInt $_relationEmptyModelItemsRelationEmptyModelId;

  @override
  List<_isd.Column> get columns => [
    id,
    name,
    $_relationEmptyModelItemsRelationEmptyModelId,
  ];

  @override
  List<_isd.Column> get managedColumns => [
    id,
    name,
  ];
}

abstract interface class EmptyModelRelationItemJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class EmptyModelRelationItemJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class EmptyModelRelationItemInclude extends _isd.IncludeObject
    implements EmptyModelRelationItemJsonInclude, _isd.FullModelInclude {
  EmptyModelRelationItemInclude._();

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => EmptyModelRelationItem.t;
}

final class EmptyModelRelationItemIncludeList extends _isd.IncludeList
    implements EmptyModelRelationItemJsonIncludeList, _isd.FullModelInclude {
  EmptyModelRelationItemIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EmptyModelRelationItemInclude? super.include,
  });

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => EmptyModelRelationItem.t;
}

final class _EmptyModelRelationItemJsonInclude extends _isd.IncludeObject
    implements EmptyModelRelationItemJsonInclude {
  _EmptyModelRelationItemJsonInclude._({this.selectedColumns});

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {};

  @override
  _isd.Table<int?> get table => EmptyModelRelationItem.t;
}

final class _EmptyModelRelationItemJsonIncludeList extends _isd.IncludeList
    implements EmptyModelRelationItemJsonIncludeList {
  _EmptyModelRelationItemJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    EmptyModelRelationItemJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => EmptyModelRelationItem.t;
}

class EmptyModelRelationItemRepository {
  const EmptyModelRelationItemRepository._();

  /// Returns a list of [EmptyModelRelationItem]s matching the given query parameters.
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
  Future<List<EmptyModelRelationItem>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EmptyModelRelationItem] matching the given query parameters.
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
  Future<EmptyModelRelationItem?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? offset,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EmptyModelRelationItem] by its [id] or null if no such row exists.
  Future<EmptyModelRelationItem?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EmptyModelRelationItem>(
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
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<EmptyModelRelationItemTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      select: select?.call(EmptyModelRelationItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Map<String, dynamic>] matching the given query parameters.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.
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
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? offset,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<EmptyModelRelationItemTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      offset: offset,
      transaction: transaction,
      select: select?.call(EmptyModelRelationItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Map<String, dynamic>] by its [id] or null if no such row exists.
  ///
  /// Use [select] to specify which columns to include from the root table.
  /// If none is specified, all columns will be returned.
  /// Note: If an [include] with its own selected columns (e.g. via `includeJson(select: ...)`)
  /// is also provided at the root level, the include's `select` will take precedence.

  Future<Map<String, dynamic>?> findByIdAsJson(
    _isd.DatabaseSession session,
    Object id, {
    _isd.Transaction? transaction,
    _isd.SelectColumnsBuilder<EmptyModelRelationItemTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<EmptyModelRelationItem>(
      id,
      transaction: transaction,
      select: select?.call(EmptyModelRelationItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EmptyModelRelationItem]s in the list and returns the inserted rows.
  ///
  /// The returned [EmptyModelRelationItem]s will have their `id` fields set.
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
  Future<List<EmptyModelRelationItem>> insert(
    _isd.DatabaseSession session,
    List<EmptyModelRelationItem> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<EmptyModelRelationItem>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [EmptyModelRelationItem] and returns the inserted row.
  ///
  /// The returned [EmptyModelRelationItem] will have its `id` field set.
  Future<EmptyModelRelationItem> insertRow(
    _isd.DatabaseSession session,
    EmptyModelRelationItem row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<EmptyModelRelationItem>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [EmptyModelRelationItem]s in the list and returns the resulting rows.
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
  /// The returned [EmptyModelRelationItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmptyModelRelationItem>> upsert(
    _isd.DatabaseSession session,
    List<EmptyModelRelationItem> rows, {
    required _isd.ColumnSelections<EmptyModelRelationItemTable> conflictColumns,
    _isd.ColumnSelections<EmptyModelRelationItemTable>? updateColumns,
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<EmptyModelRelationItem>(
      rows,
      conflictColumns: conflictColumns(EmptyModelRelationItem.t),
      updateColumns: updateColumns?.call(EmptyModelRelationItem.t),
      updateWhere: updateWhere?.call(EmptyModelRelationItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [EmptyModelRelationItem] and returns the resulting row.
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
  /// The returned [EmptyModelRelationItem] will have its `id` field set.
  Future<EmptyModelRelationItem?> upsertRow(
    _isd.DatabaseSession session,
    EmptyModelRelationItem row, {
    required _isd.ColumnSelections<EmptyModelRelationItemTable> conflictColumns,
    _isd.ColumnSelections<EmptyModelRelationItemTable>? updateColumns,
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<EmptyModelRelationItem>(
      row,
      conflictColumns: conflictColumns(EmptyModelRelationItem.t),
      updateColumns: updateColumns?.call(EmptyModelRelationItem.t),
      updateWhere: updateWhere?.call(EmptyModelRelationItem.t),
      transaction: transaction,
    );
  }

  /// Updates all [EmptyModelRelationItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmptyModelRelationItem>> update(
    _isd.DatabaseSession session,
    List<EmptyModelRelationItem> rows, {
    _isd.ColumnSelections<EmptyModelRelationItemTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<EmptyModelRelationItem>(
      rows,
      columns: columns?.call(EmptyModelRelationItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [EmptyModelRelationItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EmptyModelRelationItem> updateRow(
    _isd.DatabaseSession session,
    EmptyModelRelationItem row, {
    _isd.ColumnSelections<EmptyModelRelationItemTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<EmptyModelRelationItem>(
      row,
      columns: columns?.call(EmptyModelRelationItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EmptyModelRelationItem] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EmptyModelRelationItem?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<EmptyModelRelationItemUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<EmptyModelRelationItem>(
      id,
      columnValues: columnValues(EmptyModelRelationItem.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EmptyModelRelationItem]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<EmptyModelRelationItem>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<EmptyModelRelationItemUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<EmptyModelRelationItemTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<EmptyModelRelationItem>(
      columnValues: columnValues(EmptyModelRelationItem.t.updateTable),
      where: where(EmptyModelRelationItem.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [EmptyModelRelationItem]s in the list and returns the deleted rows.
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
  Future<List<EmptyModelRelationItem>> delete(
    _isd.DatabaseSession session,
    List<EmptyModelRelationItem> rows, {
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<EmptyModelRelationItem>(
      rows,
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [EmptyModelRelationItem].
  Future<EmptyModelRelationItem> deleteRow(
    _isd.DatabaseSession session,
    EmptyModelRelationItem row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EmptyModelRelationItem>(
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
  Future<List<EmptyModelRelationItem>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<EmptyModelRelationItemTable> where,
    _isd.OrderByBuilder<EmptyModelRelationItemTable>? orderBy,
    _isd.OrderByListBuilder<EmptyModelRelationItemTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<EmptyModelRelationItem>(
      where: where(EmptyModelRelationItem.t),
      orderBy: orderBy?.call(EmptyModelRelationItem.t),
      orderByList: orderByList?.call(EmptyModelRelationItem.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<EmptyModelRelationItemTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<EmptyModelRelationItem>(
      where: where?.call(EmptyModelRelationItem.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EmptyModelRelationItem] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<EmptyModelRelationItemTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EmptyModelRelationItem>(
      where: where(EmptyModelRelationItem.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

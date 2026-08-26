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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../empty_model/empty_model_relation_item.dart' as _iq60yogb;

abstract class RelationEmptyModel
    implements _isd.TableRow<int?>, _isc.ProtocolSerialization {
  RelationEmptyModel._({
    this.id,
    this.items,
  });

  factory RelationEmptyModel({
    int? id,
    List<_iq60yogb.EmptyModelRelationItem>? items,
  }) = _RelationEmptyModelImpl;

  factory RelationEmptyModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return RelationEmptyModel(
      id: jsonSerialization['id'] as int?,
      items: jsonSerialization['items'] == null
          ? null
          : _i0ntutnq.Protocol()
                .deserialize<List<_iq60yogb.EmptyModelRelationItem>>(
                  jsonSerialization['items'],
                ),
    );
  }

  static final t = RelationEmptyModelTable();

  static const db = RelationEmptyModelRepository._();

  @override
  int? id;

  List<_iq60yogb.EmptyModelRelationItem>? items;

  @override
  _isd.Table<int?> get table => t;

  /// Returns a shallow copy of this [RelationEmptyModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  RelationEmptyModel copyWith({
    int? id,
    List<_iq60yogb.EmptyModelRelationItem>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RelationEmptyModel',
      if (id != null) 'id': id,
      if (items != null) 'items': items?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RelationEmptyModel',
      if (id != null) 'id': id,
      if (items != null)
        'items': items?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  /// Builds a complete [RelationEmptyModelInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static RelationEmptyModelInclude include({
    _iq60yogb.EmptyModelRelationItemIncludeList? items,
  }) {
    return RelationEmptyModelInclude._(items: items);
  }

  /// Builds a complete [RelationEmptyModelIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static RelationEmptyModelIncludeList includeList({
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    RelationEmptyModelInclude? include,
  }) {
    return RelationEmptyModelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [RelationEmptyModelJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static RelationEmptyModelJsonInclude includeJson({
    _iq60yogb.EmptyModelRelationItemJsonIncludeList? items,
    _isd.SelectColumnsBuilder<RelationEmptyModelTable>? select,
  }) {
    return _RelationEmptyModelJsonInclude._(
      items: items,
      selectedColumns: select?.call(RelationEmptyModel.t),
    );
  }

  /// Builds a JSON-compatible [RelationEmptyModelJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static RelationEmptyModelJsonIncludeList includeJsonList({
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    RelationEmptyModelJsonInclude? include,
    _isd.SelectColumnsBuilder<RelationEmptyModelTable>? select,
  }) {
    return _RelationEmptyModelJsonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      include: include,
      selectedColumns: select?.call(RelationEmptyModel.t),
    );
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RelationEmptyModelImpl extends RelationEmptyModel {
  _RelationEmptyModelImpl({
    int? id,
    List<_iq60yogb.EmptyModelRelationItem>? items,
  }) : super._(
         id: id,
         items: items,
       );

  /// Returns a shallow copy of this [RelationEmptyModel]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  RelationEmptyModel copyWith({
    Object? id = _Undefined,
    Object? items = _Undefined,
  }) {
    return RelationEmptyModel(
      id: id is int? ? id : this.id,
      items: items is List<_iq60yogb.EmptyModelRelationItem>?
          ? items
          : this.items?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class RelationEmptyModelUpdateTable
    extends _isd.UpdateTable<RelationEmptyModelTable> {
  RelationEmptyModelUpdateTable(super.table);
}

class RelationEmptyModelTable extends _isd.Table<int?> {
  RelationEmptyModelTable({super.tableRelation})
    : super(tableName: 'relation_empty_model') {
    updateTable = RelationEmptyModelUpdateTable(this);
  }

  late final RelationEmptyModelUpdateTable updateTable;

  _iq60yogb.EmptyModelRelationItemTable? ___items;

  _isd.ManyRelation<_iq60yogb.EmptyModelRelationItemTable>? _items;

  _iq60yogb.EmptyModelRelationItemTable get __items {
    if (___items != null) return ___items!;
    ___items = _isd.createRelationTable(
      relationFieldName: '__items',
      field: RelationEmptyModel.t.id,
      foreignField: _iq60yogb
          .EmptyModelRelationItem
          .t
          .$_relationEmptyModelItemsRelationEmptyModelId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iq60yogb.EmptyModelRelationItemTable(
            tableRelation: foreignTableRelation,
          ),
    );
    return ___items!;
  }

  _isd.ManyRelation<_iq60yogb.EmptyModelRelationItemTable> get items {
    if (_items != null) return _items!;
    var relationTable = _isd.createRelationTable(
      relationFieldName: 'items',
      field: RelationEmptyModel.t.id,
      foreignField: _iq60yogb
          .EmptyModelRelationItem
          .t
          .$_relationEmptyModelItemsRelationEmptyModelId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iq60yogb.EmptyModelRelationItemTable(
            tableRelation: foreignTableRelation,
          ),
    );
    _items = _isd.ManyRelation<_iq60yogb.EmptyModelRelationItemTable>(
      tableWithRelations: relationTable,
      table: _iq60yogb.EmptyModelRelationItemTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _items!;
  }

  @override
  List<_isd.Column> get columns => [id];

  @override
  _isd.Table? getRelationTable(String relationField) {
    if (relationField == 'items') {
      return __items;
    }
    return null;
  }
}

abstract interface class RelationEmptyModelJsonInclude
    implements _isd.JsonCompatibleInclude {}

abstract interface class RelationEmptyModelJsonIncludeList
    implements _isd.JsonCompatibleInclude {}

final class RelationEmptyModelInclude extends _isd.IncludeObject
    implements RelationEmptyModelJsonInclude, _isd.FullModelInclude {
  RelationEmptyModelInclude._({
    _iq60yogb.EmptyModelRelationItemIncludeList? items,
  }) {
    _items = items;
  }

  _iq60yogb.EmptyModelRelationItemIncludeList? _items;

  @override
  Map<String, _isd.Include?> get includes => {'items': _items};

  @override
  _isd.Table<int?> get table => RelationEmptyModel.t;
}

final class RelationEmptyModelIncludeList extends _isd.IncludeList
    implements RelationEmptyModelJsonIncludeList, _isd.FullModelInclude {
  RelationEmptyModelIncludeList._({
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    RelationEmptyModelInclude? super.include,
  }) {
    super.where = where?.call(RelationEmptyModel.t);
  }

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => RelationEmptyModel.t;
}

final class _RelationEmptyModelJsonInclude extends _isd.IncludeObject
    implements RelationEmptyModelJsonInclude {
  _RelationEmptyModelJsonInclude._({
    _iq60yogb.EmptyModelRelationItemJsonIncludeList? items,
    this.selectedColumns,
  }) {
    _items = items;
  }

  _iq60yogb.EmptyModelRelationItemJsonIncludeList? _items;

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => {'items': _items};

  @override
  _isd.Table<int?> get table => RelationEmptyModel.t;
}

final class _RelationEmptyModelJsonIncludeList extends _isd.IncludeList
    implements RelationEmptyModelJsonIncludeList {
  _RelationEmptyModelJsonIncludeList._({
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    RelationEmptyModelJsonInclude? super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(RelationEmptyModel.t);
  }

  @override
  final List<_isd.Column>? selectedColumns;

  @override
  Map<String, _isd.Include?> get includes => include?.includes ?? {};

  @override
  _isd.Table<int?> get table => RelationEmptyModel.t;
}

class RelationEmptyModelRepository {
  const RelationEmptyModelRepository._();

  final attach = const RelationEmptyModelAttachRepository._();

  final attachRow = const RelationEmptyModelAttachRowRepository._();

  final detach = const RelationEmptyModelDetachRepository._();

  final detachRow = const RelationEmptyModelDetachRowRepository._();

  /// Returns a list of [RelationEmptyModel]s matching the given query parameters.
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
  Future<List<RelationEmptyModel>> find(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _isd.Transaction? transaction,
    RelationEmptyModelInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RelationEmptyModel] matching the given query parameters.
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
  Future<RelationEmptyModel?> findFirstRow(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? offset,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _isd.Transaction? transaction,
    RelationEmptyModelInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RelationEmptyModel] by its [id] or null if no such row exists.
  Future<RelationEmptyModel?> findById(
    _isd.DatabaseSession session,
    int id, {
    _isd.Transaction? transaction,
    RelationEmptyModelInclude? include,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RelationEmptyModel>(
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
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _isd.Transaction? transaction,
    RelationEmptyModelJsonInclude? include,
    _isd.SelectColumnsBuilder<RelationEmptyModelTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(RelationEmptyModel.t),
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
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? offset,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _isd.Transaction? transaction,
    RelationEmptyModelJsonInclude? include,
    _isd.SelectColumnsBuilder<RelationEmptyModelTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(RelationEmptyModel.t),
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
    RelationEmptyModelJsonInclude? include,
    _isd.SelectColumnsBuilder<RelationEmptyModelTable>? select,
    _isd.LockMode? lockMode,
    _isd.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<RelationEmptyModel>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(RelationEmptyModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RelationEmptyModel]s in the list and returns the inserted rows.
  ///
  /// The returned [RelationEmptyModel]s will have their `id` fields set.
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
  Future<List<RelationEmptyModel>> insert(
    _isd.DatabaseSession session,
    List<RelationEmptyModel> rows, {
    _isd.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<RelationEmptyModel>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [RelationEmptyModel] and returns the inserted row.
  ///
  /// The returned [RelationEmptyModel] will have its `id` field set.
  Future<RelationEmptyModel> insertRow(
    _isd.DatabaseSession session,
    RelationEmptyModel row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.insertRow<RelationEmptyModel>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [RelationEmptyModel]s in the list and returns the resulting rows.
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
  /// The returned [RelationEmptyModel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelationEmptyModel>> upsert(
    _isd.DatabaseSession session,
    List<RelationEmptyModel> rows, {
    required _isd.ColumnSelections<RelationEmptyModelTable> conflictColumns,
    _isd.ColumnSelections<RelationEmptyModelTable>? updateColumns,
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? updateWhere,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<RelationEmptyModel>(
      rows,
      conflictColumns: conflictColumns(RelationEmptyModel.t),
      updateColumns: updateColumns?.call(RelationEmptyModel.t),
      updateWhere: updateWhere?.call(RelationEmptyModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [RelationEmptyModel] and returns the resulting row.
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
  /// The returned [RelationEmptyModel] will have its `id` field set.
  Future<RelationEmptyModel?> upsertRow(
    _isd.DatabaseSession session,
    RelationEmptyModel row, {
    required _isd.ColumnSelections<RelationEmptyModelTable> conflictColumns,
    _isd.ColumnSelections<RelationEmptyModelTable>? updateColumns,
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? updateWhere,
    _isd.Transaction? transaction,
  }) async {
    return session.db.upsertRow<RelationEmptyModel>(
      row,
      conflictColumns: conflictColumns(RelationEmptyModel.t),
      updateColumns: updateColumns?.call(RelationEmptyModel.t),
      updateWhere: updateWhere?.call(RelationEmptyModel.t),
      transaction: transaction,
    );
  }

  /// Updates all [RelationEmptyModel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelationEmptyModel>> update(
    _isd.DatabaseSession session,
    List<RelationEmptyModel> rows, {
    _isd.ColumnSelections<RelationEmptyModelTable>? columns,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<RelationEmptyModel>(
      rows,
      columns: columns?.call(RelationEmptyModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [RelationEmptyModel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RelationEmptyModel> updateRow(
    _isd.DatabaseSession session,
    RelationEmptyModel row, {
    _isd.ColumnSelections<RelationEmptyModelTable>? columns,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateRow<RelationEmptyModel>(
      row,
      columns: columns?.call(RelationEmptyModel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RelationEmptyModel] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RelationEmptyModel?> updateById(
    _isd.DatabaseSession session,
    int id, {
    required _isd.ColumnValueListBuilder<RelationEmptyModelUpdateTable>
    columnValues,
    _isd.Transaction? transaction,
  }) async {
    return session.db.updateById<RelationEmptyModel>(
      id,
      columnValues: columnValues(RelationEmptyModel.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RelationEmptyModel]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<RelationEmptyModel>> updateWhere(
    _isd.DatabaseSession session, {
    required _isd.ColumnValueListBuilder<RelationEmptyModelUpdateTable>
    columnValues,
    required _isd.WhereExpressionBuilder<RelationEmptyModelTable> where,
    int? limit,
    int? offset,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<RelationEmptyModel>(
      columnValues: columnValues(RelationEmptyModel.t.updateTable),
      where: where(RelationEmptyModel.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [RelationEmptyModel]s in the list and returns the deleted rows.
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
  Future<List<RelationEmptyModel>> delete(
    _isd.DatabaseSession session,
    List<RelationEmptyModel> rows, {
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<RelationEmptyModel>(
      rows,
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [RelationEmptyModel].
  Future<RelationEmptyModel> deleteRow(
    _isd.DatabaseSession session,
    RelationEmptyModel row, {
    _isd.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RelationEmptyModel>(
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
  Future<List<RelationEmptyModel>> deleteWhere(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<RelationEmptyModelTable> where,
    _isd.OrderByBuilder<RelationEmptyModelTable>? orderBy,
    _isd.OrderByListBuilder<RelationEmptyModelTable>? orderByList,
    _isd.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<RelationEmptyModel>(
      where: where(RelationEmptyModel.t),
      orderBy: orderBy?.call(RelationEmptyModel.t),
      orderByList: orderByList?.call(RelationEmptyModel.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _isd.DatabaseSession session, {
    _isd.WhereExpressionBuilder<RelationEmptyModelTable>? where,
    int? limit,
    _isd.Transaction? transaction,
  }) async {
    return session.db.count<RelationEmptyModel>(
      where: where?.call(RelationEmptyModel.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RelationEmptyModel] rows matching the [where] expression.
  Future<void> lockRows(
    _isd.DatabaseSession session, {
    required _isd.WhereExpressionBuilder<RelationEmptyModelTable> where,
    required _isd.LockMode lockMode,
    required _isd.Transaction transaction,
    _isd.LockBehavior lockBehavior = _isd.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RelationEmptyModel>(
      where: where(RelationEmptyModel.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class RelationEmptyModelAttachRepository {
  const RelationEmptyModelAttachRepository._();

  /// Creates a relation between this [RelationEmptyModel] and the given [EmptyModelRelationItem]s
  /// by setting each [EmptyModelRelationItem]'s foreign key `_relationEmptyModelItemsRelationEmptyModelId` to refer to this [RelationEmptyModel].
  Future<void> items(
    _isd.DatabaseSession session,
    RelationEmptyModel relationEmptyModel,
    List<_iq60yogb.EmptyModelRelationItem> emptyModelRelationItem, {
    _isd.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }
    if (relationEmptyModel.id == null) {
      throw ArgumentError.notNull('relationEmptyModel.id');
    }

    var $emptyModelRelationItem = emptyModelRelationItem
        .map(
          (e) => _iq60yogb.EmptyModelRelationItemImplicit(
            e,
            $_relationEmptyModelItemsRelationEmptyModelId:
                relationEmptyModel.id,
          ),
        )
        .toList();
    await session.db.update<_iq60yogb.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _iq60yogb
            .EmptyModelRelationItem
            .t
            .$_relationEmptyModelItemsRelationEmptyModelId,
      ],
      transaction: transaction,
    );
  }
}

class RelationEmptyModelAttachRowRepository {
  const RelationEmptyModelAttachRowRepository._();

  /// Creates a relation between this [RelationEmptyModel] and the given [EmptyModelRelationItem]
  /// by setting the [EmptyModelRelationItem]'s foreign key `_relationEmptyModelItemsRelationEmptyModelId` to refer to this [RelationEmptyModel].
  Future<void> items(
    _isd.DatabaseSession session,
    RelationEmptyModel relationEmptyModel,
    _iq60yogb.EmptyModelRelationItem emptyModelRelationItem, {
    _isd.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.id == null) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }
    if (relationEmptyModel.id == null) {
      throw ArgumentError.notNull('relationEmptyModel.id');
    }

    var $emptyModelRelationItem = _iq60yogb.EmptyModelRelationItemImplicit(
      emptyModelRelationItem,
      $_relationEmptyModelItemsRelationEmptyModelId: relationEmptyModel.id,
    );
    await session.db.updateRow<_iq60yogb.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _iq60yogb
            .EmptyModelRelationItem
            .t
            .$_relationEmptyModelItemsRelationEmptyModelId,
      ],
      transaction: transaction,
    );
  }
}

class RelationEmptyModelDetachRepository {
  const RelationEmptyModelDetachRepository._();

  /// Detaches the relation between this [RelationEmptyModel] and the given [EmptyModelRelationItem]
  /// by setting the [EmptyModelRelationItem]'s foreign key `_relationEmptyModelItemsRelationEmptyModelId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> items(
    _isd.DatabaseSession session,
    List<_iq60yogb.EmptyModelRelationItem> emptyModelRelationItem, {
    _isd.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.any((e) => e.id == null)) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }

    var $emptyModelRelationItem = emptyModelRelationItem
        .map(
          (e) => _iq60yogb.EmptyModelRelationItemImplicit(
            e,
            $_relationEmptyModelItemsRelationEmptyModelId: null,
          ),
        )
        .toList();
    await session.db.update<_iq60yogb.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _iq60yogb
            .EmptyModelRelationItem
            .t
            .$_relationEmptyModelItemsRelationEmptyModelId,
      ],
      transaction: transaction,
    );
  }
}

class RelationEmptyModelDetachRowRepository {
  const RelationEmptyModelDetachRowRepository._();

  /// Detaches the relation between this [RelationEmptyModel] and the given [EmptyModelRelationItem]
  /// by setting the [EmptyModelRelationItem]'s foreign key `_relationEmptyModelItemsRelationEmptyModelId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> items(
    _isd.DatabaseSession session,
    _iq60yogb.EmptyModelRelationItem emptyModelRelationItem, {
    _isd.Transaction? transaction,
  }) async {
    if (emptyModelRelationItem.id == null) {
      throw ArgumentError.notNull('emptyModelRelationItem.id');
    }

    var $emptyModelRelationItem = _iq60yogb.EmptyModelRelationItemImplicit(
      emptyModelRelationItem,
      $_relationEmptyModelItemsRelationEmptyModelId: null,
    );
    await session.db.updateRow<_iq60yogb.EmptyModelRelationItem>(
      $emptyModelRelationItem,
      columns: [
        _iq60yogb
            .EmptyModelRelationItem
            .t
            .$_relationEmptyModelItemsRelationEmptyModelId,
      ],
      transaction: transaction,
    );
  }
}

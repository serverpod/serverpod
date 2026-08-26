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
import 'package:serverpod_test_sqlite_server/src/generated/protocol.dart'
    as _i08l111i;
import '../../models_with_relations/nested_one_to_many/team.dart' as _iaks25tn;

abstract class Arena implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Arena._({
    this.id,
    required this.name,
    this.team,
  });

  factory Arena({
    int? id,
    required String name,
    _iaks25tn.Team? team,
  }) = _ArenaImpl;

  factory Arena.fromJson(Map<String, dynamic> jsonSerialization) {
    return Arena(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      team: jsonSerialization['team'] == null
          ? null
          : _i08l111i.Protocol().deserialize<_iaks25tn.Team>(
              jsonSerialization['team'],
            ),
    );
  }

  static final t = ArenaTable();

  static const db = ArenaRepository._();

  @override
  int? id;

  String name;

  _iaks25tn.Team? team;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Arena]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Arena copyWith({
    int? id,
    String? name,
    _iaks25tn.Team? team,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Arena',
      if (id != null) 'id': id,
      'name': name,
      if (team != null) 'team': team?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Arena',
      if (id != null) 'id': id,
      'name': name,
      if (team != null) 'team': team?.toJsonForProtocol(),
    };
  }

  /// Builds a complete [ArenaInclude] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ArenaInclude include({_iaks25tn.TeamInclude? team}) {
    return ArenaInclude._(team: team);
  }

  /// Builds a complete [ArenaIncludeList] object for this table, fetching all columns.
  /// Used for typed queries (e.g. `find`, `findFirstRow`, `findById`).

  static ArenaIncludeList includeList({
    _is.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    ArenaInclude? include,
  }) {
    return ArenaIncludeList._(
      where: where?.call(Arena.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      include: include,
    );
  }

  /// Builds a JSON-compatible [ArenaJsonInclude] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// Note: If [select] is specified here on a root include, it will take precedence
  /// over any `select` parameter passed to `findAsJson`.

  static ArenaJsonInclude includeJson({
    _iaks25tn.TeamJsonInclude? team,
    _is.SelectColumnsBuilder<ArenaTable>? select,
  }) {
    return _ArenaJsonInclude._(
      team: team,
      selectedColumns: select?.call(Arena.t),
    );
  }

  /// Builds a JSON-compatible [ArenaJsonIncludeList] object for this table.
  ///
  /// Use [select] to specify which columns to include in the query.
  /// When nested in other includes or used with `findAsJson`, only the selected
  /// columns will be fetched.

  static ArenaJsonIncludeList includeJsonList({
    _is.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    ArenaJsonInclude? include,
    _is.SelectColumnsBuilder<ArenaTable>? select,
  }) {
    return _ArenaJsonIncludeList._(
      where: where?.call(Arena.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      include: include,
      selectedColumns: select?.call(Arena.t),
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ArenaImpl extends Arena {
  _ArenaImpl({
    int? id,
    required String name,
    _iaks25tn.Team? team,
  }) : super._(
         id: id,
         name: name,
         team: team,
       );

  /// Returns a shallow copy of this [Arena]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Arena copyWith({
    Object? id = _Undefined,
    String? name,
    Object? team = _Undefined,
  }) {
    return Arena(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      team: team is _iaks25tn.Team? ? team : this.team?.copyWith(),
    );
  }
}

class ArenaUpdateTable extends _is.UpdateTable<ArenaTable> {
  ArenaUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );
}

class ArenaTable extends _is.Table<int?> {
  ArenaTable({super.tableRelation}) : super(tableName: 'arena') {
    updateTable = ArenaUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
  }

  late final ArenaUpdateTable updateTable;

  late final _is.ColumnString name;

  _iaks25tn.TeamTable? _team;

  _iaks25tn.TeamTable get team {
    if (_team != null) return _team!;
    _team = _is.createRelationTable(
      relationFieldName: 'team',
      field: Arena.t.id,
      foreignField: _iaks25tn.Team.t.arenaId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iaks25tn.TeamTable(tableRelation: foreignTableRelation),
    );
    return _team!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'team') {
      return team;
    }
    return null;
  }
}

abstract interface class ArenaJsonInclude
    implements _is.JsonCompatibleInclude {}

abstract interface class ArenaJsonIncludeList
    implements _is.JsonCompatibleInclude {}

final class ArenaInclude extends _is.IncludeObject
    implements ArenaJsonInclude, _is.FullModelInclude {
  ArenaInclude._({_iaks25tn.TeamInclude? team}) {
    _team = team;
  }

  _iaks25tn.TeamInclude? _team;

  @override
  Map<String, _is.Include?> get includes => {'team': _team};

  @override
  _is.Table<int?> get table => Arena.t;
}

final class ArenaIncludeList extends _is.IncludeList
    implements ArenaJsonIncludeList, _is.FullModelInclude {
  ArenaIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ArenaInclude? super.include,
  });

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Arena.t;
}

final class _ArenaJsonInclude extends _is.IncludeObject
    implements ArenaJsonInclude {
  _ArenaJsonInclude._({
    _iaks25tn.TeamJsonInclude? team,
    this.selectedColumns,
  }) {
    _team = team;
  }

  _iaks25tn.TeamJsonInclude? _team;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {'team': _team};

  @override
  _is.Table<int?> get table => Arena.t;
}

final class _ArenaJsonIncludeList extends _is.IncludeList
    implements ArenaJsonIncludeList {
  _ArenaJsonIncludeList._({
    super.where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    ArenaJsonInclude? super.include,
    this.selectedColumns,
  });

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Arena.t;
}

class ArenaRepository {
  const ArenaRepository._();

  final attachRow = const ArenaAttachRowRepository._();

  final detachRow = const ArenaDetachRowRepository._();

  /// Returns a list of [Arena]s matching the given query parameters.
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
  Future<List<Arena>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    _is.Transaction? transaction,
    ArenaInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Arena>(
      where: where?.call(Arena.t),
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Arena] matching the given query parameters.
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
  Future<Arena?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ArenaTable>? where,
    int? offset,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    _is.Transaction? transaction,
    ArenaInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Arena>(
      where: where?.call(Arena.t),
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Arena] by its [id] or null if no such row exists.
  Future<Arena?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    ArenaInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Arena>(
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    _is.Transaction? transaction,
    ArenaJsonInclude? include,
    _is.SelectColumnsBuilder<ArenaTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findAsJson<Arena>(
      where: where?.call(Arena.t),
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Arena.t),
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ArenaTable>? where,
    int? offset,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    _is.Transaction? transaction,
    ArenaJsonInclude? include,
    _is.SelectColumnsBuilder<ArenaTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findFirstRowAsJson<Arena>(
      where: where?.call(Arena.t),
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      offset: offset,
      transaction: transaction,
      include: include,
      select: select?.call(Arena.t),
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
    _is.DatabaseSession session,
    Object id, {
    _is.Transaction? transaction,
    ArenaJsonInclude? include,
    _is.SelectColumnsBuilder<ArenaTable>? select,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) {
    return session.db.findByIdAsJson<Arena>(
      id,
      transaction: transaction,
      include: include,
      select: select?.call(Arena.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Arena]s in the list and returns the inserted rows.
  ///
  /// The returned [Arena]s will have their `id` fields set.
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
  Future<List<Arena>> insert(
    _is.DatabaseSession session,
    List<Arena> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Arena>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Arena] and returns the inserted row.
  ///
  /// The returned [Arena] will have its `id` field set.
  Future<Arena> insertRow(
    _is.DatabaseSession session,
    Arena row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Arena>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Arena]s in the list and returns the resulting rows.
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
  /// The returned [Arena]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Arena>> upsert(
    _is.DatabaseSession session,
    List<Arena> rows, {
    required _is.ColumnSelections<ArenaTable> conflictColumns,
    _is.ColumnSelections<ArenaTable>? updateColumns,
    _is.WhereExpressionBuilder<ArenaTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Arena>(
      rows,
      conflictColumns: conflictColumns(Arena.t),
      updateColumns: updateColumns?.call(Arena.t),
      updateWhere: updateWhere?.call(Arena.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Arena] and returns the resulting row.
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
  /// The returned [Arena] will have its `id` field set.
  Future<Arena?> upsertRow(
    _is.DatabaseSession session,
    Arena row, {
    required _is.ColumnSelections<ArenaTable> conflictColumns,
    _is.ColumnSelections<ArenaTable>? updateColumns,
    _is.WhereExpressionBuilder<ArenaTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Arena>(
      row,
      conflictColumns: conflictColumns(Arena.t),
      updateColumns: updateColumns?.call(Arena.t),
      updateWhere: updateWhere?.call(Arena.t),
      transaction: transaction,
    );
  }

  /// Updates all [Arena]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Arena>> update(
    _is.DatabaseSession session,
    List<Arena> rows, {
    _is.ColumnSelections<ArenaTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Arena>(
      rows,
      columns: columns?.call(Arena.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Arena]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Arena> updateRow(
    _is.DatabaseSession session,
    Arena row, {
    _is.ColumnSelections<ArenaTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Arena>(
      row,
      columns: columns?.call(Arena.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Arena] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Arena?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<ArenaUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Arena>(
      id,
      columnValues: columnValues(Arena.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Arena]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Arena>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ArenaUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ArenaTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Arena>(
      columnValues: columnValues(Arena.t.updateTable),
      where: where(Arena.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Arena]s in the list and returns the deleted rows.
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
  Future<List<Arena>> delete(
    _is.DatabaseSession session,
    List<Arena> rows, {
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Arena>(
      rows,
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Arena].
  Future<Arena> deleteRow(
    _is.DatabaseSession session,
    Arena row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Arena>(
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
  Future<List<Arena>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ArenaTable> where,
    _is.OrderByBuilder<ArenaTable>? orderBy,
    _is.OrderByListBuilder<ArenaTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Arena>(
      where: where(Arena.t),
      orderBy: orderBy?.call(Arena.t),
      orderByList: orderByList?.call(Arena.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ArenaTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Arena>(
      where: where?.call(Arena.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Arena] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ArenaTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Arena>(
      where: where(Arena.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class ArenaAttachRowRepository {
  const ArenaAttachRowRepository._();

  /// Creates a relation between the given [Arena] and [Team]
  /// by setting the [Arena]'s foreign key `id` to refer to the [Team].
  Future<void> team(
    _is.DatabaseSession session,
    Arena arena,
    _iaks25tn.Team team, {
    _is.Transaction? transaction,
  }) async {
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }
    if (arena.id == null) {
      throw ArgumentError.notNull('arena.id');
    }

    var $team = team.copyWith(arenaId: arena.id);
    await session.db.updateRow<_iaks25tn.Team>(
      $team,
      columns: [_iaks25tn.Team.t.arenaId],
      transaction: transaction,
    );
  }
}

class ArenaDetachRowRepository {
  const ArenaDetachRowRepository._();

  /// Detaches the relation between this [Arena] and the [Team] set in `team`
  /// by setting the [Arena]'s foreign key `id` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> team(
    _is.DatabaseSession session,
    Arena arena, {
    _is.Transaction? transaction,
  }) async {
    var $team = arena.team;

    if ($team == null) {
      throw ArgumentError.notNull('arena.team');
    }
    if ($team.id == null) {
      throw ArgumentError.notNull('arena.team.id');
    }
    if (arena.id == null) {
      throw ArgumentError.notNull('arena.id');
    }

    var $$team = $team.copyWith(arenaId: null);
    await session.db.updateRow<_iaks25tn.Team>(
      $$team,
      columns: [_iaks25tn.Team.t.arenaId],
      transaction: transaction,
    );
  }
}

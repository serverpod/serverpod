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
import '../../models_with_relations/nested_one_to_many/arena.dart' as _iv085ahk;
import '../../models_with_relations/nested_one_to_many/player.dart'
    as _i9mhudyy;

abstract class Team implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Team._({
    this.id,
    required this.name,
    this.arenaId,
    this.arena,
    this.players,
  });

  factory Team({
    int? id,
    required String name,
    int? arenaId,
    _iv085ahk.Arena? arena,
    List<_i9mhudyy.Player>? players,
  }) = _TeamImpl;

  factory Team.fromJson(Map<String, dynamic> jsonSerialization) {
    return Team(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      arenaId: jsonSerialization['arenaId'] as int?,
      arena: jsonSerialization['arena'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iv085ahk.Arena>(
              jsonSerialization['arena'],
            ),
      players: jsonSerialization['players'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_i9mhudyy.Player>>(
              jsonSerialization['players'],
            ),
    );
  }

  static final t = TeamTable();

  static const db = TeamRepository._();

  @override
  int? id;

  String name;

  int? arenaId;

  _iv085ahk.Arena? arena;

  List<_i9mhudyy.Player>? players;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Team]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Team copyWith({
    int? id,
    String? name,
    int? arenaId,
    _iv085ahk.Arena? arena,
    List<_i9mhudyy.Player>? players,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Team',
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId,
      if (arena != null) 'arena': arena?.toJson(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Team',
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId,
      if (arena != null) 'arena': arena?.toJsonForProtocol(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static TeamInclude include({
    _iv085ahk.ArenaInclude? arena,
    _i9mhudyy.PlayerIncludeList? players,
  }) {
    return TeamInclude.internal_(
      arena: arena,
      players: players,
    );
  }

  static TeamIncludeList includeList({
    _is.WhereExpressionBuilder<TeamTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeamTable>? orderBy,
    _is.OrderByListBuilder<TeamTable>? orderByList,
    TeamInclude? include,
  }) {
    return TeamIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeamImpl extends Team {
  _TeamImpl({
    int? id,
    required String name,
    int? arenaId,
    _iv085ahk.Arena? arena,
    List<_i9mhudyy.Player>? players,
  }) : super._(
         id: id,
         name: name,
         arenaId: arenaId,
         arena: arena,
         players: players,
       );

  /// Returns a shallow copy of this [Team]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Team copyWith({
    Object? id = _Undefined,
    String? name,
    Object? arenaId = _Undefined,
    Object? arena = _Undefined,
    Object? players = _Undefined,
  }) {
    return Team(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      arenaId: arenaId is int? ? arenaId : this.arenaId,
      arena: arena is _iv085ahk.Arena? ? arena : this.arena?.copyWith(),
      players: players is List<_i9mhudyy.Player>?
          ? players
          : this.players?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class TeamUpdateTable extends _is.UpdateTable<TeamTable> {
  TeamUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<int, int> arenaId(int? value) => _is.ColumnValue(
    table.arenaId,
    value,
  );
}

class TeamTable extends _is.Table<int?> {
  TeamTable({super.tableRelation}) : super(tableName: 'team') {
    updateTable = TeamUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    arenaId = _is.ColumnInt(
      'arenaId',
      this,
    );
  }

  late final TeamUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnInt arenaId;

  _iv085ahk.ArenaTable? _arena;

  _i9mhudyy.PlayerTable? ___players;

  _is.ManyRelation<_i9mhudyy.PlayerTable>? _players;

  _iv085ahk.ArenaTable get arena {
    if (_arena != null) return _arena!;
    _arena = _is.createRelationTable(
      relationFieldName: 'arena',
      field: Team.t.arenaId,
      foreignField: _iv085ahk.Arena.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _iv085ahk.ArenaTable(tableRelation: foreignTableRelation),
    );
    return _arena!;
  }

  _i9mhudyy.PlayerTable get __players {
    if (___players != null) return ___players!;
    ___players = _is.createRelationTable(
      relationFieldName: '__players',
      field: Team.t.id,
      foreignField: _i9mhudyy.Player.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i9mhudyy.PlayerTable(tableRelation: foreignTableRelation),
    );
    return ___players!;
  }

  _is.ManyRelation<_i9mhudyy.PlayerTable> get players {
    if (_players != null) return _players!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'players',
      field: Team.t.id,
      foreignField: _i9mhudyy.Player.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i9mhudyy.PlayerTable(tableRelation: foreignTableRelation),
    );
    _players = _is.ManyRelation<_i9mhudyy.PlayerTable>(
      tableWithRelations: relationTable,
      table: _i9mhudyy.PlayerTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _players!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    name,
    arenaId,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'arena') {
      return arena;
    }
    if (relationField == 'players') {
      return __players;
    }
    return null;
  }
}

class TeamInclude extends _is.IncludeObject {
  TeamInclude.internal_({
    _iv085ahk.ArenaInclude? arena,
    _i9mhudyy.PlayerIncludeList? players,
    this.selectedColumns,
  }) {
    _arena = arena;
    _players = players;
  }

  _iv085ahk.ArenaInclude? _arena;

  _i9mhudyy.PlayerIncludeList? _players;

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {
    'arena': _arena,
    'players': _players,
  };

  @override
  _is.Table<int?> get table => Team.t;
}

class TeamIncludeList extends _is.IncludeList {
  TeamIncludeList.internal_({
    _is.WhereExpressionBuilder<TeamTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    this.selectedColumns,
  }) {
    super.where = where?.call(Team.t);
  }

  @override
  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Team.t;
}

class TeamRepository {
  const TeamRepository._();

  final attach = const TeamAttachRepository._();

  final attachRow = const TeamAttachRowRepository._();

  final detach = const TeamDetachRepository._();

  final detachRow = const TeamDetachRowRepository._();

  /// Returns a list of [Team]s matching the given query parameters.
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
  Future<List<Team>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeamTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeamTable>? orderBy,
    _is.OrderByListBuilder<TeamTable>? orderByList,
    _is.Transaction? transaction,
    TeamInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Team>(
      where: where?.call(Team.t),
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Team] matching the given query parameters.
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
  Future<Team?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeamTable>? where,
    int? offset,
    _is.OrderByBuilder<TeamTable>? orderBy,
    _is.OrderByListBuilder<TeamTable>? orderByList,
    _is.Transaction? transaction,
    TeamInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Team>(
      where: where?.call(Team.t),
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Team] by its [id] or null if no such row exists.
  Future<Team?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    TeamInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Team>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Team]s in the list and returns the inserted rows.
  ///
  /// The returned [Team]s will have their `id` fields set.
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
  Future<List<Team>> insert(
    _is.DatabaseSession session,
    List<Team> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Team>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Team] and returns the inserted row.
  ///
  /// The returned [Team] will have its `id` field set.
  Future<Team> insertRow(
    _is.DatabaseSession session,
    Team row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Team>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Team]s in the list and returns the resulting rows.
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
  /// The returned [Team]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Team>> upsert(
    _is.DatabaseSession session,
    List<Team> rows, {
    required _is.ColumnSelections<TeamTable> conflictColumns,
    _is.ColumnSelections<TeamTable>? updateColumns,
    _is.WhereExpressionBuilder<TeamTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Team>(
      rows,
      conflictColumns: conflictColumns(Team.t),
      updateColumns: updateColumns?.call(Team.t),
      updateWhere: updateWhere?.call(Team.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Team] and returns the resulting row.
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
  /// The returned [Team] will have its `id` field set.
  Future<Team?> upsertRow(
    _is.DatabaseSession session,
    Team row, {
    required _is.ColumnSelections<TeamTable> conflictColumns,
    _is.ColumnSelections<TeamTable>? updateColumns,
    _is.WhereExpressionBuilder<TeamTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Team>(
      row,
      conflictColumns: conflictColumns(Team.t),
      updateColumns: updateColumns?.call(Team.t),
      updateWhere: updateWhere?.call(Team.t),
      transaction: transaction,
    );
  }

  /// Updates all [Team]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Team>> update(
    _is.DatabaseSession session,
    List<Team> rows, {
    _is.ColumnSelections<TeamTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Team>(
      rows,
      columns: columns?.call(Team.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Team]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Team> updateRow(
    _is.DatabaseSession session,
    Team row, {
    _is.ColumnSelections<TeamTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Team>(
      row,
      columns: columns?.call(Team.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Team] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Team?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<TeamUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Team>(
      id,
      columnValues: columnValues(Team.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Team]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Team>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TeamUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TeamTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TeamTable>? orderBy,
    _is.OrderByListBuilder<TeamTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Team>(
      columnValues: columnValues(Team.t.updateTable),
      where: where(Team.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Team]s in the list and returns the deleted rows.
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
  Future<List<Team>> delete(
    _is.DatabaseSession session,
    List<Team> rows, {
    _is.OrderByBuilder<TeamTable>? orderBy,
    _is.OrderByListBuilder<TeamTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Team>(
      rows,
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Team].
  Future<Team> deleteRow(
    _is.DatabaseSession session,
    Team row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Team>(
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
  Future<List<Team>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeamTable> where,
    _is.OrderByBuilder<TeamTable>? orderBy,
    _is.OrderByListBuilder<TeamTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Team>(
      where: where(Team.t),
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TeamTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Team>(
      where: where?.call(Team.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Team] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TeamTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Team>(
      where: where(Team.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class TeamAttachRepository {
  const TeamAttachRepository._();

  /// Creates a relation between this [Team] and the given [Player]s
  /// by setting each [Player]'s foreign key `teamId` to refer to this [Team].
  Future<void> players(
    _is.DatabaseSession session,
    Team team,
    List<_i9mhudyy.Player> player, {
    _is.Transaction? transaction,
  }) async {
    if (player.any((e) => e.id == null)) {
      throw ArgumentError.notNull('player.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $player = player.map((e) => e.copyWith(teamId: team.id)).toList();
    await session.db.update<_i9mhudyy.Player>(
      $player,
      columns: [_i9mhudyy.Player.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamAttachRowRepository {
  const TeamAttachRowRepository._();

  /// Creates a relation between the given [Team] and [Arena]
  /// by setting the [Team]'s foreign key `arenaId` to refer to the [Arena].
  Future<void> arena(
    _is.DatabaseSession session,
    Team team,
    _iv085ahk.Arena arena, {
    _is.Transaction? transaction,
  }) async {
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }
    if (arena.id == null) {
      throw ArgumentError.notNull('arena.id');
    }

    var $team = team.copyWith(arenaId: arena.id);
    await session.db.updateRow<Team>(
      $team,
      columns: [Team.t.arenaId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Team] and the given [Player]
  /// by setting the [Player]'s foreign key `teamId` to refer to this [Team].
  Future<void> players(
    _is.DatabaseSession session,
    Team team,
    _i9mhudyy.Player player, {
    _is.Transaction? transaction,
  }) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $player = player.copyWith(teamId: team.id);
    await session.db.updateRow<_i9mhudyy.Player>(
      $player,
      columns: [_i9mhudyy.Player.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamDetachRepository {
  const TeamDetachRepository._();

  /// Detaches the relation between this [Team] and the given [Player]
  /// by setting the [Player]'s foreign key `teamId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> players(
    _is.DatabaseSession session,
    List<_i9mhudyy.Player> player, {
    _is.Transaction? transaction,
  }) async {
    if (player.any((e) => e.id == null)) {
      throw ArgumentError.notNull('player.id');
    }

    var $player = player.map((e) => e.copyWith(teamId: null)).toList();
    await session.db.update<_i9mhudyy.Player>(
      $player,
      columns: [_i9mhudyy.Player.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamDetachRowRepository {
  const TeamDetachRowRepository._();

  /// Detaches the relation between this [Team] and the [Arena] set in `arena`
  /// by setting the [Team]'s foreign key `arenaId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> arena(
    _is.DatabaseSession session,
    Team team, {
    _is.Transaction? transaction,
  }) async {
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $team = team.copyWith(arenaId: null);
    await session.db.updateRow<Team>(
      $team,
      columns: [Team.t.arenaId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [Team] and the given [Player]
  /// by setting the [Player]'s foreign key `teamId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> players(
    _is.DatabaseSession session,
    _i9mhudyy.Player player, {
    _is.Transaction? transaction,
  }) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }

    var $player = player.copyWith(teamId: null);
    await session.db.updateRow<_i9mhudyy.Player>(
      $player,
      columns: [_i9mhudyy.Player.t.teamId],
      transaction: transaction,
    );
  }
}

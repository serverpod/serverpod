/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../models_with_relations/nested_one_to_many/arena.dart' as _i2;
import '../../models_with_relations/nested_one_to_many/player.dart' as _i3;

abstract class Team implements _i1.TableRow, _i1.ProtocolSerialization {
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
    _i2.Arena? arena,
    List<_i3.Player>? players,
  }) = _TeamImpl;

  factory Team.fromJson(Map<String, dynamic> jsonSerialization) {
    return Team(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      arenaId: jsonSerialization['arenaId'] as int?,
      arena: jsonSerialization['arena'] == null
          ? null
          : _i2.Arena.fromJson(
              (jsonSerialization['arena'] as Map<String, dynamic>)),
      players: (jsonSerialization['players'] as List?)
          ?.map((e) => _i3.Player.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = TeamTable();

  static const db = TeamRepository._();

  @override
  int? id;

  String name;

  int? arenaId;

  _i2.Arena? arena;

  List<_i3.Player>? players;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Team]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Team copyWith({
    int? id,
    String? name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i3.Player>? players,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
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
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId,
      if (arena != null) 'arena': arena?.toJsonForProtocol(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static TeamInclude include({
    _i2.ArenaInclude? arena,
    _i3.PlayerIncludeList? players,
  }) {
    return TeamInclude._(
      arena: arena,
      players: players,
    );
  }

  static TeamIncludeList includeList({
    _i1.WhereExpressionBuilder<TeamTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TeamTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeamTable>? orderByList,
    TeamInclude? include,
  }) {
    return TeamIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Team.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Team.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TeamImpl extends Team {
  _TeamImpl({
    int? id,
    required String name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i3.Player>? players,
  }) : super._(
          id: id,
          name: name,
          arenaId: arenaId,
          arena: arena,
          players: players,
        );

  /// Returns a shallow copy of this [Team]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      arena: arena is _i2.Arena? ? arena : this.arena?.copyWith(),
      players: players is List<_i3.Player>?
          ? players
          : this.players?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class TeamTable extends _i1.Table {
  TeamTable({super.tableRelation}) : super(tableName: 'team') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    arenaId = _i1.ColumnInt(
      'arenaId',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt arenaId;

  _i2.ArenaTable? _arena;

  _i3.PlayerTable? ___players;

  _i1.ManyRelation<_i3.PlayerTable>? _players;

  _i2.ArenaTable get arena {
    if (_arena != null) return _arena!;
    _arena = _i1.createRelationTable(
      relationFieldName: 'arena',
      field: Team.t.arenaId,
      foreignField: _i2.Arena.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.ArenaTable(tableRelation: foreignTableRelation),
    );
    return _arena!;
  }

  _i3.PlayerTable get __players {
    if (___players != null) return ___players!;
    ___players = _i1.createRelationTable(
      relationFieldName: '__players',
      field: Team.t.id,
      foreignField: _i3.Player.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PlayerTable(tableRelation: foreignTableRelation),
    );
    return ___players!;
  }

  _i1.ManyRelation<_i3.PlayerTable> get players {
    if (_players != null) return _players!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'players',
      field: Team.t.id,
      foreignField: _i3.Player.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.PlayerTable(tableRelation: foreignTableRelation),
    );
    _players = _i1.ManyRelation<_i3.PlayerTable>(
      tableWithRelations: relationTable,
      table: _i3.PlayerTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _players!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        arenaId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'arena') {
      return arena;
    }
    if (relationField == 'players') {
      return __players;
    }
    return null;
  }
}

class TeamInclude extends _i1.IncludeObject {
  TeamInclude._({
    _i2.ArenaInclude? arena,
    _i3.PlayerIncludeList? players,
  }) {
    _arena = arena;
    _players = players;
  }

  _i2.ArenaInclude? _arena;

  _i3.PlayerIncludeList? _players;

  @override
  Map<String, _i1.Include?> get includes => {
        'arena': _arena,
        'players': _players,
      };

  @override
  _i1.Table get table => Team.t;
}

class TeamIncludeList extends _i1.IncludeList {
  TeamIncludeList._({
    _i1.WhereExpressionBuilder<TeamTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Team.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Team.t;
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeamTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TeamTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeamTable>? orderByList,
    _i1.Transaction? transaction,
    TeamInclude? include,
  }) async {
    return session.db.find<Team>(
      where: where?.call(Team.t),
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
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
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeamTable>? where,
    int? offset,
    _i1.OrderByBuilder<TeamTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TeamTable>? orderByList,
    _i1.Transaction? transaction,
    TeamInclude? include,
  }) async {
    return session.db.findFirstRow<Team>(
      where: where?.call(Team.t),
      orderBy: orderBy?.call(Team.t),
      orderByList: orderByList?.call(Team.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Team] by its [id] or null if no such row exists.
  Future<Team?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    TeamInclude? include,
  }) async {
    return session.db.findById<Team>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Team]s in the list and returns the inserted rows.
  ///
  /// The returned [Team]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Team>> insert(
    _i1.Session session,
    List<Team> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Team>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Team] and returns the inserted row.
  ///
  /// The returned [Team] will have its `id` field set.
  Future<Team> insertRow(
    _i1.Session session,
    Team row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Team>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Team]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Team>> update(
    _i1.Session session,
    List<Team> rows, {
    _i1.ColumnSelections<TeamTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Team>(
      rows,
      columns: columns?.call(Team.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Team]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Team> updateRow(
    _i1.Session session,
    Team row, {
    _i1.ColumnSelections<TeamTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Team>(
      row,
      columns: columns?.call(Team.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Team]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Team>> delete(
    _i1.Session session,
    List<Team> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Team>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Team].
  Future<Team> deleteRow(
    _i1.Session session,
    Team row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Team>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Team>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TeamTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Team>(
      where: where(Team.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TeamTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Team>(
      where: where?.call(Team.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class TeamAttachRepository {
  const TeamAttachRepository._();

  /// Creates a relation between this [Team] and the given [Player]s
  /// by setting each [Player]'s foreign key `teamId` to refer to this [Team].
  Future<void> players(
    _i1.Session session,
    Team team,
    List<_i3.Player> player, {
    _i1.Transaction? transaction,
  }) async {
    if (player.any((e) => e.id == null)) {
      throw ArgumentError.notNull('player.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $player = player.map((e) => e.copyWith(teamId: team.id)).toList();
    await session.db.update<_i3.Player>(
      $player,
      columns: [_i3.Player.t.teamId],
      transaction: transaction,
    );
  }
}

class TeamAttachRowRepository {
  const TeamAttachRowRepository._();

  /// Creates a relation between the given [Team] and [Arena]
  /// by setting the [Team]'s foreign key `arenaId` to refer to the [Arena].
  Future<void> arena(
    _i1.Session session,
    Team team,
    _i2.Arena arena, {
    _i1.Transaction? transaction,
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
    _i1.Session session,
    Team team,
    _i3.Player player, {
    _i1.Transaction? transaction,
  }) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $player = player.copyWith(teamId: team.id);
    await session.db.updateRow<_i3.Player>(
      $player,
      columns: [_i3.Player.t.teamId],
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
    _i1.Session session,
    List<_i3.Player> player, {
    _i1.Transaction? transaction,
  }) async {
    if (player.any((e) => e.id == null)) {
      throw ArgumentError.notNull('player.id');
    }

    var $player = player.map((e) => e.copyWith(teamId: null)).toList();
    await session.db.update<_i3.Player>(
      $player,
      columns: [_i3.Player.t.teamId],
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
    _i1.Session session,
    Team team, {
    _i1.Transaction? transaction,
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
    _i1.Session session,
    _i3.Player player, {
    _i1.Transaction? transaction,
  }) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }

    var $player = player.copyWith(teamId: null);
    await session.db.updateRow<_i3.Player>(
      $player,
      columns: [_i3.Player.t.teamId],
      transaction: transaction,
    );
  }
}

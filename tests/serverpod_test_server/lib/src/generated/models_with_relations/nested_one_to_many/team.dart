/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class Team extends _i1.TableRow {
  Team._({
    int? id,
    required this.name,
    this.arenaId,
    this.arena,
    this.players,
  }) : super(id);

  factory Team({
    int? id,
    required String name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i2.Player>? players,
  }) = _TeamImpl;

  factory Team.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Team(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      arenaId:
          serializationManager.deserialize<int?>(jsonSerialization['arenaId']),
      arena: serializationManager
          .deserialize<_i2.Arena?>(jsonSerialization['arena']),
      players: serializationManager
          .deserialize<List<_i2.Player>?>(jsonSerialization['players']),
    );
  }

  static final t = TeamTable();

  static const db = TeamRepository._();

  String name;

  int? arenaId;

  _i2.Arena? arena;

  List<_i2.Player>? players;

  @override
  _i1.Table get table => t;

  Team copyWith({
    int? id,
    String? name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i2.Player>? players,
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
  Map<String, dynamic> allToJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (arenaId != null) 'arenaId': arenaId,
      if (arena != null) 'arena': arena?.allToJson(),
      if (players != null)
        'players': players?.toJson(valueToJson: (v) => v.allToJson()),
    };
  }

  static TeamInclude include({
    _i2.ArenaInclude? arena,
    _i2.PlayerIncludeList? players,
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
}

class _Undefined {}

class _TeamImpl extends Team {
  _TeamImpl({
    int? id,
    required String name,
    int? arenaId,
    _i2.Arena? arena,
    List<_i2.Player>? players,
  }) : super._(
          id: id,
          name: name,
          arenaId: arenaId,
          arena: arena,
          players: players,
        );

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
      players: players is List<_i2.Player>? ? players : this.players?.clone(),
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

  _i2.PlayerTable? ___players;

  _i1.ManyRelation<_i2.PlayerTable>? _players;

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

  _i2.PlayerTable get __players {
    if (___players != null) return ___players!;
    ___players = _i1.createRelationTable(
      relationFieldName: '__players',
      field: Team.t.id,
      foreignField: _i2.Player.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PlayerTable(tableRelation: foreignTableRelation),
    );
    return ___players!;
  }

  _i1.ManyRelation<_i2.PlayerTable> get players {
    if (_players != null) return _players!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'players',
      field: Team.t.id,
      foreignField: _i2.Player.t.teamId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PlayerTable(tableRelation: foreignTableRelation),
    );
    _players = _i1.ManyRelation<_i2.PlayerTable>(
      tableWithRelations: relationTable,
      table: _i2.PlayerTable(
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
    _i2.PlayerIncludeList? players,
  }) {
    _arena = arena;
    _players = players;
  }

  _i2.ArenaInclude? _arena;

  _i2.PlayerIncludeList? _players;

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

  Future<void> players(
    _i1.Session session,
    Team team,
    List<_i2.Player> player,
  ) async {
    if (player.any((e) => e.id == null)) {
      throw ArgumentError.notNull('player.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $player = player.map((e) => e.copyWith(teamId: team.id)).toList();
    await session.db.update<_i2.Player>(
      $player,
      columns: [_i2.Player.t.teamId],
    );
  }
}

class TeamAttachRowRepository {
  const TeamAttachRowRepository._();

  Future<void> arena(
    _i1.Session session,
    Team team,
    _i2.Arena arena,
  ) async {
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
    );
  }

  Future<void> players(
    _i1.Session session,
    Team team,
    _i2.Player player,
  ) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $player = player.copyWith(teamId: team.id);
    await session.db.updateRow<_i2.Player>(
      $player,
      columns: [_i2.Player.t.teamId],
    );
  }
}

class TeamDetachRepository {
  const TeamDetachRepository._();

  Future<void> players(
    _i1.Session session,
    List<_i2.Player> player,
  ) async {
    if (player.any((e) => e.id == null)) {
      throw ArgumentError.notNull('player.id');
    }

    var $player = player.map((e) => e.copyWith(teamId: null)).toList();
    await session.db.update<_i2.Player>(
      $player,
      columns: [_i2.Player.t.teamId],
    );
  }
}

class TeamDetachRowRepository {
  const TeamDetachRowRepository._();

  Future<void> arena(
    _i1.Session session,
    Team team,
  ) async {
    if (team.id == null) {
      throw ArgumentError.notNull('team.id');
    }

    var $team = team.copyWith(arenaId: null);
    await session.db.updateRow<Team>(
      $team,
      columns: [Team.t.arenaId],
    );
  }

  Future<void> players(
    _i1.Session session,
    _i2.Player player,
  ) async {
    if (player.id == null) {
      throw ArgumentError.notNull('player.id');
    }

    var $player = player.copyWith(teamId: null);
    await session.db.updateRow<_i2.Player>(
      $player,
      columns: [_i2.Player.t.teamId],
    );
  }
}
